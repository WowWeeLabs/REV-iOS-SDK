//
//  DriveViewController.m
//  MiPSampleProject
//
//  Created by Forrest Chan on 20/10/14.
//  Copyright (c) 2014 WowWee Group Ltd. All rights reserved.
//


#import "DriveViewController.h"
#import "Player.h"
#import "DeviceHub.h"
@interface DriveViewController ()

@property (nonatomic, strong) NSTimer *joystickTimer;
@property (nonatomic) CGVector left_movementVector;
@property (nonatomic) CGVector right_movementVector;
@property (nonatomic, assign) Boolean left_trackingDataSendBack;
@property (nonatomic, assign) Boolean right_trackingDataSendBack;
@property (weak, nonatomic) Player *left_player;
@property (weak, nonatomic) Player *right_player;

@property (strong, nonatomic) IBOutlet UIButton *rightShotBtn;
@property (strong, nonatomic) IBOutlet UILabel  *rightHealthLevel;
@property (strong, nonatomic) IBOutlet UILabel  *rightbulletLevel;
@property (strong, nonatomic) IBOutlet UILabel  *rightStatusLbl;

@property (strong, nonatomic) IBOutlet UIButton *leftShotBtn;
@property (strong, nonatomic) IBOutlet UILabel  *leftHealthLevel;
@property (strong, nonatomic) IBOutlet UILabel  *leftbulletLevel;
@property (strong, nonatomic) IBOutlet UILabel  *leftStatusLbl;
@end

@implementation DriveViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Configure joysticks
    [self.leftJoystick setHidden: true];
    [self.leftJoystick setJoystickCenterImage:@"joy_left_bk.png" frameImage: @"joy_outerring.png"];
    [self.leftJoystick setJoystickCenterScale: 0.5];
    [self.leftJoystick setDelegate: self];
    
    [self.rightJoystick setHidden: true];
    [self.rightJoystick setJoystickCenterImage:@"joy_right_bk.png" frameImage: @"joy_outerring.png"];
    [self.rightJoystick setJoystickCenterScale: 0.5];
    [self.rightJoystick setDelegate: self];
   
    _left_trackingDataSendBack = false;
    _right_trackingDataSendBack = false;
    
    
}


- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    _left_player = nil;
    _right_player = nil;
    
        if ([[self traitCollection] forceTouchCapability] == UIForceTouchCapabilityAvailable)
            {
                _rightShotBtn.hidden = true;
                _leftShotBtn.hidden = true;
            }
    
    
    // Get first connected mip
    
    self.right_player =((Player *)[[[DeviceHub playerList] allValues]objectAtIndex:0]);
    [self.right_player setPlayerLED:REVRobotColorCyan];
    self.right_player.playerdelegate = self;
    [_right_player checkStatus];

 
    if ([[DeviceHub  playerList] allValues].count > 1)
    {
        self.left_player = ((Player *)[[[DeviceHub playerList] allValues]objectAtIndex:1]);
        [self.left_player setPlayerLED:REVRobotColorGreen];
        self.left_player.playerdelegate = self;
        [_left_player checkStatus];

    }
    
    
    // Joystick timer
    self.joystickTimer = [NSTimer scheduledTimerWithTimeInterval:0.05 target:self selector:@selector(joystickTimerCallback) userInfo:nil repeats: true];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
    // Reset timer
         [self.left_player.rev revSetTrackingMode:REVTrackingUserControl];
    [self.joystickTimer invalidate];
    self.joystickTimer = nil;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)shot:(id)sender {
    Player * tempPlayer;
    if (((UIButton *)sender).tag == 0)
    {
     tempPlayer = _right_player;
    }else if (((UIButton *)sender).tag == 1)
    {
     tempPlayer = _left_player;
    }

    [self gunshot:tempPlayer];
}

-(void)gunshot:(Player *)player{
        [player gunFire];
}

#pragma mark - PlayerDelegate Callback
-(void)remainHealthLevel:(int)health orgHealth:(int)orgHealth  Player:(Player *)player{
    NSLog(@"Player rev name %@",player.rev.name);
    NSLog(@"remainHealthLevel %d",health);
    UILabel * tmpLabel;
    if (player == _left_player) {
        tmpLabel =  _leftHealthLevel;
    }else if (player == _right_player){
         tmpLabel =  _rightHealthLevel;
    }
    tmpLabel.text = [NSString stringWithFormat:@"Health %d/%d",orgHealth, health];
}

