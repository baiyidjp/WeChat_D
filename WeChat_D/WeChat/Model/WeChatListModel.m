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
    EMMessage *emmessage = conversation.latestMessage;
    switch (self.conversationType) {//判断属于单聊还是群聊
        case EMConversationTypeChat:{
            self.name = conversation.conversationId;
            [self setChatModelWith:emmessage];
        }
            break;
        case EMConversationTypeGroupChat:{
            self.name = [conversation.ext objectForKey:GroupName];
            if ([emmessage.from isEqualToString:[[EMClient sharedClient] currentUsername]]) {
                [self setChatModelWith:emmessage];
            }else{
                [self setChatGroupModelWith:emmessage];
            }
        }
            break;
        default:
            break;
    }
    if (emmessage.timestamp) {
        self.time = [self returnTimeWitnLongTime:emmessage.timestamp];
    }else{
        self.time = [self returnCurrentTime];
    }
    self.imageUrl = FRIENDHEADERIMAGE_URL;
}

- (NSString *)returnTimeWitnLongTime:(long long)longtime{
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    formatter.dateFormat = @"HH : mm";
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:longtime/1000];
    NSString *time = [formatter stringFromDate:date];
    return time;
}

- (NSString *)returnCurrentTime{
    
    NSDate *date = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    formatter.dateFormat = @"HH : mm";
    NSString *time = [formatter stringFromDate:date];
    return time;
}

- (void)setChatModelWith:(EMMessage *)emmessage{
    switch (emmessage.body.type) {
        case EMMessageBodyTypeText:{
            //文本类型的消息
            //拿到文本消息体
            EMTextMessageBody *textBody = (EMTextMessageBody *)emmessage.body;
            self.message = textBody.text;
        }
            break;
        case EMMessageBodyTypeVoice:{
            self.message = @"[语音消息]";
        }
            break;
            
        case EMMessageBodyTypeImage:{
            self.message = @"[图片]";
        }
            break;
            
        default:
            break;
    }

}

- (void)setChatGroupModelWith:(EMMessage *)emmessage{
    switch (emmessage.body.type) {
        case EMMessageBodyTypeText:{
            //文本类型的消息
            //拿到文本消息体
            EMTextMessageBody *textBody = (EMTextMessageBody *)emmessage.body;
            self.message = [NSString stringWithFormat:@"%@:%@",emmessage.from,textBody.text];
        }
            break;
        case EMMessageBodyTypeVoice:{
            self.message = [NSString stringWithFormat:@"%@:[语音消息]",emmessage.from];
        }
            break;
            
        case EMMessageBodyTypeImage:{
            self.message = [NSString stringWithFormat:@"%@:[图片]",emmessage.from];
        }
            break;
            
        default:
            break;
    }

}
@end
