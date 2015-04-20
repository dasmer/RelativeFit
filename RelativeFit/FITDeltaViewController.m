#import "FITDeltaViewController.h"
#import <ReactiveCocoa/ReactiveCocoa.h>
#import "RelativeFit-Swift.h"
#import "FITSettingsViewController.h"

@import RelativeFitDataKit;

@interface FITDeltaViewController () <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) FITPedometer *pedometer;
@property (strong, nonatomic) PedometerData *pedometerData;
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
    [self configureNavigationBar];
    [self configureCells];
    [self configureTableView];
    [self configureBindings];
    [self startPedometer];
}

- (void)configureNavigationBar
{
    self.title = NSLocalizedString(@"Δ Today", nil);
    UIBarButtonItem *settingsButton = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Settings", nil) style:UIBarButtonItemStylePlain target:self action:@selector(userTappedSettingsButton)];
    self.navigationItem.rightBarButtonItem = settingsButton;
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

- (void)configureBindings
{
    RACSignal *pedometerDataSignal = [RACObserve(self, pedometerData) deliverOnMainThread];

    // Bind Steps Cells
    RAC(self.stepsCell.deltaValueLabel, text) = [pedometerDataSignal map:^id(PedometerData *pedometerData) {
        return [[@(pedometerData.numberOfStepsDelta) fit_deltaStringValue] stringByAppendingString:NSLocalizedString(@" steps", nil)];
    }];

    RAC(self.stepsCell.todayValueLabel, text) = [pedometerDataSignal map:^id(PedometerData *pedometerData) {
        return [@(pedometerData.numberOfStepsToday) stringValue];
    }];

    RAC(self.stepsCell.yesterdayValueLabel, text) = [pedometerDataSignal map:^id(PedometerData *pedometerData) {
        return [@(pedometerData.numberOfStepsYesterday) stringValue];
    }];

    // Bind Distance Cells
    RACSignal *unitsSignal = RACObserve(self.settingsController, distanceType);
    RACSignal *stepsUpdateSignal = [[RACSignal combineLatest:@[pedometerDataSignal, unitsSignal]] deliverOnMainThread];

    RAC(self.distanceCell.deltaValueLabel, text) = [stepsUpdateSignal map:^id(RACTuple *tuple) {
        PedometerData *pedometerData = [tuple first];
        FITDistanceUnits distanceUnits = [[tuple last] unsignedIntegerValue];

        NSString *amountString = [@([@(pedometerData.numberOfMetersDelta) fit_metersInDistanceUnits:distanceUnits]) fit_deltaStringValue];
        NSString *unitsString = [NSString fit_unitsForDistanceType:distanceUnits];
        return [NSString stringWithFormat:@"%@ %@", amountString, unitsString];
    }];

    RAC(self.distanceCell.todayValueLabel, text) = [stepsUpdateSignal map:^id(RACTuple *tuple) {
        PedometerData *pedometerData = [tuple first];
        FITDistanceUnits distanceUnits = [[tuple last] unsignedIntegerValue];

        return [@([@(pedometerData.numberOfMetersToday) fit_metersInDistanceUnits:distanceUnits]) stringValue];
    }];

    RAC(self.distanceCell.yesterdayValueLabel, text) = [stepsUpdateSignal map:^id(RACTuple *tuple) {
        PedometerData *pedometerData = [tuple first];
        FITDistanceUnits distanceUnits = [[tuple last] unsignedIntegerValue];

        return [@([@(pedometerData.numberOfMetersYesterday) fit_metersInDistanceUnits:distanceUnits]) stringValue];
    }];

    // Bind Floors Cells
    RAC(self.floorsCell.deltaValueLabel, text) = [pedometerDataSignal map:^id(PedometerData *pedometerData) {
        return [[@(pedometerData.numberOfFloorsDelta) fit_deltaStringValue] stringByAppendingString:NSLocalizedString(@" floors", nil)];
    }];

    RAC(self.floorsCell.todayValueLabel, text) = [pedometerDataSignal map:^id(PedometerData *pedometerData) {
        return [@(pedometerData.numberOfAbsoluteFloorsToday) stringValue];
    }];

    RAC(self.floorsCell.yesterdayValueLabel, text) = [pedometerDataSignal map:^id(PedometerData *pedometerData) {
        return [@(pedometerData.numberOfAbsoluteFloorsYesterday) stringValue];
    }];

}

- (void)startPedometer
{
    __weak typeof (self) weakSelf = self;
    [self.pedometer startWithDidUpdateBlock:^(PedometerData *pedometerData) {
        __weak typeof (self) strongSelf = weakSelf;
        strongSelf.pedometerData = pedometerData;
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
