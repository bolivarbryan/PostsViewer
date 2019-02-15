import Foundation

struct Address: Codable {
    let street: String
    let suite: String
    let city: String
    let zipcode: String
    let geo: Geo

    var dataRepresentation: Data? {
        let data = try? JSONEncoder().encode(self)
        return data
    }
}

struct Geo: Codable {
    let lat: String
    let lng: String
}
