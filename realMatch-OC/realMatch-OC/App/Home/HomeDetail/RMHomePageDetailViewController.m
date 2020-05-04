//
//  RMHomePageDetailViewController.m
//  realMatch-OC
//
//  Created by yxl on 2019/6/14.
//  Copyright © 2019 qingting. All rights reserved.
//

#import "RMHomePageDetailViewController.h"
#import "Router.h"
#import "RMFetchDetailAPI.h"
#import "SDWebImage.h"
#import "RMFileManager.h"
#import "UIDevice+RealMatch.h"
#import "realMatch_OC-Swift.h"
#import "RMLikeFlagAPI.h"

@interface RMHomePageDetailViewController ()<RouterController,UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *videoListTableView;
@property (strong,nonatomic) NSMutableArray<RMFetchVideoDetailModel*> * videoArr;
@property (weak, nonatomic) IBOutlet UIButton *dislikeButton;
@property (weak, nonatomic) IBOutlet UIButton *likeButton;
@property (strong,nonatomic) NSString* matchedUserId;
@property (strong, nonatomic) RouterAdopter * adopter;
@property (weak, nonatomic) IBOutlet UIImageView *matchedAvatar;
@property (weak, nonatomic) IBOutlet UILabel *countryLabel;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *vipLabel;

@end

@implementation RMHomePageDetailViewController


- (DisplayStyle)displayStyle {
    return DisplayStylePush;
}

- (instancetype)initWithCommand:(RouterAdopter *)adopter{
    if(self = [super init]){
        _adopter = adopter;
        _matchedUserId = adopter.params[@"userId"];
    }
    return self;
}

- (BOOL)animation {
    return YES;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.videoListTableView.delegate = self;
    self.videoListTableView.dataSource = self;
    self.videoListTableView.backgroundColor = [UIColor whiteColor];
    [self.videoListTableView registerNib:[UINib nibWithNibName:@"RMEditProfileTableViewCell" bundle:nil] forCellReuseIdentifier:@"RMEditProfileTableViewCell"];
    self.videoListTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    RMFetchDetailAPI * api = [[RMFetchDetailAPI alloc]initWithUserId:_matchedUserId];
    [[RMNetworkManager shareManager] request:api completion:^(RMNetworkResponse <RMFetchDetailAPIData* > *response) {
        RMFetchDetailAPIData* result = response.responseObject;
        self.videoArr = [NSMutableArray arrayWithArray:result.videoArr];
        [self.matchedAvatar sd_setImageWithURL:[NSURL URLWithString:result.avatar] placeholderImage:[UIImage imageNamed:@"default.jpeg"]];
        self.vipLabel.hidden = !result.recharged;
        self.nameLabel.text = result.name;
        self.countryLabel.text = result.area;
        for(int i = 0;i<self.videoArr.count;i++){
            RMFetchVideoDetailModel* model = self.videoArr[i];
        }
        [self.videoListTableView reloadData];
    }];
    
    RMMatchResultAPI *matchCheckAPI = [[RMMatchResultAPI alloc] initWithUserId:_matchedUserId type:1];
    [[RMNetworkManager shareManager] request:matchCheckAPI completion:^(RMNetworkResponse *response) {
        if([response.responseObject isKindOfClass:[RMMatchResultAPIData class]]){
            RMMatchResultAPIData * data = (RMMatchResultAPIData *)response.responseObject;
            self.likeButton.hidden = data.matched;
            self.dislikeButton.hidden = data.matched;
        }
    }];
    // Do any additional setup after loading the view from its nib.
}

#pragma mark - UITableViewDelegate and datasource

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.videoArr count];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    RMFetchVideoDetailModel* model = self.videoArr[indexPath.row];
    return model.rowHeight;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    RMEditProfileTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"RMEditProfileTableViewCell" forIndexPath:indexPath];
    RMFetchVideoDetailModel* model = self.videoArr[indexPath.row];
    cell.subTitleLabel.text = model.subtitle;
    cell.addVideoView.hidden = YES;
    cell.editVideoButton.hidden = YES;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    NSString* url = model.videoImg.ossLocation;
    if(url.length <= 0){
        url = model.ossLocation;
    }
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        UIImage* image = [RMFileManager getVideoPreViewImage:[NSURL URLWithString:url]];
        dispatch_async(dispatch_get_main_queue(), ^{
            cell.detailImageView.image = image;
        });
    });
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    RMFetchVideoDetailModel* model = self.videoArr[indexPath.row];
    NSString* url = model.ossLocation;
    [[Router shared] routerTo:@"RMVideoPlayViewController" parameter:@{@"url":url}];
}
- (IBAction)messageButtonClicked:(id)sender {
    if (self.matchedUserId.length > 0){
        RouterAdopter *adopter = [[RouterAdopter alloc] init];
        adopter.vcName = @"RMReportViewController";
        adopter.params = @{@"complainUser":[RMUserCenter shared].userId,@"complainedUser":self.matchedUserId};
        adopter.routerAdopterCallback = ^(NSDictionary *dict) {
            [self dislikeButtonClicked:nil];
        };
        [[Router shared] routerTo:adopter];
    }
}
- (IBAction)backButtonClicked:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)dislikeButtonClicked:(id)sender {
    if(_matchedUserId.length > 0) {
        RMLikeFlagAPI* api = [[RMLikeFlagAPI alloc]initWithMatchedUserId:_matchedUserId userId:[RMUserCenter shared].userId isLike:NO];
        __weak typeof(self) weakSelf = self;
        [[RMNetworkManager shareManager] request:api completion:^(RMNetworkResponse *response) {
            RMLikeFlagAPIData *data = (RMLikeFlagAPIData *)response.responseObject;
            if ([data isKindOfClass:[RMLikeFlagAPIData class]]){
                if(weakSelf.adopter.routerAdopterCallback){
                    [weakSelf.navigationController popViewControllerAnimated:NO];
                    weakSelf.adopter.routerAdopterCallback(@{@"like":@(0)});
                }
            }
                
        }];
    }
    
}
- (IBAction)likeButtonClicked:(id)sender {
    if(_matchedUserId.length > 0) {
        if (![RMUserCenter shared].isUploadedVideo) {
            [[Router shared] routerTo:@"RMGuideVideoViewController" parameter:nil];
            return ;
        }
        RMLikeFlagAPI* api = [[RMLikeFlagAPI alloc]initWithMatchedUserId:_matchedUserId userId:[RMUserCenter shared].userId isLike:YES];
        __weak typeof(self) weakSelf = self;
        [[RMNetworkManager shareManager] request:api completion:^(RMNetworkResponse *response) {
            RMLikeFlagAPIData *data = (RMLikeFlagAPIData *)response.responseObject;
            if ([data isKindOfClass:[RMLikeFlagAPIData class]]){
                if(weakSelf.adopter.routerAdopterCallback){
                    [weakSelf backButtonClicked:nil];
                    weakSelf.adopter.routerAdopterCallback(@{@"like":@(1)});
                }
            }
                
        }];
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
