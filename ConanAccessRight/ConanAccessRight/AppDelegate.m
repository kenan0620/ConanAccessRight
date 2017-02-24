//
//  AppDelegate.m
//  ConanAccessRight
//
//  Created by Conan on 2017/2/15.
//  Copyright © 2017年 Conan. All rights reserved.
//

#import "AppDelegate.h"
#import<CoreLocation/CoreLocation.h>
#import "ViewController.h"
#import "SecViewController.h"
@import HealthKit;
@interface AppDelegate ()
@property(nonatomic,strong)CLLocationManager*manager;

@property (nonatomic) HKHealthStore *healthStore;
@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
    // Override point for customization after application launch.
    _manager.pausesLocationUpdatesAutomatically=NO;//该模式是抵抗ios在后台杀死程序
    self.healthStore = [[HKHealthStore alloc] init];
    
    SecViewController *vc= [[ SecViewController alloc]init];
    
//     [vc setHealthStore:self.healthStore];
    UINavigationController *na=[[ UINavigationController alloc]initWithRootViewController:vc];
    self.window.rootViewController = na;
    [self.window makeKeyAndVisible];
    
    
        
    
    return YES;
}

- (void)homeManagerDidUpdateHomes:(HMHomeManager *)manager {
    // Send a notification to the other objects
    [[NSNotificationCenter defaultCenter] postNotificationName:@"UpdateHomesNotification" object:self];
}

- (void)homeManagerDidUpdatePrimaryHome:(HMHomeManager *)manager {
    // Send a notification to the other objects
    [[NSNotificationCenter defaultCenter] postNotificationName:@"UpdatePrimaryHomeNotification" object:self];
}
#pragma mark - Convenience

// Set the healthStore property on each view controller that will be presented to the user. The root view controller is a tab
// bar controller. Each tab of the root view controller is a navigation controller which contains its root view controller—
// these are the subclasses of the view controller that present HealthKit information to the user.
- (void)setUpHealthStoreForTabBarControllers {
    UITabBarController *tabBarController = (UITabBarController *)[self.window rootViewController];
    
    for (UINavigationController *navigationController in tabBarController.viewControllers) {
        id viewController = navigationController.topViewController;
        
        if ([viewController respondsToSelector:@selector(setHealthStore:)]) {
            [viewController setHealthStore:self.healthStore];
        }
    }
}



- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    if([CLLocationManager  significantLocationChangeMonitoringAvailable])
        
    {
        
        [_manager stopUpdatingLocation];
        
        [_manager startMonitoringSignificantLocationChanges];
        
    }
    
    else
        
    {
        
        NSLog(@"Significant location change monitoring is not available.");
        
    }
    

}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    if([CLLocationManager  significantLocationChangeMonitoringAvailable])
        
    {
        
        [_manager stopMonitoringSignificantLocationChanges];
        
        [_manager startUpdatingLocation];
        
    }
    
    else
        
    {
        
        NSLog(@"Significant location change monitoring is not available.");
        
    }
    

}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
