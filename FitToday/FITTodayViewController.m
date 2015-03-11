#import "FITTodayViewController.h"
#import <NotificationCenter/NotificationCenter.h>

@import RelativeFitDataKit;

@interface FITTodayViewController () <NCWidgetProviding>

@property (weak, nonatomic) IBOutlet UILabel *stepsLabel;
@property (weak, nonatomic) IBOutlet UILabel *distanceLabel;
@property (weak, nonatomic) IBOutlet UILabel *floorsLabel;
@property (strong, nonatomic) FITPedometer *pedometer;

@end

@implementation FITTodayViewController

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    return  [super initWithCoder:aDecoder];
}

- (instancetype)init
{
    return [super init];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    __weak typeof (self) weakSelf = self;
    self.pedometer = [[FITPedometer alloc] initWithDidUpdateBlock:^(FITPedometerData *pedometerData) {
        __weak typeof (self) strongSelf = weakSelf;
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            strongSelf.stepsLabel.text = [@([pedometerData.numberOfStepsDelta integerValue]) stringValue];
            strongSelf.distanceLabel.text = [@([pedometerData.numberOfMetersDelta integerValue]) stringValue];
            strongSelf.floorsLabel.text = [@([pedometerData.numberOfFloorsDelta integerValue]) stringValue];
        }];
    }];
}

- (void)widgetPerformUpdateWithCompletionHandler:(void (^)(NCUpdateResult))completionHandler
{
    // Perform any setup necessary in order to update the view.
    
    // If an error is encountered, use NCUpdateResultFailed
    // If there's no update required, use NCUpdateResultNoData
    // If there's an update, use NCUpdateResultNewData

    completionHandler(NCUpdateResultNewData);
}

@end
