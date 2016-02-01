//
//  PlayerHub.h
//  REVSampleProject
//
//  Created by DavidFF Chan on 22/1/2016.
//  Copyright © 2016 DavidFF Chan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <WowWeeREVSDK/WowWeeREVSDK.h>

@class Player;
@protocol DeviceHubDelegate <NSObject>
@optional
-(void)reloadPendingDeviceList;
-(void)selectedDeviceIndex:(int)index Player:(Player *)player;
-(void)playerListChange;
-(void)buildingChange;
@end


@class Building;
@interface DeviceHub : NSObject

+ (DeviceHub *)sharedInstance;
+ (NSMutableDictionary *) playerList;
+ (Building *)folt;
+ (void)removeFolt;

- (void)removePlayerHash:(NSString *)hashKey;
- (NSArray *)pendingConnectREVNameList;
- (NSString *)pendingConnectRAMPName;
- (Player *)connectREVdeviceByIndex:(int)index;
- (Building *)connectRAMPdevice;

- (void)startScan;
- (void)stopScan;
- (void)reflashPendingDevice;

@property (nonatomic,weak) id  <DeviceHubDelegate>  deviceHubDelegate;
@end

