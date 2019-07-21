//
//  RMHomeCardView.m
//  realMatch-OC
//
//  Created by yxl on 2019/6/10.
//  Copyright © 2019 qingting. All rights reserved.
//

#import "RMHomeCardView.h"
#import "UIColor+RealMatch.h"
#import "UIView+RealMatch.h"
@interface RMHomeCardView ()

@end

@implementation RMHomeCardView

-(instancetype)initWithFrame:(CGRect)frame{
    if(self = [super initWithFrame:frame]){
        self = [[[NSBundle mainBundle]loadNibNamed:@"RMHomeCardView" owner:self options:nil] lastObject];
    }
    return  self;
}

-(void)awakeFromNib{
    [super awakeFromNib];
    
    self.blacklayer = [CAGradientLayer layer];
    _blacklayer.startPoint = CGPointMake(0, 0);
    _blacklayer.endPoint = CGPointMake(0, 1);
    self.blacklayer.cornerRadius = 4;
    self.blacklayer.masksToBounds = YES;
    _blacklayer.colors = @[(__bridge id)[UIColor colorWithString:@"000000" alpha:0].CGColor,(__bridge id)[UIColor colorWithString:@"000000" alpha:0.6].CGColor];
    [self.blackView.layer insertSublayer:_blacklayer atIndex:0];
    
    UITapGestureRecognizer * tapGest = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(routeToDetail:)];
    self.detailImageView.userInteractionEnabled = YES;
    [self.detailImageView addGestureRecognizer:tapGest];
}

-(void)routeToDetail:(UITapGestureRecognizer*)tap{
    if(self.routeToDetailBlock){
        self.routeToDetailBlock();
    }
}

-(void)setVideoLayerWithPlayer:(AVPlayer*)player{
    self.playerLayer = [AVPlayerLayer playerLayerWithPlayer:player];
    [self.bottomImageView.layer insertSublayer:self.playerLayer atIndex:0];
}

-(void)layoutSubviews{
    self.blackView.width = self.width;
    self.blacklayer.frame = self.blackView.bounds;
    self.playerLayer.frame = self.bounds;
//    self.playerLayer.
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
