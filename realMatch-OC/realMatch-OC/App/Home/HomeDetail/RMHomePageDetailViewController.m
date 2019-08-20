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
#import "RMHomePageDetailTableViewCell.h"
#import "RMHomePageDetailHeaderView.h"
#import "SDWebImage.h"
#import "RMFileManager.h"
#import "UIDevice+RealMatch.h"
#import "realMatch_OC-Swift.h"

@interface RMHomePageDetailViewController ()<RouterController,UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *videoListTableView;
@property (strong,nonatomic) NSArray<RMFetchDetailModel*> * videoArr;
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
    [self.videoListTableView registerNib:[UINib nibWithNibName:@"RMHomePageDetailTableViewCell" bundle:nil] forCellReuseIdentifier:@"RMHomePageDetailTableViewCell"];
    self.videoListTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    RMFetchDetailAPI * api = [[RMFetchDetailAPI alloc]initWithUserId:_matchedUserId];
    [[RMNetworkManager shareManager] request:api completion:^(RMNetworkResponse <RMFetchDetailAPIData* > *response) {
        RMFetchDetailAPIData* result = response.responseObject;
        self.videoArr = result.videoArr;
        [self.videoListTableView reloadData];
    }];
    // Do any additional setup after loading the view from its nib.
}

#pragma mark - UITableViewDelegate and datasource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return [self.videoArr count];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return ([UIScreen mainScreen].bounds.size.width - 2*8)*466.0/359.0;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    RMHomePageDetailHeaderView* header = [[RMHomePageDetailHeaderView alloc]init];
    RMFetchDetailModel* model = self.videoArr[section];
    header.label.text = model.name;
    return  header;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 60;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01f;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    RMHomePageDetailTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"RMHomePageDetailTableViewCell" forIndexPath:indexPath];
    RMFetchDetailModel* model = self.videoArr[indexPath.section];
    
    [cell.videoImageView sd_setImageWithURL:[NSURL URLWithString:model.videoImg]];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [[Router shared] routerTo:@"RMVideoPlayViewController" parameter:nil];
}
- (IBAction)messageButtonClicked:(id)sender {
    [[Router shared] routerTo:@"RMMessageViewController" parameter:@{@"userId":_matchedUserId}];
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
