//
//  RMBaseModel.h
//  realMatch-OC
//
//  Created by yxlyxlyxl on 2019/6/17.
//  Copyright © 2019 qingting. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface RMBaseModel : NSObject

-(void)parseFromDict:(NSDictionary*)dict;
-(void)parseFromArr:(NSArray*)arr;

@end

NS_ASSUME_NONNULL_END
