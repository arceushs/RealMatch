//
//  LoginAndRegisterViewController.h
//  realMatch-OC
//
//  Created by yxl on 2019/5/23.
//  Copyright © 2019 qingting. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Router.h"

NS_ASSUME_NONNULL_BEGIN

@interface LoginAndRegisterViewController : UIViewController<RouterController>

-(instancetype)initWithRouterParams:(NSDictionary*)params;

@end

NS_ASSUME_NONNULL_END
