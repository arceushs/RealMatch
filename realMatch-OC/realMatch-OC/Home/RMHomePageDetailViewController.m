//
//  RMHomePageDetailViewController.m
//  realMatch-OC
//
//  Created by yxl on 2019/6/14.
//  Copyright © 2019 qingting. All rights reserved.
//

#import "RMHomePageDetailViewController.h"
#import "Router.h"

@interface RMHomePageDetailViewController ()<RouterController>
@property (weak, nonatomic) IBOutlet UITableView *videoListTableView;

@end

@implementation RMHomePageDetailViewController


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
    
    
    // Do any additional setup after loading the view from its nib.
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
