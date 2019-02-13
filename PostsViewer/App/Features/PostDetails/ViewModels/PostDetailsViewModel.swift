import Foundation
import Moya

class PostDetailsViewModel {
    var comments: [Comment] = []
    var currentUser: User? = nil

    func fetchUserDetails(userID: Int, completion: @escaping () -> ()) {
        let provider = MoyaProvider<JSONPlaceholderAPI>()
        provider.request(.userDetails(id: userID)) { (result) in
            switch result {
            case let .success(moyaResponse):
                let data = moyaResponse.data

                do {
                    let user = try JSONDecoder().decode(User.self, from: data)
                    self.currentUser = user
                    completion()
                } catch {
                    print(error.localizedDescription)
                }
            case let .failure(error):
                print(error.localizedDescription)
            }
        }
    }

    func fetchCommentsFromPost(postID: Int, completion: @escaping () -> ()) {
        let provider = MoyaProvider<JSONPlaceholderAPI>()
        provider.request(.comments(postID: postID)) { (result) in
            switch result {
            case let .success(moyaResponse):
                let data = moyaResponse.data

                do {
                    let comments = try JSONDecoder().decode([Comment].self, from: data)
                    self.comments = comments
                    completion()
                } catch {
                    print(error.localizedDescription)
                }
            case let .failure(error):
                print(error.localizedDescription)
            }
        }
    }
}
