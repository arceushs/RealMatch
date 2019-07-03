//
//  Router.h
//  realMatch-OC
//
//  Created by yxl on 2019/5/23.
//  Copyright © 2019 qingting. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger,DisplayStyle){
    DisplayStylePush,
    DisplayStylePresent,
};

@protocol RouterController <NSObject>

@required
-(instancetype)initWithRouterParams:(NSDictionary*)params;
-(DisplayStyle)displayStyle;
-(BOOL)animation;

@end


@interface Router : NSObject

+(void)setNavigationVC:(UINavigationController*)vc;
+(instancetype)shared;

-(void)routerTo:(NSString*)vcName parameter:(NSDictionary*)params;
-(UIViewController *) topMostController ;
@end


