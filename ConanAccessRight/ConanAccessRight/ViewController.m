//
//  ViewController.m
//  ConanAccessRight
//
//  Created by Conan on 2017/2/15.
//  Copyright © 2017年 Conan. All rights reserved.
//

#import "ViewController.h"

#import "ConanAccessRight.h"


#import "HKHealthStore+AAPLExtensions.h"

// A mapping of logical sections of the table view to actual indexes.


@interface ViewController ()

@property (nonatomic ,strong) UIButton *conanAccessRightBtn;

@end

@implementation ViewController

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    self.title=@"AAPLProfileViewController";
    // Set up an HKHealthStore, asking the user for read/write permissions. The profile view controller is the
    // first view controller that's shown to the user, so we'll ask for all of the desired HealthKit permissions now.
    // In your own app, you should consider requesting permissions the first time a user wants to interact with
    // HealthKit data.
    if ([HKHealthStore isHealthDataAvailable]) {
        NSSet *writeDataTypes = [self dataTypesToWrite];
        NSSet *readDataTypes = [self dataTypesToRead];
        
        [self.healthStore requestAuthorizationToShareTypes:writeDataTypes readTypes:readDataTypes completion:^(BOOL success, NSError *error) {
            if (!success) {
                NSLog(@"You didn't allow HealthKit to access these read/write data types. In your app, try to handle this error gracefully when a user decides not to provide access. The error was: %@. If you're using a simulator, try it on a device.", error);
                
                return;
            }
            
            dispatch_async(dispatch_get_main_queue(), ^{
                // Update the user interface based on the current user's health information.
                [self updateUsersAgeLabel];
                [self updateUsersHeightLabel];
                [self updateUsersWeightLabel];
            });
        }];
    }
}

#pragma mark - HealthKit Permissions

// Returns the types of data that Fit wishes to write to HealthKit.
- (NSSet *)dataTypesToWrite {
    HKQuantityType *dietaryCalorieEnergyType = [HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierDietaryEnergyConsumed];
    HKQuantityType *activeEnergyBurnType = [HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierActiveEnergyBurned];
    HKQuantityType *heightType = [HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierHeight];
    HKQuantityType *weightType = [HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierBodyMass];
    
    return [NSSet setWithObjects:dietaryCalorieEnergyType, activeEnergyBurnType, heightType, weightType, nil];
}

// Returns the types of data that Fit wishes to read from HealthKit.
- (NSSet *)dataTypesToRead {
    HKQuantityType *dietaryCalorieEnergyType = [HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierDietaryEnergyConsumed];
    HKQuantityType *activeEnergyBurnType = [HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierActiveEnergyBurned];
    HKQuantityType *heightType = [HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierHeight];
    HKQuantityType *weightType = [HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierBodyMass];
    HKCharacteristicType *birthdayType = [HKObjectType characteristicTypeForIdentifier:HKCharacteristicTypeIdentifierDateOfBirth];
    HKCharacteristicType *biologicalSexType = [HKObjectType characteristicTypeForIdentifier:HKCharacteristicTypeIdentifierBiologicalSex];
    
    return [NSSet setWithObjects:dietaryCalorieEnergyType, activeEnergyBurnType, heightType, weightType, birthdayType, biologicalSexType, nil];
}

#pragma mark - Reading HealthKit Data

- (void)updateUsersAgeLabel {
    // Set the user's age unit (years).
//    self.ageUnitLabel.text = NSLocalizedString(@"Age (yrs)", nil);
    
    NSError *error;
    NSDate *dateOfBirth = [self.healthStore dateOfBirthWithError:&error];
    
    if (!dateOfBirth) {
        NSLog(@"Either an error occured fetching the user's age information or none has been stored yet. In your app, try to handle this gracefully.");
        
//        self.ageValueLabel.text = NSLocalizedString(@"Not available", nil);
    }
    else {
        // Compute the age of the user.
        NSDate *now = [NSDate date];
        
        NSDateComponents *ageComponents = [[NSCalendar currentCalendar] components:NSCalendarUnitYear fromDate:dateOfBirth toDate:now options:NSCalendarWrapComponents];
        
        NSUInteger usersAge = [ageComponents year];
        
        NSLog(@"您的年龄%@岁",[NSNumberFormatter localizedStringFromNumber:@(usersAge) numberStyle:NSNumberFormatterNoStyle]);
//        self.ageValueLabel.text = [NSNumberFormatter localizedStringFromNumber:@(usersAge) numberStyle:NSNumberFormatterNoStyle];
    }
}

