//
//  UIDevice+RealMatch.h
//  realMatch-OC
//
//  Created by yxl on 2019/6/5.
//  Copyright © 2019 qingting. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@interface UIDevice (RealMatch)

+(CGFloat)safeTopHeight;

+(CGFloat)safeBottomHeight;

+(BOOL)isIPhoneXSeries;
@end

NS_ASSUME_NONNULL_END
