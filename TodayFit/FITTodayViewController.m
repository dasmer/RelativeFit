#import "FITTodayViewController.h"
#import <NotificationCenter/NotificationCenter.h>

@import RelativeFitDataKit;

static NSString *const UIViewHiddenKey = @"hidden";

@interface FITTodayViewController () <NCWidgetProviding>

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *detailLabel;
@property (strong, nonatomic) FITPedometer *pedometer;
@property (weak, nonatomic) IBOutlet UIButton *button;

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
    [self.view.subviews setValue:@(YES) forKey:UIViewHiddenKey];
    self.titleLabel.textColor = [UIColor fit_emeraldColor];
    self.detailLabel.textColor = [UIColor whiteColor];
    self.button.tintColor = [UIColor fit_emeraldColor];
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

            NSString *titleString = [NSString stringWithFormat:@"%@ steps", [@(pedometerData.numberOfStepsDelta) fit_deltaStringValue]];
            NSString *detailString = [NSString stringWithFormat:@"%@ m ･ %@ floors",[@(pedometerData.numberOfMetersDelta) stringValue], [@(pedometerData.numberOfFloorsDelta) stringValue]];

            UILabel *titleLabel = strongSelf.titleLabel;
            UILabel *detailLabel = strongSelf.detailLabel;

            if (![titleLabel.text isEqualToString:titleString] || ![detailLabel.text isEqualToString:detailString]) {
                [self.view.subviews setValue:@(YES) forKey:UIViewHiddenKey];
                titleLabel.text = titleString;
                detailLabel.text = detailString;
                [self.view.subviews setValue:@(NO) forKey:UIViewHiddenKey];
                completionHandler(NCUpdateResultNewData);
            }
            else {
                completionHandler(NCUpdateResultNoData);
            }
        });
    }];
}

- (IBAction)userTappedButton:(id)sender
{
    NSURL *URL = [NSURL URLWithString:@"relativefit://"];
    [self.extensionContext openURL:URL completionHandler:nil];
}

- (UIEdgeInsets)widgetMarginInsetsForProposedMarginInsets:(UIEdgeInsets)margins
{
    margins.bottom = 0;
    return margins;
}

@end
