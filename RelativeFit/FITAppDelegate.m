#import "FITAppDelegate.h"
#import "FITDeltaViewController.h"
@import RelativeFitDataKit;

@interface FITAppDelegate ()

@end

@implementation FITAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:[[FITDeltaViewController alloc] init]];
    [UINavigationBar appearance].barTintColor = [UIColor fit_emeraldColor];
    [UINavigationBar appearance].tintColor = [UIColor whiteColor];
    [UINavigationBar appearance].titleTextAttributes = @{NSForegroundColorAttributeName: [UIColor whiteColor]};
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];


    self.window.rootViewController = navigationController;
    [self.window makeKeyAndVisible];
    return YES;
}

@end
