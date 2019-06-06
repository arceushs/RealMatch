//
//  RMHomePageViewController.m
//  realMatch-OC
//
//  Created by yxl on 2019/6/6.
//  Copyright © 2019 qingting. All rights reserved.
//

#import "RMHomePageViewController.h"
#import "Router.h"
#import "UIColor+RealMatch.h"
#import <AVFoundation/AVFoundation.h>
#import "UIView+RealMatch.h"

@interface RMHomePageViewController ()<RouterController>

@property (nonatomic,strong) CAGradientLayer* layer;
@property (nonatomic,strong) AVPlayer* avplayer;
@property (nonatomic,strong) AVPlayerLayer * playerLayer;

@property (nonatomic,strong) UIScrollView* scrollView;

@end

@implementation RMHomePageViewController

- (DisplayStyle)displayStyle {
    return DisplayStylePush;
}

- (instancetype)initWithRouterParams:(NSDictionary *)params {
    if(self = [super init]){
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.layer = [CAGradientLayer layer];
    _layer.startPoint = CGPointMake(0, 0);
    _layer.endPoint = CGPointMake(0, 1);
    
    _layer.colors = @[(__bridge id)[UIColor colorWithString:@"000000" alpha:0].CGColor,(__bridge id)[UIColor colorWithString:@"000000" alpha:0.6].CGColor];
    [self.backgroundView.layer insertSublayer:_layer atIndex:0];

    NSString* filePath = [[NSBundle mainBundle] pathForResource:@"aiqinggongyu" ofType:@"mp4"];
    
    self.avplayer = [AVPlayer playerWithURL:[NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"aiqinggongyu.mp4" ofType:@""]]];
    self.playerLayer = [AVPlayerLayer playerLayerWithPlayer:self.avplayer];
    
    
    self.scrollView = [[UIScrollView alloc]initWithFrame:self.bottomView.bounds];
    [self.bottomView insertSubview:self.scrollView atIndex:0];
    
    [self.scrollView.layer addSublayer:self.playerLayer];
    
    [self.avplayer play];
    // Do any additional setup after loading the view from its nib.
}

-(void)viewDidLayoutSubviews{
    _layer.frame = self.backgroundView.bounds;
    _scrollView.frame = self.bottomView.bounds;
    self.playerLayer.frame = CGRectMake(8, 8, _scrollView.width-16, _scrollView.height - 16);
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
