//
//  AppDelegate.h
//  ConanAccessRight
//
//  Created by Conan on 2017/2/15.
//  Copyright © 2017年 Conan. All rights reserved.
//

#import <UIKit/UIKit.h>
@import HomeKit;
@interface AppDelegate : UIResponder <UIApplicationDelegate,HMHomeManagerDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) HMHomeManager *homeManager;

@end

