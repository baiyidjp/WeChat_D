//
//  MessageTableViewCell.m
//  WeChat_D
//
//  Created by tztddong on 16/7/18.
//  Copyright © 2016年 dongjiangpeng. All rights reserved.
//

#import "MessageTableViewCell.h"
#import "MessageModel.h"

@interface MessageTableViewCell ()
/**
 *  头像
 */
@property(nonatomic,strong)UIImageView *headerView;
/**
 *  底层图片
 */
@property(nonatomic,strong)UIImageView *backImgaeView;
/**
 *  文字消息
 */
@property(nonatomic,strong)UILabel *messageText;
/**
 *  图片消息
 */
@property(nonatomic,strong)UIImageView *messsgeImage;
/**
 *  语音消息
 */
@property(nonatomic,strong)UIButton *messageVoice;
@end

@implementation MessageTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self congifViews];
    }
    return self;
}

- (void)congifViews{
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.backgroundColor = [UIColor clearColor];
    
    [self.contentView addSubview:self.headerView];
    [self.contentView addSubview:self.backImgaeView];
    [self.contentView addSubview:self.messageText];
    
    self.contentView.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
    [self.contentView addGestureRecognizer:tap];
    
//    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPress:)];
//    longPress.numberOfTouchesRequired = 1;
//    longPress.minimumPressDuration = 1.f;
//    [self.contentView addGestureRecognizer:longPress];
}

- (void)handleTap:(UITapGestureRecognizer *)tap {
    if (tap.state == UIGestureRecognizerStateEnded) {
        CGPoint tapPoint = [tap locationInView:self.contentView];
        if (CGRectContainsPoint(self.backImgaeView.frame, tapPoint)) {
            [self.delegate messageCellTappedMessage:self];
        }else if (CGRectContainsPoint(self.headerView.frame, tapPoint)) {
            [self.delegate messageCellTappedHead:self];
        }else {
            [self.delegate messageCellTappedBlank:self];
        }
    }
}

#pragma mark 懒加载views
- (UIImageView *)headerView{
    
    if (!_headerView) {
        _headerView = [[UIImageView alloc]init];
    }
    return _headerView;
}

- (UIImageView *)backImgaeView{
    
    if (!_backImgaeView) {
        _backImgaeView = [[UIImageView alloc]init];
    }
    return _backImgaeView;
}

- (UILabel *)messageText{
    
    if (!_messageText) {
        _messageText = [[UILabel alloc]init];
        _messageText.numberOfLines = 0;
        _messageText.font = FONTSIZE(15);
    }
    return _messageText;
}

- (void)setModel:(MessageModel *)model{
    
    _model = model;
    self.messageText.attributedText = [PublicMethod emojiWithText:model.messagetext];
    if (model.isMineMessage) {
        
        [self.headerView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.right.offset(-KMARGIN);
            make.top.offset(KMARGIN);
            make.size.mas_equalTo(CGSizeMake(50, 50));
        }];
        self.headerView.backgroundColor = [UIColor redColor];
        //换行设置
        self.messageText.preferredMaxLayoutWidth = KWIDTH/5*3;
        [self.messageText mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.headerView.mas_top).with.offset(KMARGIN);
            make.right.equalTo(self.headerView.mas_left).with.offset(-2*KMARGIN);
            make.width.lessThanOrEqualTo(@(KWIDTH/5*3)).priorityHigh();
        }];
        [self.backImgaeView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.headerView.mas_top);
            make.right.equalTo(self.headerView.mas_left).with.offset(-KMARGIN/2);
            make.left.equalTo(self.messageText.mas_left).with.offset(-2*KMARGIN);
            make.bottom.equalTo(self.messageText.mas_bottom).with.offset(KMARGIN);
        }];
        self.backImgaeView.image = [self backImage:[UIImage imageNamed:@"message_sender_background_normal"]];
        
    }else{
        [self.headerView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.offset(KMARGIN);
            make.top.offset(KMARGIN);
            make.size.mas_equalTo(CGSizeMake(50, 50));
        }];
        self.headerView.backgroundColor = [UIColor blueColor];
        //换行设置
        self.messageText.preferredMaxLayoutWidth = KWIDTH/5*3;
        [self.messageText mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.headerView.mas_top).with.offset(KMARGIN);
            make.left.equalTo(self.headerView.mas_right).with.offset(2*KMARGIN);
            make.width.lessThanOrEqualTo(@(KWIDTH/5*3)).priorityHigh();
        }];
        [self.backImgaeView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.headerView.mas_top);
            make.left.equalTo(self.headerView.mas_right).with.offset(KMARGIN/2);
            make.right.equalTo(self.messageText.mas_right).with.offset(2*KMARGIN);
            make.bottom.equalTo(self.messageText.mas_bottom).with.offset(KMARGIN);
        }];
        self.backImgaeView.image = [self backImage:[UIImage imageNamed:@"message_receiver_background_normal"]];
    }
}

+ (CGFloat)cellHeightWithModel:(MessageModel *)model{
    
    MessageTableViewCell *cell = [[MessageTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"MessageTableViewCell"];
    [cell setModel:model];
    [cell layoutIfNeeded];
    
    CGFloat height  = CGRectGetMaxY(cell.backImgaeView.frame);
    
    return height+KMARGIN/2;
}

- (UIImage *)backImage:(UIImage *)image{

    // 设置端盖的值
    CGFloat top = image.size.height * 0.6;
    CGFloat left = image.size.width * 0.5;
    CGFloat bottom = image.size.height * 0.3;
    CGFloat right = image.size.width * 0.5;
    // 设置端盖的值
    UIEdgeInsets edgeInsets = UIEdgeInsetsMake(top, left, bottom, right);
    // 设置拉伸的模式
    UIImageResizingMode mode = UIImageResizingModeStretch;
    // 拉伸图片
    UIImage *newImage = [image resizableImageWithCapInsets:edgeInsets resizingMode:mode];
    
    return newImage;
}

@end
