//
//  RMFetchHomeVideoAPI.m
//  realMatch-OC
//
//  Created by arceushs on 2019/7/20.
//  Copyright © 2019 qingting. All rights reserved.
//

#import "RMFetchHomeVideoAPI.h"

@implementation RMFetchHomeVideoAPIData

@end

@implementation RMFetchHomeVideoAPI
{
    NSString* _userId;
}

-(instancetype)initWithUserId:(NSString*)userId{
    if(self = [super init]){
        _userId = userId;
    }
    return self;
}

-(NSString*)requestHost{
    return @"https://www.4match.top";
}

-(NSString*)requestPath{
    return @"/api/home";//以/开头;
}

-(NSDictionary*)parameters{
    return @{
             @"userId":_userId,
             };
}

-(RMHttpMethod)method{
    return RMHttpMethodPost;
}

-(RMTaskType)taskType{
    return RMTaskTypeData;
}

-(RMNetworkResponse *)adoptResponse:(RMNetworkResponse *)response{
    RMFetchHomeVideoAPIData* data = [[RMFetchHomeVideoAPIData alloc]init];
    
    if(response.error){
        return [[RMNetworkResponse alloc]initWithResponseObject:data];
    }
    
    NSDictionary * responseObject = response.responseObject;
    
    NSDictionary* dataDict = responseObject[@"data"];
    if([dataDict isKindOfClass:[NSDictionary class]]){
        data.userId = [NSString stringWithFormat:@"%li",[dataDict[@"userId"] longValue]];
        data.name = dataDict[@"name"];
        data.sex = [dataDict[@"sex"] integerValue];
        data.age = [dataDict[@"age"] integerValue];
        data.videoDefaultImg = dataDict[@"videoDefaultImg"];
        data.video = dataDict[@"video"];
    }
    //parse response here
    
    RMNetworkResponse* finalResponse = [[RMNetworkResponse alloc]initWithResponseObject:data];
    finalResponse.cookie = response.cookie;
    return finalResponse;
    
}

@end

