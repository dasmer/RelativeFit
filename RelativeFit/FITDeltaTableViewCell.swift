import UIKit
import RelativeFitDataKit

@objc(FITDeltaTableViewCell)

public class FITDeltaTableViewCell: UITableViewCell {

    class func height() -> Int {
        return 90;
    }

    @IBOutlet weak var deltaValueLabel: UILabel!
    @IBOutlet weak var todayValueLabel: UILabel!
    @IBOutlet weak var yesterdayValueLabel: UILabel!

}
