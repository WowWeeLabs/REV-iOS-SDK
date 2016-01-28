//
//  Building.h
//  REVSampleProject
//
//  Created by DavidFF Chan on 22/1/2016.
//  Copyright © 2016 DavidFF Chan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DeviceHub.h"
#import <WowWeeREVSDK/WowWeeREVSDK.h>

@class Building;
@protocol BuildingDelegate <NSObject>

@optional
-(void)remainHealthLevel:(int)health orgHealth:(int)orgHealth Building:(Building *)building;
-(void)remainBullet:(int)bullet orgBullet:(int)orgBullet Building:(Building *)building;
-(void)status:(NSString*)status Building:(Building *)building;
@end

@interface Building : NSObject <REVRobotDelegateSDK>


@property (setter=rampAssigment:,getter=rampGetter, weak) REVRobotSDK * ramp;
@property (nonatomic, weak) id <BuildingDelegate> buildingdelegate;
@property (setter=selectGunID:,getter=building_gunID, assign) uint8_t building_gunID;
@property (setter=setJumper:, getter=jumperOnOff) Boolean jumperOnOff;

-(void)gunFire;
-(void)setBuildingLED:(REVRobotColor)color;

@end
