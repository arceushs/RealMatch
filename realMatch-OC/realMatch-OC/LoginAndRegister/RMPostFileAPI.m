//
//  RMPostFileAPI.m
//  realMatch-OC
//
//  Created by yxlyxlyxl on 2019/7/4.
//  Copyright © 2019 qingting. All rights reserved.
//

#import "RMPostFileAPI.h"

@implementation RMPostFileAPIData

@end

@implementation RMPostFileAPI
{
    NSString* _filename;
    NSString* _userId;
}
-(instancetype)initWithFilename:(NSString*)filename userId:(NSString*)userId{
    if(self = [super init]){
        _filename = filename;
        _userId = userId;
    }
    return self;
}

-(NSString*)requestHost{
    return @"http://www.4match.top";
}

-(NSString*)requestPath{
	return @"/api/upload";//以/开头;
}

-(NSDictionary*)parameters{
    return @{@"file":@"myfirstVideo"};
}

-(RMHttpMethod)method{
	return RMHttpMethodGet;
}

-(RMNetworkResponse *)adoptResponse:(RMNetworkResponse *)response{
	RMPostFileAPIData* data = [[RMPostFileAPIData alloc]init];
    
    if(response.error){
        return [[RMNetworkResponse alloc]initWithResponseObject:data];
    }
    
    NSDictionary * responseObject = response.responseObject;
   
   	//parse response here

    return [[RMNetworkResponse alloc]initWithResponseObject:data];

}



@end
