import UIKit

class DataTableCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var textLabel: UILabel!
    @IBOutlet weak var textLabelTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var textLabelTrailingConstraint: NSLayoutConstraint!
    @IBOutlet weak var textLabelBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var textLabelLeadingConstraint: NSLayoutConstraint!
    @IBOutlet weak var bottomBorderView: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
