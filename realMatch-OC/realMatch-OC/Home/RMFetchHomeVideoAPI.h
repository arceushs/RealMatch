//
//  RMFetchHomeVideoAPI.h
//  realMatch-OC
//
//  Created by arceushs on 2019/7/20.
//  Copyright © 2019 qingting. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RMNetworkManager.h"
NS_ASSUME_NONNULL_BEGIN

@interface RMFetchHomeVideoAPIData : NSObject

@property (nonatomic,strong) NSString* userId;
@property (nonatomic,strong) NSString* name;
@property (nonatomic,assign) NSInteger age;
@property (nonatomic,assign) NSInteger sex;
@property (nonatomic,strong) NSString* videoDefaultImg;
@property (nonatomic,strong) NSString* video;


@end

@interface RMFetchHomeVideoAPI :  NSObject<RMNetworkAPI>

-(instancetype)initWithUserId:(NSString*)userId;

@end
NS_ASSUME_NONNULL_END
