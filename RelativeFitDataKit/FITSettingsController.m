#import "FITSettingsController.h"

static NSString *const FITSettingsDistanceTypeUserDefaultsKey = @"FITSettingsDistanceTypeUserDefaultsKey";
static NSString *const FITSettingsFloorCountUserDefaultsKey = @"FITSettingsFloorCountUserDefaultsKey";

@implementation FITSettingsController

- (void)setDistanceType:(FITDistanceUnits)distanceType
{
    [self willChangeValueForKey:NSStringFromSelector(@selector(distanceType))];
    NSUserDefaults *userDefaults = [self groupUserDefaults];
    [userDefaults setInteger:distanceType
                      forKey:FITSettingsDistanceTypeUserDefaultsKey];
    [userDefaults synchronize];
    [self didChangeValueForKey:NSStringFromSelector(@selector(distanceType))];
}

- (FITDistanceUnits)distanceType
{
    NSUserDefaults *userDefaults = [self groupUserDefaults];
    return [userDefaults integerForKey:FITSettingsDistanceTypeUserDefaultsKey];
}

- (void)setFloorCountMethod:(FITFloorCountMethod)floorCountMethod
{
    [self willChangeValueForKey:NSStringFromSelector(@selector(floorCountMethod))];
    NSUserDefaults *userDefaults = [self groupUserDefaults];
    [userDefaults setInteger:floorCountMethod
                      forKey:FITSettingsFloorCountUserDefaultsKey];
    [userDefaults synchronize];
    [self didChangeValueForKey:NSStringFromSelector(@selector(floorCountMethod))];
}

- (FITFloorCountMethod)floorCountMethod
{
    NSUserDefaults *userDefaults = [self groupUserDefaults];
    return [userDefaults integerForKey:FITSettingsFloorCountUserDefaultsKey];
}

- (NSUserDefaults *)groupUserDefaults
{
    return [[NSUserDefaults alloc] initWithSuiteName:@"group.edu.columbia.ds2644.RelativeFit"];
}

@end