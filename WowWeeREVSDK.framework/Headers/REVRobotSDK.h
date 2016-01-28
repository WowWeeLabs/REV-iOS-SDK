//
//  REVRobotSDK.h
//  REV
//
//  Created by DavidFF Chan on 12/1/2016.
//  Copyright © 2016 ___WOWWEE___. All rights reserved.
//

@import UIKit;
@import Foundation;
#import <CoreBluetooth/CoreBluetooth.h>

#import "REVCommandValuesSDK.h"
#import "REVRobotConstantSDK.h"


#import "BluetoothRobot.h"


#import "RobotCommand.h"

#import "REVTrackingStatus.h"

@protocol REVRobotDelegateSDK;

FOUNDATION_EXPORT NSString *const REV_CONNECTED_NOTIFICATION_NAME;
FOUNDATION_EXPORT NSString *const REV_DISCONNECTED_NOTIFICATION_NAME;
#define BatteryLevelToVoltage     (3.6*275/75/256)

typedef enum : NSUInteger {
    UNKNOW = 0,
    REV,
    RAMP,
    LUMI,
} REVType;

@interface REVRobotSDK : BluetoothRobot

/** Determine it's a REV or RAMP */
@property (nonatomic, assign) REVType revType;

/** Current RSSI value */
@property (nonatomic, strong) NSNumber *rssi;

/** Current car mode */
@property (nonatomic, assign) REVRobotTrackingMode revTrackingMode;

/** REV battery level. From 0 to 1 */
@property (nonatomic, assign) float batteryLevel;

/** REV battery level. From 0 to 1 */
@property (nonatomic, assign) BOOL isRechargableBattery;




/** Hardware version */
@property (nonatomic, assign) int voiceChipVersion;
@property (nonatomic, assign) int irChipVersion;

/** REV volume */
@property (nonatomic, assign) int volume;

/** Beacon status */
@property (nonatomic, assign) BOOL beaconFound;

@property (nonatomic, weak) id<REVRobotDelegateSDK> REVRobotDelegateSDK_delegate;



- (void)initVariables;

#pragma mark - REV Commands

- (void)revDrive:(CGVector)vector;  // from -1 to 1
- (void)revDrive:(CGVector)vector driveSpeedRatio:(float)driveSpeedRatio turnSpeedRatio:(float)turnSpeedRatio;  // from -1 to 1
- (void)revTurnLeftByTime:(float)time turnSpeed:(float)turnSpeedRatio;
- (void)revTurnRightByTime:(float)time turnSpeed:(float)turnSpeedRatio;
- (void)revDriveForwardWithTime:(float)time;
- (void)revDriveBackwardWithTime:(float)time;
- (void)revPlaySound:(uint8_t)soundByte;
- (void)revPlaySound:(uint8_t)soundByte repeatTimes:(uint8_t)repeatTimes;
- (void)revSetTrackingMode:(REVRobotTrackingMode)trackingMode;
- (void)revGetTrackingMode;
- (void)revSetTrackingSensorStatusNotifyEnabled:(BOOL)notifyEnabled;
- (void)revSetTrackingDistance:(REVRobotTrackingDistance)trackingDistance trackingSpeed:(REVRobotTrackingSpeed)trackingSpeed;
- (void)revGetTrackingDistanceAndSpeed;
- (void)revSendIRCommand:(uint8_t)irCommand soundIndex:(uint8_t)sound direction:(REVTXDirection)direction;
- (void)rampSendIRCommand:(uint8_t)irCommand direction:(RampTXDirection)direction;
- (void)revStop;
- (void)revGetLEDColor;
- (void)revSetLEDColor:(REVRobotColor)revColor;
- (void)revFlashLEDColor:(REVRobotColor)revColor timeOn:(int)timeOnMilliseconds timeOff:(int)timeOffMilliseconds repeat:(int)repeat;
- (void)revPulsateLEDColor:(REVRobotColor)revColor timeOn:(int)timeOnMilliseconds timeOff:(int)timeOffMilliseconds;
- (void)revGetBatteryLevel;
- (void)revGetHardwareVersion;
- (void)revGetSoftwareVersion;
- (void)revSetBumpNotifyOnOff:(BOOL)isOn;
- (void)revSetSoundVolume:(uint8_t)soundVolume;      // 0 - 7
- (void)revGetSoundVolume;
- (void)revGetMotorVoltage;
- (void)revSetTraction:(REVTraction)traction;
- (void)didReceiveRawCommandData:(NSData *)data;

@end


#pragma mark - REVRobotDelegate
@protocol REVRobotDelegateSDK <NSObject>

@optional
/** Connection Methods **/
- (void)REVDeviceConnected:(REVRobotSDK *)rev;
- (void)REVDeviceReady:(REVRobotSDK *)rev;
- (void)REVDeviceDisconnected:(REVRobotSDK *)rev cleanly:(bool)cleanly;
- (void)REVDeviceFailedToConnect:(REVRobotSDK *)rev error:(NSError *)error;
- (void)REVDeviceDidReceivedRawData:(REVRobotSDK *)rev data:(NSData*)data;

- (void)REVRobotDidReceiveBump:(REVRobotSDK *)rev;

- (void)REVRobot:(REVRobotSDK *)rev didReceivedTrackingMode:(REVRobotTrackingMode)trackingMode;
- (void)REVRobot:(REVRobotSDK *)rev didReceivedTrackingStatus:(REVTrackingStatus *)trackingStatus;
- (void)REVRobot:(REVRobotSDK *)rev didReceivedTrackingDistance:(REVRobotTrackingDistance)trackingDistance trackingSpeed:(REVRobotTrackingSpeed)trackingSpeed;
- (void)REVRobot:(REVRobotSDK *)rev didReceivedIRCommand:(uint8_t)irCommand rx:(REVRobotRXSensor)rxSensor;
- (void)REVRobot:(REVRobotSDK *)rev didReceivedCurrentLEDColor:(REVRobotColor)revColor;
- (void)REVRobot:(REVRobotSDK *)rev didReceivedBatteryLevel:(float)batteryLevel isRechargable:(BOOL)isRechargable;
- (void)REVRobot:(REVRobotSDK *)rev didReceivedVoiceChipVersion:(int)voiceChipVersion irChipVersion:(int)irChipVersion;
- (void)REVRobot:(REVRobotSDK *)rev didReceivedSoftwareVersion:(NSString *)softwareVersion;
- (void)REVRobot:(REVRobotSDK *)rev didReceivedSoundVolume:(int)volume;
- (void)REVRobotBeaconStatusUpdated:(id)sender;
- (void)REVRobot:(REVRobotSDK *)rev didReceivedMotorVoltage:(float)motorVoltage;


@end

