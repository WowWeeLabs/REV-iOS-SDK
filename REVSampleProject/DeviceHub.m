//
//  PlayerHub.m
//  REVSampleProject
//
//  Created by DavidFF Chan on 22/1/2016.
//  Copyright © 2016 DavidFF Chan. All rights reserved.
//

#import "DeviceHub.h"
#import "Player.h"
#import "Building.h"


@implementation DeviceHub

static NSMutableDictionary * playerListDic;
static Building * theFolk;



+ (id)sharedInstance{
    // structure used to test whether the block has completed or not
    static dispatch_once_t p = 0;
    
    // initialize sharedObject as nil (first call only)
    __strong static id _sharedObject = nil;
    
    // executes a block object once and only once for the lifetime of an application
    dispatch_once(&p, ^{
        _sharedObject = [[self alloc] init];
        playerListDic = [[NSMutableDictionary alloc]init];
        [REVRobotFinderSDK sharedInstance];  
    });
    
    // returns the same object each time
    return _sharedObject;
}

+ (NSMutableDictionary *) playerList{
    
    return playerListDic;
}

- (NSArray *)pendingConnectREVNameList{

    NSMutableArray * tempDeviceNameArray;
    tempDeviceNameArray = [[NSMutableArray alloc]init];
    
    for(REVRobotSDK * tmpRev in [REVRobotFinderSDK sharedInstance].devicesFound)
    {
        [tempDeviceNameArray addObject:tmpRev.name];
    }
    
    
    return tempDeviceNameArray;
}


- (NSString *)pendingConnectRAMPName{
    if ([REVRobotFinderSDK sharedInstance].rampsFound.count > 0)
    {
        return  ((REVRobotSDK *)[[REVRobotFinderSDK sharedInstance].rampsFound firstObject]).name;
    }
    else{
        return nil;
    }
}

-(void)reflashPendingDevice{

    [[REVRobotFinderSDK sharedInstance] clearFoundREVList];
    [self stopScan];
    [self startScan];
    
}

- (void)removePlayerHash:(NSString *)hashKey{
    [self reflashPendingDevice];
    [playerListDic removeObjectForKey:hashKey];
    [_deviceHubDelegate playerListChange];
}

+ (Building *)folt{
    return theFolk;
}

+(void)removeFolt{
    theFolk = nil;
}

- (void)startScan{
    [self addNotificationObservers];
    ((REVRobotFinderSDK *)[REVRobotFinderSDK sharedInstance]).scanOptionsFlagMask = RPFScanOptionMask_FilterByProductId;
    [[REVRobotFinderSDK sharedInstance] scanForREV];
}

-(void)stopScan{
    [[REVRobotFinderSDK sharedInstance] stopScanForREV];
    [self removeNotificationObservers];
}

- (void)addNotificationObservers {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(revFoundNotification:) name:REVRobotFinderNotificationID object:nil];
}

- (void)removeNotificationObservers {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:REVRobotFinderNotificationID object:nil];
}

-(void)revFoundNotification:(NSNotification *)note {
    [_deviceHubDelegate reloadPendingDeviceList];
}

- (Player *)connectREVdeviceByIndex:(int)index{
    
    REVRobotSDK * tmpDevice = [[[REVRobotFinderSDK sharedInstance]devicesFound]objectAtIndex:index];
    NSString * revHash = [NSString stringWithFormat:@"%lu",(unsigned long)tmpDevice.hash];
    Player * tmpPlayer = [playerListDic objectForKey:revHash];
    
    if (!tmpPlayer)
    {
    tmpPlayer  = [[Player alloc]init];
    tmpPlayer.rev = [[[REVRobotFinderSDK sharedInstance]devicesFound]objectAtIndex:index];
    [tmpPlayer.rev connect];
    
    NSString * revHash = [NSString stringWithFormat:@"%lu",(unsigned long)tmpPlayer.rev.hash];
    [playerListDic setObject:tmpPlayer forKey:revHash];
    }
    
    [_deviceHubDelegate playerListChange];
    return tmpPlayer;
    
}

- (Building *)connectRAMPdevice{
    REVRobotSDK * tmpDevice = [[[REVRobotFinderSDK sharedInstance]rampsFound]objectAtIndex:0];
    
    if (!theFolk) {
        theFolk = [[Building alloc]init];
        theFolk.ramp = tmpDevice;
        [theFolk.ramp connect];
    }
    [_deviceHubDelegate buildingChange];
    return theFolk;
}

@end
