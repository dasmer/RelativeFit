#import <Foundation/Foundation.h>

@class CMPedometerData;

@interface FITPedometerData : NSObject

@property (strong, nonatomic, readonly) NSNumber *numberOfStepsYesterday;
@property (strong, nonatomic, readonly) NSNumber *numberOfStepsToday;
@property (strong, nonatomic, readonly) NSNumber *numberOfStepsDelta;

@property (strong, nonatomic, readonly) NSNumber *numberOfMetersYesterday;
@property (strong, nonatomic, readonly) NSNumber *numberOfMetersToday;
@property (strong, nonatomic, readonly) NSNumber *numberOfMetersDelta;

@property (strong, nonatomic, readonly) NSNumber *numberOfFloorsYesterday;
@property (strong, nonatomic, readonly) NSNumber *numberOfFloorsToday;
@property (strong, nonatomic, readonly) NSNumber *numberOfFloorsDelta;

- (instancetype)initWithYesterdayData:(CMPedometerData *)yesterdayData
                            todayData:(CMPedometerData *)todayData;

@end
