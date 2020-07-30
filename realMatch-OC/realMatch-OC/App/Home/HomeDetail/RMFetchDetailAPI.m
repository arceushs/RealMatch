//
//  RMFetchDetailAPI.m
//  realMatch-OC
//
//  Created by yxlyxlyxl on 2019/6/17.
//  Copyright © 2019 qingting. All rights reserved.
//

#import "RMFetchDetailAPI.h"
#import "RMNetworkAPIHost.h"

@implementation RMFetchDetailAPIData

-(instancetype)init{
    if(self = [super init]){
        self.videoArr = [NSMutableArray array];
        self.videoDefaultImg = @"";
        self.name = @"";
        self.phone = @"";
        self.email = @"";
        self.sex = 0;
        self.age = 0;
        self.area = @"";
        self.avatar = @"";
        self.height = 0;
        self.width = 0;
    }
    return self;
}

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
    return RMNetworkAPIHost.apiHost;
}

-(NSString*)requestPath{
    return [NSString stringWithFormat:@"%@/%@/detail",RMNetworkAPIHost.apiPath,_userid];//以/开头;
}

-(NSDictionary*)parameters{
	return nil;
}

-(RMHttpMethod)method{
	return RMHttpMethodPost;
}

- (RMTaskType)taskType {
    return RMTaskTypeData;
}

-(RMNetworkResponse *)adoptResponse:(RMNetworkResponse *)response{
    RMFetchDetailAPIData* data = [[RMFetchDetailAPIData alloc]init];
    
    if(response.error){
        return [[RMNetworkResponse alloc]initWithError:response.error];
    }
    
    NSDictionary * responseObject = response.responseObject;
    NSDictionary * dataDict = [responseObject objectForKey:@"data"];
    
    if([dataDict isKindOfClass:[NSDictionary class]]){
        NSArray* uploads = [dataDict objectForKey:@"uploads"];
        
        NSMutableArray<RMFetchVideoDetailModel*>* modelsArr = [NSMutableArray array];
        for(NSDictionary* dict in uploads){
            RMFetchVideoDetailModel* model = [[RMFetchVideoDetailModel alloc]init];
            [model parseFromDict:dict];
            [modelsArr addObject:model];
        }
        
        data.videoArr = [NSArray arrayWithArray:modelsArr];
        data.name = [dataDict objectForKey:@"name"];
        data.email = [dataDict objectForKey:@"email"];
        data.phone = [dataDict objectForKey:@"phone"];
        data.sex = [[dataDict objectForKey:@"sex"] intValue];
        data.age = [[dataDict objectForKey:@"age"] intValue];
        data.area = [dataDict objectForKey:@"country"];
        data.avatar = [dataDict objectForKey:@"avatar"];
        data.recharged = [[dataDict objectForKey:@"recharged"] boolValue];
        data.isAnomaly = [dataDict[@"is_anomaly"] boolValue];
        data.uploadedVideo = [dataDict[@"has_intro_video"] boolValue];
        data.avatar = [dataDict objectForKey:@"avatar"];
        data.school = [dataDict objectForKey:@"school"];
        if (data.school.length <= 0) {
            data.school = @"my school";
        }
        data.job = [dataDict objectForKey:@"job"];
        if (data.job.length <= 0) {
            data.job = @"my job";
        }
        data.aboutMe = [dataDict objectForKey:@"about_me"];
        if (data.aboutMe.length <= 0) {
            data.aboutMe = @"about me";
        }
    }
    
    return [[RMNetworkResponse alloc]initWithResponseObject:data];
}




@end
