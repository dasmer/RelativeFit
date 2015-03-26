import Foundation

public extension NSString {

    public class func fit_unitsForDistanceType(units: FITDistanceUnits) -> String {
        switch units {
        case .Miles:
            return "miles"
        case .Kilometers:
            return "kilometers"
        }
    }

}