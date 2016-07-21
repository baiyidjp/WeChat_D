//
//  WeChatListModel.h
//  WeChat_D
//
//  Created by tztddong on 16/7/15.
//  Copyright © 2016年 dongjiangpeng. All rights reserved.
//

#import <Foundation/Foundation.h>

@class EMConversation;
@interface WeChatListModel : NSObject
/**
 *  头像地址
 */
@property(nonatomic,copy)NSString *imageUrl;
/**
 *  名字
 */
@property(nonatomic,copy)NSString *name;
/**
 *  最新的消息
 */
@property(nonatomic,copy)NSString *message;
/**
 *  时间
 */
@property(nonatomic,copy)NSString *time;
/**
 *  会话标识
 */
@property(nonatomic,copy)NSString *conversationID;
/**
 *  未读消息数量
 */
@property(nonatomic,assign)NSInteger unreadMessagesCount;
/**
 *  会话类型
 */
@property(nonatomic,assign)EMConversationType conversationType;

//当前会话
@property(nonatomic,strong)EMConversation *conversation;

@end
