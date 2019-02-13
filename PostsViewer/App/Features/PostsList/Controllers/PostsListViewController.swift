import UIKit
import RxSwift
import RxCocoa
import SnapKit

class PostsListViewController: UIViewController {

    let viewModel = PostListViewModel()
    let tableView = UITableView(frame: .zero)

    var deleteButton: UIButton = {
        let button = UIButton(frame: .zero)
        button.backgroundColor = .red
        button.setTitle(Language.deleteAll.localized.capitalized, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 17, weight: .bold)
        return button
    }()

    var segmentedControl: UISegmentedControl = {
        let control = UISegmentedControl(items: [Language.all.localized.capitalized,
                                                 Language.favorite.localized.pluralized.capitalized])
        control.tintColor = .customGreen
        return control
    }()

    let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        viewModel.fetchPosts()
        title = Language.post.localized.pluralized.capitalized
        view.backgroundColor = .gray250
    }

    func configureUI() {

        //Delete Button
        view.addSubview(deleteButton)
        deleteButton.snp.makeConstraints {
            $0.bottom.right.left.equalToSuperview()
            $0.height.equalTo(80)
        }

        deleteButton.rx.tap.asObservable()
            .subscribe(onNext: { _ in
                self.viewModel.deleteAllPosts()
            })
            .disposed(by: disposeBag)


        //Segmented Control
        view.addSubview(segmentedControl)
        segmentedControl.snp.makeConstraints {
            $0.top.equalToSuperview().offset(10)
            $0.right.equalToSuperview().offset(-10)
            $0.left.equalToSuperview().offset(10)
            $0.height.equalTo(40)
        }
        segmentedControl.selectedSegmentIndex = 0

        //TableView
        view.addSubview(tableView)
        tableView.snp.makeConstraints {
            $0.top.equalTo(segmentedControl.snp.bottom).offset(10)
            $0.right.left.equalToSuperview()
            $0.bottom.equalTo(deleteButton.snp.top)
        }

        tableView.register(PostTableViewCell.self, forCellReuseIdentifier: PostTableViewCell.identifier)

        //Navigation Bar
        let reloadButton = UIBarButtonItem(image: #imageLiteral(resourceName: "reload"), style: .plain, target: self, action: nil)
        navigationItem.rightBarButtonItem = reloadButton

        reloadButton.rx.tap.asObservable()
            .subscribe(onNext: { _ in
                self.viewModel.fetchPosts()
            })
            .disposed(by: disposeBag)


        //Rx Binders
        viewModel.posts.asObservable()
            .bind(to: tableView.rx.items(cellIdentifier: PostTableViewCell.identifier,
                                         cellType: PostTableViewCell.self)) {  row, element, cell in
                                            cell.post.value = element
                                            cell.accessoryType = .disclosureIndicator
            }
            .disposed(by: disposeBag)

        tableView.rx.modelSelected(Post.self).asObservable()
            .subscribe(onNext: { element in
                let storyboard = UIStoryboard(name: "PostDetails", bundle: nil)

                guard
                    let vc = storyboard.instantiateInitialViewController() as? PostDetailsViewController
                    else { return }

                self.navigationController?.pushViewController(vc, animated: true)
                vc.post = element
            })
        .disposed(by: disposeBag)
    }

}
