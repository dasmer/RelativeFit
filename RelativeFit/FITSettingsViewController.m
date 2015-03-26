#import "FITSettingsViewController.h"
#import <RelativeFitDataKit/FITSettingsController.h>

typedef NS_ENUM(NSUInteger, FITSettingsViewControllerSection) {
    FITSettingsViewControllerSectionDistanceUnits,
    FITSettingsViewControllerSectionFloorType,
    FITSettingsViewControllerSectionCount
};


typedef NS_ENUM(NSUInteger, FITSettingsViewControllerDistanceUnitsRow) {
    FITSettingsViewControllerDistanceUnitsRowMiles,
    FITSettingsViewControllerDistanceUnitsRowKilometers,
    FITSettingsViewControllerDistanceUnitsRowCount
};


@interface FITSettingsViewController () <UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) FITSettingsController *settingsController;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSArray *distanceCells;
@property (strong, nonatomic) NSArray *floorTypeCells;

@end

@implementation FITSettingsViewController

- (instancetype)initWithSettingsController:(FITSettingsController *)settingsController
{
    self = [super init];
    if (self) {
        _settingsController = settingsController;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    Class cellClass = [UITableViewCell class];
    [self.tableView registerClass:cellClass
           forCellReuseIdentifier:NSStringFromClass(cellClass)];
}


#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return FITSettingsViewControllerSectionCount;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell;
    switch (indexPath.section) {
        case FITSettingsViewControllerSectionDistanceUnits: {
            cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([UITableViewCell class])];
            switch (indexPath.row) {
                case FITSettingsViewControllerDistanceUnitsRowMiles: {
                    cell.textLabel.text = NSLocalizedString(@"Miles", nil);
                    break;
                }
                case FITSettingsViewControllerDistanceUnitsRowKilometers: {
                    cell.textLabel.text = NSLocalizedString(@"Kilometers", nil);
                    break;
                }
                default:
                    break;
            }
            break;
        }

        default:
            cell = [UITableViewCell new];
            break;
    }
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger numberOfRows;
    switch (section) {
        case FITSettingsViewControllerSectionDistanceUnits: {
            numberOfRows = FITSettingsViewControllerDistanceUnitsRowCount;
            break;
        }
        default:
            numberOfRows = 0;
            break;
    }
    return numberOfRows;
}

@end
