//
//  ConanAccessRight.h
//  AccessRight
//
//  Created by Conan on 2017/2/14.
//  Copyright © 2017年 Conan. All rights reserved.
//

#import <Foundation/Foundation.h>


@import CoreLocation;
@import AVFoundation;

@import Photos;
@import Contacts;
@import AddressBook;

@import EventKit;

@import MediaPlayer;
@import CoreMotion;
@import CoreBluetooth;

@import Speech;
typedef NS_ENUM(NSInteger, LocationAuthorizedType) {
    LocationAuthorizedAlways,
    LocationAuthorizedWhenInUse
};

typedef NS_ENUM(NSInteger, EventAuthorizedType) {
    EventAuthorizedCalendar,//日历权限
    EventAuthorizedReminder //提醒权限
};

typedef void (^LocationResult) (BOOL Authorize, CLLocation *location);

@interface ConanAccessRight : NSObject<CBCentralManagerDelegate>

+ (ConanAccessRight *)sharedInstance;

/*
 *蓝牙权限
 */
-(void)ConanAccessRightBluetoothPeripheral:(void (^)(BOOL Authorize))result;

/*
 *相机权限
 */
-(void)ConanAccessRightCamera:(void (^)(BOOL Authorize))result;

/*
 *通讯录权限
 */
-(void)ConanAccessRightContacts:(void (^)(BOOL Authorize))result;

/*
 *健康分享权限
 */
-(void)ConanAccessRightHealthShare:(void (^)(BOOL Authorize))result;

/*
 *健康更新权限
 */
-(void)ConanAccessRightHealthUpdate:(void (^)(BOOL Authorize))result;

/*
 *智能家居权限
 */
-(void)ConanAccessRightHomeKit:(void (^)(BOOL Authorize))result;

/*
 *媒体库权限
 */
-(void)ConanAccessRightMediaLibrary:(void (^)(BOOL Authorize))result;

/*
 *麦克风权限
 */
-(void)ConanAccessRightMicrophone:(void (^)(BOOL Authorize))result;

/*
 *运动与健身权限
 */
-(void)ConanAccessRightMotion:(void (^)(BOOL Authorize))result;

/*
 *音乐权限
 */
-(void)ConanAccessRightMusic:(void (^)(BOOL Authorize))result;

/*
 *相册权限
 */
-(void)ConanAccessRightPhotoLibrary:(void (^)(BOOL Authorize))result;

/*
 *Siri权限
 */
-(void)ConanAccessRightSiri:(void (^)(BOOL Authorize))result;

/*
 *语音转文字权限
 */
-(void)ConanAccessRightSpeechRecognition:(void (^)(BOOL Authorize))result;

/*
 *电视供应商权限
 */
-(void)ConanAccessRightTVProvider:(void (^)(BOOL Authorize))result;

/*
 *备忘录权限、日历权限
 */
-(void)ConanAccessRightEvent:(EventAuthorizedType)eventType result:(void (^)(BOOL Authorize))result;

/*
 *定位权限
 */
- (void)ConanAccessRightLocation:(LocationAuthorizedType)authorizedType result:(LocationResult)result;

/*
 *推送权限
 */
-(void)ConanAccessRightPush:(void (^)(BOOL Authorize))result;

/*
 *1、联网权限
 */
-(void)ConanAccessRightCTCellularDataRestrictedState:(void (^)(BOOL Authorize))result;
@end
