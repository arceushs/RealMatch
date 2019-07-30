//
//  RMNetworkManager.m
//  realMatch-OC
//
//  Created by yxlyxlyxl on 2019/6/14.
//  Copyright © 2019 qingting. All rights reserved.
//

#import "RMNetworkManager.h"
#import "AFNetworking.h"
#import "RMFileManager.h"

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
    RMTaskType taskType = [api taskType];
    
    _afmanager = [AFHTTPSessionManager manager];
    
    AFHTTPRequestSerializer *requestSerialization = [AFHTTPRequestSerializer serializer];
    // 设置自动管理Cookies
    requestSerialization.HTTPShouldHandleCookies = YES;
    NSString *cookie = [[NSUserDefaults standardUserDefaults] objectForKey:@"global-cookie"];
    if (cookie != nil) {
        [requestSerialization setValue:cookie forHTTPHeaderField:@"token"];
    }
    _afmanager.requestSerializer = requestSerialization;
    _afmanager.responseSerializer = [AFJSONResponseSerializer serializer];
    _afmanager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript", nil];
    switch (method) {
        
        case RMHttpMethodPost:{
            if(taskType == RMTaskTypeUpload){
                [_afmanager POST:url parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
                    NSString *filePath = [parameters objectForKey:@"filepath"];
                    NSString *filename = [parameters objectForKey:@"filename"];
                    NSString* mimetype = [parameters objectForKey:@"mimetype"];
                    /* 本地文件上传 */
                    NSString* fileString = filePath;
                    NSData *fileData = [NSData dataWithContentsOfFile:fileString];
                    
                    /* 上传数据拼接 */
                    if([filename length]>0 && [filePath length]>0 && [mimetype length]>0){
                        [formData appendPartWithFileData:fileData name:@"file" fileName:filename mimeType:mimetype];
                    }
                } progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                    RMNetworkResponse* response = [[RMNetworkResponse alloc]initWithResponseObject:responseObject];
                    if([api respondsToSelector:@selector(adoptResponse:)]){
                        response = [api adoptResponse:response];
                    }
                    if(completion){
                        completion(response);
                    }

                } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                    RMNetworkResponse* response = [[RMNetworkResponse alloc]initWithError:error];
                    if(completion){
                        completion(response);
                    }
                    NSLog(@"%@",error);
                }];

            }else if(taskType == RMTaskTypeData){
                NSMutableDictionary* params = [NSMutableDictionary dictionaryWithDictionary:parameters];
                [params removeObjectForKey:@"filepath"];
                [params removeObjectForKey:@"filename"];
                [params removeObjectForKey:@"mimetype"];
                [_afmanager POST:url parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                    NSDictionary *allHeaderFieldsDic = ((NSHTTPURLResponse* )task.response).allHeaderFields;
                    NSString *setCookie = allHeaderFieldsDic[@"Set-Cookie"];
                    RMNetworkResponse* response = [[RMNetworkResponse alloc]initWithResponseObject:responseObject];
                    if (setCookie != nil) {
                        NSString *cookie = [[[[setCookie componentsSeparatedByString:@";"] objectAtIndex:0] componentsSeparatedByString:@"="] objectAtIndex:1];
                        // 这里对cookie进行存储
                        [response setCookie:cookie];
                    }
                    if([api respondsToSelector:@selector(adoptResponse:)]){
                        response = [api adoptResponse:response];
                    }
                    if(completion){
                        completion(response);
                    }
                } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                    RMNetworkResponse* response = [[RMNetworkResponse alloc]initWithError:error];
                    if(completion){
                        completion(response);
                    }
                    
                }];

            }else if(taskType == RMTaskTypeDownload){
                
            }
        }
            break;
        
        case RMHttpMethodGet:{
            NSMutableDictionary* params = [NSMutableDictionary dictionaryWithDictionary:parameters];
            [params removeObjectForKey:@"filepath"];
            [params removeObjectForKey:@"filename"];
            [params removeObjectForKey:@"mimetype"];
            [_afmanager GET:url parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                NSDictionary *allHeaderFieldsDic = ((NSHTTPURLResponse* )task.response).allHeaderFields;
                NSString *setCookie = allHeaderFieldsDic[@"Set-Cookie"];
                RMNetworkResponse* response = [[RMNetworkResponse alloc]initWithResponseObject:responseObject];
                if (setCookie != nil) {
                    NSString *cookie = [[[[setCookie componentsSeparatedByString:@";"] objectAtIndex:0] componentsSeparatedByString:@"="] objectAtIndex:1];
                    // 这里对cookie进行存储
                    [response setCookie:cookie];
                }
                if([api respondsToSelector:@selector(adoptResponse:)]){
                    response = [api adoptResponse:response];
                }
                if(completion){
                    completion(response);
                }
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                RMNetworkResponse* response = [[RMNetworkResponse alloc]initWithError:error];
                if(completion){
                    completion(response);
                }
                
            }];
        }
            break;
        default:{
            
        }
            break;
    }
}

@end
