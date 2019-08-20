//
//  RMFetchMessageAPI.h
//  realMatch-OC
//
//  Created by arceushs on 2019/7/28.
//  Copyright © 2019 qingting. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RMNetworkManager.h"
NS_ASSUME_NONNULL_BEGIN
@interface RMFetchMessageModel : NSObject

@property (nonatomic,strong) NSString* userId;
@property (nonatomic,strong) NSString* name;
@property (nonatomic,strong) NSString* avatar;
@property (nonatomic,strong) NSString* msg;
@property (nonatomic,strong) NSString* msgType;

@end

@interface RMFetchMessageAPIData : NSObject

@property (nonatomic,strong) NSArray<RMFetchMessageModel*>* list;

@end

@interface RMFetchMessageAPI : NSObject<RMNetworkAPI>

-(instancetype)initWithUserId:(NSString *)userId;

@end

NS_ASSUME_NONNULL_END
