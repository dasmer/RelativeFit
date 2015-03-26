#import "FITDeltaViewController.h"
#import "RelativeFit-Swift.h"
#import "FITSettingsViewController.h"

@import RelativeFitDataKit;

@interface FITDeltaViewController () <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) FITPedometer *pedometer;
@property (strong, nonatomic) FITSettingsController *settingsController;
@property (strong, nonatomic) DeltaTableViewCell *stepsCell;
@property (strong, nonatomic) DeltaTableViewCell *distanceCell;
@property (strong, nonatomic) DeltaTableViewCell *floorsCell;
@property (strong, nonatomic) NSArray *cells;

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
        _settingsController = [[FITSettingsController alloc] init];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(stopPedometer) name:UIApplicationDidEnterBackgroundNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(startPedometer) name:UIApplicationWillEnterForegroundNotification object:nil];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self startPedometer];
    [self configureNavigationBar];
    [self configureCells];
    [self configureTableView];
}

- (void)configureNavigationBar
{
    self.title = NSLocalizedString(@"Δ Today", nil);
    UIBarButtonItem *settingsButton = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Settings", nil) style:UIBarButtonItemStylePlain target:self action:@selector(userTappedSettingsButton)];
    self.navigationItem.rightBarButtonItem = settingsButton;
}

- (void)configureTableView
{
    NSString *cellClassString = NSStringFromClass([DeltaTableViewCell class]);
    UINib *cellNib = [UINib nibWithNibName:cellClassString bundle:nil];
    [self.tableView registerNib:cellNib
         forCellReuseIdentifier:cellClassString];
    CGFloat requiredHeight = [DeltaTableViewCell height] * self.cells.count;
    CGFloat maxHeight = CGRectGetHeight(self.view.bounds) - 64;
    if (requiredHeight < maxHeight) {
        self.tableView.scrollEnabled  = NO;
    }
}

- (void)configureCells
{
    NSString *cellClassString = NSStringFromClass([DeltaTableViewCell class]);
    NSBundle *mainBundle = [NSBundle mainBundle];
    self.stepsCell = [[mainBundle loadNibNamed:cellClassString owner:self options:nil] firstObject];
    self.distanceCell = [[mainBundle loadNibNamed:cellClassString owner:self options:nil] firstObject];
    self.floorsCell = [[mainBundle loadNibNamed:cellClassString owner:self options:nil] firstObject];
    self.cells = @[self.stepsCell, self.distanceCell, self.floorsCell];
}

- (void)startPedometer
{
    __weak typeof (self) weakSelf = self;
    [self.pedometer startWithDidUpdateBlock:^(PedometerData *pedometerData) {
        __weak typeof (self) strongSelf = weakSelf;
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            DeltaTableViewCell *stepsCell = strongSelf.stepsCell;
            stepsCell.deltaValueLabel.text = [[@(pedometerData.numberOfStepsDelta) fit_deltaStringValue] stringByAppendingString:NSLocalizedString(@" steps", nil)];
            stepsCell.todayValueLabel.text = [@(pedometerData.numberOfStepsToday) stringValue];
            stepsCell.yesterdayValueLabel.text = [@(pedometerData.numberOfStepsYesterday) stringValue];

            DeltaTableViewCell *distanceCell = strongSelf.distanceCell;
            NSString *units = [NSString fit_unitsForDistanceType:self.settingsController.distanceType];
            distanceCell.deltaValueLabel.text = [[@(pedometerData.numberOfMetersDelta) fit_deltaStringValue] stringByAppendingString:units];
            distanceCell.todayValueLabel.text = [@(pedometerData.numberOfMetersToday) stringValue];
            distanceCell.yesterdayValueLabel.text = [@(pedometerData.numberOfMetersYesterday) stringValue];


            DeltaTableViewCell *floorsCell = strongSelf.floorsCell;
            floorsCell.deltaValueLabel.text = [[@(pedometerData.numberOfFloorsDelta) fit_deltaStringValue] stringByAppendingString:NSLocalizedString(@" floors", nil)];
            floorsCell.todayValueLabel.text = [@(pedometerData.numberOfAbsoluteFloorsToday) stringValue];
            floorsCell.yesterdayValueLabel.text = [@(pedometerData.numberOfAbsoluteFloorsYesterday) stringValue];
        }];
    }];
}

- (void)stopPedometer
{
    [self.pedometer stop];
}


#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.cells.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return self.cells[indexPath.row];
}


#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [DeltaTableViewCell height];
}

- (void)userTappedSettingsButton
{
    FITSettingsViewController *settingsViewController = [[FITSettingsViewController alloc] initWithSettingsController:self.settingsController];
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:settingsViewController];

    [self presentViewController:navigationController animated:YES completion:nil];
}

@end
