//
//  RMFetchDetailModel.m
//  realMatch-OC
//
//  Created by yxlyxlyxl on 2019/6/17.
//  Copyright © 2019 qingting. All rights reserved.
//

#import "RMFetchDetailModel.h"

@implementation RMFetchDetailModel

-(void)parseFromDict:(NSDictionary *)dict{
    self.title = dict[@"title"];
    self.name = dict[@"name"];
    self.extension = dict[@"extension"];
    self.ossLocation = dict[@"ossLocation"];
    self.videoImg = dict[@"videoImg"];
}

-(void)parseFromArr:(NSArray *)arr{
    
}

@end
