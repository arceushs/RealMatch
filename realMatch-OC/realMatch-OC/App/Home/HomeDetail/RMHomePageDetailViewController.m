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

@interface RMHomePageDetailViewController ()<RouterController,UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *videoListTableView;
@property (strong,nonatomic) NSMutableArray<RMFetchVideoDetailModel*> * videoArr;
@property (strong,nonatomic) NSString* matchedUserId;
@end

@implementation RMHomePageDetailViewController


- (DisplayStyle)displayStyle {
    return DisplayStylePush;
}

- (instancetype)initWithRouterParams:(NSDictionary *)params {
    if(self = [super init]){
        _matchedUserId = params[@"userId"];
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
        
        for(int i = 0;i<self.videoArr.count;i++){
            RMFetchVideoDetailModel* model = self.videoArr[i];
            if(i == 0){
                model.title = @"About me";
                model.subtitle = @"who are you, where are you from, yuor school, your job.";
            }else if(i == 1){
                model.title = @"Interests";
                model.subtitle = @"what make you differ";
            }else if(i == 2){
                model.title = @"My friends";
                model.subtitle = @"Who do you like to be with";
            }
        }
        [self.videoListTableView reloadData];
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
    cell.titleLabel.text = model.title;
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
    [[Router shared] routerTo:@"RMReportViewController" parameter:nil];
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
