//
//  MessageFromMeTableViewCell.h
//  realMatch-OC
//
//  Created by yxlyxlyxl on 2019/7/5.
//  Copyright © 2019 qingting. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface RMMessageFromMeTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *avatarImageView;
@property (weak, nonatomic) IBOutlet UILabel *LabelContent;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentHeightStraint;

@end

NS_ASSUME_NONNULL_END
