//
//  RMFileManager.h
//  realMatch-OC
//
//  Created by yxl on 2019/6/6.
//  Copyright © 2019 qingting. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import <UIKit/UIKit.h>
NS_ASSUME_NONNULL_BEGIN

@interface RMFileManager : NSObject

+(NSString*)pathForSaveRecord;
+(NSString*)pathForSavePreload;
+(UIImage*)getVideoPreViewImage:(NSURL*)path;
+(BOOL)removePreloadMp4:(NSString*)name;

@end

NS_ASSUME_NONNULL_END
