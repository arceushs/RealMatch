//
//  RMHomeVideoViewController.m
//  realMatch-OC
//
//  Created by arceushs on 2019/7/20.
//  Copyright © 2019 qingting. All rights reserved.
//

#import "RMHomeCardViewController.h"
#import "RMHomeCardView.h"
#import "RMFetchHomeVideoAPI.h"
#import "realMatch_OC-Swift.h"

@interface RMHomeCardViewController ()

@property (nonatomic,strong) RMHomeCardView* cardView;
@property (nonatomic,strong) AVPlayer* player;
@property (nonatomic,strong) AVPlayerItem* playerItem;

@end

@implementation RMHomeCardViewController
{
    CGRect _cardFrame;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.cardView = [[RMHomeCardView alloc]initWithFrame:CGRectZero];
    self.cardView.routeToDetailBlock = self.routeToDetailBlock;
    [self.view addSubview:self.cardView];
    
    RMFetchHomeVideoAPI* fetchHomeVideoAPI = [[RMFetchHomeVideoAPI alloc] initWithUserId:[RMUserCenter shared].userId];
    __weak typeof(self) weakSelf = self;
    [[RMNetworkManager shareManager] request:fetchHomeVideoAPI completion:^(RMNetworkResponse *response) {
        RMFetchHomeVideoAPIData* data = (RMFetchHomeVideoAPIData*)response.responseObject;
        NSString* finalfilePath = data.video;
        weakSelf.player = [AVPlayer playerWithPlayerItem:nil];
        [weakSelf.cardView setVideoLayerWithPlayer:weakSelf.player];
        NSURL *streamURL = [NSURL fileURLWithPath:finalfilePath];
        AVPlayerItem *currentItem = [[AVPlayerItem alloc] initWithURL:streamURL];
        weakSelf.playerItem = currentItem;
        [weakSelf.player replaceCurrentItemWithPlayerItem:currentItem];
        [weakSelf.player play];
        
        weakSelf.matchedUserId = data.userId;
        
        [weakSelf.cardView setNeedsLayout];
        [weakSelf.cardView layoutIfNeeded];
    }];
    // Do any additional setup after loading the view from its nib.
}

-(void)setPlayerItem:(AVPlayerItem *)playerItem{
    _playerItem = playerItem;
    [_playerItem addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionNew context: nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playerItemDidPlayToEnd) name:AVPlayerItemDidPlayToEndTimeNotification object:_playerItem];
}

-(void)playerItemDidPlayToEnd{
    [self.player seekToTime:CMTimeMakeWithSeconds(0, 600) toleranceBefore:kCMTimeZero toleranceAfter:kCMTimeZero];
    [self.player play];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}

-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
}

-(void)viewWillLayoutSubviews{
    [super viewWillLayoutSubviews];
    self.cardView.frame = self.view.bounds;
}

-(void)dealloc{
//    [self.player pause];
//    [_playerItem removeObserver:self forKeyPath:@"status" context:nil];
//    [[NSNotificationCenter defaultCenter] removeObserver:self name:AVPlayerItemDidPlayToEndTimeNotification object:_playerItem];
//    _playerItem = nil;
//    self.player = nil;
}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context{

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
