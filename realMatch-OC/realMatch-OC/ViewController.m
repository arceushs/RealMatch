//
//  ViewController.m
//  realMatch-OC
//
//  Created by yxl on 2019/5/22.
//  Copyright © 2019 qingting. All rights reserved.
//

#import "ViewController.h"
//#import <AccountKit/AccountKit.h>
#import "Router/Router.h"
#import "PurchaseManager.h"
@interface ViewController ()

@end

@implementation ViewController


- (void)viewDidLoad {
    [super viewDidLoad];

    [Router setNavigationVC:self.navigationController];
    
    [[PurchaseManager shareManager] startPurchaseWithID:@"1_month_premium"];
    
//    [[Router shared] routerTo:@"LoginAndRegisterViewController" parameter:nil];
//
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
}

@end
