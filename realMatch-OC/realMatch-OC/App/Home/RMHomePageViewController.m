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
#import "RMFetchHomeVideoAPI.h"
#import "realMatch_OC-Swift.h"
#import "SDWebImage.h"
#import "RMHomeCardViewController.h"
#import "RMLikeFlagAPI.h"
#import "RMSocketManager.h"
#import "PurchaseManager.h"

@interface RMHomePageViewController ()<RouterController,CAAnimationDelegate>

@property (nonatomic,strong) RMHomeCardViewController* cardVC1;
@property (nonatomic,strong) RMHomeCardViewController* cardVC2;
@property (nonatomic,strong) RMHomeCardViewController* currentCardVC;
@property (nonatomic,strong) RMHomeCardViewController* replaceCardVC;
@property (weak, nonatomic) IBOutlet UIButton *dislikeButton;
@property (weak, nonatomic) IBOutlet UIButton *likeButton;
@property (weak, nonatomic) IBOutlet UIView *noCardHintView;

@end

@implementation RMHomePageViewController
{
}
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
    
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    
    [[RMSocketManager shared] connectWithUserId:[RMUserCenter shared].userId];
    [PurchaseManager shareManager];
    
    self.noCardHintView.hidden = YES;
    
    _cardVC1 = [[RMHomeCardViewController alloc]init];
    __weak typeof(self) weakSelf = self;
    _cardVC1.routeToDetailBlock = ^{
        if([weakSelf.currentCardVC.matchedUserId length] <= 0)
            return;
        RouterAdopter * adopter = [[RouterAdopter alloc] init];
        adopter.vcName = @"RMHomePageDetailViewController";
        adopter.params = @{@"userId":weakSelf.currentCardVC.matchedUserId};
        adopter.routerAdopterCallback = ^(NSDictionary *dict){
            if([((NSNumber *)dict[@"like"]) boolValue]){
                [weakSelf likeButtonClicked:nil];
            }else{
                [weakSelf dislikeButtonClicked:nil];
            }
        };
        [[Router shared] routerTo:adopter];
    };
    _cardVC1.noCardHintBlock = ^{
        weakSelf.noCardHintView.hidden = NO;
    };
    [self addChildViewController:_cardVC1];
    [self.cardContainerView addSubview:_cardVC1.view];
    self.currentCardVC = _cardVC1;
    _cardVC1.view.frame = CGRectMake(8 , 8, self.cardContainerView.width -16, self.cardContainerView.height - 16);

    UISwipeGestureRecognizer *swipeGestRight = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(pageGet:)];
    swipeGestRight.direction = UISwipeGestureRecognizerDirectionRight;
    [self.cardContainerView addGestureRecognizer:swipeGestRight];
    UISwipeGestureRecognizer *swipeGestLeft = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(pageGet:)];
    swipeGestLeft.direction = UISwipeGestureRecognizerDirectionLeft;
    [self.cardContainerView addGestureRecognizer:swipeGestLeft];
    // Do any additional setup after loading the view from its nib.
}

