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

@class EMMessage;
@interface MessageModel : NSObject

@property(nonatomic,copy)NSString *messagetext;
@property(nonatomic,copy)NSString *imageUrl;
@property(nonatomic,copy)NSString *image_mark;
/** 缩略图的尺寸 */
@property(nonatomic,assign) CGSize thumbnailSize;

/** 语音是否已读 */
@property(nonatomic,assign) BOOL voiceIsListen;

@property(nonatomic,assign)int voiceTime;
/**
 *  网络路径
 */
@property(nonatomic,copy)NSString *voicePath;
/**
 *  本地路径
 */
@property(nonatomic,copy)NSString *voiceLocaPath;

@property(nonatomic,assign)BOOL isMineMessage;
@property(nonatomic,assign)MessageType messageType;

/** Emmessage */
@property(nonatomic,strong)EMMessage *emmessage;
/** body */
@property(nonatomic,strong)EMMessageBody *messageBody;
/** 消息ID */
@property(nonatomic,copy)NSString *messageId;

@end
