#import "FITPedometer.h"
#import <CoreMotion/CMPedometer.h>
#import <MTDates/NSDate+MTDates.h>
#import <UIKit/UIKit.h>
#import "FITPedometerData.h"

@interface FITPedometer ()

@property (nonatomic, copy) void(^pedometerDidUpdateBlock)(FITPedometerData *);
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

- (void)startWithDidUpdateBlock:(void(^)(FITPedometerData * pedometerData))pedometerDidUpdateBlock;
{
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
                                               FITPedometerData *updatedData = [[FITPedometerData alloc] initWithYesterdayData:yesterdayPedometerData
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
                                                  FITPedometerData *updatedData = [[FITPedometerData alloc] initWithYesterdayData:yesterdayPedometerData
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
