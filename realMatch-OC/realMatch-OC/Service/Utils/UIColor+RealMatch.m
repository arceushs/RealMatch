//
//  UIColor+RealMatch.m
//  realMatch-OC
//
//  Created by yxl on 2019/6/6.
//  Copyright © 2019 qingting. All rights reserved.
//

#import "UIColor+RealMatch.h"

@implementation UIColor (RealMatch)

+(instancetype)colorWithString:(NSString*)string alpha:(CGFloat)alpha{
    if([string length] == 6){
        unsigned int red = 0;
        NSString* redStr = [string substringWithRange:NSMakeRange(0, 2)];
        [[NSScanner scannerWithString:redStr] scanHexInt:&red];
        NSString* greenStr = [string substringWithRange:NSMakeRange(2, 2)];
        unsigned int green = 0;
        [[NSScanner scannerWithString:greenStr] scanHexInt:&green];
        NSString* blueStr = [string substringWithRange:NSMakeRange(4, 2)];
        unsigned int blue = 0;
        [[NSScanner scannerWithString:blueStr] scanHexInt:&blue];
        
        return [UIColor colorWithRed:red/255.0 green:green/255.0 blue:blue/255.0 alpha:alpha];
    }
    return nil;
}

+(instancetype)colorWithString:(NSString*)string{
    if([string length] == 6){
        return [self colorWithString:string alpha:1.0];
    }
    return nil;
}

@end
