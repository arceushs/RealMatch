//
//  RMHomeCardView.h
//  realMatch-OC
//
//  Created by yxl on 2019/6/10.
//  Copyright © 2019 qingting. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
NS_ASSUME_NONNULL_BEGIN

@interface RMHomeCardView : UIView
@property (weak, nonatomic) IBOutlet UIView *blackView;
@property (weak, nonatomic) IBOutlet UIImageView *bottomImageView;
@property (weak, nonatomic) IBOutlet UIImageView *detailImageView;
@property (strong, nonatomic) void(^routeToDetailBlock)(void);


@property (nonatomic,strong) CAGradientLayer* blacklayer;
@property (nonatomic,strong) AVPlayerLayer * playerLayer;

-(void)setVideoLayerWithPlayer:(AVPlayer*)player;

@end

NS_ASSUME_NONNULL_END
