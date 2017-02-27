//
//  FirstVC.m
//  HealthAccessRight
//
//  Created by Conan on 2017/2/27.
//  Copyright © 2017年 Conan. All rights reserved.
//

#import "FirstVC.h"
//#import "HKHealthStore+AAPLExtensions.h"

@interface FirstVC ()

@end

@implementation FirstVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title=@"FirstVC";
    self.view.backgroundColor = [UIColor yellowColor];
 

    if ([HKHealthStore isHealthDataAvailable]) {
        NSSet *writeDataTypes = [self dataTypesToWrite];
        NSSet *readDataTypes = [self dataTypesToRead];
        
        [self.healthStore requestAuthorizationToShareTypes:writeDataTypes readTypes:readDataTypes completion:^(BOOL success, NSError *error) {
            
            if (!success) {
                NSLog(@"You didn't allow HealthKit to access these read/write data types. In your app, try to handle this error gracefully when a user decides not to provide access. The error was: %@. If you're using a simulator, try it on a device.", error);
                
                return;
            }
            
            
        }];
    }else
    {
        NSLog(@"isHealthDataAvailable");
    }

    
}

#pragma mark - HealthKit Permissions

// Returns the types of data that Fit wishes to write to HealthKit.
- (NSSet *)dataTypesToWrite {
    HKQuantityType *footWalk = [HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierStepCount];

    return [NSSet setWithObjects:footWalk, nil];
}

// Returns the types of data that Fit wishes to read from HealthKit.
- (NSSet *)dataTypesToRead {
     HKQuantityType *footWalk = [HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierStepCount];
    return [NSSet setWithObjects:footWalk, nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
