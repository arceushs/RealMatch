//
//  RMNetworkResponse.h
//  realMatch-OC
//
//  Created by yxlyxlyxl on 2019/6/17.
//  Copyright © 2019 qingting. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface RMNetworkResponse<T> : NSObject

@property (nonatomic,strong,readonly) T responseObject;
@property (nonatomic,strong,readonly) NSError* error;

-(instancetype)initWithResponseObject:(id)object;
-(instancetype)initWithError:(NSError*)error;


@end

NS_ASSUME_NONNULL_END
