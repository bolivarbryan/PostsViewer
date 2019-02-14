import Foundation

struct Post: Codable {
    let userID: Int
    let id: Int
    let title: String
    let body: String
    var seen: Bool = false

    enum CodingKeys: String, CodingKey {
        case userID = "userId"
        case id, title, body
    }
}

extension Post: Comparable, Equatable {
    static func < (lhs: Post, rhs: Post) -> Bool {
        return lhs.id < rhs.id
    }

    static func == (lhs: Post, rhs: Post) -> Bool {
        return lhs.id == rhs.id
    }

}