-(void)pageGet:(UISwipeGestureRecognizer*)gest{
    __weak typeof(self) weakSelf = self;
    
    CGFloat length = self.view.width;
    if(gest.direction == UISwipeGestureRecognizerDirectionRight){
        length = 0 - length;
        if([self.currentCardVC.matchedUserId length] > 0){
            if (![RMUserCenter shared].isUploadedVideo) {
                [[Router shared] routerTo:@"RMGuideVideoViewController" parameter:nil];
                return ;
            }
            RMLikeFlagAPI* api = [[RMLikeFlagAPI alloc]initWithMatchedUserId:self.currentCardVC.matchedUserId userId:[RMUserCenter shared].userId isLike:YES];
            [[RMNetworkManager shareManager] request:api completion:^(RMNetworkResponse *response) {
                
            }];
        }
    }else if(gest.direction == UISwipeGestureRecognizerDirectionLeft){
        
        if([self.currentCardVC.matchedUserId length]>0){
            RMLikeFlagAPI* api = [[RMLikeFlagAPI alloc]initWithMatchedUserId:self.currentCardVC.matchedUserId userId:[RMUserCenter shared].userId isLike:NO];
            [[RMNetworkManager shareManager] request:api completion:^(RMNetworkResponse *response) {
                
            }];
        }
        
    }
    
    if(self.currentCardVC == _cardVC1){
        _cardVC2 = [[RMHomeCardViewController alloc]init];
        _cardVC2.routeToDetailBlock = ^{
            if([weakSelf.currentCardVC.matchedUserId length]<=0)
                return;
            RouterAdopter * adopter = [[RouterAdopter alloc] init];
            adopter.vcName = @"RMHomePageDetailViewController";
            adopter.params = @{@"userId":weakSelf.currentCardVC.matchedUserId};
            adopter.routerAdopterCallback = ^(NSDictionary *dict){
                if([((NSNumber *)dict[@"like"]) boolValue]){
                    [weakSelf likeButtonClicked:nil];
                }else{
                    [weakSelf dislikeButtonClicked:nil];
                }
            };
            [[Router shared] routerTo:adopter];
        };
        _cardVC2.noCardHintBlock = ^{
            weakSelf.noCardHintView.hidden = NO;
        };
        [self addChildViewController:_cardVC2];
        [self.cardContainerView insertSubview:_cardVC2.view belowSubview:_cardVC1.view];
//        [self.cardContainerView insertSubview:_cardVC2.view atIndex:0];
        
        _cardVC2.view.frame = CGRectMake(8 , 8, self.cardContainerView.width -16, self.cardContainerView.height - 16);
        _cardVC2.view.transform = CGAffineTransformMakeScale(0.8, 0.8);
        
        [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            weakSelf.cardVC2.view.transform = CGAffineTransformMakeScale(1, 1);
            weakSelf.cardVC1.view.frame = CGRectMake(8 - length, 8, self.cardContainerView.width -16, self.cardContainerView.height - 16);
        } completion:^(BOOL finished) {
            [weakSelf.cardVC1.view removeFromSuperview];
            [weakSelf.cardVC1 removeFromParentViewController];
            weakSelf.cardVC1 = nil;
            weakSelf.currentCardVC = weakSelf.cardVC2;
        }];
        
    }else{
        _cardVC1 = [[RMHomeCardViewController alloc]init];
        _cardVC1.routeToDetailBlock = ^{
            if([weakSelf.currentCardVC.matchedUserId length]<=0)
                return;
            RouterAdopter * adopter = [[RouterAdopter alloc] init];
            adopter.vcName = @"RMHomePageDetailViewController";
            adopter.params = @{@"userId":weakSelf.currentCardVC.matchedUserId};
            adopter.routerAdopterCallback = ^(NSDictionary *dict){
                if([((NSNumber *)dict[@"like"]) boolValue]){
                    [weakSelf likeButtonClicked:nil];
                }else{
                    [weakSelf dislikeButtonClicked:nil];
                }
            };
            [[Router shared] routerTo:adopter];
        };
        _cardVC2.noCardHintBlock = ^{
            weakSelf.noCardHintView.hidden = NO;
        };
        [self addChildViewController:_cardVC1];
        [self.cardContainerView insertSubview:_cardVC1.view belowSubview:_cardVC2.view];
        
        _cardVC1.view.frame = CGRectMake(8 , 8, self.cardContainerView.width -16, self.cardContainerView.height - 16);
        _cardVC1.view.transform = CGAffineTransformMakeScale(0.8, 0.8);
        [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            weakSelf.cardVC1.view.transform = CGAffineTransformMakeScale(1, 1);
            weakSelf.cardVC2.view.frame = CGRectMake(8 - length, 8, self.cardContainerView.width -16, self.cardContainerView.height - 16);
        } completion:^(BOOL finished) {
            [weakSelf.cardVC2.view removeFromSuperview];
            [weakSelf.cardVC2 removeFromParentViewController];
            weakSelf.cardVC2 = nil;
            weakSelf.currentCardVC = weakSelf.cardVC1;
        }];
        
    }
}

- (IBAction)dislikeButtonClicked:(id)sender {
//    if([self.currentCardVC.matchedUserId length]<=0)
//        return;
//    RMLikeFlagAPI* api = [[RMLikeFlagAPI alloc]initWithMatchedUserId:self.currentCardVC.matchedUserId userId:[RMUserCenter shared].userId isLike:NO];
//    [[RMNetworkManager shareManager] request:api completion:^(RMNetworkResponse *response) {
//
//    }];
    
    UISwipeGestureRecognizer* gest = [[UISwipeGestureRecognizer alloc]init];
    gest.direction = UISwipeGestureRecognizerDirectionLeft;
    [self pageGet:gest];
}
- (IBAction)likeButtonClicked:(id)sender {
//    if([self.currentCardVC.matchedUserId length]<=0)
//        return;
//    RMLikeFlagAPI* api = [[RMLikeFlagAPI alloc]initWithMatchedUserId:self.currentCardVC.matchedUserId userId:[RMUserCenter shared].userId isLike:YES];
//    [[RMNetworkManager shareManager] request:api completion:^(RMNetworkResponse *response) {
//
//    }];
    
    UISwipeGestureRecognizer* gest = [[UISwipeGestureRecognizer alloc]init];
    gest.direction = UISwipeGestureRecognizerDirectionRight;
    [self pageGet:gest];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}

-(void)viewWillLayoutSubviews{
    [super viewWillLayoutSubviews];
}

-(void)viewDidDisappear:(BOOL)animated{
    [SVProgressHUD dismiss];
}

- (IBAction)messageButtonClicked:(id)sender {
    [[Router shared] routerTo:@"RMMessageViewController" parameter:@{@"userId":[RMUserCenter shared].userId}];
}

- (IBAction)profileButtonClicked:(id)sender {
    [[Router shared] routerTo:@"RMProfileViewController" parameter:nil];
}


