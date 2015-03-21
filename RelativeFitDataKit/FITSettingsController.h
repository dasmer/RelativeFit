#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, FITSettingsDistanceUnits) {
    FITSettingsDistanceUnitsMiles,
    FITSettingsDistanceUnitsKilometers
};

typedef NS_ENUM(NSUInteger, FITSettingsFloorCountMethod) {
    FITSettingsFloorCountMethodTotal,
    FITSettingsFloorCountMethodTotalAscending,
    FITSettingsFloorCountMethodTotalDescending
};

@interface FITSettingsController : NSObject

@property (nonatomic, assign) FITSettingsDistanceUnits distanceType;
@property (nonatomic, assign) FITSettingsFloorCountMethod floorCountMethod;

@end
