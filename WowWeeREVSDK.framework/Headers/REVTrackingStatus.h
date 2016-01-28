//
//  REVTrackingStatus.h
//  REV
//
//  Created by Forrest Chan on 9/12/14.
//  Copyright (c) 2014 ___WOWWEE___. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "REVRobotConstantSDK.h"

@interface REVTrackingStatus : NSObject

@property (nonatomic, assign) REVRobotTrackingSignalDirection signalDirection;
@property (nonatomic, assign) int degrees;      // 0 - 180
@property (nonatomic, assign) int strength;     // 0 - 100

@end
