//
//  RMFetchHomeVideoAPI.m
//  realMatch-OC
//
//  Created by arceushs on 2019/7/20.
//  Copyright © 2019 qingting. All rights reserved.
//

#import "RMFetchHomeVideoAPI.h"
#import "RMNetworkAPIHost.h"

@implementation RMFetchHomeVideoAPIModel

-(void)parseFromDict:(NSDictionary*)dataDict{
    self.userId = [NSString stringWithFormat:@"%li",[dataDict[@"userId"] longValue]];
    self.name = dataDict[@"name"];
    self.sex = [dataDict[@"sex"] integerValue];
    self.age = [dataDict[@"age"] integerValue];
    self.videoDefaultImg = dataDict[@"videoDefaultImg"];
    self.video = dataDict[@"video"];
    self.country = dataDict[@"country"];
    self.height = [dataDict[@"height"] doubleValue];
    self.width = [dataDict[@"width"] doubleValue];
}

@end

@implementation RMFetchHomeVideoAPIData

-(instancetype)init{
    if(self = [super init]){
        _listArr = [NSMutableArray array];
    }
    return self;
}

-(RMFetchHomeVideoAPIModel *)currentModel{
    if([self.listArr count]>0){
        return  self.listArr[0];
    }
    return nil;
}

-(void)parseFromDict:(NSDictionary*)dataDict{
    [self.listArr removeAllObjects];
    for (NSDictionary* dict in dataDict[@"list"]) {
        RMFetchHomeVideoAPIModel* model = [RMFetchHomeVideoAPIModel new];
        [model parseFromDict:dict];
        [self.listArr addObject:model];
    }
}

@end

@implementation RMFetchHomeVideoAPI
{
    NSString* _userId;
    NSInteger _count;
}

-(instancetype)initWithUserId:(NSString*)userId{
    return [self initWithUserId:userId count:6];
}

-(instancetype)initWithUserId:(NSString*)userId count:(NSInteger)count{
    if(self = [super init]){
        _userId = userId;
        _count = count;
    }
    return self;
}

-(NSString*)requestHost{
    return @"https://www.4match.top";
}

-(NSString*)requestPath{
    return [NSString stringWithFormat:@"%@/home",RMNetworkAPIHost.apiPath];
}

-(NSDictionary*)parameters{
    return @{
             @"userId":_userId,
             @"count":@(_count),
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
        return [[RMNetworkResponse alloc]initWithError:response.error];
    }
    
    NSDictionary * responseObject = response.responseObject;
    
    NSDictionary* dataDict = responseObject[@"data"];
    if([dataDict isKindOfClass:[NSDictionary class]]){
        [data parseFromDict:dataDict];
    }
    //parse response here
    
    RMNetworkResponse* finalResponse = [[RMNetworkResponse alloc]initWithResponseObject:data];
    return finalResponse;
    
}

@end

