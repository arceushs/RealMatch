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

@end
