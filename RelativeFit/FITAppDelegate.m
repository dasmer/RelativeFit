#import "FITAppDelegate.h"
#import "FITDeltaViewController.h"

@interface FITAppDelegate ()

@end

@implementation FITAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.rootViewController = [[UINavigationController alloc] initWithRootViewController:[[FITDeltaViewController alloc] init]];
    [self.window makeKeyAndVisible];
    return YES;
}

@end
