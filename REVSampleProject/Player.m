//
//  Player.m
//  REVSampleProject
//
//  Created by DavidFF Chan on 22/1/2016.
//  Copyright © 2016 DavidFF Chan. All rights reserved.
//

#import "Player.h"
#import "GunData.h"

@interface Player()

@property (nonatomic, assign) Boolean gunReload;
@property (nonatomic, assign) Boolean gunlock;
@property (nonatomic, assign) Boolean lose;
@property (nonatomic, assign) Boolean gunDemo;
@property (nonatomic, assign) int player_health;
@property (nonatomic, assign) int player_gunBulletNo;
@property (nonatomic, assign) float player_gunFireResume;
@property (nonatomic, assign) float player_gunReloadTime;
@property (nonatomic, assign) REVTXDirection player_gunDirection;
@property (nonatomic, assign) uint8_t player_gunFireSound;
@property (nonatomic, assign) REVRobotColor player_LEDcolor;
@end



@implementation Player

@synthesize rev = _rev;
@synthesize player_gunID = _player_gunID;
@synthesize trackMode = _trackMode;
int orgBullet;
int orgHealth;

-(void)revAssigment:(REVRobotSDK *)rev{
    
    _rev = rev;
    _rev.REVRobotDelegateSDK_delegate = self;
    _revHash = [NSString stringWithFormat:@"%lu",(unsigned long)rev.hash];

}

-(REVRobotSDK *)revGetter{
    return _rev;
}


-(void)gunFire{
    if ((!_gunlock)&&(!_gunReload)&&(!_lose)) {
    NSLog(@"-(void)gunFire");
    [_rev revSendIRCommand:_player_gunID  soundIndex:_player_gunFireSound  direction:_player_gunDirection];
    _gunlock = true;
    _player_gunBulletNo --;
    [_playerdelegate remainBullet:_player_gunBulletNo orgBullet:orgBullet Player:self];
        
        if (_player_gunBulletNo <= 0) {
            _gunReload = true;
            [_rev revFlashLEDColor:REVRobotColorRed timeOn:200 timeOff:200 repeat:1000];
            [self performSelector:@selector(gunBulletReload) withObject:nil afterDelay:_player_gunReloadTime];
            [_playerdelegate status:@"Wait reload" Player:self];
        }else{
         [self performSelector:@selector(gunrelease) withObject:nil afterDelay:_player_gunFireResume];
        }
   

    NSLog(@"_player_gunBulletNo %d",_player_gunBulletNo);
    }
}

-(void)playGunDemo{
    if (!_gunDemo) {
        _gunDemo = true;
        uint8_t gotFireSound =  ((GunData *)[[GunData gunsList] objectAtIndex:_player_gunID]).fireSound;
        [_rev revPlaySound:gotFireSound];
        [self performSelector:@selector(playGunDemo) withObject:nil afterDelay:1];
        [_playerdelegate gunDemoMessage:@"Fire!!"];
    }else{
        uint8_t gotFireSound =  ((GunData *)[[GunData gunsList] objectAtIndex:_player_gunID]).gotFireSound;
        [_rev revPlaySound:gotFireSound];
         [_playerdelegate gunDemoMessage:@"Got shot!!"];
        _gunDemo = false;
    }
}

-(void)setREVTrackMode:(REVRobotTrackingMode)trackMode{
    _trackMode = trackMode;
    [_rev revSetTrackingMode:trackMode];
}

-(REVRobotTrackingMode)trackMode{
    return _trackMode;
}

-(void)gunrelease{
    NSLog(@"-(void)gunrelease");
    [self ledResume];
    _gunlock = false;
}

-(void)gunBulletReload{
    NSLog(@"-(void)gunBulletReload");
    _gunReload = false;
    [self gunrelease];
    [self selectGunID:_player_gunID];
}

-(void)lifeResume{
    _lose = false;
    _player_health = orgHealth;
    [self ledResume];
    [self checkStatus];

}

