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
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "PostEntity")
            fetchRequest.returnsObjectsAsFaults = false

            do {
                let context = appDelegate.persistentContainer.viewContext
                let result = try context.fetch(fetchRequest)
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
            context.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
            let entity = NSEntityDescription.entity(forEntityName: "PostEntity", in: context)
            let newPost = NSManagedObject(entity: entity!, insertInto: context)
            newPost.setValue(post.id, forKey: "id")
            newPost.setValue(post.title, forKey: "title")
            newPost.setValue(post.userID, forKey: "userId")
            newPost.setValue(post.body, forKey: "body")
            newPost.setValue(seen, forKey: "seen")
            newPost.setValue(true, forKey: "visible")
            do {
                try context.save()
            } catch {
                //Duplicated value, just ignoring it
            }
        default:
            fatalError("Invalid endpoint used \(self)")
        }
    }

    func update() {
        switch self {
        case let .markPostAssSeen(postID):
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let context = appDelegate.persistentContainer.viewContext
            let entity = NSEntityDescription.entity(forEntityName: "PostEntity", in: context)
            guard
                let name = entity?.name
            else { return }

            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: name)
            fetchRequest.predicate = NSPredicate(format: "id = \(postID)")

            do {

                let posts = try context.fetch(fetchRequest) as? [NSManagedObject]
                guard
                    let post = posts?.first
                    else { return }

                post.setValue(true, forKey: "seen")
                try context.save()

            } catch let error as NSError {
                print(error.localizedDescription)
            }
        case .deleteAllPosts():
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let context = appDelegate.persistentContainer.viewContext
            let entity = NSEntityDescription.entity(forEntityName: "PostEntity", in: context)
            guard
                let name = entity?.name
                else { return }

            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: name)

            do {

                let posts = try context.fetch(fetchRequest) as? [NSManagedObject]
                guard
                    let post = posts?.first
                    else { return }

                post.setValue(false, forKey: "visible")
                try context.save()

            } catch let error as NSError {
                print(error.localizedDescription)
            }

        case let .deletePost(postID):
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let context = appDelegate.persistentContainer.viewContext
            let entity = NSEntityDescription.entity(forEntityName: "PostEntity", in: context)
            guard
                let name = entity?.name
                else { return }

            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: name)
            fetchRequest.predicate = NSPredicate(format: "id = \(postID)")

            do {

                let posts = try context.fetch(fetchRequest) as? [NSManagedObject]
                guard
                    let post = posts?.first
                    else { return }

                post.setValue(false, forKey: "visible")
                try context.save()

            } catch let error as NSError {
                print(error.localizedDescription)
            }

        default:
            fatalError("Invalid endpoint used \(self)")
        }
    }

    func delete() {
        switch self {
        case .deleteAllPosts():
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let context = appDelegate.persistentContainer.viewContext
            let entity = NSEntityDescription.entity(forEntityName: "PostEntity", in: context)
            guard
                let name = entity?.name
                else { return }

            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: name)
            let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
            do {
                try context.execute(deleteRequest)
                try context.save()
            } catch {
                print ("There was an error")
            }
        case let .deletePost(postID):
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let context = appDelegate.persistentContainer.viewContext
            let entity = NSEntityDescription.entity(forEntityName: "PostEntity", in: context)
            guard
                let name = entity?.name
                else { return }

            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: name)
            fetchRequest.predicate = NSPredicate(format: "id = \(postID)")
            let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
            do {
                try context.execute(deleteRequest)
                try context.save()
            } catch {
                print ("There was an error")
            }

        default:
            fatalError("Invalid endpoint used \(self)")
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
