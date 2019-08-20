//
//  RMPurchaseViewController.m
//  realMatch-OC
//
//  Created by yxlyxlyxl on 2019/7/5.
//  Copyright © 2019 qingting. All rights reserved.
//

#import "RMPurchaseViewController.h"
#import "UIColor+RealMatch.h"
@interface RMPurchaseViewController ()

@end

@implementation RMPurchaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.firstView.layer.cornerRadius = 4;
    self.firstView.layer.masksToBounds = YES;
    self.firstView.layer.borderColor = [UIColor colorWithString:@"C9CCD6"].CGColor;
    self.firstView.layer.borderWidth = 1;
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
