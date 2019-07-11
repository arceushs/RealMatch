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
#import "RMHomeCardView.h"

@interface RMHomePageViewController ()<RouterController,CAAnimationDelegate>

@property (nonatomic,strong) CAGradientLayer* layer;

@property (nonatomic,strong) RMHomeCardView* upperCardView;
@property (nonatomic,strong) RMHomeCardView* bottomCardView;

@property (nonatomic,strong) AVPlayer* upperVideoPlayer;
@property (nonatomic,strong) AVPlayer* bottomVideoPlayer;

@property (nonatomic,assign) BOOL result;

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

- (BOOL)animation {
    return NO;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.upperCardView = [self produceCardViewPathinUpperVideoPlayer:@"aiqinggongyu.mp4" ];
    self.bottomCardView = [self produceCardViewPathinBottomVideoPlayer:@"aiqinggongyu2.mp4" ];
    [self.upperVideoPlayer play];
    [self.bottomVideoPlayer play];
    UISwipeGestureRecognizer *swipeGest = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(pageCurl:)];
    swipeGest.direction = UISwipeGestureRecognizerDirectionLeft;
    [self.cardContainerView addGestureRecognizer:swipeGest];
    
    UITapGestureRecognizer * tapGest = [[UITapGestureRecognizer alloc] initWithTarget:self action: @selector(routerToDetail:)];
    [self.cardContainerView addGestureRecognizer:tapGest];
    // Do any additional setup after loading the view from its nib.
}

- (void)transitionWithType:(NSString *) type WithSubtype:(NSString *) subtype ForView : (UIView *) view {
    CATransition *animation = [CATransition animation];
    animation.duration = 1.f;
    animation.type = type;
    if (subtype != nil) {
        animation.subtype = subtype;
    }
    animation.timingFunction = [CAMediaTimingFunction functionWithName: kCAMediaTimingFunctionEaseInEaseOut];
    //    animation.fillMode = kCAFillModeForwards;
    animation.delegate = self;
    [view exchangeSubviewAtIndex:0 withSubviewAtIndex:1];
    [view.layer addAnimation:animation forKey:@""];
    
    
}

-(void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag{
    if(_result==NO){
        if(self.bottomVideoPlayer){
            NSURL *streamURL = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"aiqinggongyu2.mp4" ofType:@""]];
            AVPlayerItem *currentItem = [[AVPlayerItem alloc] initWithURL:streamURL];
            [self.bottomVideoPlayer replaceCurrentItemWithPlayerItem:currentItem];
            [self.bottomVideoPlayer play];
        }
        _result = YES;
    }else{
        if(self.upperVideoPlayer){
            [self.upperVideoPlayer replaceCurrentItemWithPlayerItem:[AVPlayerItem playerItemWithURL:[NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"aiqinggongyu.mp4" ofType:@""]]]];
            [self.upperVideoPlayer play];
        }
        
        _result = NO;
    }
}

-(void)routerToDetail:(id)sender{
    [[Router shared]routerTo:@"RMHomePageDetailViewController" parameter:nil];
}

-(void)pageCurl:(UISwipeGestureRecognizer*)sender{
    [self transitionWithType:@"pageCurl" WithSubtype:kCATransitionFromRight ForView:self.cardContainerView];
    
}

- (IBAction)likeButton:(UIButton*)sender {
    [self transitionWithType:@"pageCurl" WithSubtype:kCATransitionFromRight ForView:self.cardContainerView];
}

-(RMHomeCardView*)produceCardViewPathinBottomVideoPlayer:(NSString*)filePath {
    RMHomeCardView* homeCardView = [[RMHomeCardView alloc]initWithFrame:CGRectZero];
    
    filePath = [[NSBundle mainBundle] pathForResource:filePath ofType:@""];
    self.bottomVideoPlayer = [AVPlayer playerWithURL:[NSURL fileURLWithPath:filePath]];
    [homeCardView setVideoLayerWithPlayer:self.bottomVideoPlayer];
    
    return homeCardView;
}

-(RMHomeCardView*)produceCardViewPathinUpperVideoPlayer:(NSString*)filePath {
    RMHomeCardView* homeCardView = [[RMHomeCardView alloc]initWithFrame:CGRectZero];
    filePath = [[NSBundle mainBundle] pathForResource:filePath ofType:@""];
    self.upperVideoPlayer = [[AVPlayer alloc]init];
    [self.upperVideoPlayer replaceCurrentItemWithPlayerItem:[AVPlayerItem playerItemWithURL:[NSURL fileURLWithPath:filePath]]];
    [homeCardView setVideoLayerWithPlayer:self.upperVideoPlayer];
    
    homeCardView.layer.cornerRadius = 4;
    homeCardView.layer.masksToBounds = YES;
    
    return homeCardView;
}

-(void)viewWillLayoutSubviews{
    self.upperCardView.frame = CGRectMake(8, 8, self.cardContainerView.width -16, self.cardContainerView.height - 16);
    self.bottomCardView.frame = CGRectMake(8, 8, self.cardContainerView.width -16, self.cardContainerView.height - 16);
    
    [self.cardContainerView insertSubview:self.upperCardView atIndex:1];
    [self.cardContainerView insertSubview:self.bottomCardView atIndex:0];
}

- (IBAction)routeToMessage:(id)sender {
    [[Router shared] routerTo:@"RMMessageViewController" parameter:nil];
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
