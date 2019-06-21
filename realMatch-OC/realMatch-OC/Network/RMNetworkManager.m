//
//  RMNetworkManager.m
//  realMatch-OC
//
//  Created by yxlyxlyxl on 2019/6/14.
//  Copyright © 2019 qingting. All rights reserved.
//

#import "RMNetworkManager.h"
#import "AFNetworking.h"

@implementation RMNetworkManager
{
    AFHTTPSessionManager * _afmanager;
}
+(instancetype)shareManager{
    static dispatch_once_t onceToken;
    static RMNetworkManager* manager = nil;
    dispatch_once(&onceToken, ^{
        if(manager == nil){
            manager = [[RMNetworkManager alloc]init];
        }
    });
    return manager;
}

-(void)request:(id<RMNetworkAPI>)api completion:(ReponseBlock)completion{
    NSDictionary* parameters = [api parameters];
    NSString* host = [api requestHost];
    NSString* path = [api requestPath];
    NSString* url = [NSString stringWithFormat:@"%@%@",host,path];
    RMHttpMethod method = [api method];
    
    _afmanager = [AFHTTPSessionManager manager];
    switch (method) {
        case RMHttpMethodPost:{
            [_afmanager POST:url parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                RMNetworkResponse* response = [[RMNetworkResponse alloc]initWithResponseObject:responseObject];
                if([api respondsToSelector:@selector(adoptResponse:)]){
                    response = [api adoptResponse:response];
                }
                if(completion){
                    completion(response,nil);
                }
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                if(completion){
                    completion(nil,error);
                }
            }];
        }
            break;
            
        default:
            break;
    }
}

@end
