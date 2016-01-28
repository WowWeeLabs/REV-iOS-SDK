//
//  Player.h
//  REVSampleProject
//
//  Created by DavidFF Chan on 22/1/2016.
//  Copyright © 2016 DavidFF Chan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <WowWeeREVSDK/WowWeeREVSDK.h>
#import "DeviceHub.h"
#import "GunData.h"


@class Player;
@protocol PlayerDelegate <NSObject>

@optional
-(void)remainHealthLevel:(int)health orgHealth:(int)orgHealth Player:(Player *)player;
-(void)remainBullet:(int)bullet orgBullet:(int)orgBullet Player:(Player *)player;
-(void)status:(NSString*)status Player:(Player *)player;
-(void)gunDemoMessage:(NSString *)message;

@end

@interface Player : NSObject <REVRobotDelegateSDK>

@property (nonatomic, strong) NSString * revHash;
@property (setter=revAssigment:,getter=revGetter, weak) REVRobotSDK * rev;
@property (nonatomic, weak) id <PlayerDelegate> playerdelegate;
@property (setter=selectGunID:,getter=player_gunID, assign) uint8_t player_gunID;
@property (setter=setREVTrackMode:,getter=trackMode, assign) REVRobotTrackingMode trackMode;


-(void)playerDrive:(CGVector)vector;
-(void)gunFire;
-(void)playGunDemo;
-(void)setPlayerLED:(REVRobotColor)color;
-(void)checkStatus;
@end
