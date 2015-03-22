import Foundation

public extension NSNumber {

    public func fit_deltaStringValue() -> String {
        var appendString = ""
        if (self.floatValue > 0) {
            appendString = "+"
        }
        return appendString.stringByAppendingString(self.stringValue);
    }

}