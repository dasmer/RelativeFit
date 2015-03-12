#import <Foundation/Foundation.h>
@class FITPedometerData;

@interface FITPedometer : NSObject

- (void)startWithDidUpdateBlock:(void(^)(FITPedometerData * pedometerData))pedometerDidUpdateBlock;

- (void)stop;

@end
