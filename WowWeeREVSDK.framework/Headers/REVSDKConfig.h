//
//  REVSDKConfig.h
//  REV
//
//  Created by Forrest Chan on 14/1/15.
//  Copyright (c) 2015 ___WOWWEE___. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    RPFScanOptionMask_ShowAllDevices       = 0,
    RPFScanOptionMask_FilterByProductId    = 1 << 0,
    RPFScanOptionMask_FilterByServices     = 1 << 1,
    RPFScanOptionMask_FilterByDeviceName   = 1 << 2,
} REVFinderScanOptions;

#ifndef REV_SCAN_OPTIONS
#define REV_SCAN_OPTIONS RPFScanOptionMask_ShowAllDevices | RPFScanOptionMask_FilterByProductId
#endif

@interface REVSDKConfig : NSObject

@end
