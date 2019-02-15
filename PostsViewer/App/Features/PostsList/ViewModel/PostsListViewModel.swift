import Foundation
import RxCocoa
import RxSwift
import Moya

class PostListViewModel {
    let posts: Variable<[Post]> = Variable([])

    func fetchPosts() {
        fetchPostsFromLocalDatabase()
        let provider = MoyaProvider<JSONPlaceholderAPI>()
        provider.request(.posts) { (result) in
            switch result {
            case let .success(moyaResponse):
                self.decodeAndStorePostsFromData(moyaResponse.data)
                self.fetchPostsFromLocalDatabase()
            case let .failure(error):
                print(error.localizedDescription)
            }
        }
    }

    private func decodeAndStorePostsFromData(_  data: Data) {
        let database = DatabaseEndpoint.listPosts
        database.fetch { (response) in
            let array = response as! [[String: Any]]
            let postsArray = array.compactMap({ Post(from: $0) })
            do {
                let posts = try JSONDecoder().decode([Post].self, from: data)
                posts.enumerated().forEach({ (index, post) in
                    if !postsArray.contains(post) {
                        let db = DatabaseEndpoint.savePost(post, seen: index > 20)
                        db.save()
                    }
                })
            } catch {
                print(error.localizedDescription)
            }
        }
    }

    func fetchPostsFromLocalDatabase() {
        let database = DatabaseEndpoint.listPosts
        database.fetch { (response) in
            let array = response as! [[String: Any]]

            let posts = array
                .compactMap({ Post(from: $0) })
                .filter({$0.visible == true})

            var groupedPosts = posts
                .filter { $0.seen == false }
                .sorted()

            let seenPosts = posts
                .filter { $0.seen == true }
                .sorted()
            groupedPosts.append(contentsOf: seenPosts)
            self.posts.value = groupedPosts
        }
    }

    func deleteAllPosts(clearCache: Bool) {
        let database = DatabaseEndpoint.deleteAllPosts()
        switch clearCache {
        case true:
            database.delete()
        case false:
            database.update()
            fetchPostsFromLocalDatabase()
        }
    }

    func deletePost(post: Post, clearCache: Bool) {
        let database = DatabaseEndpoint.deletePost(postID: post.id)
        database.update()
    }
}