-(void)checkStatus{
    [_playerdelegate remainBullet:_player_gunBulletNo orgBullet:orgBullet Player:self];
    [_playerdelegate remainHealthLevel:_player_health orgHealth:orgHealth Player:self];
    [_playerdelegate status:@"Ready" Player:self];
}

-(void)ledResume{
 [_rev revSetLEDColor:_player_LEDcolor];
}

-(void)gotShotGunID:(int)gunID{
    NSLog(@"%@ ",_rev.name);
    NSLog(@"gotShotGunID %d",gunID);
    if (_lose)
    {
        return;
    }
        
        
    uint8_t gotFireSound =  ((GunData *)[[GunData gunsList] objectAtIndex:gunID]).gotFireSound;
    int damage =  ((GunData *)[[GunData gunsList] objectAtIndex:gunID]).damage;
    
    _player_health =  _player_health - damage;
    
    
   [_rev revPlaySound:gotFireSound];
    [_rev revSetLEDColor:REVRobotColorRed];

    
    if (_player_health <= 0)
    {
        _lose = true;
        [_playerdelegate status:@"Lose! Wait 10sec resume" Player:self];
        [self performSelector:@selector(lifeResume) withObject:nil afterDelay:10];
    }else{
        [self performSelector:@selector(ledResume) withObject:nil afterDelay:0.1];
    }
    
    [_playerdelegate remainHealthLevel:_player_health orgHealth:orgHealth Player:self];
    NSLog(@"_player_health %d",_player_health);
    
}

-(void)selectGunID:(uint8_t)gunID{
    _player_gunID = gunID;
    orgBullet = ((GunData *)[[GunData gunsList] objectAtIndex:gunID]).bulletNo;
    _player_gunBulletNo = orgBullet;
    _player_gunFireResume = ((GunData *)[[GunData gunsList] objectAtIndex:gunID]).fireResume;
    _player_gunReloadTime = ((GunData *)[[GunData gunsList] objectAtIndex:gunID]).reloadTime;
    _player_gunDirection = ((GunData *)[[GunData gunsList] objectAtIndex:gunID]).allDirection? REVTXAll: REVTXFront;
    _player_gunFireSound =  ((GunData *)[[GunData gunsList] objectAtIndex:gunID]).fireSound;
    
}

-(uint8_t)player_gunID{
    return _player_gunID;
}

-(void)playerDrive:(CGVector)vector{
    if (_lose)
    {
        return;
    }
        [_rev revDrive:vector];
}

-(void)setPlayerLED:(REVRobotColor)color{
    _player_LEDcolor = color;
    [_rev revSetLEDColor:color];
}

-(void)connect{
    _revHash = [NSString stringWithFormat:@"%lu",(unsigned long)self.hash];
    [self.rev connect];
}

#pragma mark - REVRobotDelegateSDK call back
-(void)REVDeviceReady:(REVRobotSDK *)rev
{
    [rev revSetSoundVolume:1];
    [rev revSetTrackingMode:REVTrackingUserControl];
    _trackMode = REVTrackingUserControl;
    _lose = false;
    _gunlock = false;
    _gunReload = false;
    _gunDemo = false;
    orgHealth = 100;
    _player_health = orgHealth;
    [self selectGunID:0];
  
}

-(void)REVDeviceDisconnected:(REVRobotSDK *)rev cleanly:(bool)cleanly{
    [rev disconnect];
    [[DeviceHub sharedInstance] removePlayerHash:_revHash];
}

- (void)REVRobot:(REVRobotSDK *)rev didReceivedIRCommand:(uint8_t)irCommand rx:(REVRobotRXSensor)rxSensor{
    
    if((irCommand >= 0)&&(irCommand <= 14))
    {
        [self gotShotGunID:irCommand];
    }
    
}

- (void)REVRobot:(REVRobotSDK *)rev didReceivedTrackingStatus:(REVTrackingStatus *)trackingStatus{
}




@end
