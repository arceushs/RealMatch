//
//  RMMessageViewController.m
//  realMatch-OC
//
//  Created by arceushs on 2019/6/23.
//  Copyright © 2019 qingting. All rights reserved.
//

#import "RMMessageViewController.h"
#import "RMMessageTableViewCell.h"
#import "Router.h"
#import "realMatch_OC-Swift.h"
#import "UIView+RealMatch.h"
#import "RMFetchMessageAPI.h"

@interface RMMessageViewController ()<UITableViewDelegate,UITableViewDataSource,RouterController>
@property (weak, nonatomic) IBOutlet UITableView *messageTableView;
@property (strong,nonatomic) NSString* userId;
@property (strong,nonatomic) NSArray<RMFetchMessageModel*>* messageArr;
@property (strong,nonatomic) NSArray<RMFetchLikesMeModel*>* likesArr;
@end

@implementation RMMessageViewController

- (BOOL)animation {
    return true;
}

- (DisplayStyle)displayStyle {
    return DisplayStylePush;
}

- (instancetype)initWithRouterParams:(NSDictionary *)params {
    if(self = [super init]){
        _userId = params[@"userId"];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.messageTableView.delegate = self;
    self.messageTableView.dataSource = self;
    self.messageTableView.rowHeight = 97;
    
    self.likesArr = [NSMutableArray array];
    self.messageArr = [NSMutableArray array];
    
    [self.messageTableView registerNib:[UINib nibWithNibName:@"RMMessageTableViewCell" bundle:nil] forCellReuseIdentifier:@"RMMessageTableViewCell"];
    
    RMFetchLikesMeAPI* likesMeAPI = [[RMFetchLikesMeAPI alloc] initWithUserId:_userId];
    [[RMNetworkManager shareManager] request:likesMeAPI completion:^(RMNetworkResponse *response) {
        RMFetchLikesMeAPIData* data = [[RMFetchLikesMeAPIData alloc]init];
        data = (RMFetchLikesMeAPIData*)response.responseObject;
        if([data.likesMeArr count]>0){
            RMMessageHeader* header = [[RMMessageHeader alloc]initWithFrame:CGRectMake(0, 0, self.messageTableView.width, 160) likesMeArr:data.likesMeArr];
            self.messageTableView.tableHeaderView = header;
        }
        self.likesArr = [data.likesMeArr copy];
    }];
    
    RMFetchMessageAPI* messageAPI = [[RMFetchMessageAPI alloc]initWithUserId:_userId];
    [[RMNetworkManager shareManager] request:messageAPI completion:^(RMNetworkResponse *response) {
        RMFetchMessageAPIData* data = [[RMFetchMessageAPIData alloc]init];
        data = (RMFetchMessageAPIData*)response.responseObject;
        self.messageArr = [data.list copy];
        if([data.list count]>0){
            [self.messageTableView reloadData];
        }else{
            RMMessageFooter* footer = [[RMMessageFooter alloc]initWithFrame:CGRectMake(0, 0, self.messageTableView.width, 400)];
            self.messageTableView.tableFooterView = footer;
        }
    }];
    
    

    // Do any additional setup after loading the view from its nib.
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.messageArr.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    RMMessageTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"RMMessageTableViewCell"];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    RMFetchMessageModel* model = self.messageArr[indexPath.row];
    [[Router shared]routerTo:@"RMMessageDetailViewController" parameter:@{@"fromUser":self.userId,@"toUser":model.userId}];
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
