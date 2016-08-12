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
    
    self.messageId = emmessage.messageId;
    self.sendSuccess = emmessage.status;
    self.chatType = emmessage.chatType;
    self.messageFromName = emmessage.from;
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
            self.voiceLocaPath = voiceBody.localPath;
            self.messageType = MessageType_Voice;
            NSFileManager *fileManger = [NSFileManager defaultManager];
            if ([fileManger fileExistsAtPath:self.voiceLocaPath]){
                self.voiceIsListen = [[NSUserDefaults standardUserDefaults] objectForKey:self.voiceLocaPath];
            }else{
                self.voiceIsListen = [[NSUserDefaults standardUserDefaults] objectForKey:self.voicePath];
            }

        }
            break;

        case EMMessageBodyTypeImage:{
            EMImageMessageBody *imageBody = (EMImageMessageBody *)_messageBody;
            self.messageType = MessageType_Picture;
            self.imageUrl = imageBody.thumbnailRemotePath;//缩略图的服务器路径
            self.image_mark = imageBody.thumbnailLocalPath;//缩略图的本地路径
            self.bigImage_Url = imageBody.remotePath;
            self.thumbnailSize = imageBody.size;
        }
            break;

        default:
            break;
    }
}

@end
