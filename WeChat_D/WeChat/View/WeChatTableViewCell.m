//
//  WeChatTableViewCell.m
//  WeChat_D
//
//  Created by tztddong on 16/7/15.
//  Copyright © 2016年 dongjiangpeng. All rights reserved.
//

#import "WeChatTableViewCell.h"
#import "WeChatListModel.h"

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
    if (array.count) {
        self.messageLabel.text = [array objectAtIndex:array.count-1];
    }else{
        self.messageLabel.text = model.message;
    }
    self.headImage.image = [UIImage imageNamed:model.imageUrl];
    self.nameLable.text = model.name;
    self.timeLable.text = model.time;
}

@end
