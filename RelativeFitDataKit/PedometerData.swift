import Foundation
import CoreMotion

public class PedometerData: NSObject {

    public let numberOfStepsYesterday:Int
    public let numberOfStepsToday:Int

    public let numberOfMetersYesterday:Int
    public let numberOfMetersToday:Int

    public let numberOfFloorsAscendedYesterday:Int
    public let numberOfFloorsAscendedToday:Int

    public let numberOfFloorsDescendedYesterday:Int
    public let numberOfFloorsDescendedToday:Int

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

    override public init() {
        numberOfStepsYesterday = 0
        numberOfStepsToday = 0
        numberOfMetersYesterday = 0
        numberOfMetersToday = 0
        numberOfFloorsAscendedYesterday = 0
        numberOfFloorsAscendedToday = 0
        numberOfFloorsDescendedYesterday = 0
        numberOfFloorsDescendedToday = 0
        super.init();
    }

}
