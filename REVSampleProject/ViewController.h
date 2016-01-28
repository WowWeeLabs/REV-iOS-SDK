//
//  ViewController.h
//  REVSampleProject
//
//  Created by DavidFF Chan on 18/1/2016.
//  Copyright © 2016 DavidFF Chan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Player.h"
#import "Building.h"
#import "DeviceHub.h"

@interface ViewController : UIViewController <UITableViewDataSource,UITableViewDelegate,UIPickerViewDataSource,UIPickerViewDelegate,DeviceHubDelegate,PlayerDelegate>

@property IBOutlet UITableView * deviceListTable;

@end

