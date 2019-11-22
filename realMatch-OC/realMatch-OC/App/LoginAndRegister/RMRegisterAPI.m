//
//  RMRegisterAPI.m
//  realMatch-OC
//
//  Created by yxlyxlyxl on 2019/7/8.
//  Copyright © 2019 qingting. All rights reserved.
//

#import "RMRegisterAPI.h"
#import "RMNetworkAPIHost.h"

@implementation RMRegisterAPIData

@end

@implementation RMRegisterAPI
{
    NSString* _name;
    NSString* _birth;
    int _sex;
    NSString* _userId;
}
-(instancetype)initWithName:(NSString*)name birth:(NSString*)birth sex:(int)sex userId:(NSString*)userId{
    if(self = [super init]){
        _name = name;
        _birth = birth;
        _sex = sex;
        _userId = userId;
    }
    return self;
}

-(NSString*)requestHost{
    return @"https://www.4match.top";
}

-(NSString*)requestPath{
	return [NSString stringWithFormat:@"%@/%@/create",RMNetworkAPIHost.apiPath,_userId];//以/开头;
}

-(NSDictionary*)parameters{
    return @{@"name":_name,
             @"birthday":_birth,
             @"sex":@(_sex),
             };
}

-(RMHttpMethod)method{
	return RMHttpMethodPost;
}

-(RMTaskType)taskType{
    return RMTaskTypeData;
}

-(RMNetworkResponse *)adoptResponse:(RMNetworkResponse *)response{
	RMRegisterAPIData* data = [[RMRegisterAPIData alloc]init];
    
    if(response.error){
        return [[RMNetworkResponse alloc]initWithResponseObject:data];
    }
    
    NSDictionary * responseObject = response.responseObject;
   
    int code = [[responseObject objectForKey:@"code"] intValue];
    if(code == 200){
        data.result = YES;
    }
   	//parse response here

    return [[RMNetworkResponse alloc]initWithResponseObject:data];

}

@end
