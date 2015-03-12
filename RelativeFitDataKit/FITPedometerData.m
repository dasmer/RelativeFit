#import "FITPedometerData.h"
#import <CoreMotion/CMPedometer.h>

@implementation FITPedometerData

- (instancetype)initWithYesterdayData:(CMPedometerData *)yesterdayData
                            todayData:(CMPedometerData *)todayData
{
    self = [super init];
    if (self) {
        _numberOfStepsYesterday = yesterdayData.numberOfSteps;
        _numberOfStepsToday = todayData.numberOfSteps;
        _numberOfStepsDelta = @([_numberOfStepsToday unsignedIntegerValue] - [_numberOfStepsYesterday unsignedIntegerValue]);

        _numberOfMetersYesterday = yesterdayData.distance;
        _numberOfMetersToday = todayData.distance;
        _numberOfMetersDelta = @([_numberOfMetersToday unsignedIntegerValue] - [_numberOfMetersYesterday unsignedIntegerValue]);

        _numberOfFloorsYesterday = @([yesterdayData.floorsAscended unsignedIntegerValue] + [yesterdayData.floorsDescended unsignedIntegerValue]);
        _numberOfFloorsToday = @([todayData.floorsAscended unsignedIntegerValue] + [todayData.floorsDescended unsignedIntegerValue]);
        _numberOfFloorsDelta = @([_numberOfFloorsToday unsignedIntegerValue] - [_numberOfFloorsYesterday unsignedIntegerValue]);
    }
    return self;
}

@end
