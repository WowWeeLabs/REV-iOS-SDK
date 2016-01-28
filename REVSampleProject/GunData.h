//
//  GunDataType.h
//  REVSampleProject
//
//  Created by DavidFF Chan on 26/1/2016.
//  Copyright © 2016 DavidFF Chan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GunData : NSObject


@property (nonatomic, strong) NSString * gunName;
@property (nonatomic, assign) uint8_t fireSound;
@property (nonatomic, assign) uint8_t  gotFireSound;
@property (nonatomic, assign) int damage;
@property (nonatomic, assign) float fireResume;
@property (nonatomic, assign) float reloadTime;
@property (nonatomic, assign) int bulletNo;
@property (nonatomic, assign) BOOL allDirection;


+(NSArray *)gunsList;

@end
