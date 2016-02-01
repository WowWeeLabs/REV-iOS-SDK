//
//  REVRobotFinderSDK.h
//  Bluetooth Robot Control Library
//
//  Created by Andy on 5/9/14.
//  Copyright (c) 2014 Forrest Chan. All rights reserved.
//


#import "REVRobotSDK.h"
#import "BluetoothRobotFinder.h"
#import "REVSDKConfig.h"

FOUNDATION_EXPORT NSString *const REVRobotFinderNotificationID;
FOUNDATION_EXPORT bool const REV_ROBOT_FINDER_DEBUG_MODE;

typedef enum : NSUInteger {
    REVRobotFinder_REVFound = 1,
    REVRobotFinder_RAMPFound,
    REVRobotFinder_LUMIFound,
    REVRobotFinder_REVListCleared,
    REVRobotFinder_BluetoothError,
    REVRobotFinder_BluetoothStoppedScanning,
    REVRobotFinder_ConnectedBroadcastREVFound,
    REVRobotFinder_ConnectedBroadcastREVUpdated
} REVRobotFinderNotificationValue;

@interface REVRobotFinderSDK : BluetoothRobotFinder <CBCentralManagerDelegate>

@property (assign, nonatomic) REVFinderScanOptions scanOptionsFlagMask; //Dd to be confirm expose or not

@property (nonatomic, strong, readonly) NSMutableArray *devicesFound;
@property (nonatomic, strong, readonly) NSMutableArray *devicesConnected;
@property (nonatomic, strong, readonly) NSMutableArray *rampsFound;
@property (nonatomic, strong, readonly) NSMutableArray *rampsConnected;
@property (nonatomic, assign, readonly) CBCentralManagerState cbCentralManagerState; //Dd to be confirm expose or not


@property (nonatomic, assign) uint16_t scanFoundProductId;

/** Starts the BLE scanning */
-(void)scanForREV;
-(void)startScan;

/** Starts the BLE scanning for a specified number of seconds. Normally you should use this method because endlessly scanning is very battery intensive. */
-(void)scanForREVForDuration:(NSUInteger)seconds;
-(void)stopScanForREV;
-(void)clearFoundREVList;

/**
 Quick access to first connected MiP in mipsConnected list
 @return devicesConnected[0] or nil if devicesConnected is empty
 */

-(REVRobotSDK *)firstConnectedREV;
-(NSMutableArray *)revFound;

-(void) postNotification:(REVRobotFinderNotificationValue)broadcast;
-(void) postNotification:(REVRobotFinderNotificationValue)broadcast withData:(id)data ;

@end