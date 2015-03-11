#import <Foundation/Foundation.h>
@class FITPedometerData;

@interface FITPedometer : NSObject

- (instancetype)initWithDidUpdateBlock:(void(^)(FITPedometerData * pedometerData))pedometerDidUpdateBlock;

- (void)start;

@end
