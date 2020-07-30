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

-(instancetype)init{
    if (self = [super init]) {
        _newUser = NO;
        _code = -1;
        _msg = @"";
        _userId = @"";
        _appToken = @"";
    }
    return self;
}

@end

@implementation RMLoginAPI
{
    NSString* _phone;
    NSString* _countryCode;
    NSString* _smsCode;
}

-(instancetype)initWithPhone:(NSString*)phone phoneCountryCode:(NSString*)countryCode smsCode:(nonnull NSString *)smsCode{
    if(self = [super init]){
        _phone = (phone ? phone : @"");
        _countryCode = countryCode ? countryCode : @"";
        _smsCode = smsCode ? smsCode : @"";
    }
    return self;
}

-(NSString*)requestHost{
    return RMNetworkAPIHost.apiHost;
}

-(NSString*)requestPath{
    return [NSString stringWithFormat:@"%@/login",RMNetworkAPIHost.apiPath];
}

-(NSDictionary*)parameters{
    return @{
             @"phone":_phone,
             @"phoneCountryCode":_countryCode,
             @"smsCode":_smsCode,
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
        return [[RMNetworkResponse alloc]initWithError:response.error];
    }
    
    NSDictionary * responseObject = response.responseObject;
   
    NSDictionary* dataDict = responseObject[@"data"];
    data.code = [responseObject[@"code"] intValue];
    data.msg = responseObject[@"message"];
    if([dataDict isKindOfClass:[NSDictionary class]]){
        data.newUser = [dataDict[@"newUser"] boolValue];
        data.userId = [NSString stringWithFormat:@"%li",[dataDict[@"userId"] longValue]];
        data.appToken = dataDict[@"app_token"];
        if(![data.appToken isKindOfClass:[NSString class]]) {
            data.appToken = @"";
        }
    }
   	//parse response here

    RMNetworkResponse* finalResponse = [[RMNetworkResponse alloc]initWithResponseObject:data];
    return finalResponse;

}

@end
