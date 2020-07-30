//
//  NetworkAPIHost.m
//  realMatch-OC
//
//  Created by arceushs on 2019/6/23.
//  Copyright © 2019 qingting. All rights reserved.
//

#import "RMNetworkAPIHost.h"

@implementation RMNetworkAPIHost

+(NSString *)apiHost{
#ifdef DEBUG
    return @"https://www.4match.wang";
#else
    return @"https://www.4match.top";
#endif
}

+(NSString *)apiPath{
    return @"/api";
//#ifdef DEBUG
//    return @"/api/test";
//#else
//    BOOL currentEnviroment = [[NSUserDefaults standardUserDefaults] boolForKey:@"testEnviroment"];
//    BOOL xcodeEnviroment = [[[[NSProcessInfo processInfo] environment] objectForKey:@"testEnviroment"] boolValue];
//    if(!currentEnviroment && !xcodeEnviroment) {
//        return @"/api";
//    }else{
//        return @"/api/test";
//    }
//#endif
}

@end
