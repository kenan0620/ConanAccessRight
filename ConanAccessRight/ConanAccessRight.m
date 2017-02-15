//
//  ConanAccessRight.m
//  AccessRight
//
//  Created by Conan on 2017/2/14.
//  Copyright © 2017年 Conan. All rights reserved.
//

#import "ConanAccessRight.h"
@import CoreTelephony;

@interface ConanAccessRight ()<CLLocationManagerDelegate>
@property (strong, nonatomic) CNContactStore *contactStore;
@property (strong, nonatomic) EKEventStore *eventStore;
@property (strong, nonatomic) CLLocationManager *locationManager;
@property (copy, nonatomic) LocationResult locationBlock;

@end
@implementation ConanAccessRight
+ (ConanAccessRight *)sharedInstance
{
    static ConanAccessRight *accessRightShareInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        accessRightShareInstance = [[ConanAccessRight alloc]init];
    });
    return  accessRightShareInstance;
}

/*
 *蓝牙权限
 */
-(void)ConanAccessRightBluetoothPeripheral:(void (^)(BOOL Authorize))result
{
    
}

/*
 *相机权限
 *
 *
 AVAuthorizationStatusNotDetermined = 0,用户尚未做出选择这个应用程序的问候
	AVAuthorizationStatusRestricted,此应用程序没有被授权访问的照片数据。可能是家长控制权限
	AVAuthorizationStatusDenied,用户已经明确否认了这一照片数据的应用程序访问
	AVAuthorizationStatusAuthorized用户已经授权应用访问照片数据

 */
-(void)ConanAccessRightCamera:(void (^)(BOOL Authorize))result
{
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    
    if(authStatus == AVAuthorizationStatusNotDetermined){
        [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
            result(granted);
        }];
    } else if (authStatus == AVAuthorizationStatusAuthorized) {
        result(YES);
    } else {
        result(NO);
    }
}

/*
 *通讯录权限
 */
-(void)ConanAccessRightContacts:(void (^)(BOOL Authorize))result
{
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 9.0) {
        CNAuthorizationStatus status = [CNContactStore authorizationStatusForEntityType:CNEntityTypeContacts];
        
        if (status == CNAuthorizationStatusNotDetermined) {
            self.contactStore = [[CNContactStore alloc] init];
            [_contactStore requestAccessForEntityType:CNEntityTypeContacts completionHandler:^(BOOL granted, NSError * _Nullable error) {
                result(granted);
            }];
        } else if (status == CNAuthorizationStatusAuthorized) {
            result(YES);
        } else {
            result(NO);
        }
    } else {  //iOS 8 and below
        ABAuthorizationStatus status = ABAddressBookGetAuthorizationStatus();
        if (status == kABAuthorizationStatusNotDetermined) {
            ABAddressBookRef addressBook = ABAddressBookCreateWithOptions(nil, nil);
            
            ABAddressBookRequestAccessWithCompletion(addressBook, ^(bool granted, CFErrorRef error){
                result(granted);
                CFRelease(addressBook);
            });
        } else if (status == kABAuthorizationStatusAuthorized) {
            result(YES);
        } else {
            result(NO);
        }
    }
}

/*
 *健康分享权限
 */
-(void)ConanAccessRightHealthShare:(void (^)(BOOL Authorize))result
{
    
}

/*
 *健康更新权限
 */
-(void)ConanAccessRightHealthUpdate:(void (^)(BOOL Authorize))result
{
    
}

/*
 *智能家居权限
 */
-(void)ConanAccessRightHomeKit:(void (^)(BOOL Authorize))result
{
    
}

/*
 *定位权限
 */
-(void)ConanAccessRightLocatio:(void (^)(BOOL Authorize))result
{
}

/*
 *媒体库权限
 */
-(void)ConanAccessRightMediaLibrary:(void (^)(BOOL Authorize))result
{
    
}

/*
 *麦克风权限
 */
-(void)ConanAccessRightMicrophone:(void (^)(BOOL Authorize))result
{
    AVAudioSessionRecordPermission micPermisson = [[AVAudioSession sharedInstance] recordPermission];
    
    if (micPermisson == AVAudioSessionRecordPermissionUndetermined) {
        [[AVAudioSession sharedInstance] requestRecordPermission:^(BOOL granted) {
            result(granted);
        }];
    } else if (micPermisson == AVAudioSessionRecordPermissionGranted) {
        result(YES);
    } else {
        result(NO);
    }
}

