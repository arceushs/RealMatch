//
//  RMLoginAPI.m
//  realMatch-OC
//
//  Created by yxlyxlyxl on 2019/7/8.
//  Copyright © 2019 qingting. All rights reserved.
//

#import "RMLoginAPI.h"
#import "RMNetworkAPIHost.h"

@implementation RMLoginAPIData

@end

@implementation RMLoginAPI
{
    NSString* _phone;
    NSString* _countryCode;
    NSString* _email;
    NSString* _accountId;
}

-(instancetype)initWithPhone:(NSString*)phone phoneCountryCode:(NSString*)countryCode email:(NSString*)email accountKeyId:(NSString*)userId{
    if(self = [super init]){
        _phone = (phone ? phone : @"");
        _countryCode = countryCode ? countryCode : @"";
        _email = email ? email : @"";
        _accountId = userId ? userId: @"";
    }
    return self;
}

-(NSString*)requestHost{
    return @"https://www.4match.top";
}

-(NSString*)requestPath{
    return [NSString stringWithFormat:@"%@/login",RMNetworkAPIHost.apiPath];
}

-(NSDictionary*)parameters{
    return @{
             @"phone":_phone,
             @"phoneCountryCode":_countryCode,
             @"email":_email,
             @"accountKeyId":_accountId,
             };
}

-(RMHttpMethod)method{
	return RMHttpMethodPost;
}

-(RMTaskType)taskType{
    return RMTaskTypeData;
}

-(RMNetworkResponse *)adoptResponse:(RMNetworkResponse *)response{
	RMLoginAPIData* data = [[RMLoginAPIData alloc]init];
    
    if(response.error){
        return [[RMNetworkResponse alloc]initWithResponseObject:data];
    }
    
    NSDictionary * responseObject = response.responseObject;
   
    NSDictionary* dataDict = responseObject[@"data"];
    if([dataDict isKindOfClass:[NSDictionary class]]){
        data.newUser = [dataDict[@"newUser"] boolValue];
        data.userId = [NSString stringWithFormat:@"%li",[dataDict[@"userId"] longValue]];
    }
   	//parse response here

    RMNetworkResponse* finalResponse = [[RMNetworkResponse alloc]initWithResponseObject:data];
    finalResponse.cookie = response.cookie;
    return finalResponse;

}

@end
