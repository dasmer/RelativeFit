#import "FITDeltaViewController.h"
#import "FITPedometer.h"
#import "FITPedometerData.h"

@interface FITDeltaViewController ()

@property (weak, nonatomic) IBOutlet UILabel *stepsLabel;
@property (weak, nonatomic) IBOutlet UILabel *distanceLabel;
@property (weak, nonatomic) IBOutlet UILabel *floorsLabel;
@property (strong, nonatomic) FITPedometer *pedometer;

@end

@implementation FITDeltaViewController

- (instancetype)init
{
    self = [super init];
    if (self) {
        __weak typeof (self) weakSelf = self;
        _pedometer = [[FITPedometer alloc] initWithDidUpdateBlock:^(FITPedometerData *pedometerData) {
            __weak typeof (self) strongSelf = weakSelf;
            [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                strongSelf.stepsLabel.text = [@([pedometerData.numberOfStepsDelta integerValue]) stringValue];
                strongSelf.distanceLabel.text = [@([pedometerData.numberOfMetersDelta integerValue]) stringValue];
                strongSelf.floorsLabel.text = [@([pedometerData.numberOfFloorsDelta integerValue]) stringValue];
            }];
        }];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.pedometer start];
}

@end
