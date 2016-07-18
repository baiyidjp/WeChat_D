//
//  MessageModel.h
//  WeChat_D
//
//  Created by tztddong on 16/7/18.
//  Copyright © 2016年 dongjiangpeng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MessageModel : NSObject

@property(nonatomic,copy)NSString *messagetext;
@property(nonatomic,assign)BOOL isMineMessage;

@end
