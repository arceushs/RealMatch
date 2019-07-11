//
//  RMFetchDetailAPI.m
//  realMatch-OC
//
//  Created by yxlyxlyxl on 2019/6/17.
//  Copyright © 2019 qingting. All rights reserved.
//

#import "RMFetchDetailAPI.h"

@implementation RMFetchDetailAPIData


@end

@implementation RMFetchDetailAPI
{
    NSString* _userid;
}
-(instancetype)initWithUserId:(NSString *)userId{
    if(self = [super init]){
        _userid = userId;
    }
    return self;
}

-(NSString*)requestHost{
	return @"";
}

-(NSString*)requestPath{
    return @"";//以/开头;
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
    RMFetchDetailAPIData* data = [[RMFetchDetailAPIData alloc]init];
    
    if(response.error){
        return [[RMNetworkResponse alloc]initWithResponseObject:data];
    }
    
    NSDictionary * responseObject = response.responseObject;
    NSDictionary * dataDict = [responseObject objectForKey:@"data"];
    
    if([dataDict isKindOfClass:[NSDictionary class]]){
        NSArray* uploads = [dataDict objectForKey:@"uploads"];
        NSMutableArray<RMFetchDetailModel*>* modelsArr = [NSMutableArray array];
        for(NSDictionary* dict in uploads){
            RMFetchDetailModel* model = [[RMFetchDetailModel alloc]init];
            [model parseFromDict:dict];
            [modelsArr addObject:model];
        }
        data.videoArr = [NSArray arrayWithArray:modelsArr];
    }
    
    return [[RMNetworkResponse alloc]initWithResponseObject:data];
}




@end
