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

@interface RMMessageViewController ()<UITableViewDelegate,UITableViewDataSource,RouterController>
@property (weak, nonatomic) IBOutlet UITableView *messageTableView;
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
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.messageTableView.delegate = self;
    self.messageTableView.dataSource = self;
    self.messageTableView.rowHeight = 97;
    [self.messageTableView registerNib:[UINib nibWithNibName:@"RMMessageTableViewCell" bundle:nil] forCellReuseIdentifier:@"RMMessageTableViewCell"];
    // Do any additional setup after loading the view from its nib.
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 5;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    RMMessageTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"RMMessageTableViewCell"];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [[Router shared]routerTo:@"RMMessageDetailViewController" parameter:nil];
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
