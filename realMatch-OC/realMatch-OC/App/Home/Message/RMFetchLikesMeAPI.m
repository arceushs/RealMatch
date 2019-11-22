//
//  RMFetchLikesMeAPI.m
//  realMatch-OC
//
//  Created by arceushs on 2019/7/27.
//  Copyright © 2019 qingting. All rights reserved.
//

#import "RMFetchLikesMeAPI.h"
#import "RMNetworkAPIHost.h"

@implementation RMFetchLikesMeModel
@end

@implementation RMFetchLikesMeAPIData
@end

@implementation RMFetchLikesMeAPI
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
    return [NSString stringWithFormat:@"%@/%@/likeMeUsers",RMNetworkAPIHost.apiPath,_userId];//以/开头;
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
    RMFetchLikesMeAPIData* data = [[RMFetchLikesMeAPIData alloc]init];
    
    if(response.error){
        return [[RMNetworkResponse alloc]initWithResponseObject:data];
    }
    
    NSDictionary * responseObject = response.responseObject;
    NSDictionary * dataDict = [responseObject objectForKey:@"data"];
    
    if([dataDict isKindOfClass:[NSDictionary class]]){
        NSArray* lists = [dataDict objectForKey:@"list"];
        NSMutableArray<RMFetchLikesMeModel*>* modelsArr = [NSMutableArray array];
        for(NSDictionary* dict in lists){
            RMFetchLikesMeModel* model = [[RMFetchLikesMeModel alloc]init];
            model.userId = dict[@"userId"];
            model.avatar = dict[@"avatar"];
            [modelsArr addObject:model];
        }
        data.likesMeArr = [NSArray arrayWithArray:modelsArr];
    }
    
    return [[RMNetworkResponse alloc]initWithResponseObject:data];
}


@end
