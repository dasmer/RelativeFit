#import "FITDeltaViewController.h"
#import "RelativeFit-Swift.h"
@import RelativeFitDataKit;

@interface FITDeltaViewController () <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) FITPedometer *pedometer;
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
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(stopPedometer) name:UIApplicationDidEnterBackgroundNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(startPedometer) name:UIApplicationWillEnterForegroundNotification object:nil];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = NSLocalizedString(@"Δ Today", nil);
    [self startPedometer];
    [self configureCells];
    [self configureTableView];
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
            stepsCell.deltaValueLabel.text = [[@(pedometerData.numberOfStepsDelta) stringValue] stringByAppendingString:NSLocalizedString(@" steps", nil)];
            stepsCell.todayValueLabel.text = [@(pedometerData.numberOfStepsToday) stringValue];
            stepsCell.yesterdayValueLabel.text = [@(pedometerData.numberOfStepsYesterday) stringValue];

            DeltaTableViewCell *distanceCell = strongSelf.distanceCell;
            distanceCell.deltaValueLabel.text = [[@(pedometerData.numberOfMetersDelta) stringValue] stringByAppendingString:NSLocalizedString(@" meters", nil)];
            distanceCell.todayValueLabel.text = [@(pedometerData.numberOfMetersToday) stringValue];
            distanceCell.yesterdayValueLabel.text = [@(pedometerData.numberOfMetersYesterday) stringValue];


            DeltaTableViewCell *floorsCell = strongSelf.floorsCell;
            floorsCell.deltaValueLabel.text = [[@(pedometerData.numberOfFloorsDelta) stringValue] stringByAppendingString:NSLocalizedString(@" floors", nil)];
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

@end
