import Moya

enum JSONPlaceholderAPI {
    case posts
    case userDetails(id: Int)
}

extension JSONPlaceholderAPI: TargetType {

    var baseURL: URL { return URL(string: "https://jsonplaceholder.typicode.com")! }

    var path: String {
        switch self {
        case .posts:
            return "/posts"
        case let .userDetails(id):
            return "/users/\(id)/"
        }
    }

    var method: Moya.Method {
        switch self {
        case .posts, .userDetails:
            return .get
        }
    }

    var task: Task {
        switch self {
        case .posts, .userDetails:
            return .requestPlain
        }
    }

    var sampleData: Data {
        return Data()
    }

    var headers: [String: String]? {
        return [:]
    }
}

