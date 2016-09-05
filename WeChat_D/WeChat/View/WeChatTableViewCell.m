//
//  WeChatTableViewCell.m
//  WeChat_D
//
//  Created by tztddong on 16/7/15.
//  Copyright © 2016年 dongjiangpeng. All rights reserved.
//

#import "WeChatTableViewCell.h"
#import "WeChatListModel.h"
#import "MessageModel.h"
#import "UIImage+Round.h"

@interface WeChatTableViewCell ()
@property (weak, nonatomic) IBOutlet UIImageView *headImage;
@property (weak, nonatomic) IBOutlet UILabel *timeLable;
@property (weak, nonatomic) IBOutlet UILabel *nameLable;
@property (weak, nonatomic) IBOutlet UILabel *messageLabel;
@property (weak, nonatomic) IBOutlet UILabel *unreadCount;

@end

@implementation WeChatTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.unreadCount.layer.cornerRadius = 10;
    self.unreadCount.layer.masksToBounds = YES;
    [self.headImage setContentScaleFactor:[[UIScreen mainScreen] scale]];
    self.headImage.contentMode =  UIViewContentModeScaleAspectFill;
    self.headImage.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    self.headImage.clipsToBounds  = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setModel:(WeChatListModel *)model{
    
    _model = model;
    self.messageLabel.text = model.message;
//    [self.headImage sd_setImageWithURL:[NSURL URLWithString:model.imageUrl] placeholderImage:[UIImage imageNamed:DefaultHeadImageName_Message]];
    [self.headImage layoutIfNeeded];
    self.headImage.image = [[UIImage imageNamed:DefaultHeadImageName_Message] imageWithCornerRadius:self.headImage.frame.size.width/2 size:self.headImage.frame.size];
    [[SDWebImageManager sharedManager] downloadImageWithURL:[NSURL URLWithString:model.imageUrl] options:SDWebImageRetryFailed progress:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
        if (image) {
            self.headImage.image = [image imageWithCornerRadius:self.headImage.frame.size.width/2 size:self.headImage.frame.size];
        }
    }];
    self.nameLable.text = model.name;
    self.timeLable.text = model.time;
    if (model.unreadMessagesCount) {
        self.unreadCount.hidden = NO;
        self.unreadCount.text = [NSString stringWithFormat:@"%zd",model.unreadMessagesCount];
        if (model.unreadMessagesCount > 99) {
            self.unreadCount.text = @"99+";
        }
    }else{
        self.unreadCount.text = [NSString stringWithFormat:@"%zd",model.unreadMessagesCount];
        self.unreadCount.hidden = YES;
    }
}

@end
