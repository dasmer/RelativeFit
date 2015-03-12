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

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        _pedometer = [[FITPedometer alloc] init];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(stopPedometer) name:UIApplicationDidEnterBackgroundNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(startPedometer) name:UIApplicationWillEnterForegroundNotification object:nil];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self startPedometer];
}

- (void)startPedometer
{
    __weak typeof (self) weakSelf = self;
    [self.pedometer startWithDidUpdateBlock:^(FITPedometerData *pedometerData) {
        __weak typeof (self) strongSelf = weakSelf;
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            strongSelf.stepsLabel.text = [@([pedometerData.numberOfStepsDelta integerValue]) stringValue];
            strongSelf.distanceLabel.text = [@([pedometerData.numberOfMetersDelta integerValue]) stringValue];
            strongSelf.floorsLabel.text = [@([pedometerData.numberOfFloorsDelta integerValue]) stringValue];
        }];
    }];
}

- (void)stopPedometer
{
    [self.pedometer stop];
}

@end
