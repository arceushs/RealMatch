//
//  RMLoginAPI.m
//  realMatch-OC
//
//  Created by yxlyxlyxl on 2019/7/8.
//  Copyright © 2019 qingting. All rights reserved.
//

#import "RMLoginAPI.h"

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
	return @"/api/login";//以/开头;
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
   
   	//parse response here

    return [[RMNetworkResponse alloc]initWithResponseObject:data];

}

@end
