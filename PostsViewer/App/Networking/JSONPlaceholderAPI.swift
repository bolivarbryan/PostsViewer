import Moya

enum JSONPlaceholderAPI {
    case posts
}

extension JSONPlaceholderAPI: TargetType {

    var baseURL: URL { return URL(string: "https://jsonplaceholder.typicode.com")! }

    var path: String {
        switch self {
        case .posts:
            return "/posts"
        }
    }

    var method: Moya.Method {
        switch self {
        case .posts:
            return .get
        }
    }

    var task: Task {
        switch self {
        case .posts:
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

