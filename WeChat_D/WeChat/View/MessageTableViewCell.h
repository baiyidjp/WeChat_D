//
//  MessageTableViewCell.h
//  WeChat_D
//
//  Created by tztddong on 16/7/18.
//  Copyright © 2016年 dongjiangpeng. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MessageModel,MessageTableViewCell;
@protocol MessageTableViewCellDelegate <NSObject>

/**
 *  点击空白处
 */
- (void)messageCellTappedBlank:(MessageTableViewCell *)messageCell;
/**
 *  点击头像
 */
- (void)messageCellTappedHead:(MessageTableViewCell *)messageCell;
/**
 *  点击消息
 */
- (void)messageCellTappedMessage:(MessageTableViewCell *)messageCell MessageModel:(MessageModel *)messageModel;
/**
 *  长按消息
 */
- (void)messageCellLonrPressMessage:(MessageTableViewCell *)messageCell MessageModel:(MessageModel *)messageModel indexPath:(NSIndexPath *)indexPath;
/**
 *  重新发送
 */
- (void)resendMessageWith:(MessageTableViewCell *)messageCell indexPath:(NSIndexPath *)indexPath;
@end

@interface MessageTableViewCell : UITableViewCell

@property(nonatomic,strong)MessageModel *model;
+ (CGFloat)cellHeightWithModel:(MessageModel *)model;
@property(nonatomic,weak)id<MessageTableViewCellDelegate> delegate;
/** indexpath */
@property(nonatomic,strong) NSIndexPath *indexPath;
- (void)viewBack;
@end
