//
//  RMFileManager.m
//  realMatch-OC
//
//  Created by yxl on 2019/6/6.
//  Copyright © 2019 qingting. All rights reserved.
//

#import "RMFileManager.h"

@implementation RMFileManager


+(NSString*)pathForSaveRecord{
    NSFileManager* fm = [NSFileManager defaultManager];
    
    NSString* recordPath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject] stringByAppendingPathComponent:@"Records"];
    BOOL isDir = NO;
    BOOL existed = [fm fileExistsAtPath:recordPath isDirectory:&isDir];
    if(!(isDir == YES && existed == YES)){
        [fm createDirectoryAtPath:recordPath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    
    return recordPath;
}

+(NSString*)pathForSavePreload{
    NSFileManager* fm = [NSFileManager defaultManager];
    
    NSString* recordPath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject] stringByAppendingPathComponent:@"Preload"];
    BOOL isDir = NO;
    BOOL existed = [fm fileExistsAtPath:recordPath isDirectory:&isDir];
    if(!(isDir == YES && existed == YES)){
        [fm createDirectoryAtPath:recordPath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    
    return recordPath;
}

+(BOOL)removePreloadMp4:(NSString*)name{
    NSFileManager* fm = [NSFileManager defaultManager];
    NSString* recordPath = [NSString stringWithFormat:@"%@/%@",[self pathForSavePreload],name];
    NSError* error = nil;
    return [fm removeItemAtPath:recordPath error:&error];
}

#pragma mark - 第一帧
+(UIImage*)getVideoPreViewImage:(NSURL*)path{
    AVURLAsset * asset = [[AVURLAsset alloc]initWithURL:path options:nil];
    AVAssetImageGenerator * assetGen = [[AVAssetImageGenerator alloc]initWithAsset:asset];
    assetGen.appliesPreferredTrackTransform = YES;
    
    CMTime time = CMTimeMakeWithSeconds(0.0, 600);
    NSError* error = nil;
    CMTime actualTime;
    CGImageRef image = [assetGen copyCGImageAtTime:time actualTime:&actualTime error:&error];
    UIImage* videoImage = [[UIImage alloc]initWithCGImage:image];
    CGImageRelease(image);
    CGFloat width = videoImage.size.width > videoImage.size.height ? videoImage.size.width : videoImage.size.height;
    videoImage = [self cutCenterImageSize:CGSizeMake(width, width) iMg:videoImage];
    return videoImage;
}

//传入size记得屏幕的1x的size

+ (UIImage *)cutCenterImageSize:(CGSize)size iMg:(UIImage *)img {
    CGFloat scale = [UIScreen mainScreen].scale;
    size.width = size.width*scale;
    size.height = size.height *scale;
    CGSize imageSize = img.size;
    CGRect rect;
    //根据图片的大小计算出图片中间矩形区域的位置与大小
    if (imageSize.width > imageSize.height) {
        float leftMargin = (imageSize.width - imageSize.height) *0.5;
        rect = CGRectMake(leftMargin,0, imageSize.height, imageSize.height);
    }else{
        float topMargin = (imageSize.height - imageSize.width) *0.5;
        rect = CGRectMake(0, topMargin, imageSize.width, imageSize.width);
    }
    CGImageRef imageRef = img.CGImage;

    //截取中间区域矩形图片
    CGImageRef imageRefRect = CGImageCreateWithImageInRect(imageRef, rect);
    UIImage *tmp = [[UIImage alloc] initWithCGImage:imageRefRect];

    CGImageRelease(imageRefRect);
    UIGraphicsBeginImageContext(size);
    CGRect rectDraw =CGRectMake(0,0, size.width, size.height);
    [tmp drawInRect:rectDraw];

    // 从当前context中创建一个改变大小后的图片

    tmp = UIGraphicsGetImageFromCurrentImageContext();
    // 使当前的context出堆栈
    UIGraphicsEndImageContext();

    NSLog(@"tmp sizewidth is %f sizeHeight is %f",tmp.size.width,tmp.size.height);

    return tmp;
}
@end
