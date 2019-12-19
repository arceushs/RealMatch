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
    
    
    // app从后台进入前台都会调用这个方法
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationBecomeActive) name:UIApplicationDidBecomeActiveNotification object:nil];
    // 添加检测app进入后台的观察者
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationEnterBackground) name: UIApplicationDidEnterBackgroundNotification object:nil];

    [self getHomeData];
    
    // Do any additional setup after loading the view from its nib.
}

-(void)getHomeData{
    RMFetchHomeVideoAPI* fetchHomeVideoAPI = [[RMFetchHomeVideoAPI alloc] initWithUserId:[RMUserCenter shared].userId];
    __weak typeof(self) weakSelf = self;
    [SVProgressHUD show];
    [[RMNetworkManager shareManager] request:fetchHomeVideoAPI completion:^(RMNetworkResponse *response) {
        if (response.error){
            if(self.noCardHintBlock){
                self.noCardHintBlock();
                [SVProgressHUD dismiss];
            }
            return ;
        }
        RMFetchHomeVideoAPIData* data = (RMFetchHomeVideoAPIData*)response.responseObject;
        RMFetchHomeVideoAPIModel* currentModel = data.currentModel;
        if([[RMUserCenter shared].matchedUserIdArr containsObject:currentModel.userId]){
            [weakSelf getHomeData];
            return;
        }

        if(currentModel == nil){
            if(self.noCardHintBlock){
                self.noCardHintBlock();
                [SVProgressHUD dismiss];
            }
            return ;
        }
        
        NSLock* lock = [[NSLock alloc]init];
        [lock lock];
        NSMutableArray<NSString*>* matchedUserIdArr =[NSMutableArray arrayWithArray: [RMUserCenter shared].matchedUserIdArr];
        [matchedUserIdArr addObject:currentModel.userId];
        [RMUserCenter shared].matchedUserIdArr = [NSArray arrayWithArray:matchedUserIdArr];
        [lock unlock];
        
        [weakSelf.cardView.bottomImageView sd_setImageWithURL:[NSURL URLWithString:currentModel.videoDefaultImg]];

        if([currentModel.video length]>0){
            weakSelf.player = [AVPlayer playerWithPlayerItem:nil];
            [weakSelf.cardView setVideoLayerWithPlayer:weakSelf.player];
            weakSelf.cardView.nameLabel.text = currentModel.name;
            weakSelf.cardView.regionLabel.text = currentModel.country;
            NSURL *streamURL = nil;
            if([[RMDownloadManager shared].downloadedArr containsObject:currentModel.video]){
                streamURL = [NSURL fileURLWithPath: [[RMDownloadManager shared] getFilePathFromUrl:currentModel.video]];
            }else{
                streamURL = [NSURL URLWithString:currentModel.video];
            }
            
            AVPlayerItem *currentItem = [[AVPlayerItem alloc] initWithURL:streamURL];
            weakSelf.playerItem = currentItem;
            [weakSelf.player replaceCurrentItemWithPlayerItem:currentItem];
            if(self.isViewLoaded&&self.view.window){
                [weakSelf.player play];
            }
            
            weakSelf.matchedUserId = currentModel.userId;
            
            [weakSelf.cardView setNeedsLayout];
            [weakSelf.cardView layoutIfNeeded];
        }
        
        
        for(int i = 0;i<data.listArr.count;i++){
            RMFetchHomeVideoAPIModel* model = data.listArr[i];
            if(!([[[RMDownloadManager shared] downloadingArr] containsObject:model.video] || [[[RMDownloadManager shared] downloadedArr] containsObject:model.video])){
                [[RMDownloadManager shared] preloadUrl:model.video];
            }
        }
    }];
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
    if(self.player){
        [self.player play];
    }
}

-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    if(self.player){
        [self.player pause];
    }
}

-(void)viewWillLayoutSubviews{
    [super viewWillLayoutSubviews];
    self.cardView.frame = self.view.bounds;
}

-(void)applicationBecomeActive{
    if(self.player){
        if(self.isViewLoaded&&self.view.window){
            [self.player play];
        }
    }
}

-(void)applicationEnterBackground{
    if(self.player){
        [self.player pause];
    }
}

-(void)dealloc{
    [self.player pause];
    [_playerItem removeObserver:self forKeyPath:@"status" context:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:AVPlayerItemDidPlayToEndTimeNotification object:_playerItem];
    _playerItem = nil;
    [self.player replaceCurrentItemWithPlayerItem:nil];
    self.player = nil;
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context{
    if([keyPath isEqualToString:@"status"]){
        AVPlayerStatus status = [change[NSKeyValueChangeNewKey] integerValue];
        if(status == AVPlayerStatusReadyToPlay){
            [SVProgressHUD dismiss];
        }
    }
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
