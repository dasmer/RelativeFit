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

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        _pedometer = [[FITPedometer alloc] init];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view.subviews setValue:@(YES) forKey:@"hidden"];
}

- (void)widgetPerformUpdateWithCompletionHandler:(void (^)(NCUpdateResult))completionHandler {
    // Perform any setup necessary in order to update the view.
    
    // If an error is encountered, use NCUpdateResultFailed
    // If there's no update required, use NCUpdateResultNoData
    // If there's an update, use NCUpdateResultNewData
    __weak typeof (self) weakSelf = self;
    [self.pedometer startWithDidUpdateBlock:^(PedometerData *pedometerData) {
        __strong typeof (self) strongSelf = weakSelf;
        dispatch_async(dispatch_get_main_queue(), ^{
            NSString *stepsString = [@(pedometerData.numberOfStepsDelta) stringValue];
            NSString *distanceString = [@(pedometerData.numberOfMetersDelta) stringValue];
            NSString *floorsString = [@(pedometerData.numberOfFloorsDelta) stringValue];
            if (![strongSelf.stepsLabel.text isEqualToString:stepsString]
                || ![strongSelf.distanceLabel.text isEqualToString:distanceString]
                || ![strongSelf.floorsLabel.text isEqualToString:floorsString]) {
                [self.view.subviews setValue:@(YES) forKey:@"hidden"];
                strongSelf.stepsLabel.text = stepsString;
                strongSelf.distanceLabel.text = distanceString;
                strongSelf.floorsLabel.text = floorsString;
                [self.view.subviews setValue:@(NO) forKey:@"hidden"];
                completionHandler(NCUpdateResultNewData);
            }
            else {
                completionHandler(NCUpdateResultNoData);
            }
        });
    }];
}


- (UIEdgeInsets)widgetMarginInsetsForProposedMarginInsets:(UIEdgeInsets)margins
{
    margins.bottom = 0;
    return margins;
}

@end
