//
//  RMVideoPlayViewController.m
//  realMatch-OC
//
//  Created by yxlyxlyxl on 2019/6/20.
//  Copyright © 2019 qingting. All rights reserved.
//

#import "RMVideoPlayViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "Router.h"
@interface RMVideoPlayViewController ()<RouterController>

@end

@implementation RMVideoPlayViewController
{
    AVPlayer* _player;
    AVPlayerLayer* _playerLayer;
}

-(instancetype)initWithRouterParams:(NSDictionary *)params{
    if(self = [super init]){
    }
    return self;
}

-(DisplayStyle)displayStyle{
    return DisplayStylePush;
}

- (BOOL)animation {
    return YES;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    _player = [[AVPlayer alloc]initWithURL:[NSURL fileURLWithPath:[[NSBundle mainBundle]pathForResource:@"aiqinggongyu" ofType:@"mp4"]]];
    
    _playerLayer = [AVPlayerLayer playerLayerWithPlayer:_player];
    
    [self.bottomView.layer addSublayer:_playerLayer];
    [_player play];
}

-(void)viewWillLayoutSubviews{
    _playerLayer.frame = self.bottomView.bounds;
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [_player pause];
    _player = nil;
}

- (IBAction)backButtonClicked:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */



@end
