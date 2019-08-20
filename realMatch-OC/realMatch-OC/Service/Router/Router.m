//
//  Router.m
//  realMatch-OC
//
//  Created by yxl on 2019/5/23.
//  Copyright © 2019 qingting. All rights reserved.
//

#import "Router.h"

@implementation RouterAdopter

@end


@interface Router ()
@property (nonatomic,strong) NSMutableArray<NSString*>* routeTable;
@property (nonatomic,strong) UINavigationController * navigationVC;
@end

@implementation Router

+(instancetype)shared{
    static dispatch_once_t onceToken;
    static Router * router = nil;
    dispatch_once(&onceToken, ^{
        if(router == nil){
            router = [[Router alloc]init];
            router.routeTable = [NSMutableArray array];
            [router createRouteTable:router.routeTable];
        }
    });
    return router;
}

+(void)setNavigationVC:(id)vc{
    [Router shared].navigationVC = vc;
}

-(void)createRouteTable:(NSMutableArray<NSString*> *)routeTable{
    [routeTable addObject:@"LoginAndRegisterViewController"];
    [routeTable addObject:@"RMCaptureViewController"];
    [routeTable addObject:@"RMHomePageViewController"];
    [routeTable addObject:@"RMHomePageDetailViewController"];
    [routeTable addObject:@"RMVideoPlayViewController"];
    [routeTable addObject:@"RMEmailViewController"];
    [routeTable addObject:@"RMNameViewController"];
    [routeTable addObject:@"RMDatePickerViewController"];
    [routeTable addObject:@"RMGenderViewController"];
    [routeTable addObject:@"RMRealVideoViewController"];
    [routeTable addObject:@"RMCaptureViewController"];
    [routeTable addObject:@"RMMessageViewController"];
    [routeTable addObject:@"RMMessageDetailViewController"];
    [routeTable addObject:@"RMPurchaseViewController"];
    [routeTable addObject:@"RMMatchedViewController"];
    [routeTable addObject:@"RMProfileViewController"];
    [routeTable addObject:@"RMEditProfileViewController"];
    [routeTable addObject:@"RMSettingViewController"];
}

-(void)routerTo:(RouterAdopter *)routerAdopter{
    for (NSString* tableVCName in _routeTable) {
        if([routerAdopter.vcName isEqualToString:tableVCName]){
            Class vcClass = NSClassFromString(tableVCName);
            if(vcClass == nil){
                vcClass = NSClassFromString([NSString stringWithFormat:@"realMatch_OC.%@",tableVCName]);
            }
            UIViewController<RouterController>* targetVC = nil;
            if([vcClass instancesRespondToSelector:@selector(initWithCommand:)]){
                targetVC = [[vcClass alloc]initWithCommand:routerAdopter];
                
                DisplayStyle style = DisplayStylePush;
                if([targetVC respondsToSelector:@selector(displayStyle)]){
                    style = [targetVC displayStyle];
                }
                
                BOOL animation = YES;
                if([targetVC respondsToSelector:@selector(animation)]){
                    animation = [targetVC animation];
                }
                
                if(style == DisplayStylePush){
                    [self.navigationVC pushViewController:targetVC animated:animation];
                }else{
                    [[self topMostController] presentViewController:targetVC animated:animation completion:nil];
                }
            }
            break;
        }
    }
}

-(void)routerTo:(NSString*)vcName parameter:(NSDictionary*)params{
    for (NSString* tableVCName in _routeTable) {
        if([vcName isEqualToString:tableVCName]){
            Class vcClass = NSClassFromString(tableVCName);
            if(vcClass == nil){
                vcClass = NSClassFromString([NSString stringWithFormat:@"realMatch_OC.%@",tableVCName]);
            }
            UIViewController<RouterController>* targetVC = nil;
            if([vcClass instancesRespondToSelector:@selector(initWithRouterParams:)]){
                targetVC = [[vcClass alloc]initWithRouterParams:params];
                
                DisplayStyle style = DisplayStylePush;
                if([targetVC respondsToSelector:@selector(displayStyle)]){
                    style = [targetVC displayStyle];
                }
                
                BOOL animation = YES;
                if([targetVC respondsToSelector:@selector(animation)]){
                    animation = [targetVC animation];
                }
                
                if(style == DisplayStylePush){
                    [self.navigationVC pushViewController:targetVC animated:animation];
                }else{
                    [[self topMostController] presentViewController:targetVC animated:animation completion:nil];
                }
            }
            break;
        }
    }
}

-(UIViewController *) topMostController {
    UIViewController*topController = [UIApplication sharedApplication].keyWindow.rootViewController;
    while(topController.presentedViewController){
        topController=topController.presentedViewController;
    }
    return topController;
}

@end
