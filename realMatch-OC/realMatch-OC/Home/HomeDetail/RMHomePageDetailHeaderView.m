//
//  RMHomePageDetailHeaderView.m
//  realMatch-OC
//
//  Created by yxlyxlyxl on 2019/6/19.
//  Copyright © 2019 qingting. All rights reserved.
//

#import "RMHomePageDetailHeaderView.h"

@implementation RMHomePageDetailHeaderView

-(instancetype)init{
    if(self = [super init]){
        self = [[[NSBundle mainBundle]loadNibNamed:@"RMHomePageDetailHeaderView" owner:nil options:nil] lastObject];
        
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
