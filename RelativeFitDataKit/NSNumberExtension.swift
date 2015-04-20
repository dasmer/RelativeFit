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
        var distance:Float
        switch units {
        case .Miles:
            distance = self.floatValue * 0.000621371
        case .Kilometers:
            distance = self.floatValue * 0.001
        }
        return (round(100 * distance)/100)
    }

}