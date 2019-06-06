//
//  UIColor+RealMatch.h
//  realMatch-OC
//
//  Created by yxl on 2019/6/6.
//  Copyright © 2019 qingting. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIColor (RealMatch)

+(instancetype)colorWithString:(NSString*)string;
+(instancetype)colorWithString:(NSString*)string alpha:(CGFloat)alpha;
@end

NS_ASSUME_NONNULL_END
