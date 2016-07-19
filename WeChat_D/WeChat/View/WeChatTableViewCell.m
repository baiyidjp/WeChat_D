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
    //取出最近的消息
    NSMutableArray *array = [[NSUserDefaults standardUserDefaults]objectForKey:@"message"];
    NSArray *arr = [MessageModel mj_objectArrayWithKeyValuesArray:array];
    if (array.count) {
        MessageModel *messageModel = [arr objectAtIndex:arr.count-1];
        switch (messageModel.messageType) {
            case MessageType_Text:
                self.messageLabel.attributedText = [PublicMethod emojiWithText:messageModel.messagetext];
                break;
            case MessageType_Voice:
                self.messageLabel.text = @"[语音消息]";
                break;
            case MessageType_Picture:
                self.messageLabel.text = @"[图片]";
                break;
            default:
                break;
        }
        
    }else{
        self.messageLabel.text = model.message;
    }
    [self.headImage sd_setImageWithURL:[NSURL URLWithString:model.imageUrl]];
    self.nameLable.text = model.name;
    self.timeLable.text = model.time;
}

@end
