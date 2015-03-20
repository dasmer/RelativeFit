#import "FITDeltaInterfaceController.h"

@import RelativeFitDataKit;

@interface FITDeltaInterfaceController()

@property (weak, nonatomic) IBOutlet WKInterfaceLabel *stepsLabel;
@property (weak, nonatomic) IBOutlet WKInterfaceLabel *metersLabel;
@property (weak, nonatomic) IBOutlet WKInterfaceLabel *floorsLabel;

@property (strong, nonatomic) FITPedometer *pedometer;

@end

@implementation FITDeltaInterfaceController

- (instancetype)init
{
    self = [super init];
    if (self) {
        _pedometer = [[FITPedometer alloc] init];
    }
    return self;
}

- (void)awakeWithContext:(id)context {
    [super awakeWithContext:context];
}

- (void)willActivate {
    [super willActivate];
    __weak typeof (self) weakSelf = self;
    [self.pedometer startWithDidUpdateBlock:^(PedometerData *pedometerData) {
        __strong typeof (self) strongSelf = weakSelf;
        dispatch_async(dispatch_get_main_queue(), ^{
            NSString *stepsString = [@(pedometerData.numberOfStepsDelta) fit_deltaStringValue];
            NSString *distanceString = [@(pedometerData.numberOfMetersDelta) stringValue];
            NSString *floorsString = [@(pedometerData.numberOfFloorsDelta) stringValue];

            [strongSelf.stepsLabel setText:stepsString];
            [strongSelf.metersLabel setText:distanceString];
            [strongSelf.floorsLabel setText:floorsString];
        });
    }];
}

- (void)didDeactivate {
    [self.pedometer stop];
    [super didDeactivate];
}

@end



