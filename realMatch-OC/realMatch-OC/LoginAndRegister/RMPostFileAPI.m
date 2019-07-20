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
    NSString* _filePath;
    NSString* _mimeType;
}
-(instancetype)initWithFilePath:(NSString*)filePath Filename:(NSString*)filename userId:(NSString*)userId mimeType:(NSString*)mimeType{
    if(self = [super init]){
        _filename = filename;
        _userId = userId;
        _filePath = filePath;
        _mimeType = mimeType;
    }
    return self;
}

-(NSString*)requestHost{
    return @"https://www.4match.top";
}

-(NSString*)requestPath{
	return @"/api/upload";//以/开头;
}

-(NSDictionary*)parameters{
    return @{@"userId":_userId,
             @"filepath":_filePath,
             @"filename":_filename,
             @"mimetype":_mimeType,
             };
}

-(RMHttpMethod)method{
	return RMHttpMethodPost;
}

-(RMTaskType)taskType{
    return RMTaskTypeUpload;
}

-(RMNetworkResponse *)adoptResponse:(RMNetworkResponse *)response{
	RMPostFileAPIData* data = [[RMPostFileAPIData alloc]init];
    
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
