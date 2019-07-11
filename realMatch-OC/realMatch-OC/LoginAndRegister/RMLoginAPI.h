//
//  RMLoginAPI.h
//  realMatch-OC
//
//  Created by yxlyxlyxl on 2019/7/8.
//  Copyright © 2019 qingting. All rights reserved.
//
#import "RMNetworkManager.h"
#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
@interface RMLoginAPIData : NSObject

@end

@interface RMLoginAPI : NSObject<RMNetworkAPI>

-(instancetype)initWithPhone:(NSString*)phone phoneCountryCode:(NSString*)countryCode email:(NSString*)email accountKeyId:(NSString*)userId;

@end

NS_ASSUME_NONNULL_END
