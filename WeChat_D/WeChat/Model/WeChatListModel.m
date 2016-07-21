    //
//  WeChatListModel.m
//  WeChat_D
//
//  Created by tztddong on 16/7/15.
//  Copyright © 2016年 dongjiangpeng. All rights reserved.
//

#import "WeChatListModel.h"

@implementation WeChatListModel

- (void)setConversation:(EMConversation *)conversation{
    
    _conversation = conversation;
    
    self.conversationID = conversation.conversationId;
    self.unreadMessagesCount = conversation.unreadMessagesCount;
    self.conversationType = conversation.type;
    self.name = conversation.conversationId;
    EMMessage *emmessage = conversation.latestMessage;
    switch (emmessage.body.type) {
            
        case EMMessageBodyTypeText:{
            //文本类型的消息
            //拿到文本消息体
            EMTextMessageBody *textBody = (EMTextMessageBody *)emmessage.body;
            self.message = textBody.text;
        }
            break;
        case EMMessageBodyTypeVoice:{
            
//            EMVoiceMessageBody *voiceBody = (EMVoiceMessageBody *)emmessage.body;
            self.message = @"语音消息";
        }
            break;
            
        case EMMessageBodyTypeImage:{
//            EMImageMessageBody *imageBody = (EMImageMessageBody *)emmessage.body;
            self.message = @"图片";
        }
            break;
            
        default:
            break;
    }
    self.time = [self returnTimeWitnLongTime:emmessage.localTime];
    self.imageUrl = @"http://ww1.sinaimg.cn/crop.0.0.1080.1080.1024/006cxmWbjw8evactf4t2ij30u00u0jtj.jpg";
}

- (NSString *)returnTimeWitnLongTime:(long long)longtime{
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    formatter.dateFormat = @"HH : mm";
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:longtime/1000];
    NSString *time = [formatter stringFromDate:date];
    return time;
}

@end
