import Foundation
import RxCocoa
import RxSwift
import Moya

class PostListViewModel {
    let posts: Variable<[Post]> = Variable([])

    func fetchPosts() {
        let provider = MoyaProvider<JSONPlaceholderAPI>()
        provider.request(.posts) { (result) in
            switch result {
            case let .success(moyaResponse):
                let data = moyaResponse.data

                do {
                    let posts = try JSONDecoder().decode([Post].self, from: data)
                    print(posts)
                } catch {
                    print(error.localizedDescription)
                }
            case let .failure(error):
                print(error.localizedDescription)
            }
        }
    }
}
