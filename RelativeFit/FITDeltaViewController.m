#import "FITDeltaViewController.h"
#import "RelativeFit-Swift.h"
@import RelativeFitDataKit;

typedef NS_ENUM(NSUInteger, FITDeltaViewControllerRow) {
    FITDeltaViewControllerRowSteps,
    FITDeltaViewControllerRowDistance,
    FITDeltaViewControllerRowFloors,
    FITDeltaViewControllerRowCount
};

@interface FITDeltaViewController () <UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) UITableView *tableView;
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
    [self configureTableView];
}

- (void)configureTableView
{
    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds];
    self.tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self.view addSubview:self.tableView];
    NSString *cellClassString = NSStringFromClass([FITDeltaTableViewCell class]);
    UINib *cellNib = [UINib nibWithNibName:cellClassString bundle:nil];
    [self.tableView registerNib:cellNib
         forCellReuseIdentifier:cellClassString];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
}

- (void)startPedometer
{
    __weak typeof (self) weakSelf = self;
    [self.pedometer startWithDidUpdateBlock:^(PedometerData *pedometerData) {
        __weak typeof (self) strongSelf = weakSelf;
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            strongSelf.stepsLabel.text = [@(pedometerData.numberOfStepsDelta) stringValue];
            strongSelf.distanceLabel.text = [@(pedometerData.numberOfMetersDelta) stringValue];
            strongSelf.floorsLabel.text = [@(pedometerData.numberOfFloorsDelta) stringValue];
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
    return FITDeltaViewControllerRowCount;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([FITDeltaTableViewCell class])];
}

@end