-(void)remainBullet:(int)bullet orgBullet:(int)orgBullet Player:(Player *)player{
    NSLog(@"Player rev name %@",player.rev.name);
    NSLog(@"remainBullet %d",bullet);
    UILabel * tmpLabel;
    if (player == _left_player) {
        tmpLabel = _leftbulletLevel;
    }else if (player == _right_player){
        tmpLabel = _rightbulletLevel;
    }
    tmpLabel.text = [NSString stringWithFormat:@"Bullet %d/%d",orgBullet, bullet];
}

-(void)status:(NSString *)status Player:(Player *)player{
    NSLog(@"Player rev name %@",player.rev.name);
    NSLog(@"remainBullet %@",status);
    UILabel * tmpLabel;
    if (player == _left_player) {
        tmpLabel = _leftStatusLbl;
    }else if (player == _right_player){
        tmpLabel = _rightStatusLbl;
    }
    tmpLabel.text = [NSString stringWithFormat:@"%@",status];
}

#pragma mark - Timer Callback
- (void)joystickTimerCallback {
    if(self.left_movementVector.dx != 0 || self.left_movementVector.dy != 0){
        [self.left_player playerDrive:self.left_movementVector];
    }
    
    if(self.right_movementVector.dx != 0 || self.right_movementVector.dy != 0){
        [self.right_player playerDrive:self.right_movementVector];
    }
    
}

#pragma mark - JoystickViewDelegate
- (void)joystickUpdate:(JoystickView *)joystick vector:(CGVector)vector {
    self.left_movementVector = CGVectorMake([self.leftJoystick joystickVector].dx, [self.leftJoystick joystickVector].dy);
    self.right_movementVector = CGVectorMake([self.rightJoystick joystickVector].dx, [self.rightJoystick joystickVector].dy);
}

#pragma mark - Button Actions
- (IBAction)backAction:(id)sender {
    [self dismissViewControllerAnimated:YES completion:NULL];
}

#pragma mark - Touches
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    for(UITouch *touch in touches){
        CGPoint location = [touch locationInView: self.view];
        if(location.x < self.view.frame.size.width / 2) {
            // left side
            if(!self.leftJoystick.touchToTrack){
                if (_left_player != nil){
                [self.leftJoystick setHidden: false];
                [self.leftJoystick setCenter: location];
                [self.leftJoystick setTouchToTrack: touch];
                }
            }
        }
        else {
            // right side
            if(!self.rightJoystick.touchToTrack){
                [self.rightJoystick setHidden: false];
                [self.rightJoystick setCenter: location];
                [self.rightJoystick setTouchToTrack: touch];
            }
        }
    }
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    for(UITouch *touch in touches){
        if(touch == self.leftJoystick.touchToTrack) {
            [self.leftJoystick touchesMoved: [[NSSet alloc] initWithObjects: touch, nil] withEvent: event];
            float force = ((UITouch *)touch).force;
            //NSLog(@"((UITouch *)touches).force %f",force);
            if (force > 3)
            {
                [_left_player gunFire ];
            }
        }
        else if(touch == self.rightJoystick.touchToTrack){
            [self.rightJoystick touchesMoved: [[NSSet alloc] initWithObjects: touch, nil] withEvent: event];
            
            float force = ((UITouch *)touch).force;
            //NSLog(@"((UITouch *)touches).force %f",force);
            if (force > 3)
            {
                [_right_player gunFire ];
            }
        }
    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    for(UITouch *touch in touches){
        if(touch == self.leftJoystick.touchToTrack){
            [self.leftJoystick touchesEnded: [[NSSet alloc] initWithObjects: touch, nil] withEvent: event];
            [self.leftJoystick setHidden: true];
        }
        else if(touch == self.rightJoystick.touchToTrack){
            [self.rightJoystick touchesEnded: [[NSSet alloc] initWithObjects: touch, nil] withEvent: event];
            [self.rightJoystick setHidden: true];
        }
    }
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
    for(UITouch *touch in touches){
        if(touch == self.leftJoystick.touchToTrack){
            [self.leftJoystick touchesCancelled: [[NSSet alloc] initWithObjects: touch, nil] withEvent: event];
            [self.leftJoystick setHidden: true];
        }
        else if(touch == self.rightJoystick.touchToTrack){
            [self.rightJoystick touchesCancelled: [[NSSet alloc] initWithObjects: touch, nil] withEvent: event];
            [self.rightJoystick setHidden: true];
        }
    }
}


@end
