#import "FITSettingsViewController.h"
#import <ReactiveCocoa/ReactiveCocoa.h>
#import <RelativeFitDataKit/FITSettingsController.h>
#import <BlocksKit/UIBarButtonItem+BlocksKit.h>

typedef NS_ENUM(NSUInteger, FITSettingsViewControllerSection) {
    FITSettingsViewControllerSectionDistanceUnits,
    FITSettingsViewControllerSectionCount
};

@interface FITSettingsViewController () <UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) FITSettingsController *settingsController;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) NSArray *distanceCells;
@property (strong, nonatomic) UITableViewCell *milesCell;
@property (strong, nonatomic) UITableViewCell *kilometersCell;

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
    [self configureNavigationBar];
    [self configureCells];
    [self configureBindings];
}

- (void)configureNavigationBar
{
    self.title = NSLocalizedString(@"Settings", nil);
    __weak typeof(self) weakSelf = self;
    [self.navigationItem.rightBarButtonItem = [UIBarButtonItem alloc] bk_initWithBarButtonSystemItem:UIBarButtonSystemItemDone handler:^(id sender) {
        __strong typeof(self) strongSelf = weakSelf;
        [strongSelf dismissViewControllerAnimated:YES completion:nil];
    }];

}

- (void)configureCells
{
    UITableViewCell *milesCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    milesCell.selectionStyle = UITableViewCellSelectionStyleNone;
    milesCell.textLabel.text = NSLocalizedString(@"Miles", nil);
    self.milesCell = milesCell;

    UITableViewCell *kilometersCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    kilometersCell.selectionStyle = UITableViewCellSelectionStyleNone;
    kilometersCell.textLabel.text = NSLocalizedString(@"Kilometers", nil);
    self.kilometersCell = kilometersCell;

    self.distanceCells = @[milesCell, kilometersCell];
}

- (void)configureBindings
{
    __weak typeof(self) weakSelf = self;
   [RACObserve(self.settingsController, distanceType) subscribeNext:^(NSNumber *distanceTypeNumber) {
       __strong typeof(self) strongSelf = weakSelf;
       UITableViewCellAccessoryType milesAccessoryType = UITableViewCellAccessoryNone;
       UITableViewCellAccessoryType kilometersAccessoryType = UITableViewCellAccessoryNone;
       FITDistanceUnits distanceUnits = [distanceTypeNumber unsignedIntegerValue];
       switch (distanceUnits) {
           case FITDistanceUnitsMiles: {
               milesAccessoryType = UITableViewCellAccessoryCheckmark;
               break;
           }
           case FITDistanceUnitsKilometers: {
               kilometersAccessoryType = UITableViewCellAccessoryCheckmark;
               break;
           }
       }
       strongSelf.milesCell.accessoryType = milesAccessoryType;
       strongSelf.kilometersCell.accessoryType = kilometersAccessoryType;
   }];
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
            cell = self.distanceCells[indexPath.row];
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
            numberOfRows = self.distanceCells.count;
            break;
        }
        default:
            numberOfRows = 0;
            break;
    }
    return numberOfRows;
}


#pragma mark - UITableViewDelegate

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSString *sectionTitle;
    switch (section) {
        case FITSettingsViewControllerSectionDistanceUnits: {
            sectionTitle = NSLocalizedString(@"Distance Units", nil);
            break;
        }
        default:
            break;
    }
    return sectionTitle;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section) {
        case FITSettingsViewControllerSectionDistanceUnits: {
            UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
            FITDistanceUnits distanceUnits;
            if ([cell isEqual:self.milesCell]) {
                distanceUnits = FITDistanceUnitsMiles;
            } else if ([cell isEqual:self.kilometersCell]) {
                distanceUnits = FITDistanceUnitsKilometers;
            }
            self.settingsController.distanceType = distanceUnits;
            break;
        }

        default:
            break;
    }
}

@end
