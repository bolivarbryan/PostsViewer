import Foundation

struct Post: Codable {
    let userID: Int
    let id: Int
    let title: String
    let body: String
    var seen: Bool = true
    var visible: Bool = true

    enum CodingKeys: String, CodingKey {
        case userID = "userId"
        case id, title, body
    }

    init?(from dictionary: [String: Any]) {
        guard
            let userID = dictionary["userId"] as? Int,
            let id = dictionary["id"] as? Int,
            let title = dictionary["title"] as? String,
            let body = dictionary["body"] as? String,
            let seen = dictionary["seen"] as? Bool,
            let visible = dictionary["visible"] as? Bool
            else { return nil }

        self.userID = userID
        self.id = id
        self.title = title
        self.body = body
        self.seen = seen
        self.visible = visible
    }
}

extension Post: Equatable, Comparable {

    static func < (lhs: Post, rhs: Post) -> Bool {
        return lhs.id < rhs.id
    }

    static func == (lhs: Post, rhs: Post) -> Bool {
        return lhs.id == rhs.id
    }

}
