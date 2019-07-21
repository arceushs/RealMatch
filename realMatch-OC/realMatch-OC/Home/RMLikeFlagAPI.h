//
//  RMLikeFlagAPI.h
//  realMatch-OC
//
//  Created by arceushs on 2019/7/20.
//  Copyright © 2019 qingting. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RMNetworkManager.h"

NS_ASSUME_NONNULL_BEGIN

@interface RMLikeFlagAPIData : NSObject

@property (nonatomic,assign) BOOL result;



@end

@interface RMLikeFlagAPI : NSObject<RMNetworkAPI>

-(instancetype)initWithMatchedUserId:(NSString*)matchedUserId userId:(NSString*)userId isLike:(BOOL)isLike;

@end

NS_ASSUME_NONNULL_END
