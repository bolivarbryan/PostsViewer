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
            case let .failure(error):
                print(error.localizedDescription)
            }
        }
    }

    private func decodeAndStorePostsFromData(_  data: Data) {
        do {
            let posts = try JSONDecoder().decode([Post].self, from: data)
            self.posts.value = posts
            posts.forEach({ post in
                let db = DatabaseEndpoint.savePost(post)
                db.save()
            })
        } catch {
            print(error.localizedDescription)
        }
    }

    private func fetchPostsFromLocalDatabase() {
        let database = DatabaseEndpoint.listPosts
        database.fetch { (response) in
            let array = response as! [[String: Any]]

            do {
                let postData = try JSONSerialization.data(withJSONObject: array)
                let posts = try JSONDecoder().decode([Post].self, from: postData)
                self.posts.value = posts
                print(posts.count)
            } catch {
                print(error.localizedDescription)
            }
        }
    }

    func deleteAllPosts() {
        posts.value = []
    }
}
