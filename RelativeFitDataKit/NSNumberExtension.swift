import Foundation

public extension NSNumber {

    public func fit_deltaStringValue() -> String {
        var appendString = ""
        if (self.floatValue > 0) {
            appendString = "+"
        }
        return appendString.stringByAppendingString(self.stringValue);
    }

    public func fit_metersInDistanceUnits(units: FITDistanceUnits) -> Float {
        switch units {
        case .Miles:
            return self.floatValue * 0.000621371
        case .Kilometers:
            return self.floatValue * 0.001
        }
    }

}