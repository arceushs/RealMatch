//
//  UIDevice+RealMatch.m
//  realMatch-OC
//
//  Created by yxl on 2019/6/5.
//  Copyright © 2019 qingting. All rights reserved.
//

#import "UIDevice+RealMatch.h"

@implementation UIDevice (RealMatch)
+(BOOL)isIPhoneXSeries{
    if (@available(iOS 11.0, *)) {
        UIWindow *keyWindow = [[[UIApplication sharedApplication] delegate] window];
        // 获取底部安全区域高度，iPhone X 竖屏下为 34.0，横屏下为 21.0，其他类型设备都为 0
        CGFloat bottomSafeInset = keyWindow.safeAreaInsets.bottom;
        if (bottomSafeInset == 34.0f || bottomSafeInset == 21.0f) {
            return YES;
        }
    }
    return NO;
}

+(CGFloat)safeTopHeight{
    if (@available(iOS 11.0, *)) {
        UIWindow *keyWindow = [[[UIApplication sharedApplication] delegate] window];
        
        return keyWindow.safeAreaInsets.top;
    }
    return 0;
}

+(CGFloat)safeBottomHeight{
    if (@available(iOS 11.0, *)) {
        UIWindow *keyWindow = [[[UIApplication sharedApplication] delegate] window];
        
        return keyWindow.safeAreaInsets.bottom;
    }
    return 0;
}
@end
