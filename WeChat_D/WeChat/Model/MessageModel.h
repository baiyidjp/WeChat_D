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

@interface MessageModel : NSObject

@property(nonatomic,copy)NSString *messagetext;
@property(nonatomic,copy)NSString *imageUrl;
@property(nonatomic,copy)NSString *image_mark;
@property(nonatomic,assign)BOOL isMineMessage;
@property(nonatomic,assign)MessageType messageType;

@end
