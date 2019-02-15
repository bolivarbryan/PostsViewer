import Foundation
import RxCocoa
import RxSwift
import Moya

class PostListViewModel {
    private let posts: Variable<[Post]> = Variable([])
    let filteredPosts: Variable<[Post]> = Variable([])

    var shouldListOnlyFavorites: Bool = false {
        didSet {
            self.applyFiltering()
        }
    }

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
            self.applyFiltering()

        }
    }

    func deleteAllPosts(clearCache: Bool) {
        switch clearCache {
        case true:
            let database = DatabaseEndpoint.deleteAllPosts()
            database.delete()
        case false:
            posts.value.forEach { post in
                self.deletePost(post: post, clearCache: clearCache)
            }

            fetchPostsFromLocalDatabase()
        }
    }

    func deletePost(post: Post, clearCache: Bool) {
        let database = DatabaseEndpoint.deletePost(postID: post.id)
        database.update()
    }

    func applyFiltering() {
        switch shouldListOnlyFavorites {
        case true:
            filteredPosts.value = posts.value.filter { $0.isFavorite }
        case false:
            filteredPosts.value = posts.value
        }
    }

}
