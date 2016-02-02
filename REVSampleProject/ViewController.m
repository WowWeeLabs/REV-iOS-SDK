//
//  ViewController.m
//  REVSampleProject
//
//  Created by DavidFF Chan on 18/1/2016.
//  Copyright © 2016 DavidFF Chan. All rights reserved.
//

#import "ViewController.h"
#import "DeviceHub.h"


@interface ViewController ()


@property (weak, nonatomic) IBOutlet UIPickerView *gunPick;
@property (weak, nonatomic) IBOutlet UIPickerView *buildingGunPick;
@property (weak, nonatomic) IBOutlet UIPickerView *playerModePick;
@property (weak, nonatomic) IBOutlet UIView *playerPanel;
@property (weak, nonatomic) IBOutlet UIView *buildingPanel;
@property (strong, nonatomic) IBOutlet UITextView *GunProfile;
@property (strong, nonatomic) IBOutlet UIButton *StartGame;
@property (strong, nonatomic) IBOutlet UIButton *BuildingBtn;
@property (weak, nonatomic) IBOutlet UISwitch *jumperOnOffSW;


@end

@implementation ViewController

int selectedDeviceIndex;
Player * selectedPLayer;
Building * selectedBuilding;
NSArray * revTrackingMode;

- (void)viewDidLoad{
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [DeviceHub sharedInstance];
    [DeviceHub sharedInstance].deviceHubDelegate = self;
    
    _playerPanel.hidden = true;
    _buildingPanel.hidden = true;
    _StartGame.hidden = true;
    _gunPick.delegate = self;
    _gunPick.dataSource = self;
    revTrackingMode = [[NSArray alloc]initWithObjects:@"User Control",@"Chase",@"Turret",@"Avoid",@"Beacon",@"Jumper",nil];
}




- (void)viewDidAppear:(BOOL)animated{
    // We need to wait 1 second to make sure that bluetooth is ready
    [self performSelector:@selector(scan) withObject:nil afterDelay:1];
}


- (void)scan{
    [[DeviceHub sharedInstance] startScan];
}


-(void)updatePlayerView{
    [_playerPanel setHidden:false];
    [_buildingPanel setHidden:true];
    [_gunPick selectRow:selectedPLayer.player_gunID inComponent:0 animated:false];
    
    GunData * tmpGun = (GunData *)[[GunData gunsList] objectAtIndex:selectedPLayer.player_gunID];
    NSMutableString * tmpStr = [[NSMutableString alloc]init];
    [tmpStr appendFormat:@"Gun name \t\t: %@\n",tmpGun.gunName];
    [tmpStr appendFormat:@"Target damage \t: %d\n",tmpGun.damage];
    [tmpStr appendFormat:@"Next trigger time\t: %.02f sec\n",tmpGun.fireResume];
    [tmpStr appendFormat:@"Bullet No    \t: %d\n",tmpGun.bulletNo];
    [tmpStr appendFormat:@"Reload time\t: %.02f sec\n",tmpGun.reloadTime];
    [tmpStr appendFormat:@"Gun cover \t: %@\n",tmpGun.allDirection?@"All Direction":@"Front"];
    [_GunProfile setText:tmpStr];
    
    REVRobotTrackingMode tmpTrackMode = selectedPLayer.trackMode;
    if (tmpTrackMode == 0){
        tmpTrackMode = REVTrackingBeacon;
    }
    
    int tmpIndex;
    
      switch (tmpTrackMode) {
        case REVTrackingUserControl:
            tmpIndex = 0;
            break;
        case REVTrackingChase:
            tmpIndex = 1;
            break;
        case REVTrackingTurret:
            tmpIndex = 2;
            break;
        case REVTrackingAvoid:
            tmpIndex = 3;
            break;
        case REVTrackingBeacon:
            tmpIndex = 4;
            break;
        case REVTrackingRamp:
            tmpIndex = 5;
            break;
            
        default:
            break;
    }
    [_playerModePick selectRow:tmpIndex inComponent:0 animated:false];
}





#pragma marks DeviceHubDelegate call back
-(void)reloadPendingDeviceList{
    [_deviceListTable reloadData];

    NSString * tmpName = [[DeviceHub sharedInstance] pendingConnectRAMPName];
    
    [_BuildingBtn setTitle:tmpName forState:UIControlStateNormal];
}


