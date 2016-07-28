//
//  MessageModel.h
//  WeChat_D
//
//  Created by tztddong on 16/7/18.
//  Copyright © 2016年 dongjiangpeng. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum : NSUInteger {
    MessageType_Text,
    MessageType_Voice,
    MessageType_Picture,
} MessageType;

typedef enum : NSUInteger {
    MessageSendNone,
    MessageSendSuccess,
    MessageSendField,
} MessageSendStale;

@class EMMessage;
@interface MessageModel : NSObject

@property(nonatomic,copy)NSString *messagetext;
@property(nonatomic,copy)NSString *imageUrl;
@property(nonatomic,copy)NSString *image_mark;
/** 缩略图的尺寸 */
@property(nonatomic,assign) CGSize thumbnailSize;

/** 语音是否已读 */
@property(nonatomic,assign) BOOL voiceIsListen;
/**
 *  录音时间
 */
@property(nonatomic,assign)int voiceTime;
/**
 *  网络路径
 */
@property(nonatomic,copy)NSString *voicePath;
/**
 *  本地路径
 */
@property(nonatomic,copy)NSString *voiceLocaPath;
/**
 *  是否本人发送
 */
@property(nonatomic,assign)BOOL isMineMessage;
/**
 *  消息体类型
 */
@property(nonatomic,assign)MessageType messageType;

/** Emmessage */
@property(nonatomic,strong)EMMessage *emmessage;
/** body */
@property(nonatomic,strong)EMMessageBody *messageBody;
/** 消息ID */
@property(nonatomic,copy)NSString *messageId;
/**
 *  发送状态
 */
@property(nonatomic,assign) EMMessageStatus sendSuccess;
/**
 *  消息类型
 */
@property(nonatomic,assign)EMChatType chatType;
/**
 *  消息发送者名字
 */
@property(nonatomic,copy)NSString *messageFromName;
@end
