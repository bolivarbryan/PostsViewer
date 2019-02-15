import UIKit
import RxSwift
import RxCocoa

class PostTableViewCell: UITableViewCell {
    static let identifier = "PostTableViewCell"

    let bulletView = UIView(frame: .zero)
    let bodyLabel = UILabel(frame: .zero)
    let disposeBag = DisposeBag()
    let post: Variable<Post?> = Variable(nil)

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureUI()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configureUI() {
        addSubview(bulletView)
        bulletView.snp.makeConstraints {
            $0.height.width.equalTo(10)
            $0.centerY.equalToSuperview()
            $0.left.equalToSuperview().offset(5)
        }
        bulletView.layer.cornerRadius = 5

        addSubview(bodyLabel)
        bodyLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(10)
            $0.right.equalToSuperview().offset(-20)
            $0.bottom.equalToSuperview().offset(-10)
            $0.left.equalTo(bulletView.snp.right).offset(10)
        }
        bodyLabel.numberOfLines = 0
        bodyLabel.font = UIFont.systemFont(ofSize: 14, weight: .regular)

        post.asObservable()
            .map({ $0?.body })
            .bind(to: bodyLabel.rx.text)
            .disposed(by: disposeBag)

        post.asObservable()
            .map({ $0?.seen ?? true })
            .subscribe(onNext: {
                switch $0 {
                case true:
                    self.bulletView.backgroundColor = .white
                case false:
                    self.bulletView.backgroundColor = .customBlue
                }
            })
        .disposed(by: disposeBag)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
