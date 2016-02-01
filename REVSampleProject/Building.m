//
//  Building.m
//  REVSampleProject
//
//  Created by DavidFF Chan on 22/1/2016.
//  Copyright © 2016 DavidFF Chan. All rights reserved.
//

#import "Building.h"


@interface Building()

@property (nonatomic, assign) REVRobotColor building_LEDcolor;
@property (nonatomic, assign) BOOL aiEnable;

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
        [_ramp revSetTrackingMode:REVTrackingChase]; //RAMP jumping IR will broadcast, the REV in "REVTrackingRamp" will auto jump over RAMP
    }else{
        [_ramp revSetTrackingMode:REVTrackingUserControl]; //RAMP jumping IR will broadcast stop, the REV in "REVTrackingRamp" auto jump not function.
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
    [_ramp revFlashLEDColor:REVRobotColorRed timeOn:10 timeOff:10 repeat:5]; //RAMP will flash the red LED
    if (_aiEnable) {
            [self  performSelector:@selector(gunFire) withObject:nil afterDelay:10]; //Fire each 10 sec
    }

}


-(void)setBuildingLED:(REVRobotColor)color{
    _building_LEDcolor = color;
    [_ramp revSetLEDColor:color];
}


-(void)connect{
    [self.ramp connect];
}


-(void)REVDeviceReady:(REVRobotSDK *)rev{
    [_ramp revGetTrackingMode];
}


-(void)REVDeviceDisconnected:(REVRobotSDK *)rev cleanly:(bool)cleanly{
    [rev disconnect];
    [DeviceHub removeFolt];
}


-(void)startGame;{
    _aiEnable = true;
    [self gunFire];
}


-(void)stopGame{
    _aiEnable = false;
}


@end