//- (void)transitionWithType:(NSString *) type WithSubtype:(NSString *) subtype ForView : (UIView *) view {
//    CATransition *animation = [CATransition animation];
//    animation.duration = 1.f;
//    animation.type = type;
//    if (subtype != nil) {
//        animation.subtype = subtype;
//    }
//    animation.timingFunction = [CAMediaTimingFunction functionWithName: kCAMediaTimingFunctionEaseInEaseOut];
//    //    animation.fillMode = kCAFillModeForwards;
//    animation.delegate = self;
//    [view exchangeSubviewAtIndex:0 withSubviewAtIndex:1];
//    [view.layer addAnimation:animation forKey:@""];
//}
//
//-(void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag{
//    RMFetchHomeVideoAPI* fetchHomeVideoAPI = [[RMFetchHomeVideoAPI alloc]initWithUserId:[RMUserCenter shared].userId];
//    __weak typeof(self) weakSelf = self;
//
//    if(_result==NO){
//        self.upperUrl = @"";
////        self.upperCardView.hidden = YES;
//        [[RMNetworkManager shareManager] request:fetchHomeVideoAPI completion:^(RMNetworkResponse *response) {
//            RMFetchHomeVideoAPIData* data = (RMFetchHomeVideoAPIData*)response.responseObject;
//            weakSelf.upperUrl = data.video;
//            self.upperCardView.hidden = NO;
//        }];
//        if(self.bottomVideoPlayer){
//            NSURL *streamURL = [NSURL fileURLWithPath:self.bottomUrl];
//            AVPlayerItem *currentItem = [[AVPlayerItem alloc] initWithURL:streamURL];
//            [self.bottomVideoPlayer replaceCurrentItemWithPlayerItem:currentItem];
//            [self.bottomVideoPlayer play];
//        }
//        _result = YES;
//    }else{
//        self.bottomUrl = @"";
////        self.bottomCardView.hidden = YES;
//        [[RMNetworkManager shareManager] request:fetchHomeVideoAPI completion:^(RMNetworkResponse *response) {
//            RMFetchHomeVideoAPIData* data = (RMFetchHomeVideoAPIData*)response.responseObject;
//            weakSelf.bottomUrl = data.video;
////            self.bottomCardView.hidden = NO;
//        }];
//        if(self.upperVideoPlayer){
//            [self.upperVideoPlayer replaceCurrentItemWithPlayerItem:[AVPlayerItem playerItemWithURL:[NSURL fileURLWithPath:self.upperUrl]]];
//            [self.upperVideoPlayer play];
//        }
//
//        _result = NO;
//    }
//}
//
//-(void)routerToDetail:(id)sender{
//    [[Router shared]routerTo:@"RMHomePageDetailViewController" parameter:nil];
//}
//
//-(void)pageCurl:(UISwipeGestureRecognizer*)sender{
//    [self transitionWithType:@"pageCurl" WithSubtype:kCATransitionFromRight ForView:self.cardContainerView];
//
//}
//
//- (IBAction)likeButton:(UIButton*)sender {
//    [self transitionWithType:@"pageCurl" WithSubtype:kCATransitionFromRight ForView:self.cardContainerView];
//}
//
//-(RMHomeCardView*)produceCardViewPathinBottomVideoPlayer:(NSString*)filePath {
//    RMHomeCardView* homeCardView = [[RMHomeCardView alloc]initWithFrame:CGRectZero];
//
//    NSString* finalfilePath = filePath;
//    self.bottomVideoPlayer = [AVPlayer playerWithURL:[NSURL fileURLWithPath:finalfilePath]];
//    [homeCardView setVideoLayerWithPlayer:self.bottomVideoPlayer];
//
//    return homeCardView;
//}
//
//-(RMHomeCardView*)produceCardViewPathinUpperVideoPlayer:(NSString*)filePath {
//    RMHomeCardView* homeCardView = [[RMHomeCardView alloc]initWithFrame:CGRectZero];
//    NSString* finalfilePath = filePath;
//    self.upperVideoPlayer = [[AVPlayer alloc]init];
//    [self.upperVideoPlayer replaceCurrentItemWithPlayerItem:[AVPlayerItem playerItemWithURL:[NSURL fileURLWithPath:finalfilePath]]];
//    [homeCardView setVideoLayerWithPlayer:self.upperVideoPlayer];
//
//    homeCardView.layer.cornerRadius = 4;
//    homeCardView.layer.masksToBounds = YES;
//
//    return homeCardView;
//}
//
//-(void)viewWillLayoutSubviews{
//    self.upperCardView.frame = CGRectMake(8, 8, self.cardContainerView.width -16, self.cardContainerView.height - 16);
//    self.bottomCardView.frame = CGRectMake(8, 8, self.cardContainerView.width -16, self.cardContainerView.height - 16);
//
//    [self.cardContainerView insertSubview:self.upperCardView atIndex:1];
//    [self.cardContainerView insertSubview:self.bottomCardView atIndex:0];
//}
//
//- (IBAction)routeToMessage:(id)sender {
//    [[Router shared] routerTo:@"RMMessageViewController" parameter:nil];
//}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
