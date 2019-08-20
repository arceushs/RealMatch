//
//  UIView+RealMatch.m
//  realMatch-OC
//
//  Created by yxl on 2019/6/4.
//  Copyright © 2019 qingting. All rights reserved.
//

#import "UIView+RealMatch.h"

@implementation UIView (RealMatch)

-(void)setWidth:(CGFloat)width{
    CGRect frame = self.frame;
    frame.size.width = width;
    self.frame = frame;
}

-(CGFloat)width{
    return self.frame.size.width;
}

-(void)setHeight:(CGFloat)height{
    CGRect frame = self.frame;
    frame.size.height = height;
    self.frame = frame;
}

-(CGFloat)height{
    return self.frame.size.height;
}

@end
