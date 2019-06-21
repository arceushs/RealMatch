//
//  RMNetworkResponse.m
//  realMatch-OC
//
//  Created by yxlyxlyxl on 2019/6/17.
//  Copyright © 2019 qingting. All rights reserved.
//

#import "RMNetworkResponse.h"

@interface RMNetworkResponse()

@property (nonatomic,strong,readwrite) id responseObject;

@end

@implementation RMNetworkResponse
-(instancetype)initWithResponseObject:(id)object{
    if(self = [super init]){
        self.responseObject = object;
    }
    return self;
}
@end
