import Foundation
import CoreData
import UIKit

protocol DatabaseRequest {
    func fetch(completion: ([Any]) -> ())
}

enum DatabaseEndpoint: DatabaseRequest {
    case listPosts
    case savePost(_ post: Post, seen: Bool)
    case favoritePost(postID: Int, value: Bool)
    case markPostAssSeen(postID: Int)
    case deletePost(postID: Int)
    case deleteAllPosts()
    case listComments(postID: Int)
    case saveComment(_ comment: Comment)
    case user(userID: Int)
    case saveUser(user: User)

    func fetch(completion: ([Any]) -> ()) {
        switch self {
        case .listPosts:
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let request = NSFetchRequest<NSFetchRequestResult>(entityName: "PostEntity")
            request.returnsObjectsAsFaults = false
            do {
                let context = appDelegate.persistentContainer.viewContext
                let result = try context.fetch(request)
                completion(self.convertToJSONArray(moArray: result as! [NSManagedObject]))
            } catch {
                print(error.localizedDescription)
            }
        default:
            completion([])
        }
    }

    func save() {
        switch self {
        case let .savePost(post, seen):
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let context = appDelegate.persistentContainer.viewContext
            let entity = NSEntityDescription.entity(forEntityName: "PostEntity", in: context)
            let newPost = NSManagedObject(entity: entity!, insertInto: context)
            newPost.setValue(post.id, forKey: "id")
            newPost.setValue(post.title, forKey: "title")
            newPost.setValue(post.userID, forKey: "userId")
            newPost.setValue(post.body, forKey: "body")
            newPost.setValue(seen, forKey: "seen")
            do {
                try context.save()
            } catch {
                //Duplicated value, just ignoring it
            }
        default: ()
        }
    }

    func convertToJSONArray(moArray: [NSManagedObject]) -> [[String : Any]] {
        var jsonArray: [[String: Any]] = []
        for item in moArray {
            var dict: [String: Any] = [:]
            for attribute in item.entity.attributesByName {
                if let value = item.value(forKey: attribute.key) {
                    dict[attribute.key] = value
                }
            }
            jsonArray.append(dict)
        }
        return jsonArray
    }
}
