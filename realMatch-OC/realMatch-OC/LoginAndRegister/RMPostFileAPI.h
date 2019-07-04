//
//  RMPostFileAPI.h
//  realMatch-OC
//
//  Created by yxlyxlyxl on 2019/7/4.
//  Copyright © 2019 qingting. All rights reserved.
//
#import "RMNetworkManager.h"
#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
@interface RMPostFileAPIData : NSObject

@end

@interface RMPostFileAPI : NSObject<RMNetworkAPI>

-(instancetype)initWithFilename:(NSString*)filename userId:(NSString*)userId;

@end

NS_ASSUME_NONNULL_END
