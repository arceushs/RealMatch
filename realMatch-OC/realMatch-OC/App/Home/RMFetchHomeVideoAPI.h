//
//  RMFetchHomeVideoAPI.h
//  realMatch-OC
//
//  Created by arceushs on 2019/7/20.
//  Copyright © 2019 qingting. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RMNetworkManager.h"
#import <UIKit/UIKit.h>
NS_ASSUME_NONNULL_BEGIN


@interface RMFetchHomeVideoAPIModel : NSObject

@property (nonatomic,strong) NSString* userId;
@property (nonatomic,strong) NSString* name;
@property (nonatomic,assign) NSInteger age;
@property (nonatomic,assign) NSInteger sex;
@property (nonatomic,copy) NSString* country;
@property (nonatomic,strong) NSString* videoDefaultImg;
@property (nonatomic,strong) NSString* video;
@property (nonatomic,assign) CGFloat height;
@property (nonatomic,assign) CGFloat width;
@property (nonatomic,assign) BOOL userIsVip;

@end

@interface RMFetchHomeVideoAPIData : NSObject

@property (nonatomic,strong) RMFetchHomeVideoAPIModel* currentModel;
@property (nonatomic,strong) NSMutableArray<RMFetchHomeVideoAPIModel*>* listArr;

@end

@interface RMFetchHomeVideoAPI :  NSObject<RMNetworkAPI>
-(instancetype)initWithUserId:(NSString*)userId;

-(instancetype)initWithUserId:(NSString*)userId count:(NSInteger)count;

@end
NS_ASSUME_NONNULL_END
