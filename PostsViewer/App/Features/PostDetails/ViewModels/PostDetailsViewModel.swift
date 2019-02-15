import Foundation
import Moya

class PostDetailsViewModel {
    var comments: [Comment] = []
    var currentUser: User? = nil

    func fetchUserDetails(userID: Int, completion: @escaping () -> ()) {

        fetchUserFromLocalDatabase(userID: userID, completion: completion)

        let provider = MoyaProvider<JSONPlaceholderAPI>()
        provider.request(.userDetails(id: userID)) { (result) in
            switch result {
            case let .success(moyaResponse):
                let data = moyaResponse.data

                do {
                    let user = try JSONDecoder().decode(User.self, from: data)
                    self.currentUser = user

                    let databaseManager = DatabaseEndpoint.saveUser(user: user)
                    databaseManager.save()
                    
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
        fetchCommentsFromLocalDatabase(postID: postID, completion: completion)

        let provider = MoyaProvider<JSONPlaceholderAPI>()
        provider.request(.comments(postID: postID)) { (result) in
            switch result {
            case let .success(moyaResponse):
                let data = moyaResponse.data

                do {
                    let comments = try JSONDecoder().decode([Comment].self, from: data)
                    self.comments = comments
                    self.saveComments(comments, postID: postID)
                    completion()
                } catch {
                    print(error.localizedDescription)
                }
            case let .failure(error):
                print(error.localizedDescription)
            }
        }
    }

    func fetchUserFromLocalDatabase(userID: Int, completion: () -> ()) {
        let database = DatabaseEndpoint.user(userID: userID)
        database.fetch { (response) in
            let array = response as! [[String: Any]]
            guard
                let userObject = array.first,
                let user = User(from: userObject)
                else { return }
            self.currentUser = user
            completion()
        }
    }

    //The Api does not provide an created_at value from where I could sort the coments, random sort results expected
    func fetchCommentsFromLocalDatabase(postID: Int, completion: () -> ()) {
        let database = DatabaseEndpoint.listComments(postID: postID)
        database.fetch { (response) in
            let array = response as! [[String: Any]]
            let comments = array.compactMap({ Comment(from: $0) })

            self.comments = comments
            completion()
        }
    }

    private func saveComments(_  comments: [Comment], postID: Int) {
        let database = DatabaseEndpoint.listComments(postID: postID)
        database.fetch { (response) in
            comments.forEach({ comment in
                let db = DatabaseEndpoint.saveComment(comment, postID: postID)
                db.save()
            })
        }

    }
}
