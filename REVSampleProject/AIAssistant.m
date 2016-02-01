//
//  AIAssistant.m
//  REVSampleProject
//
//  Created by DavidFF Chan on 1/2/2016.
//  Copyright © 2016 DavidFF Chan. All rights reserved.
//

#import "AIAssistant.h"


@interface AIAssistant ()

@property(nonatomic,assign)BOOL aiGaming;
@property(nonatomic,assign)int damage;
@property(nonatomic,assign)float reloadTime;
@property(nonatomic,assign)float resumeTime;

@end


@implementation AIAssistant

@synthesize aiGaming = _aiGaming;
@synthesize  damage = _damage;
@synthesize  reloadTime = _reloadTime;
@synthesize  resumeTime = _resumeTime;

-(id)initGunDamagePower:(int)gunDamagePower bulletReloadTime:(float)bulletReloadTime gunResume:(float)gunResume{
    if (self = [super init]){
    
        _damage = gunDamagePower;
        _reloadTime = bulletReloadTime;
        _resumeTime = gunResume;
        _aiGaming = false;
    }
    return self;
}


-(void)aiGotShot:(int)demage healthRemain:(int)healthRemain bulletRemain:(int)bulletRemain{

    if (!_aiGaming)
    {
        return;
    }
    
    if(healthRemain > 50)
    {
    [_aiAssistantDelegate AIchangeMode:REVTrackingChase];
    }else if(healthRemain > 30){
    [_aiAssistantDelegate AIchangeMode:REVTrackingCircle];
    }else{
    [_aiAssistantDelegate AIchangeMode:REVTrackingAvoid];
    }
}


-(void)startAI{
    [_aiAssistantDelegate AIchangeMode:REVTrackingChase];
    _aiGaming = true;
    [self shot];
}


-(void)stopAI{
    [_aiAssistantDelegate AIchangeMode:REVTrackingBeacon];
    _aiGaming = false;
}


-(void)shot{
    [_aiAssistantDelegate AIShot];
    if (_aiGaming)
    {
        [self performSelector:@selector(shot) withObject:nil afterDelay:_resumeTime];
    }

}


@end
