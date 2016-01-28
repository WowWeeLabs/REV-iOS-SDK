//
//  GunDataType.m
//  REVSampleProject
//
//  Created by DavidFF Chan on 26/1/2016.
//  Copyright © 2016 DavidFF Chan. All rights reserved.
//

#import "GunData.h"

@implementation GunData : NSObject


static NSArray * gunsListArray;


+(NSArray *)gunsList
{
    if(!gunsListArray)
    {
        NSArray * gunFromFile =  [[NSArray alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"Guns.plist" ofType:nil ]];
        NSMutableArray * tmpArry = [[NSMutableArray alloc]init];
        
        for (NSDictionary * tmpDic in gunFromFile)
        {
            GunData * tmpGunData = [[GunData alloc]init];
            tmpGunData.gunName = [tmpDic objectForKey:@"gunName"] ;
            tmpGunData.fireSound = [[tmpDic objectForKey:@"fireSound"] integerValue];
            tmpGunData.gotFireSound = [[tmpDic objectForKey:@"gotFireSound"] integerValue];
            tmpGunData.damage = (int)[[tmpDic objectForKey:@"damage"] integerValue];
            tmpGunData.fireResume = [[tmpDic objectForKey:@"fireResume"] floatValue];
            tmpGunData.reloadTime = [[tmpDic objectForKey:@"reloadTime"] floatValue];
            tmpGunData.bulletNo = (int)[[tmpDic objectForKey:@"bulletNo"] integerValue];
            tmpGunData.allDirection = [[tmpDic objectForKey:@"allDirection"] boolValue];
            
            [tmpArry addObject:tmpGunData];
        }
        
        gunsListArray = tmpArry;
    }
    return gunsListArray;
}


@end