- (void)updateUsersHeightLabel {
    // Fetch user's default height unit in inches.
    NSLengthFormatter *lengthFormatter = [[NSLengthFormatter alloc] init];
    lengthFormatter.unitStyle = NSFormattingUnitStyleLong;
    
    NSLengthFormatterUnit heightFormatterUnit = NSLengthFormatterUnitInch;
    NSString *heightUnitString = [lengthFormatter unitStringFromValue:10 unit:heightFormatterUnit];
    NSString *localizedHeightUnitDescriptionFormat = NSLocalizedString(@"Height (%@)", nil);
    
//    self.heightUnitLabel.text = [NSString stringWithFormat:localizedHeightUnitDescriptionFormat, heightUnitString];
    
    HKQuantityType *heightType = [HKQuantityType quantityTypeForIdentifier:HKQuantityTypeIdentifierHeight];
    
    // Query to get the user's latest height, if it exists.
    [self.healthStore aapl_mostRecentQuantitySampleOfType:heightType predicate:nil completion:^(HKQuantity *mostRecentQuantity, NSError *error) {
        if (!mostRecentQuantity) {
            NSLog(@"Either an error occured fetching the user's height information or none has been stored yet. In your app, try to handle this gracefully.");
            
            dispatch_async(dispatch_get_main_queue(), ^{
//                self.heightValueLabel.text = NSLocalizedString(@"Not available", nil);
            });
        }
        else {
            // Determine the height in the required unit.
            HKUnit *heightUnit = [HKUnit inchUnit];
            double usersHeight = [mostRecentQuantity doubleValueForUnit:heightUnit];
            
            // Update the user interface.
            dispatch_async(dispatch_get_main_queue(), ^{
//                self.heightValueLabel.text = [NSNumberFormatter localizedStringFromNumber:@(usersHeight) numberStyle:NSNumberFormatterNoStyle];
                NSLog(@"您的身高%@英寸",[NSNumberFormatter localizedStringFromNumber:@(usersHeight) numberStyle:NSNumberFormatterNoStyle]);
            });
        }
    }];
}

- (void)updateUsersWeightLabel {
    // Fetch the user's default weight unit in pounds.
    NSMassFormatter *massFormatter = [[NSMassFormatter alloc] init];
    massFormatter.unitStyle = NSFormattingUnitStyleLong;
    
    NSMassFormatterUnit weightFormatterUnit = NSMassFormatterUnitPound;
    NSString *weightUnitString = [massFormatter unitStringFromValue:10 unit:weightFormatterUnit];
    NSString *localizedWeightUnitDescriptionFormat = NSLocalizedString(@"Weight (%@)", nil);
    
//    self.weightUnitLabel.text = [NSString stringWithFormat:localizedWeightUnitDescriptionFormat, weightUnitString];
    
    // Query to get the user's latest weight, if it exists.
    HKQuantityType *weightType = [HKQuantityType quantityTypeForIdentifier:HKQuantityTypeIdentifierBodyMass];
    
    [self.healthStore aapl_mostRecentQuantitySampleOfType:weightType predicate:nil completion:^(HKQuantity *mostRecentQuantity, NSError *error) {
        if (!mostRecentQuantity) {
            NSLog(@"Either an error occured fetching the user's weight information or none has been stored yet. In your app, try to handle this gracefully.");
            
            dispatch_async(dispatch_get_main_queue(), ^{
//                self.weightValueLabel.text = NSLocalizedString(@"Not available", nil);
            });
        }
        else {
            // Determine the weight in the required unit.
            HKUnit *weightUnit = [HKUnit poundUnit];
            double usersWeight = [mostRecentQuantity doubleValueForUnit:weightUnit];
            
            // Update the user interface.
            dispatch_async(dispatch_get_main_queue(), ^{
//                self.weightValueLabel.text = [NSNumberFormatter localizedStringFromNumber:@(usersWeight) numberStyle:NSNumberFormatterNoStyle];
                
                NSLog(@"您的体重%@磅",[NSNumberFormatter localizedStringFromNumber:@(usersWeight) numberStyle:0]);
            });
        }
    }];
}

