//
//  MessageModel.m
//  WeChat_D
//
//  Created by tztddong on 16/7/18.
//  Copyright © 2016年 dongjiangpeng. All rights reserved.
//

#import "MessageModel.h"

@implementation MessageModel

- (void)setEmmessage:(EMMessage *)emmessage{
    
    _emmessage = emmessage;
    
    _messageBody = emmessage.body;
    
    if (emmessage.direction == EMMessageDirectionSend) {
        self.isMineMessage = YES;
    }else{
        self.isMineMessage = NO;
    }
    
    switch (emmessage.body.type) {
            
        case EMMessageBodyTypeText:{
            //文本类型的消息
            //拿到文本消息体
            EMTextMessageBody *textBody = (EMTextMessageBody *)_messageBody;
            self.messagetext = textBody.text;
            self.messageType = MessageType_Text;
        }
            break;
        case EMMessageBodyTypeVoice:{
            
            EMVoiceMessageBody *voiceBody = (EMVoiceMessageBody *)_messageBody;
            self.voiceTime = voiceBody.duration;
            self.voicePath = voiceBody.remotePath;
            self.messageType = MessageType_Voice;
        }
            break;

        case EMMessageBodyTypeImage:{
            EMImageMessageBody *imageBody = (EMImageMessageBody *)_messageBody;
            self.image_mark = imageBody.thumbnailRemotePath;//缩略图的本地路径
            self.messageType = MessageType_Picture;
        }
            break;

        default:
            break;
    }
}

@end
