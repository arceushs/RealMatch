//
//  RMMessageDetailModel.h
//  realMatch-OC
//
//  Created by yxlyxlyxl on 2019/7/5.
//  Copyright © 2019 qingting. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger,MessageFrom){
    MessageFromMe,
    MessageFromOther,
};

NS_ASSUME_NONNULL_BEGIN

@interface RMMessageDetailModel : NSObject

@property (nonatomic,strong) NSString* text;
@property (nonatomic,assign) MessageFrom messageFrom;
@property (nonatomic,assign) CGFloat rowHeight;

@end

NS_ASSUME_NONNULL_END
