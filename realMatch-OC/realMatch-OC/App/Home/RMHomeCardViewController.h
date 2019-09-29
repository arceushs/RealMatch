//
//  RMHomeVideoViewController.h
//  realMatch-OC
//
//  Created by arceushs on 2019/7/20.
//  Copyright © 2019 qingting. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface RMHomeCardViewController : UIViewController

@property (strong, nonatomic) void(^routeToDetailBlock)(void);
@property (strong, nonatomic) void(^noCardHintBlock)(void);
@property (strong, nonatomic) NSString* matchedUserId;

@end

NS_ASSUME_NONNULL_END
