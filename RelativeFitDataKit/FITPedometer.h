#import <Foundation/Foundation.h>
@class PedometerData;

@interface FITPedometer : NSObject

- (void)startWithDidUpdateBlock:(void(^)(PedometerData * pedometerData))pedometerDidUpdateBlock;

- (void)stop;

@end
