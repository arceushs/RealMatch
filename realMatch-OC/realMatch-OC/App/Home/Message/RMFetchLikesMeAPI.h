//
//  RMFetchLikesMeAPI.h
//  realMatch-OC
//
//  Created by arceushs on 2019/7/27.
//  Copyright © 2019 qingting. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RMNetworkManager.h"

NS_ASSUME_NONNULL_BEGIN

@interface RMFetchLikesMeModel : NSObject

@property (nonatomic,strong) NSString* userId;
@property (nonatomic,strong) NSString* avatar;
@property (nonatomic,assign) BOOL isVip;

@end

@interface RMFetchLikesMeAPIData:NSObject

@property (nonatomic,assign) NSInteger count;
@property (nonatomic,strong) NSArray<RMFetchLikesMeModel*> * likesMeArr;

@end

@interface RMFetchLikesMeAPI : NSObject<RMNetworkAPI>

-(instancetype)initWithUserId:(NSString *)userId;

@end

NS_ASSUME_NONNULL_END
