//
//  RMFetchDetailAPI.h
//  realMatch-OC
//
//  Created by yxlyxlyxl on 2019/6/17.
//  Copyright © 2019 qingting. All rights reserved.
//
#import "RMNetworkManager.h"
#import <Foundation/Foundation.h>
#import "RMFetchDetailModel.h"
NS_ASSUME_NONNULL_BEGIN
@interface RMFetchDetailAPIData : NSObject

@property (nonatomic,strong) NSArray<RMFetchDetailModel*>* videoArr;
@property (nonatomic,strong) NSString* videoDefaultImg;

@end


@interface RMFetchDetailAPI : NSObject<RMNetworkAPI>

-(instancetype)initWithUserId:(NSString*)userId;

@end

NS_ASSUME_NONNULL_END
