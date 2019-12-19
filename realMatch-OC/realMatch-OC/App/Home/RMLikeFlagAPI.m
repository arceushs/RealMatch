//
//  RMLikeFlagAPI.m
//  realMatch-OC
//
//  Created by arceushs on 2019/7/20.
//  Copyright © 2019 qingting. All rights reserved.
//

#import "RMLikeFlagAPI.h"
#import "RMNetworkAPIHost.h"

@implementation RMLikeFlagAPIData

@end

@implementation RMLikeFlagAPI
{
    NSString* _matchedUserId;
    NSString* _userId;
    BOOL _isLike;
}
-(instancetype)initWithMatchedUserId:(NSString*)matchedUserId userId:(NSString*)userId isLike:(BOOL)isLike{
    if(self = [super init]){
        _userId = userId;
        _matchedUserId = matchedUserId;
        _isLike = isLike;
    }
    return self;
}

-(NSString*)requestHost{
    return @"https://www.4match.top";
}

-(NSString*)requestPath{
    return [NSString stringWithFormat:@"%@/%@/match",RMNetworkAPIHost.apiPath,_userId];//以/开头;
}

-(NSDictionary*)parameters{
    return @{
             @"matchedUserId":_matchedUserId,
             @"isLike":@(_isLike),
             };
}

-(RMHttpMethod)method{
    return RMHttpMethodPost;
}

-(RMTaskType)taskType{
    return RMTaskTypeData;
}

-(RMNetworkResponse *)adoptResponse:(RMNetworkResponse *)response{
    RMLikeFlagAPIData* data = [[RMLikeFlagAPIData alloc]init];
    
    if(response.error){
        return [[RMNetworkResponse alloc]initWithError:response.error];
    }
    
    NSDictionary * responseObject = response.responseObject;
    
    NSInteger code = [responseObject[@"code"] integerValue];
    if(code == 200){
        data.result = YES;
    }
    //parse response here
    
    RMNetworkResponse* finalResponse = [[RMNetworkResponse alloc]initWithResponseObject:data];
    finalResponse.cookie = response.cookie;
    return finalResponse;
    
}


@end
