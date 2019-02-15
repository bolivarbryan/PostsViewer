import UIKit

// I made this implementation without Rx and Snp just for showing my work style using standard conventions

class PostDetailsViewController: UIViewController {

    var post: Post? {
        didSet {
            guard
                let post = post
                else { return }

            viewModel.fetchUserDetails(userID: post.userID, completion: {
                self.tableView?.reloadData()
            })

            viewModel.fetchCommentsFromPost(postID: post.id) {
                self.tableView?.reloadData()
            }
        }
    }

    var viewModel = PostDetailsViewModel()

    @IBOutlet weak var tableView: UITableView?

    override func viewDidLoad() {
        super.viewDidLoad()

        let favoriteButton = UIBarButtonItem(image: #imageLiteral(resourceName: "star-off"), style: .plain, target: self, action: nil)
        navigationItem.rightBarButtonItem = favoriteButton
    }
}

extension PostDetailsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            let cellIdentifier = PostDescriptionTableViewCell.identifier
            let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! PostDescriptionTableViewCell
            cell.bodyLabel?.text = post?.body
            return cell
        case 1:
            let cellIdentifier = UserTableViewCell.identifier
            let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! UserTableViewCell
            cell.user = viewModel.currentUser
            return cell
        case 2:
            let cellIdentifier = CommentTableViewCell.identifier
            let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! CommentTableViewCell
            cell.comment = viewModel.comments[indexPath.row]
            return cell
        default:
            fatalError("Default cell should not be presented")
        }
    }
}

extension PostDetailsViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0, 1:
            return 1
        default:
            return viewModel.comments.count
        }
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return Language.description.localized.capitalized
        case 1:
            return Language.user.localized.capitalized
        case 2:
            return Language.comment.localized.pluralized.capitalized
        default:
            return nil
        }
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}
