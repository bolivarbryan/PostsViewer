import Foundation

enum Language: String {
    case post = "post"
    case all = "all"
    case favorite = "favorite"
    case deleteAll = "delete.all"
    case comment = "comment"
    case description = "description"
    case user = "user"

    var localized: String {
        return NSLocalizedString(self.rawValue, comment: self.rawValue)
    }
}
