import UIKit

class PostDescriptionTableViewCell: UITableViewCell {
    static let identifier = "PostDescriptionTableViewCell"
    @IBOutlet weak var bodyLabel: UILabel?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
