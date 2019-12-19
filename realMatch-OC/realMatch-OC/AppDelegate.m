//
//  AppDelegate.m
//  realMatch-OC
//
//  Created by yxl on 2019/5/22.
//  Copyright © 2019 qingting. All rights reserved.
//

#import "AppDelegate.h"
#import "ViewController.h"
#import <StoreKit/StoreKit.h>
#import "RMSocketManager.h"
#import "realMatch_OC-Swift.h"
#import <UserNotifications/UserNotifications.h>

@interface AppDelegate ()<UNUserNotificationCenterDelegate>

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    [self addRootVCToWindow];
    [self registerRemoteNotification];
    
    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    [audioSession setCategory:AVAudioSessionCategoryPlayback error:nil];
    
    NSSetUncaughtExceptionHandler(&uncaughtExceptionHandler);
    return YES;
}


-(void)registerRemoteNotification{
    if([[UIDevice currentDevice].systemVersion floatValue]>=10){
        if(@available(iOS 10.0,*)){
            UNUserNotificationCenter * center = [UNUserNotificationCenter currentNotificationCenter];
            center.delegate = self;
            [center requestAuthorizationWithOptions:UNAuthorizationOptionBadge | UNAuthorizationOptionSound | UNAuthorizationOptionAlert | UNAuthorizationOptionCarPlay completionHandler:^(BOOL granted, NSError * _Nullable error) {
                
            }];
            
            [[UIApplication sharedApplication] registerForRemoteNotifications];
        }
    }else{
        UIUserNotificationType types = (UIUserNotificationTypeAlert | UIUserNotificationTypeSound | UIUserNotificationTypeBadge);
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:types categories:nil];
        [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
        [[UIApplication sharedApplication] registerForRemoteNotifications];
    }
}

-(void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken{
    NSString *token = [[deviceToken description] stringByTrimmingCharactersInSet: [NSCharacterSet characterSetWithCharactersInString:@"<>"]];
    token = [token stringByReplacingOccurrencesOfString:@" " withString:@""];
    [[NSUserDefaults standardUserDefaults] setObject:token forKey:@"global-pushToken"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    

    if (@available(iOS 13,*)) {
        const unsigned *tokenBytes = (const unsigned *)[deviceToken bytes];
        NSString *hexToken = [NSString stringWithFormat:@"%08x%08x%08x%08x%08x%08x%08x%08x",
                              ntohl(tokenBytes[0]), ntohl(tokenBytes[1]), ntohl(tokenBytes[2]),
                              ntohl(tokenBytes[3]), ntohl(tokenBytes[4]), ntohl(tokenBytes[5]),
                              ntohl(tokenBytes[6]), ntohl(tokenBytes[7])];
        [[NSUserDefaults standardUserDefaults] setObject:hexToken forKey:@"global-pushToken"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    
    NSLog(@"content---%@", token);
}

-(void)applicationDidEnterBackground:(UIApplication *)application{
    if([RMUserCenter shared].userId){
        [[RMSocketManager shared] disconnect:[RMUserCenter shared].userId];
    }
}

-(void)applicationWillTerminate:(UIApplication *)application{
    if([RMUserCenter shared].userId){
        [[RMSocketManager shared] disconnect:[RMUserCenter shared].userId];
    }
}

-(void)applicationWillEnterForeground:(UIApplication *)application{
    if([RMUserCenter shared].userId){
        [[RMSocketManager shared] connectWithUserId:[RMUserCenter shared].userId];
    }
}

-(void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error{
    
}

//非UNNotification框架
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler NS_AVAILABLE_IOS(7_0) {
    // iOS7及以上系统
    if (userInfo) {
        if ([UIApplication sharedApplication].applicationState == UIApplicationStateActive) {// app位于前台通知
            NSLog(@"app位于前台通知(didReceiveRemoteNotification:fetchCompletionHandler:):%@", userInfo);
        } else {// 切到后台唤起
            NSLog(@"app位于后台通知(didReceiveRemoteNotification:fetchCompletionHandler:):%@", userInfo);
        }
    }
    NSDictionary* apsDict = userInfo[@"aps"];
    NSString* avatar = apsDict[@"avatar"]?:@"";
    NSString* matchedUserId = apsDict[@"userId"]?:@"";
    NSString *username = apsDict[@"messageFrom"]?:@"";
    int pushType = [apsDict[@"pushType"] intValue];
    if (pushType == 1) {
        [[Router shared]routerTo:@"RMMessageDetailViewController" parameter:@{@"fromUser":[RMUserCenter shared].userId,@"toUser":matchedUserId,@"fromUserName":username,@"avatar":avatar}];
    } else if (pushType == 2) {
        [[Router shared] routerTo:@"RMMatchedViewController" parameter:@{@"matchedAvatar":avatar,@"matchedUserId":matchedUserId,@"matchedUsername":username}];
    }
    completionHandler(UIBackgroundFetchResultNewData);

}



-(void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions))completionHandler{
    NSDictionary* userInfo = notification.request.content.userInfo;
    NSDictionary* apsDict = userInfo[@"aps"];
    NSString* avatar = apsDict[@"avatar"]?:@"";
    NSString* matchedUserId = apsDict[@"userId"]?:@"";
    [[Router shared] routerTo:@"RMMatchedViewController" parameter:@{@"matchedAvatar":avatar,@"matchedUserId":matchedUserId}];
}

-(void)addRootVCToWindow{
    self.window = [[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
    
    ViewController* vc = [[ViewController alloc]init];
    UINavigationController* navigationVC = [[UINavigationController alloc]initWithRootViewController:vc];
    navigationVC.navigationBar.hidden = YES;
    self.window.rootViewController = navigationVC;
    [self.window makeKeyAndVisible];
    vc.view.backgroundColor = [UIColor whiteColor];
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

void uncaughtExceptionHandler(NSException*exception){
    
     NSLog(@"CRASH: %@", exception);
    
     NSLog(@"Stack Trace: %@",[exception callStackSymbols]);
    
     // Internal error reporting
    
}


@end
