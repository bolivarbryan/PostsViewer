import Foundation

struct Comment: Codable {
    let name: String
    let body: String

    var nameFormatted: String {
        return Language.sentBy.localized + " " + name
    }

    init?(from dictionary: [String: Any]) {
        guard
            let name = dictionary["name"] as? String,
            let body = dictionary["body"] as? String
            else { return nil }

        self.name = name
        self.body = body
    }
}
