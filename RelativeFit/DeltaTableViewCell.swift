import UIKit
import RelativeFitDataKit

@objc(DeltaTableViewCell)

public class DeltaTableViewCell: UITableViewCell {

    class func height() -> Int {
        return 90;
    }

    @IBOutlet weak var deltaValueLabel: UILabel!
    @IBOutlet weak var todayValueLabel: UILabel!
    @IBOutlet weak var yesterdayValueLabel: UILabel!
    @IBOutlet weak var todayTitleLabel: UILabel!
    @IBOutlet weak var yesterdayTitleLabel: UILabel!

    public override func awakeFromNib() {
        deltaValueLabel?.textColor = UIColor.fit_emeraldColor()
        todayValueLabel?.textColor = UIColor.fit_greyColor()
        yesterdayValueLabel?.textColor = UIColor.fit_greyColor()
        todayTitleLabel?.textColor = UIColor.fit_greyColor()
        yesterdayTitleLabel?.textColor = UIColor.fit_greyColor()
    }

}
