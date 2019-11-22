//
//  RMFetchMessageAPI.m
//  realMatch-OC
//
//  Created by arceushs on 2019/7/28.
//  Copyright © 2019 qingting. All rights reserved.
//

#import "RMFetchMessageAPI.h"
#import "RMNetworkAPIHost.h"

@implementation RMFetchMessageModel
@end

@implementation RMFetchMessageAPIData
@end

@implementation RMFetchMessageAPI
{
    NSString* _userId;
}
-(instancetype)initWithUserId:(NSString *)userId{
    if(self = [super init]){
        _userId = userId;
    }
    return self;
}

-(NSString*)requestHost{
    return @"https://www.4match.top";
}

-(NSString*)requestPath{
    return [NSString stringWithFormat:@"%@/%@/getMatchedMessages",RMNetworkAPIHost.apiPath,_userId];//以/开头;
}

-(NSDictionary*)parameters{
    return nil;
}

-(RMHttpMethod)method{
    return RMHttpMethodGet;
}

- (RMTaskType)taskType {
    return RMTaskTypeData;
}

-(RMNetworkResponse *)adoptResponse:(RMNetworkResponse *)response{
    RMFetchMessageAPIData* data = [[RMFetchMessageAPIData alloc]init];
    
    if(response.error){
        return [[RMNetworkResponse alloc]initWithResponseObject:data];
    }
    
    NSDictionary * responseObject = response.responseObject;
    NSDictionary * dataDict = [responseObject objectForKey:@"data"];
    
    if([dataDict isKindOfClass:[NSDictionary class]]){
        NSArray* lists = [dataDict objectForKey:@"list"];
        NSMutableArray<RMFetchMessageModel*>* modelsArr = [NSMutableArray array];
        for(NSDictionary* dict in lists){
            RMFetchMessageModel* model = [[RMFetchMessageModel alloc]init];
            model.userId =[NSString stringWithFormat:@"%d",[((NSNumber*)dict[@"userId"]) intValue]];
            model.avatar = dict[@"avatar"];
            model.name = dict[@"name"];
            model.msg = dict[@"msg"];
            model.msgType = dict[@"msgType"];
            [modelsArr addObject:model];
        }
        data.list = [NSArray arrayWithArray:modelsArr];
    }
    
    return [[RMNetworkResponse alloc]initWithResponseObject:data];
}


@end
