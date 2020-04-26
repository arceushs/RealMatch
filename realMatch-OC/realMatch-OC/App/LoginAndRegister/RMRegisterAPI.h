//
//  RMRegisterAPI.h
//  realMatch-OC
//
//  Created by yxlyxlyxl on 2019/7/8.
//  Copyright © 2019 qingting. All rights reserved.
//
#import "RMNetworkManager.h"
#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
@interface RMRegisterAPIData : NSObject
@property (nonatomic,assign) BOOL result;
@property (nonatomic,assign) NSString * appToken;
@end

@interface RMRegisterAPI : NSObject<RMNetworkAPI>

-(instancetype)initWithName:(NSString*)name birth:(NSString*)birth sex:(int)sex userId:(NSString*)userId avatar:(UIImage *)avatar;
 
@end

NS_ASSUME_NONNULL_END
