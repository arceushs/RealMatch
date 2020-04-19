//
//  LoginAndRegisterViewController.m
//  realMatch-OC
//
//  Created by yxl on 2019/5/23.
//  Copyright © 2019 qingting. All rights reserved.
//

#import "LoginAndRegisterViewController.h"
//#import <AccountKit/AccountKit.h>
#import "Router+AccountKit.h"
#import "realMatch_OC-Swift.h"
#import "SVProgressHUD.h"
#import "RMSocketManager.h"
#import <TTTAttributedLabel.h>

@interface LoginAndRegisterViewController ()<TTTAttributedLabelDelegate>
@property (weak, nonatomic) IBOutlet TTTAttributedLabel *termsAndPrivacyLabel;
@property (strong, nonatomic) UIView* agreeView;

@end

@implementation LoginAndRegisterViewController
//{
//    AKFAccountKit *_accountKit;
//    UIViewController<AKFViewController> *_pendingLoginViewController;
//}

-(instancetype)initWithRouterParams:(NSDictionary *)params{
    if(self = [super init]){
        
    }
    return self;
}

- (DisplayStyle)displayStyle {
    return DisplayStylePush;
}

-(BOOL)animation{
    return NO;
}


- (void)viewDidLoad {
    [super viewDidLoad];

    self.termsAndPrivacyLabel.enabledTextCheckingTypes = NSTextCheckingTypeLink;
    self.termsAndPrivacyLabel.delegate = self;
    NSRange range1 = [self.termsAndPrivacyLabel.text rangeOfString:@"Terms"];
    [self.termsAndPrivacyLabel addLinkToURL:[NSURL URLWithString:@"https://www.4match.top/terms.html"] withRange:range1];
    NSRange range2 = [self.termsAndPrivacyLabel.text rangeOfString:@"Privacy Policy"];
    [self.termsAndPrivacyLabel addLinkToURL:[NSURL URLWithString:@"https://www.4match.top/policy.html"] withRange:range2];
    // Do any additional setup after loading the view from its nib.
    
    RMAgreeTextView *agreeView = [[RMAgreeTextView alloc] initWithFrame:self.view.bounds];
    self.agreeView = agreeView;
    [agreeView.agreeButton addTarget:self action:@selector(gotIt) forControlEvents:UIControlEventTouchDown];
    agreeView.agreeLabel.text = @"We update our terms of use and privacy policy. If you continue to use our service, then you accept our terms and privacy policy.";
    agreeView.agreeLabel.enabledTextCheckingTypes = NSTextCheckingTypeLink;
    agreeView.agreeLabel.delegate = self;
    NSRange range3 = [agreeView.agreeLabel.text rangeOfString:@"terms of use"];
    [agreeView.agreeLabel addLinkToURL:[NSURL URLWithString:@"https://www.4match.top/terms.html"] withRange:range3];
    NSRange range4 = [agreeView.agreeLabel.text rangeOfString:@"privacy policy"];
    [agreeView.agreeLabel addLinkToURL:[NSURL URLWithString:@"https://www.4match.top/policy.html"] withRange:range4];


    [self.view addSubview:agreeView];

}

- (void)gotIt{
    [self.agreeView removeFromSuperview];
}

//- (void)_prepareLoginViewController:(UIViewController<AKFViewController> *)loginViewController
//{
//    loginViewController.delegate = self;
//}

- (IBAction)routeToAccountKitLoginVC:(id)sender {
    [[Router shared] routerTo:@"RMPhoneCheckViewController" parameter:nil];
}

//-(void)viewController:(UIViewController<AKFViewController> *)viewController didCompleteLoginWithAccessToken:(id<AKFAccessToken>)accessToken state:(NSString *)state{
//    [SVProgressHUD show];
//    [_accountKit requestAccount:^(id<AKFAccount>  _Nullable account, NSError * _Nullable error) {
//        [RMUserCenter shared].accountKitID = account.accountID;
//        [RMUserCenter shared].accountKitEmailAddress = account.emailAddress;
//        [RMUserCenter shared].accountKitPhoneNumber = account.phoneNumber.phoneNumber;
//        [RMUserCenter shared].accountKitCountryCode = account.phoneNumber.countryCode;
//
//        RMLoginAPI* loginAPI = [[RMLoginAPI alloc]initWithPhone:account.phoneNumber.phoneNumber phoneCountryCode:account.phoneNumber.countryCode email:account.emailAddress accountKeyId:account.accountID];
//        [[RMNetworkManager shareManager] request:loginAPI completion:^(RMNetworkResponse *response) {
//            [SVProgressHUD dismiss];
//            if(response.error){
//                return ;
//            }
//
//            RMLoginAPIData* data = response.responseObject;
//            [RMUserCenter shared].userId = data.userId;
//            [[NSUserDefaults standardUserDefaults] setObject:data.userId forKey:@"global-userId"];
//            [[NSUserDefaults standardUserDefaults] synchronize];
//
//            if(!data.newUser){
//                [[Router shared] routerTo:@"RMHomePageViewController" parameter:nil];
//            }else{
//                [[Router shared] routerTo:@"RMNameViewController" parameter:nil];
//            }
//        }];
//    }];
//}

//-(void)viewController:(UIViewController<AKFViewController> *)viewController didCompleteLoginWithAuthorizationCode:(NSString *)code state:(NSString *)state{
//
//}
//
//
//-(void)viewController:(UIViewController<AKFViewController> *)viewController didFailWithError:(NSError *)error{
//
//}
//
//-(void)viewControllerDidCancel:(UIViewController<AKFViewController> *)viewController{
//
//}

- (void)viewWillDisappear:(BOOL)animated{
    [SVProgressHUD dismiss];
}

- (void)viewWillLayoutSubviews{
    [super viewWillLayoutSubviews];
    self.agreeView.frame = self.view.bounds;
    
}

#pragma mark - TTTAtrributelabel
- (void)attributedLabel:(TTTAttributedLabel *)label didSelectLinkWithURL:(NSURL *)url{
    [[Router shared] routerTo:@"RMWebViewController" parameter:@{@"url":url.absoluteString}];
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
