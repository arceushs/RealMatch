//
//  RMFetchDetailModel.m
//  realMatch-OC
//
//  Created by yxlyxlyxl on 2019/6/17.
//  Copyright © 2019 qingting. All rights reserved.
//

#import "RMFetchVideoDetailModel.h"

@implementation RMFetchVideoImageDetailModel

-(instancetype)init{
    if(self = [super init]){
        self.width = 0;
        self.height = 0;
        self.name = @"";
        self.extension = @"";
        self.ossLocation = @"";
        self.uploadId = -1;
    }
    return self;
}

-(void)parseFromDict:(NSDictionary *)dict{
    self.width = [dict[@"width"] doubleValue];
    self.height = [dict[@"height"] doubleValue];
    self.name = dict[@"name"];
    self.extension = dict[@"extension"];
    self.ossLocation = dict[@"ossLocation"];
    self.uploadId = [dict[@"uploadId"] integerValue];
}

-(void)parseFromArr:(NSArray *)arr{
    
}



@end

@implementation RMFetchVideoDetailModel

-(instancetype)init{
    if(self = [super init]){
        self.title = @"";
        self.subtitle = @"";
        self.name = @"";
        self.extension = @"";
        self.ossLocation = @"";
        self.rowHeight = (UIScreen.mainScreen.bounds.size.width - 16)*466.0/359.0 + 66;
        self.previewVideoImage = [UIImage new];
    }
    return self;
}

-(void)parseFromDict:(NSDictionary *)dict{
    self.title = dict[@"title"];
    self.subtitle = dict[@"subTitle"];
    self.name = dict[@"name"];
    self.extension = dict[@"extension"];
    self.ossLocation = dict[@"ossLocation"];
    self.videoImg = [[RMFetchVideoImageDetailModel alloc]init];
    [self.videoImg parseFromDict:dict[@"videoImg"]];
    self.rowHeight = (UIScreen.mainScreen.bounds.size.width - 16)*466.0/359.0 + 66;
}

-(void)parseFromArr:(NSArray *)arr{
    
}

@end
