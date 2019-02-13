import UIKit
import RxSwift
import RxCocoa
import SnapKit

class PostsListViewController: UIViewController {

    let viewModel = PostListViewModel()
    let tableView = UITableView(frame: .zero)
    let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        viewModel.fetchPosts()
        title = Language.post.localized.pluralized.capitalized
    }

    func configureUI() {
        view.addSubview(tableView)
        tableView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }

        tableView.register(PostTableViewCell.self, forCellReuseIdentifier: PostTableViewCell.identifier)

        viewModel.posts.asObservable()
            .bind(to: tableView.rx.items(cellIdentifier: PostTableViewCell.identifier,
                                         cellType: PostTableViewCell.self)) {  row, element, cell in
                                            cell.post.value = element
            }
            .disposed(by: disposeBag)
    }

}