/*
 *运动与健身权限
 */
-(void)ConanAccessRightMotion:(void (^)(BOOL Authorize))result
{
    
}

/*
 *音乐权限
 */
-(void)ConanAccessRightMusic:(void (^)(BOOL Authorize))result
{
    
}

/*
 *相册权限
 */
-(void)ConanAccessRightPhotoLibrary:(void (^)(BOOL Authorize))result
{
    PHAuthorizationStatus photoStatus = [PHPhotoLibrary authorizationStatus];
    
    if (photoStatus == PHAuthorizationStatusNotDetermined) {
        [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
            if (status == PHAuthorizationStatusAuthorized) {
                result(YES);
            } else {
                result(NO);
            }
        }];
    } else if (photoStatus == PHAuthorizationStatusAuthorized) {
        result(YES);
    } else {
        result(NO);
    }
}

/*
 *Siri权限
 */
-(void)ConanAccessRightSiri:(void (^)(BOOL Authorize))result
{
    
}

/*
 *语音转文字权限
 */
-(void)ConanAccessRightSpeechRecognition:(void (^)(BOOL Authorize))result
{
    
}

/*
 *电视供应商权限
 */
-(void)ConanAccessRightTVProvider:(void (^)(BOOL Authorize))result
{
    
}

/*
 *备忘录权限、日历权限
 */
-(void)ConanAccessRightEvent:(EventAuthorizedType)eventType result:(void (^)(BOOL Authorize))result
{
    EKEntityType type = eventType == EventAuthorizedCalendar ? EKEntityTypeEvent : EKEntityTypeReminder;
    
    EKAuthorizationStatus status = [EKEventStore authorizationStatusForEntityType:type];
    if (status == EKAuthorizationStatusNotDetermined) {
        if (!self.eventStore) {
            self.eventStore = [[EKEventStore alloc] init];
        }
        [self.eventStore requestAccessToEntityType:type completion:^(BOOL granted, NSError * _Nullable error) {
            result(granted);
        }];
    } else if (status == EKAuthorizationStatusAuthorized) {
        result(YES);
    } else {
        result(NO);
    }

}

/*
 *定位权限
 */
- (void)ConanAccessRightLocation:(LocationAuthorizedType)authorizedType result:(LocationResult)result
{
    CLAuthorizationStatus status = [CLLocationManager authorizationStatus];
    if (status == kCLAuthorizationStatusNotDetermined) {
        
        if (!self.locationManager) {
            self.locationManager = [[CLLocationManager alloc] init];
            self.locationManager.delegate = self;
        }
        
        self.locationBlock = result;
        
        if (authorizedType == LocationAuthorizedAlways) {
            [self.locationManager requestAlwaysAuthorization];
        } else {
            [self.locationManager requestWhenInUseAuthorization];
        }
    } else if (status == kCLAuthorizationStatusAuthorizedAlways || status == kCLAuthorizationStatusAuthorizedWhenInUse){
        result(YES, nil);
    } else {
        result(NO, nil);
    }

}

#pragma mark - CLLocationManagerDelegate

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    _locationBlock(YES, nil);
}

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    _locationBlock(YES, newLocation);
    
    [self stopLocationService];
}

- (void)stopLocationService
{
    [self.locationManager stopUpdatingLocation];
    self.locationManager.delegate=nil;
    self.locationManager = nil;
}


/*
 *1、联网权限
 */
-(void)ConanAccessRightCTCellularDataRestrictedState:(void (^)(BOOL Authorize))result
{
    CTCellularData *cellularData = [[CTCellularData alloc]init];
    cellularData.cellularDataRestrictionDidUpdateNotifier =  ^(CTCellularDataRestrictedState state){
        //获取联网状态
        switch (state) {
            case kCTCellularDataRestricted:
                NSLog(@"Restricrted");
                break;
            case kCTCellularDataNotRestricted:
                NSLog(@"Not Restricted");
                break;
            case kCTCellularDataRestrictedStateUnknown:
                NSLog(@"Unknown");
                break;
            default:
                break;
        };
    };
}

/*
 *推送权限
 */
-(void)ConanAccessRightPush:(void (^)(BOOL Authorize))result
{
    UIUserNotificationSettings *notificationSettings = [UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeAlert | UIUserNotificationTypeBadge | UIUserNotificationTypeSound categories:nil];
    [[UIApplication sharedApplication] registerUserNotificationSettings:notificationSettings];
    
}
@end
