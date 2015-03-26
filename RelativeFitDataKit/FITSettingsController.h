#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, FITDistanceUnits) {
    FITDistanceUnitsMiles,
    FITDistanceUnitsKilometers
};

typedef NS_ENUM(NSUInteger, FITFloorCountMethod) {
    FITFloorCountMethodTotal,
    FITFloorCountMethodTotalAscending,
    FITFloorCountMethodTotalDescending
};

@interface FITSettingsController : NSObject

@property (nonatomic, assign) FITDistanceUnits distanceType;
@property (nonatomic, assign) FITFloorCountMethod floorCountMethod;

@end
