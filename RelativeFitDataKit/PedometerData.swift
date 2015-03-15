import Foundation
import CoreMotion

public class PedometerData: NSObject {

    public let numberOfStepsYesterday = 0
    public let numberOfStepsToday = 0

    public let numberOfMetersYesterday = 0
    public let numberOfMetersToday = 0

    public let numberOfFloorsAscendedYesterday = 0
    public let numberOfFloorsAscendedToday = 0

    public let numberOfFloorsDescendedYesterday = 0
    public let numberOfFloorsDescendedToday = 0

    public var numberOfAbsoluteFloorsYesterday : Int {
        get {
            return numberOfFloorsAscendedYesterday + numberOfFloorsDescendedYesterday
        }
    }

    public var numberOfAbsoluteFloorsToday : Int {
        get {
            return numberOfFloorsAscendedToday + numberOfFloorsDescendedToday
        }
    }

    public var numberOfStepsDelta : Int {
        get {
            return numberOfStepsToday - numberOfStepsYesterday
        }
    }

    public var numberOfMetersDelta : Int {
        get {
            return numberOfMetersToday - numberOfMetersYesterday

        }
    }

    public var numberOfFloorsDelta : Int {
        get {
            return numberOfAbsoluteFloorsToday - numberOfAbsoluteFloorsYesterday
        }
    }

    override public init() {
        super.init()
    }

    public init(yesterdayData: CMPedometerData, todayData: CMPedometerData) {
        numberOfStepsYesterday = yesterdayData.numberOfSteps.integerValue
        numberOfStepsToday = todayData.numberOfSteps.integerValue

        numberOfMetersYesterday = yesterdayData.distance.integerValue
        numberOfMetersToday = todayData.distance.integerValue

        numberOfFloorsAscendedYesterday = yesterdayData.floorsAscended.integerValue
        numberOfFloorsAscendedToday = todayData.floorsAscended.integerValue

        numberOfFloorsDescendedYesterday = yesterdayData.floorsDescended.integerValue
        numberOfFloorsDescendedToday = todayData.floorsDescended.integerValue

        super.init()
    }

}
