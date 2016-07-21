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

@interface WeChatTableViewCell ()
@property (weak, nonatomic) IBOutlet UIImageView *headImage;
@property (weak, nonatomic) IBOutlet UILabel *timeLable;
@property (weak, nonatomic) IBOutlet UILabel *nameLable;
@property (weak, nonatomic) IBOutlet UILabel *messageLabel;

@end

@implementation WeChatTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setModel:(WeChatListModel *)model{
    
    _model = model;
    self.messageLabel.text = model.message;
    [self.headImage sd_setImageWithURL:[NSURL URLWithString:model.imageUrl]];
    self.nameLable.text = model.name;
    self.timeLable.text = model.time;
}

@end