-(void)selectedDeviceIndex:(int)index Player:(Player *)player{
    if (!player){
        [[DeviceHub sharedInstance] connectREVdeviceByIndex:index];
    }
    
}


-(void)playerListChange{
    if ( [[DeviceHub playerList] count] == 2)
    {
        _StartGame.hidden = false;
    }else{
        _StartGame.hidden = true;
    }
}


-(void)buildingChange{
    _buildingPanel.hidden = false;
    [_jumperOnOffSW setOn:selectedBuilding.jumperOnOff];
}


#pragma mark - PlayerDelegate Callback
-(void)gunDemoMessage:(NSString *)message{
    NSMutableString * tmp = [[NSMutableString alloc] initWithString:_GunProfile.text];
    [tmp appendFormat:@"%@ \n",message];
     
    _GunProfile.text = tmp;
}


#pragma marks Picker handler
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)thePickerView {
    
    return 1;
}


- (NSInteger)pickerView:(UIPickerView *)thePickerView numberOfRowsInComponent:(NSInteger)component {
    
    if ((thePickerView == _gunPick) || (thePickerView == _buildingGunPick))
    {
    return [GunData gunsList].count;
    }
    else if (thePickerView == _playerModePick)
    {
        return revTrackingMode.count;
    }
    return 1;
}


- (NSString *)pickerView:(UIPickerView *)thePickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    if ((thePickerView == _gunPick) || (thePickerView == _buildingGunPick))
    {
    return ((GunData *)[[GunData gunsList] objectAtIndex:row]).gunName;
    }
    else if (thePickerView == _playerModePick)
    {
        return [revTrackingMode objectAtIndex:row];
    }
    return @"";
}


- (void)pickerView:(UIPickerView *)thePickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    
    if (thePickerView == _gunPick) {
        [selectedPLayer selectGunID:row];
        
        [self updatePlayerView];
        
        [selectedPLayer playGunDemo];
    }else if (thePickerView == _buildingGunPick)
    {
        selectedBuilding.building_gunID = row;
    }else if (thePickerView == _playerModePick)
    {
        REVRobotTrackingMode tmpTrackMode;
        switch (row) {
            case 0:
                tmpTrackMode = REVTrackingUserControl;
                break;
            case 1:
                tmpTrackMode = REVTrackingChase;
                break;
            case 2:
                tmpTrackMode = REVTrackingTurret;
                break;
            case 3:
                tmpTrackMode = REVTrackingAvoid;
                break;
            case 4:
                tmpTrackMode = REVTrackingBeacon;
                break;
            case 5:
                tmpTrackMode = REVTrackingRamp;
                break;

            default:
                break;
        }
        
        [selectedPLayer setREVTrackMode:tmpTrackMode];
    }

}


#pragma marks table dataSource and activity handle
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [[DeviceHub sharedInstance] pendingConnectREVNameList].count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell * temp = [[UITableViewCell alloc]init];
    
    temp.textLabel.text = [[[DeviceHub sharedInstance] pendingConnectREVNameList] objectAtIndex:indexPath.row];
    
    
    return temp;
}


- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UILabel * tmpLabel = [[UILabel alloc]init];
    tmpLabel.text = @" Please select rev";
    
    return tmpLabel;
    
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    selectedPLayer =  [[DeviceHub sharedInstance] connectREVdeviceByIndex:(int)indexPath.row];
    selectedPLayer.playerdelegate = self;
    [self updatePlayerView];
    [self reloadPendingDeviceList];
    
}


#pragma mark - UI interactive
- (IBAction)reflashPendingDevice:(id)sender{
    selectedPLayer = nil;
    [[DeviceHub sharedInstance] reflashPendingDevice];
}


- (IBAction)disconnect_selectedPlayer:(id)sender {
    
    if (selectedPLayer) {
        [selectedPLayer.rev disconnect];
        [_playerPanel setHidden:true];
    }
}


- (IBAction)connectBuilding:(id)sender {
    selectedBuilding = [[DeviceHub sharedInstance] connectRAMPdevice];
    [_buildingPanel setHidden:false];
}


- (IBAction)disconnect_selectedBuilding:(id)sender {
    
    if (selectedBuilding){
        [selectedBuilding.ramp disconnect];
        [_buildingPanel setHidden:true];
    }
    
}


- (IBAction)jumperOnOff:(id)sender {
    
    selectedBuilding.jumperOnOff = ((UISwitch *)sender).on;
}

@end
