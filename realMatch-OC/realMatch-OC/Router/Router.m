//
//  Router.m
//  realMatch-OC
//
//  Created by yxl on 2019/5/23.
//  Copyright © 2019 qingting. All rights reserved.
//

#import "Router.h"

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
}

-(void)routerTo:(NSString*)vcName parameter:(NSDictionary*)params{
    for (NSString* tableVCName in _routeTable) {
        if([vcName isEqualToString:tableVCName]){
            Class vcClass = NSClassFromString(tableVCName);
            UIViewController<RouterController>* targetVC = nil;
            if([vcClass instancesRespondToSelector:@selector(initWithRouterParams:)]){
                targetVC = [[vcClass alloc]initWithRouterParams:params];
                DisplayStyle style = DisplayStylePush;
                if([targetVC respondsToSelector:@selector(displayStyle)]){
                    style = [targetVC displayStyle];
                }
                if(style == DisplayStylePush){
                    [self.navigationVC pushViewController:targetVC animated:YES];
                }else{
                    [[self topMostController] presentViewController:targetVC animated:YES completion:nil];
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
