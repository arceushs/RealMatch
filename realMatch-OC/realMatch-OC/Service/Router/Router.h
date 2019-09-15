//
//  Router.h
//  realMatch-OC
//
//  Created by yxl on 2019/5/23.
//  Copyright © 2019 qingting. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface RouterAdopter : NSObject

@property (nonatomic,strong) NSString* vcName;
@property (nonatomic,strong) NSDictionary* params;
@property (nonatomic,strong) void (^routerAdopterCallback)(NSDictionary* dict);

@end


typedef NS_ENUM(NSInteger,DisplayStyle){
    DisplayStylePush,
    DisplayStylePresent,
};

@protocol RouterController <NSObject>

@required

-(instancetype)initWithRouterParams:(NSDictionary*)params;
-(DisplayStyle)displayStyle;
-(BOOL)animation;

@optional
-(instancetype)initWithCommand:(RouterAdopter*)adopter;

@end


@interface Router : NSObject

+(void)setNavigationVC:(UINavigationController*)vc;
+(instancetype)shared;
+(void)backToRoot;

-(void)routerTo:(RouterAdopter*)routerAdopter;
-(void)routerTo:(NSString*)vcName parameter:(NSDictionary*)params;
-(UIViewController *) topMostController ;
@end


