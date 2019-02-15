import Foundation

struct User: Codable {
    let id: Int
    let name: String
    let email: String
    let address: Address
    let phone: String
    let website: String
    let company: Company

    init?(from dictionary: [String: Any]) {
        guard
            let id = dictionary["id"] as? Int,
            let name = dictionary["name"] as? String,
            let email = dictionary["email"] as? String,
            let phone = dictionary["phone"] as? String,
            let website = dictionary["website"] as? String,
            let addressData = dictionary["address"] as? Data,
            let companyData = dictionary["company"] as? Data,
            let address = try? JSONDecoder().decode(Address.self, from: addressData),
            let company = try? JSONDecoder().decode(Company.self, from: companyData)
            else { return nil }


        self.id = id
        self.name = name
        self.email = email
        self.phone = phone
        self.website = website
        self.address = address
        self.company = company

    }
}
