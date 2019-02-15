#  PostsViewer
 

This Client fetches a post list from `jsonplaceholder.typicode.com`. By using it you can see the newests posts, favorite, delete and refresh them.

![](record.gif)

## App Architecture

- This Project was built with **MVVM** Architecture using **Reactive Patterns**
- In order to implement a precise layout this client uses an Dependency called **Snapkit** ([https://blog.pusher.com/mvvm-ios/]()).
- Included **CoreData** as Persistency Manager
- Using XCTest for Unit Tests

## Dependencies (Using CocoaPods)
- **SnapKit**: Used for Programatic Layout Design (http://snapkit.io/)
- **Moya**: Used for creating a Networking layer (https://github.com/Moya/Moya])
- **RxSwift**: Implementation of reactive patterns in app (https://github.com/ReactiveX/RxSwift)

## Checklist

- [x] Design App Architecture
- [x] Create XCode Project
- [x] Install Dependencies
- [x] Organize project structure
- [x] Create & Test Models
- [x] Create Networking Layer
- [x] Create Post List Controller with Layout
- [x] (**Posts, Data Persistence**) Connect Database with View Model Controller & Test
- [x] (**Posts, Networking layer**) Connect Networking layer with Database and update once data is fetched
- [x] Create Post Details View Controller with Layout
- [x] (**Post Details**) Connect ViewModel With Controller
- [x] (**Favorite Post**) Integrate Favorite Post
- [x] (**Delete Post**) Integrate Delete Posts
- [x] (**Reload Data**) Integrate Data refresh from API


## Known issues

- [ ] Animations for delete row after user swipes
- [ ] Refresh button clears database and then fetch data from api.
- [ ] Comments API data structure does not include a createdAt or id, this means that there is not a clear way to sort them unless the id is being automatically generated (like `MYSQL auto increment`)


