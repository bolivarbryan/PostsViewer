import Moya

enum JSONPlaceholderAPI {
    case posts
    case userDetails(id: Int)
    case comments(postID: Int)
}

extension JSONPlaceholderAPI: TargetType {

    var baseURL: URL { return URL(string: "https://jsonplaceholder.typicode.com")! }

    var path: String {
        switch self {
        case .posts:
            return "/posts"
        case let .userDetails(id):
            return "/users/\(id)/"
        case .comments:
            return"/comments"
        }
    }

    var method: Moya.Method {
        switch self {
        case .posts, .userDetails, .comments:
            return .get
        }
    }

    var task: Task {
        switch self {
        case .posts, .userDetails:
            return .requestPlain
        case let .comments(postID):
            return .requestParameters(parameters: ["postId": postID], encoding: URLEncoding.queryString)
        }
    }

    var sampleData: Data {
        return Data()
    }

    var headers: [String: String]? {
        return [:]
    }
}

