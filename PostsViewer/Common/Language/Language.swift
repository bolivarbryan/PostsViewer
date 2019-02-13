import Foundation

enum Language: String {
    case post = "post"
    case all = "all"
    case favorite = "favorite"
    case deleteAll = "delete.all"
    case comment = "comment"
    case description = "description"
    case user = "user"
    case sentBy = "sent.by"

    var localized: String {
        return NSLocalizedString(self.rawValue, comment: self.rawValue)
    }
}

extension String {

    var pluralized: String {
        //TODO: workaround, Plural rules needed here
        let s = self.appending("s")
        return s
    }
}
