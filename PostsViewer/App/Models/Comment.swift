import Foundation

struct Comment: Codable {
    let name: String
    let body: String

    var nameFormatted: String {
        return Language.sentBy.localized + " " + name
    }
}
