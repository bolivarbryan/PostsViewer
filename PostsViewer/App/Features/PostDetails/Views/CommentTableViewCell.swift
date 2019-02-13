import UIKit

class CommentTableViewCell: UITableViewCell {
    static let identifier = "CommentTableViewCell"

    var comment: Comment? = nil {
        didSet {
            guard
                let comment = comment
                else { return }

            commentLabel?.text = comment.body
            senderLabel?.text = comment.nameFormatted
        }
    }

    @IBOutlet weak var commentLabel: UILabel?
    @IBOutlet weak var senderLabel: UILabel?

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
