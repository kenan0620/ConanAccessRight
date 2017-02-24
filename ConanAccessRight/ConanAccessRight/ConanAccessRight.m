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

@property (strong, nonatomic) CMPedometer *stepCounter;

@property (nonatomic, strong) CBCentralManager *cMgr;

@property (nonatomic, strong) CBPeripheral *peripheral;

//@property (strong, nonatomic) UILabel *stepsLabel;
//@property (strong, nonatomic) UILabel *distanceLabel;
//@property (strong, nonatomic) UILabel *paceLabel;
//@property (strong, nonatomic) UILabel *cadenceLabel;
//@property (strong, nonatomic) UILabel *flightsUpLabel;
//@property (strong, nonatomic) UILabel *flightsDownLabel;
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
  CBCentralManager *resutlMana =  [self cmgr];
/*
 CBCentralManagerStateUnknown://未知状态
 CBCentralManagerStateResetting://重新设置
 CBCentralManagerStateUnsupported://不支持蓝牙
 CBCentralManagerStateUnauthorized://未被授权的
 CBCentralManagerStatePoweredOff://蓝牙未开启
 CBCentralManagerStatePoweredOn://蓝牙已开启
 */
 
    if (resutlMana.state == CBCentralManagerStatePoweredOn) {
        result(YES);
        NSLog(@"CBCentralManagerStatePoweredOn");//蓝牙已开启
        //            // 在中心管理者成功开启后再进行一些操作
        //            // 搜索外设
        //            [self.cMgr scanForPeripheralsWithServices:nil // 通过某些服务筛选外设
        //                                              options:nil]; // dict,条件
        //            // 搜索成功之后,会调用我们找到外设的代理方法
        //            // - (void)centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary *)advertisementData RSSI:(NSNumber *)RSSI; //找到外设
    } else {
        result(NO);
    }
}

-(CBCentralManager *)cmgr
{
    if (!_cMgr) {
        _cMgr = [[CBCentralManager alloc] initWithDelegate:self queue:nil];
    }
    return _cMgr;
}
//只要中心管理者初始化 就会触发此代理方法 判断手机蓝牙状态
- (void)centralManagerDidUpdateState:(CBCentralManager *)central
{

//    switch (central.state) {
//        case 0:
//            NSLog(@"CBCentralManagerStateUnknown");//未知状态
//            break;
//        case 1:
//            NSLog(@"CBCentralManagerStateResetting");//重新设置
//            break;
//        case 2:
//            NSLog(@"CBCentralManagerStateUnsupported");//不支持蓝牙
//            break;
//        case 3:
//            NSLog(@"CBCentralManagerStateUnauthorized");//未被授权的
//            break;
//        case 4:
//        {
//            NSLog(@"CBCentralManagerStatePoweredOff");//蓝牙未开启
//        }
//            break;
//        case 5:
//        {
//            NSLog(@"CBCentralManagerStatePoweredOn");//蓝牙已开启
//            // 在中心管理者成功开启后再进行一些操作
//            // 搜索外设
//            [self.cMgr scanForPeripheralsWithServices:nil // 通过某些服务筛选外设
//                                              options:nil]; // dict,条件
//            // 搜索成功之后,会调用我们找到外设的代理方法
//            // - (void)centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary *)advertisementData RSSI:(NSNumber *)RSSI; //找到外设
//        }
//            break;
//        default:
//            break;
//    }
    
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
 *APPle Music 和媒体资料库权限
 *
 *    
 MPMediaLibraryAuthorizationStatusNotDetermined = 0,用户尚未做出选择这个应用程序的问候
 MPMediaLibraryAuthorizationStatusDenied,用户已经明确否认了这一照片数据的应用程序访问
 MPMediaLibraryAuthorizationStatusRestricted,此应用程序没有被授权访问的照片数据。可能是家长控制权限
 MPMediaLibraryAuthorizationStatusAuthorized,用户已经授权应用访问照片数据
 */
-(void)ConanAccessRightMediaLibrary:(void (^)(BOOL Authorize))result
{
    [MPMediaLibrary requestAuthorization:^(MPMediaLibraryAuthorizationStatus mediaLibrarystatus){
        
        if(mediaLibrarystatus == MPMediaLibraryAuthorizationStatusNotDetermined){
            result(NULL);
        } else if (mediaLibrarystatus == MPMediaLibraryAuthorizationStatusAuthorized) {
            result(YES);
        } else {
            result(NO);
        }
    }];
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
    self.stepCounter = [[CMPedometer alloc]init];
    //国际标准时间
    NSDate *date = [NSDate date];
    
    NSTimeZone *zone = [NSTimeZone systemTimeZone];
    
    NSInteger interval = [zone secondsFromGMTForDate: date];
    //北京本地实际时间
    NSDate *localeDate = [date  dateByAddingTimeInterval: interval];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HHH:mm:ss"];
    NSDate *fromDate =
    [dateFormatter dateFromString:[dateFormatter stringFromDate:localeDate]];
    
    [self.stepCounter queryPedometerDataFromDate:date toDate:fromDate withHandler:^(CMPedometerData * _Nullable pedometerData, NSError * _Nullable error) {

        [[NSUserDefaults standardUserDefaults]setObject:pedometerData.numberOfSteps forKey:@"pedometerSteps"];

        if(!pedometerData.numberOfSteps) {

            result(NO);
        }else
        {
            result(YES);
//            NSLog(@"coann--%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"pedometerSteps"]);
        }

    }];
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
 *备忘录(提醒事项)权限、日历权限
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
 *联网权限
 */
-(void)ConanAccessRightCTCellularDataRestrictedState:(void (^)(BOOL Authorize))result
{
    CTCellularData *cellularData = [[CTCellularData alloc]init];
    cellularData.cellularDataRestrictionDidUpdateNotifier =  ^(CTCellularDataRestrictedState state){
        //获取联网状态
        switch (state) {
            case kCTCellularDataRestricted:
                
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
                break;
            case kCTCellularDataNotRestricted:
                
                break;
            case kCTCellularDataRestrictedStateUnknown:
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];

                break;
            default:
                break;
        };
        if (state == kCTCellularDataNotRestricted) {
            result(YES);
        } else {
            result(NO);
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
