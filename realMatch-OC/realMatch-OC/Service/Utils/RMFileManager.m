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
    return videoImage;
}

@end
