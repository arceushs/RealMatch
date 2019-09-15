//
//  RMFetchDetailAPI.h
//  realMatch-OC
//
//  Created by yxlyxlyxl on 2019/6/17.
//  Copyright © 2019 qingting. All rights reserved.
//
#import "RMNetworkManager.h"
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "RMFetchVideoDetailModel.h"
NS_ASSUME_NONNULL_BEGIN
@interface RMFetchDetailAPIData : NSObject

@property (nonatomic,strong) NSArray<RMFetchVideoDetailModel*>* videoArr;
@property (nonatomic,strong) NSString* videoDefaultImg;
@property (nonatomic,strong) NSString* name;
@property (nonatomic,strong) NSString* phone;
@property (nonatomic,strong) NSString* email;
@property (nonatomic,assign) int sex;
@property (nonatomic,assign) int age;
@property (nonatomic,strong) NSString* area;
@property (nonatomic,strong) NSString* avatar;
@property (nonatomic,assign) CGFloat height;
@property (nonatomic,assign) CGFloat width;

@end


@interface RMFetchDetailAPI : NSObject<RMNetworkAPI>

-(instancetype)initWithUserId:(NSString*)userId;

@end

NS_ASSUME_NONNULL_END
