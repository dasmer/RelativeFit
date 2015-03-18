#import "FITPedometer.h"
#import <CoreMotion/CMPedometer.h>
#import <MTDates/NSDate+MTDates.h>
#import <UIKit/UIKit.h>
#import <RelativeFitDataKit/RelativeFitDataKit-Swift.h>


@interface FITPedometer ()

@property (nonatomic, copy) void(^pedometerDidUpdateBlock)(PedometerData *);
@property (nonatomic, strong) CMPedometer *pedometer;

@property (strong, nonatomic) CMPedometerData *lastYesterdayData;
@property (strong, nonatomic) CMPedometerData *lastTodayData;

@end

@implementation FITPedometer

- (instancetype)init;
{
    self = [super init];
    if (self) {
        _pedometer = [[CMPedometer alloc] init];
    }
    return self;
}

- (void)startWithDidUpdateBlock:(void(^)(PedometerData * pedometerData))pedometerDidUpdateBlock;
{
#if TARGET_IPHONE_SIMULATOR
    if (pedometerDidUpdateBlock) {
        PedometerData *emptyData = [[PedometerData alloc] init];
        pedometerDidUpdateBlock(emptyData);
    }
    return;
#pragma GCC diagnostic ignored "-Wunreachable-code"
#endif
    _pedometerDidUpdateBlock = pedometerDidUpdateBlock;
    self.lastYesterdayData = nil;
    self.lastTodayData = nil;
    [self.pedometer queryPedometerDataFromDate:[NSDate mt_startOfYesterday]
                                        toDate:[NSDate mt_startOfToday]
                                   withHandler:^(CMPedometerData *yesterdayPedometerData, NSError *error) {
                                       if (!error) {
                                           self.lastYesterdayData = yesterdayPedometerData;
                                           CMPedometerData *todayPedometerData = self.lastTodayData;
                                           if (todayPedometerData) {
                                               PedometerData *updatedData = [[PedometerData alloc] initWithYesterdayData:yesterdayPedometerData
                                                                                                                     todayData:todayPedometerData];
                                               if (self.pedometerDidUpdateBlock) {
                                                   self.pedometerDidUpdateBlock(updatedData);
                                               }
                                           }
                                       }
                                   }];

    [self.pedometer startPedometerUpdatesFromDate:[NSDate mt_startOfToday]
                                      withHandler:^(CMPedometerData *todayPedometerData, NSError *error) {
                                          if (!error) {
                                              self.lastTodayData = todayPedometerData;
                                              CMPedometerData *yesterdayPedometerData = self.lastYesterdayData;
                                              if (yesterdayPedometerData) {
                                                  PedometerData *updatedData = [[PedometerData alloc] initWithYesterdayData:yesterdayPedometerData
                                                                                                                        todayData:todayPedometerData];
                                                  if (self.pedometerDidUpdateBlock) {
                                                      self.pedometerDidUpdateBlock(updatedData);
                                                  }
                                              }
                                          }
                                      }];
}

- (void)stop
{
    [self.pedometer stopPedometerUpdates];
}

@end
