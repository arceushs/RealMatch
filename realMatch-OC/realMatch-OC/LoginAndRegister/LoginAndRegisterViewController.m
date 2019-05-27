//
//  LoginAndRegisterViewController.m
//  realMatch-OC
//
//  Created by yxl on 2019/5/23.
//  Copyright © 2019 qingting. All rights reserved.
//

#import "LoginAndRegisterViewController.h"
#import <AccountKit/AccountKit.h>
#import "Router+AccountKit.h"

@interface LoginAndRegisterViewController ()<AKFViewControllerDelegate>

@end

@implementation LoginAndRegisterViewController
{
    AKFAccountKit *_accountKit;
    UIViewController<AKFViewController> *_pendingLoginViewController;
}

-(instancetype)initWithRouterParams:(NSDictionary *)params{
    if(self = [super init]){
        
    }
    return self;
}

- (DisplayStyle)displayStyle {
    return DisplayStylePresent;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (_accountKit == nil) {
        _accountKit = [[AKFAccountKit alloc] initWithResponseType:AKFResponseTypeAccessToken];
    }

    _pendingLoginViewController = [_accountKit viewControllerForPhoneLogin];
//     _pendingLoginViewController = [_accountKit viewControllerForEmailLoginWithEmail:@"xkjmdy1@outlook.com" state:[NSUUID UUID].UUIDString];
    
    [self _prepareLoginViewController:_pendingLoginViewController];
    // Do any additional setup after loading the view from its nib.
}

- (void)_prepareLoginViewController:(UIViewController<AKFViewController> *)loginViewController
{
    loginViewController.delegate = self;
}

- (IBAction)routeToAccountKitLoginVC:(id)sender {
    [[Router shared] routeToAccountKitLoginVC:_pendingLoginViewController];
}

-(void)viewController:(UIViewController<AKFViewController> *)viewController didCompleteLoginWithAccessToken:(id<AKFAccessToken>)accessToken state:(NSString *)state{
    
}

-(void)viewController:(UIViewController<AKFViewController> *)viewController didCompleteLoginWithAuthorizationCode:(NSString *)code state:(NSString *)state{
    
}


-(void)viewController:(UIViewController<AKFViewController> *)viewController didFailWithError:(NSError *)error{
    
}

-(void)viewControllerDidCancel:(UIViewController<AKFViewController> *)viewController{
    
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
