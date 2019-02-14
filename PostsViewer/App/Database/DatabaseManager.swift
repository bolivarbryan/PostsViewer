import Foundation
import CoreData

enum DatabaseSource {
    case coreData
}

enum DatabaseRequest {
    case posts
    case comments(postID: Int)
    case user(userID: Int)
    case favoritePost(postID: Int, value: Bool)
    case deletePost(postID: Int)
    case deleteAllPosts()
}

class DatabaseManager {
    private let databaseSource: DatabaseSource

    init(source: DatabaseSource) {
        self.databaseSource = source
    }

    func request<A>(_ request: DatabaseRequest, type: A) -> [A]  {
        return []
    }
}
