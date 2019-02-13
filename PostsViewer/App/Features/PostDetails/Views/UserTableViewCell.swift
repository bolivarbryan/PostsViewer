import UIKit

class UserTableViewCell: UITableViewCell {

    static let identifier = "UserTableViewCell"

    var user: User? = nil {
        didSet {
            nameLabel?.text = user?.name
            emailLabel?.text = user?.email
            phoneLabel?.text = user?.phone
            websiteLabel?.text = user?.website
        }
    }

    @IBOutlet weak var nameLabel: UILabel?
    @IBOutlet weak var emailLabel: UILabel?
    @IBOutlet weak var phoneLabel: UILabel?
    @IBOutlet weak var websiteLabel: UILabel?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
