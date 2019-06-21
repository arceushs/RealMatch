//
//  RMNetworkManager.h
//  realMatch-OC
//
//  Created by yxlyxlyxl on 2019/6/14.
//  Copyright © 2019 qingting. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RMNetworkResponse.h"

typedef NS_ENUM(NSInteger,RMHttpMethod){
    RMHttpMethodGet,
    RMHttpMethodPost,
};

@protocol RMNetworkAPI <NSObject>
@required
-(NSDictionary*)parameters;
-(NSString*)requestHost;
-(NSString*)requestPath;
-(RMHttpMethod)method;

@optional
-(RMNetworkResponse*)adoptResponse:(RMNetworkResponse*)response;

@end

typedef void(^ReponseBlock)(RMNetworkResponse* responseObject,NSError* error);

@interface RMNetworkManager : NSObject

+(instancetype)shareManager;
-(void)request:(id<RMNetworkAPI>)api completion:(ReponseBlock)completion;

@end

