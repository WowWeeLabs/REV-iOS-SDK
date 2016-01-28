//
//  Building.m
//  REVSampleProject
//
//  Created by DavidFF Chan on 22/1/2016.
//  Copyright © 2016 DavidFF Chan. All rights reserved.
//

#import "Building.h"
#import <WowWeeREVSDK/WowWeeREVSDK.h>

@interface Building()

@property (nonatomic, assign) REVRobotColor building_LEDcolor;

@end

@implementation Building

@synthesize ramp = _ramp;
@synthesize building_gunID = _building_gunID;
@synthesize jumperOnOff = _jumperOnOff;

-(void)rampAssigment:(REVRobotSDK *)ramp{
    _ramp = ramp;
    _ramp.REVRobotDelegateSDK_delegate = self;
    
}

-(REVRobotSDK *)rampGetter{
    return _ramp;
}

-(void)setJumper:(Boolean)jumperOnOff{
    _jumperOnOff = jumperOnOff;
    if (jumperOnOff)
    {
        [_ramp revSetTrackingMode:REVTrackingChase];
    }else{
        [_ramp revSetTrackingMode:REVTrackingUserControl];
    }
}

-(Boolean)jumperOnOff{
    return  _jumperOnOff;
}

-(void)selectGunID:(uint8_t)gunID{
    _building_gunID = gunID;
}

-(uint8_t)building_gunID{
    return _building_gunID;
}

-(void)gunFire{
    [_ramp rampSendIRCommand:_building_gunID direction:RampTXShooterIR];
}

-(void)setBuildingLED:(REVRobotColor)color{
    _building_LEDcolor = color;
    [_ramp revSetLEDColor:color];
}

-(void)connect{
    [self.ramp connect];
}

-(void)REVDeviceReady:(REVRobotSDK *)rev
{
    [_ramp revGetTrackingMode];
}

-(void)REVDeviceDisconnected:(REVRobotSDK *)rev cleanly:(bool)cleanly{
    [rev disconnect];
    [DeviceHub removeFolt];
}

- (void)REVRobot:(REVRobotSDK *)rev didReceivedIRCommand:(uint8_t)irCommand rx:(REVRobotRXSensor)rxSensor{
    NSLog(@"irCommand %d, rxSensor %d rev.name %@" ,irCommand, rxSensor, rev.name );
}

- (void)REVRobot:(REVRobotSDK *)rev didReceivedTrackingStatus:(REVTrackingStatus *)trackingStatus{
    NSLog(@"trackingStatus.degrees %d, trackingStatus.strength %d ",trackingStatus.degrees, trackingStatus.strength);
}





@end
