import Foundation
import CoreData
import UIKit

protocol DatabaseRequest {
    func fetch(completion: ([Any]) -> ())
}

enum DatabaseError: Error {
    case invalidEnpoint
}

enum DatabaseEndpoint: DatabaseRequest {
    case listPosts
    case savePost(_ post: Post, seen: Bool)
    case favoritePost(postID: Int, value: Bool)
    case markPostAssSeen(postID: Int)
    case deletePost(postID: Int)
    case deleteAllPosts()
    case listComments(postID: Int)
    case saveComment(_ comment: Comment, postID: Int)
    case user(userID: Int)
    case saveUser(user: User)

    func fetch(completion: ([Any]) -> ()) {
        switch self {
        case .listPosts:
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "PostEntity")
            fetchRequest.returnsObjectsAsFaults = false
            sendRequest(request: fetchRequest, completion: completion)
        case let .user(userID):
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "UserEntity")
            fetchRequest.returnsObjectsAsFaults = false
            fetchRequest.predicate = NSPredicate(format: "id = \(userID)")
            sendRequest(request: fetchRequest, completion: completion)
        case let .listComments(postID):
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "CommentEntity")
            fetchRequest.returnsObjectsAsFaults = false
            fetchRequest.predicate = NSPredicate(format: "postId = \(postID)")
            sendRequest(request: fetchRequest, completion: completion)
        default:
            assertionFailure("Invalid endpoint used \(self)")
        }
    }

    func save() {
        switch self {
        case let .savePost(post, seen):
            savePost(post: post, seen: seen)
        case let .saveUser(user):
            saveUser(user)
        case let .saveComment(comment, postID):
            saveComment(comment: comment, postID: postID)
        default:
            assertionFailure("Invalid endpoint used \(self)")
        }
    }

    func update() {
        switch self {
        case let .markPostAssSeen(postID):
            updatePost(postID: postID, field: "seen", value: true)
        case .deleteAllPosts():
            deleteAllPosts()
        case let .deletePost(postID):
            updatePost(postID: postID, field: "visible", value: false)
        default:
            assertionFailure("Invalid endpoint used \(self)")
        }
    }

    func delete() {
        switch self {
        case .deleteAllPosts():
            deleteAllPosts()
        case let .deletePost(postID):
            deletePost(postID: postID)
        default:
            assertionFailure("Invalid endpoint used \(self)")
        }
    }

    func sendRequest(request: NSFetchRequest<NSFetchRequestResult>, completion: ([Any]) -> ()) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        do {
            let result = try context.fetch(request)
            completion(self.convertToJSONArray(managedObjects: result as! [NSManagedObject]))
        } catch {
            print(error.localizedDescription)
        }
    }

    ///Transforms NSManagedObject into an Array of dictionaries for easier serialization
    func convertToJSONArray(managedObjects: [NSManagedObject]) -> [[String : Any]] {
        var jsonArray: [[String: Any]] = []
        for item in managedObjects {
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

extension DatabaseEndpoint {
    var context: NSManagedObjectContext {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.persistentContainer.viewContext
    }

    func deleteAllPosts() {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "PostEntity")
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        do {
            try context.execute(deleteRequest)
            try context.save()
        } catch {
            print ("There was an error")
        }
    }

    func deletePost(postID: Int) {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "PostEntity")
        fetchRequest.predicate = NSPredicate(format: "id = \(postID)")

        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        do {
            try context.execute(deleteRequest)
            try context.save()
        } catch {
            print ("There was an error")
        }
    }

    func updatePost(postID: Int, field: String, value: Any) {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "PostEntity")
        fetchRequest.predicate = NSPredicate(format: "id = \(postID)")

        do {
            let posts = try context.fetch(fetchRequest) as? [NSManagedObject]
            guard
                let post = posts?.first
                else { return }

            post.setValue(value, forKey: field)
            try context.save()

        } catch let error as NSError {
            print(error.localizedDescription)
        }
    }

    func savePost(post: Post, seen: Bool) {
        let entity = NSEntityDescription.entity(forEntityName: "PostEntity", in: context)
        let newPost = NSManagedObject(entity: entity!, insertInto: context)
        newPost.setValue(post.id, forKey: "id")
        newPost.setValue(post.title, forKey: "title")
        newPost.setValue(post.userID, forKey: "userId")
        newPost.setValue(post.body, forKey: "body")
        newPost.setValue(seen, forKey: "seen")
        newPost.setValue(true, forKey: "visible")
        try? context.save()
    }

    func saveUser(_ user: User) {
        let entity = NSEntityDescription.entity(forEntityName: "UserEntity", in: context)
        let newUser = NSManagedObject(entity: entity!, insertInto: context)
        newUser.setValue(user.id, forKey: "id")
        newUser.setValue(user.name, forKey: "name")
        newUser.setValue(user.email, forKey: "email")
        newUser.setValue(user.phone, forKey: "phone")
        newUser.setValue(user.website, forKey: "website")
        newUser.setValue(user.address.dataRepresentation, forKey: "address")
        newUser.setValue(user.company.dataRepresentation, forKey: "company")
        try? context.save()
    }

    func saveComment(comment: Comment, postID: Int) {
        let entity = NSEntityDescription.entity(forEntityName: "CommentEntity", in: context)
        let newUser = NSManagedObject(entity: entity!, insertInto: context)
        newUser.setValue(postID, forKey: "postId")
        newUser.setValue(comment.name, forKey: "name")
        newUser.setValue(comment.body, forKey: "body")
        try? context.save()
    }

}
