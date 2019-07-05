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
    
    _afmanager = [AFHTTPSessionManager manager];
    _afmanager.responseSerializer = [AFHTTPResponseSerializer serializer];
    _afmanager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript", @"text/html",@"text/plain", nil];
    
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
            
        default:{
            [_afmanager POST:url parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
                NSString *filePath = [[NSBundle mainBundle] pathForResource:@"test1.png" ofType:@""];
                /* 本地图片上传 */
                NSURL *imageUrl = [NSURL fileURLWithPath:filePath];
                NSData *imageData = [NSData dataWithContentsOfURL:imageUrl];
                
                // 直接将图片对象转成 data 也可以
                // UIImage *image = [UIImage imageNamed:@"test"];
                // NSData *imageData = UIImageJPEGRepresentation(image, 1.0);
                
                /* 上传数据拼接 */
                [formData appendPartWithFileData:imageData name:@"test1" fileName:@"test1.png" mimeType:@"image/png"];
//                [formData appendPartWithFileData:imageData name:@"file" fileName:@"test" mimeType:@"video/mp
                
            } progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                
                NSLog(@"上传成功：%@", responseObject);
                
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                
                NSLog(@"上传失败：%@", error);
            }];
        }
            break;
    }
}

@end
