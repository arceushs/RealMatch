//
//  RMFetchDetailModel.m
//  realMatch-OC
//
//  Created by yxlyxlyxl on 2019/6/17.
//  Copyright © 2019 qingting. All rights reserved.
//

#import "RMFetchDetailModel.h"

@implementation RMFetchDetailModel

-(instancetype)init{
    if(self = [super init]){
        self.title = @"";
        self.subtitle = @"";
        self.name = @"";
        self.extension = @"";
        self.ossLocation = @"";
        self.videoImg = @"";
        self.rowHeight = 0;
    }
    return self;
}

-(void)parseFromDict:(NSDictionary *)dict{
    self.title = dict[@"title"];
    if([self.title length]<=0){
        self.title = @"About me";
    }
    
    self.subtitle = dict[@"subtitle"];
    if([self.subtitle length]<=0){
        self.subtitle = @"who are you, where are you from, yuor school, your job.";
    }
    self.name = dict[@"name"];
    self.extension = dict[@"extension"];
    self.ossLocation = dict[@"ossLocation"];
    self.videoImg = dict[@"videoImg"];
    self.rowHeight = (UIScreen.mainScreen.bounds.size.width - 16)*466.0/359.0 + 66;
}

-(void)parseFromArr:(NSArray *)arr{
    
}

@end
