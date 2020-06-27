//
//  RMNetworkManager.m
//  realMatch-OC
//
//  Created by yxlyxlyxl on 2019/6/14.
//  Copyright © 2019 qingting. All rights reserved.
//

#import "RMNetworkManager.h"
#import "RMFileManager.h"
#import <CoreLocation/CoreLocation.h>

@interface RMNetworkManager()<CLLocationManagerDelegate>

@end

@implementation RMNetworkManager
{
    AFHTTPSessionManager * _afmanager;
    CLLocationManager * _locationManager;
}
+(instancetype)shareManager{
    static dispatch_once_t onceToken;
    static RMNetworkManager* manager = nil;
    dispatch_once(&onceToken, ^{
        if(manager == nil){
            manager = [[RMNetworkManager alloc]init];
            [manager locationManager];
            
        }
    });
    return manager;
}

- (void)locationManager{
    CLLocationManager *_locationManager = [[CLLocationManager alloc] init];
    // 设置代理
    _locationManager.delegate = self;
    // 设置定位精确度到米
    _locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    // 设置过滤器为无
    _locationManager.distanceFilter = kCLDistanceFilterNone;
    // 取得定位权限，有两个方法，取决于你的定位使用情况
    // 一个是requestAlwaysAuthorization，一个是requestWhenInUseAuthorization
    // 这句话ios8以上版本使用。
    self->_locationManager = _locationManager;
    [_locationManager requestWhenInUseAuthorization];
    [_locationManager requestAlwaysAuthorization];
    // 开始定位
    [_locationManager startUpdatingLocation];
    
    
}

-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations{
    // 获取当前所在的城市名
        CLGeocoder *geocoder = [[CLGeocoder alloc] init];
        //根据经纬度反向地理编译出地址信息
        [geocoder reverseGeocodeLocation:locations.firstObject completionHandler:^(NSArray *array, NSError *error){
            if (array.count > 0){
                CLPlacemark *placemark = [array objectAtIndex:0];
                //获取当前城市
                NSString *city = placemark.locality;
                if (!city) {
                    //注意：四大直辖市的城市信息无法通过locality获得，只能通过获取省份的方法来获得（如果city为空，则可知为直辖市）
                    city = placemark.administrativeArea;
                }
                NSMutableDictionary *dic = [NSMutableDictionary new];
                [dic setValue:city forKey:@"city"];
                [dic setValue:@(locations.firstObject.coordinate.longitude) forKey:@"longtitude"];
                [dic setValue:@(locations.firstObject.coordinate.latitude) forKey:@"latitude"];
                [[NSUserDefaults standardUserDefaults] setObject:dic forKey:@"cityName"];
                [[NSUserDefaults standardUserDefaults] synchronize];
            }
            else if (error == nil && [array count] == 0) {
                NSLog(@"没有结果返回.");
            }
            else if (error != nil)  {
                //NSLog(@"An error occurred = %@", error);
            }
            [self->_locationManager stopUpdatingLocation];
        }];

}



-(void)request:(id<RMNetworkAPI>)api completion:(ReponseBlock)completion{
    NSDictionary *locationDict = [[NSUserDefaults standardUserDefaults] objectForKey:@"cityName"];
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    NSDictionary* apiParam = [api parameters];
    [parameters addEntriesFromDictionary:apiParam];
    if([locationDict isKindOfClass: [NSDictionary class]]) {
        [parameters setValue:locationDict[@"latitude"] forKey:@"latitude"];
        [parameters setValue:locationDict[@"longtitude"] forKey:@"longtitude"];
        [parameters setValue:locationDict[@"city"] forKey:@"city"];
    }
    
    NSString* host = [api requestHost];
    NSString* path = [api requestPath];
    NSString* url = [NSString stringWithFormat:@"%@%@",host,path];
    RMHttpMethod method = [api method];
    RMTaskType taskType = [api taskType];
    
    _afmanager = [AFHTTPSessionManager manager];
    
    AFHTTPRequestSerializer *requestSerialization = [AFHTTPRequestSerializer serializer];
    // 设置自动管理Cookies
    requestSerialization.HTTPShouldHandleCookies = YES;
    NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:@"global-token"];
    if (token != nil) {
        [requestSerialization setValue:token forHTTPHeaderField:@"token"];
        [requestSerialization setValue:locationDict[@"latitude"] forHTTPHeaderField:@"latitude"];
        [requestSerialization setValue:locationDict[@"longtitude"] forHTTPHeaderField:@"longtitude"];
        [requestSerialization setValue:locationDict[@"city"] forHTTPHeaderField:@"city"];
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
                    
                    if ([mimetype containsString:@"video"]) {
                        UIImage* image = [RMFileManager getVideoPreViewImage:[NSURL fileURLWithPath:fileString]];
                        NSData* imageData = UIImagePNGRepresentation(image);
                        /* 上传数据拼接 */
                        if([filename length]>0 && [filePath length]>0 && [mimetype length]>0){
                            //这种代码最好是归到api的protocol中。
                            [formData appendPartWithFileData:fileData name:@"video" fileName:filename mimeType:mimetype];
                            [formData appendPartWithFileData:imageData name:@"videoImg" fileName:filename mimeType:@"image/png"];
                        }
                    } else if ([mimetype containsString:@"image"]) {
                        if([filename length]>0 && [filePath length]>0 && [mimetype length]>0){
                            //这种代码最好是归到api的protocol中。
                
                           [formData appendPartWithFileData:fileData name:@"file" fileName:filename mimeType:@"image/png"];
                        }
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
                    if([api respondsToSelector:@selector(adoptResponse:)]){
                        response = [api adoptResponse:response];
                    }
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
                    RMNetworkResponse* response = [[RMNetworkResponse alloc]initWithResponseObject:responseObject];

                    if([api respondsToSelector:@selector(adoptResponse:)]){
                        response = [api adoptResponse:response];
                    }
                    if(completion){
                        completion(response);
                    }
                } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                    RMNetworkResponse* response = [[RMNetworkResponse alloc]initWithError:error];
                    if([api respondsToSelector:@selector(adoptResponse:)]){
                        response = [api adoptResponse:response];
                    }
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
        
                RMNetworkResponse* response = [[RMNetworkResponse alloc]initWithResponseObject:responseObject];
                if([api respondsToSelector:@selector(adoptResponse:)]){
                    response = [api adoptResponse:response];
                }
                if(completion){
                    completion(response);
                }
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                RMNetworkResponse* response = [[RMNetworkResponse alloc]initWithError:error];
                if([api respondsToSelector:@selector(adoptResponse:)]){
                    response = [api adoptResponse:response];
                }
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
