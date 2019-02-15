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
        do {
            let posts = try JSONDecoder().decode([Post].self, from: data)
            posts.enumerated().forEach({ (index, post) in
                if !self.posts.value.contains(post) {
                    let db = DatabaseEndpoint.savePost(post, seen: index > 20)
                    db.save()
                }
            })
        } catch {
            print(error.localizedDescription)
        }
    }

    func fetchPostsFromLocalDatabase() {
        let database = DatabaseEndpoint.listPosts
        database.fetch { (response) in
            let array = response as! [[String: Any]]
            let posts = array.compactMap({ Post(from: $0) })
            var groupedPosts = posts.filter { $0.seen == false }
            let seenPosts = posts.filter { $0.seen == true }
            groupedPosts.append(contentsOf: seenPosts)

            self.posts.value = groupedPosts

        }
    }

    func deleteAllPosts() {
        posts.value = []
    }
}
