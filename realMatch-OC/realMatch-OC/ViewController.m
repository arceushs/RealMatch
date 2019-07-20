//
//  ViewController.m
//  realMatch-OC
//
//  Created by yxl on 2019/5/22.
//  Copyright © 2019 qingting. All rights reserved.
//

#import "ViewController.h"
//#import <AccountKit/AccountKit.h>
#import "Router/Router.h"
#import "PurchaseManager.h"
#import "RMFileManager.h"
#import "AVFoundation/AVFoundation.h"
#import "realMatch_OC-Swift.h"
@interface ViewController ()

@end

@implementation ViewController
{
    AVPlayer * _player;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    FMDatabase* db = [[RMDatabaseManager shareManager] db];
  
    if([db open]){
        [[RMDatabaseManager shareManager] createTable];
    }
   
    
    
    [Router setNavigationVC:self.navigationController];
    [[Router shared] routerTo:@"LoginAndRegisterViewController" parameter:nil];
//    [[PurchaseManager shareManager] startPurchaseWithID:@"1_month_premium"];
  
//    NSData * data = [NSData dataWithContentsOfFile:[[RMFileManager pathForSaveRecord] stringByAppendingString:@"movie.mp4"]];
    
//    _player = [AVPlayer playerWithURL:[NSURL fileURLWithPath:[[RMFileManager pathForSaveRecord] stringByAppendingString:@"movie.mp4"]]];
//
//
//   NSDictionary* fileDic = [[NSFileManager defaultManager] attributesOfItemAtPath:[[RMFileManager pathForSaveRecord] stringByAppendingString:@"movie.mp4"] error:nil];
//    unsigned long long size = [[fileDic objectForKey:NSFileSize] longLongValue];
//    size = size/1024;
//
//    AVPlayerLayer * layer = [AVPlayerLayer playerLayerWithPlayer:_player];
//
//    UIView * playView = [[UIView alloc]initWithFrame:CGRectMake(100, 100, 200, 200)];
//    layer.frame = playView.bounds;
//    playView.backgroundColor = [UIColor redColor];
//    [self.view addSubview:playView];
//    [playView.layer addSublayer:layer];
//    [_player play];
    
    
//    [[Router shared] routerTo:@"RMCaptureViewController" parameter:nil];
//
    // Do any additional setup after loading the view.
    
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
}

@end