#pragma mark - Writing HealthKit Data

- (void)saveHeightIntoHealthStore:(double)height {
    // Save the user's height into HealthKit.
    HKUnit *inchUnit = [HKUnit inchUnit];
    HKQuantity *heightQuantity = [HKQuantity quantityWithUnit:inchUnit doubleValue:height];
    
    HKQuantityType *heightType = [HKQuantityType quantityTypeForIdentifier:HKQuantityTypeIdentifierHeight];
    NSDate *now = [NSDate date];
    
    HKQuantitySample *heightSample = [HKQuantitySample quantitySampleWithType:heightType quantity:heightQuantity startDate:now endDate:now];
    
    [self.healthStore saveObject:heightSample withCompletion:^(BOOL success, NSError *error) {
        if (!success) {
            NSLog(@"An error occured saving the height sample %@. In your app, try to handle this gracefully. The error was: %@.", heightSample, error);
            abort();
        }
        
        [self updateUsersHeightLabel];
    }];
}

- (void)saveWeightIntoHealthStore:(double)weight {
    // Save the user's weight into HealthKit.
    HKUnit *poundUnit = [HKUnit poundUnit];
    HKQuantity *weightQuantity = [HKQuantity quantityWithUnit:poundUnit doubleValue:weight];
    
    HKQuantityType *weightType = [HKQuantityType quantityTypeForIdentifier:HKQuantityTypeIdentifierBodyMass];
    NSDate *now = [NSDate date];
    
    HKQuantitySample *weightSample = [HKQuantitySample quantitySampleWithType:weightType quantity:weightQuantity startDate:now endDate:now];
    
    [self.healthStore saveObject:weightSample withCompletion:^(BOOL success, NSError *error) {
        if (!success) {
            NSLog(@"An error occured saving the weight sample %@. In your app, try to handle this gracefully. The error was: %@.", weightSample, error);
            abort();
        }
        
        [self updateUsersWeightLabel];
    }];
}

#pragma mark - Convenience

- (NSNumberFormatter *)numberFormatter {
    static NSNumberFormatter *numberFormatter;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        numberFormatter = [[NSNumberFormatter alloc] init];
    });
    
    return numberFormatter;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.view.backgroundColor = [UIColor whiteColor];
    
//    self.conanAccessRightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    self.conanAccessRightBtn.frame = CGRectMake([UIScreen mainScreen].bounds.size.width/2-50, [UIScreen mainScreen].bounds.size.height/2-50, 100, 100);
//    self.conanAccessRightBtn.backgroundColor = [UIColor yellowColor];
//    [self.conanAccessRightBtn setTitle:@"授权" forState:UIControlStateNormal];
//    [self.conanAccessRightBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//    self.conanAccessRightBtn.layer.cornerRadius = 10;
//    self.conanAccessRightBtn.layer.masksToBounds = YES;
//    [self.conanAccessRightBtn addTarget:self action:@selector(accessRightBtnEvent) forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:self.conanAccessRightBtn];
    
}

-(void)accessRightBtnEvent
{
//    CGRect bouds = [[UIScreen mainScreen]applicationFrame];
//    UIWebView* webView = [[UIWebView alloc]initWithFrame:bouds];
//    webView.scalesPageToFit = YES;//自动对页面进行缩放以适应屏幕
//    
//    [self.view addSubview:webView];
//    NSURL* url = [NSURL URLWithString:@"http://www.baidu.com"];//创建URL
//    NSURLRequest* request = [NSURLRequest requestWithURL:url];//创建NSURLRequest
//    [webView loadRequest:request];//加载
    

    
//    [[ConanAccessRight sharedInstance]ConanAccessRightBluetoothPeripheral:^(BOOL Authorize) {
//        if (Authorize) {
//            NSLog(@"已经授权");
//        } else {
//            NSLog(@"未授权");
//        }
//    }];

}


-(void)desc
{
//    健康分享权限ConanAccessRightHealthShare
//    健康更新权限ConanAccessRightHealthUpdate
//    智能家居权限ConanAccessRightHomeKit
//    音乐权限ConanAccessRightMusic
//    Siri权限ConanAccessRightSiri
//    语音转文字权限ConanAccessRightSpeechRecognition
//    电视供应商权限ConanAccessRightTVProvider
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
