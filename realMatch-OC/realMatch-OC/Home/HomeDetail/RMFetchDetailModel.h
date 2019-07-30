//
//  RMFetchDetailModel.h
//  realMatch-OC
//
//  Created by yxlyxlyxl on 2019/6/17.
//  Copyright © 2019 qingting. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RMBaseModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface RMFetchDetailModel : RMBaseModel

@property (nonatomic,strong) NSString* title;
@property (nonatomic,strong) NSString* videoImg;
@property (nonatomic,strong) NSString* name;
@property (nonatomic,strong) NSString* extension;
@property (nonatomic,strong) NSString* ossLocation;



@end

NS_ASSUME_NONNULL_END
