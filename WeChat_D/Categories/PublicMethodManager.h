//
//  PublicMethod.h
//  WeChat_D
//
//  Created by tztddong on 16/7/18.
//  Copyright © 2016年 dongjiangpeng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface PublicMethodManager : NSObject

+ (instancetype)sharedPublicManager;

/**
 *  将表情文字转换为表情
 */
+ (NSAttributedString *)emojiWithText:(NSString *)text;

@end
