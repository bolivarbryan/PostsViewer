import Foundation

struct Company: Codable {
    let name: String
    let catchPhrase: String
    let bs: String

    var dataRepresentation: Data? {
        let data = try? JSONEncoder().encode(self)
        return data
    }
}
