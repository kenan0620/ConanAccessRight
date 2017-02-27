//
//  AppDelegate.m
//  ConanAccessRight
//
//  Created by Conan on 2017/2/15.
//  Copyright © 2017年 Conan. All rights reserved.
//

#import "AppDelegate.h"

#import "FirstVC.h"
#import "SecondVC.h"
#import "ThirdVC.h"

@import HealthKit;
@import CoreLocation;

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
    
    self.window =[[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
    self.window.rootViewController = [AppDelegate setNav];
    [self.window makeKeyAndVisible];
    
    self.healthStore = [[HKHealthStore alloc] init];
    
    [self setUpHealthStoreForTabBarControllers];
    

    
    return YES;
}

+(UITabBarController *)setNav
{
    //步骤1：初始化视图控制器
    FirstVC *untreatVC = [[FirstVC alloc] init]; //未处理
    SecondVC *treatVC = [[SecondVC alloc] init]; //已处理
    ThirdVC *manaVC = [[ThirdVC alloc] init]; //管理
    
    //步骤2：将视图控制器绑定到导航控制器上
    UINavigationController *nav1C = [[UINavigationController alloc] initWithRootViewController:untreatVC];
    UINavigationController *nav2C = [[UINavigationController alloc] initWithRootViewController:treatVC];
    UINavigationController *nav3C = [[UINavigationController alloc] initWithRootViewController:manaVC];
    
    //步骤3：将导航控制器绑定到TabBar控制器上
    UITabBarController *tabBarController = [[UITabBarController alloc] init];
    
    
    //改变tabBar的背景颜色
    UIView *barBgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 49)];
    barBgView.backgroundColor = [UIColor whiteColor];
    [tabBarController.tabBar insertSubview:barBgView atIndex:0];
    tabBarController.tabBar.opaque = YES;
    
    tabBarController.viewControllers = @[nav1C,nav2C,nav3C]; //需要先绑定viewControllers数据源
    //初始化TabBar数据源
    NSArray *titles = @[@"Conan1",@"Conan2",@"Conan3"];
    
    //绑定TabBar数据源
    for (int i = 0; i<tabBarController.tabBar.items.count; i++) {
        UITabBarItem *item = (UITabBarItem *)tabBarController.tabBar.items[i];
        item.title = titles[i];
        tabBarController.tabBar.tintColor = [UIColor orangeColor];
    }
    
    return tabBarController;
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
    /*后台应用刷新*/
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
    /*后台应用刷新*/
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
