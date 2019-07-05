//
//  RMMessageDetailModel.m
//  realMatch-OC
//
//  Created by yxlyxlyxl on 2019/7/5.
//  Copyright © 2019 qingting. All rights reserved.
//

#import "RMMessageDetailModel.h"

@implementation RMMessageDetailModel

-(void)setText:(NSString *)text{
    _text = text;
    CGSize size = [text boundingRectWithSize:CGSizeMake(181, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:16]} context:nil].size;
    self.rowHeight = size.height + 26 + 8 + 8;
}

@end
