//
//  AIAssistant.h
//  REVSampleProject
//
//  Created by DavidFF Chan on 1/2/2016.
//  Copyright © 2016 DavidFF Chan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <WowWeeREVSDK/WowWeeREVSDK.h>

@protocol AIAssistantDelegate <NSObject>

@required
-(void)AIShot;
-(void)AIchangeMode:(REVRobotTrackingMode)mode;

@end


@interface AIAssistant : NSObject
@property (nonatomic,weak) id <AIAssistantDelegate> aiAssistantDelegate;

-(id)initGunDamagePower:(int)gunDamagePower bulletReloadTime:(float)bulletReloadTime gunResume:(float)gunResume;
-(void)aiGotShot:(int)demage healthRemain:(int)healthRemain bulletRemain:(int)bulletRemain;
-(void)startAI;
-(void)stopAI;
-(void)shot;
@end
