import UIKit

class PostsListViewController: UIViewController {

    let viewModel = PostListViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.fetchPosts()
    }

}
