//
//  PublicMethod.m
//  WeChat_D
//
//  Created by tztddong on 16/7/18.
//  Copyright © 2016年 dongjiangpeng. All rights reserved.
//

#import "PublicMethod.h"

@implementation PublicMethod

+ (NSAttributedString *)emojiWithText:(NSString *)text{
    
    //创建一个可变的字符串
    NSMutableAttributedString *attributeStr = [[NSMutableAttributedString alloc]initWithString:text];
    //通过正则表达式找到要替换的表情的文字 [表情]
    NSString *pattern = @"\\[[a-zA-Z0-9\\u4e00-\\u9fa5]+\\]";
    NSError *error;
    NSRegularExpression *expression = [NSRegularExpression regularExpressionWithPattern:pattern options:NSRegularExpressionCaseInsensitive error:&error];
    NSArray *strArray = nil;
    if (!error) {
        //通过正则表达去找符合规则的字符串
        strArray = [expression matchesInString:text options:0 range:NSMakeRange(0, text.length)];
    }

    //遍历拿到的表情字符数组 (使用倒序遍历 如果是正遍历 位置会发生变化 导致排版错乱)
    [strArray enumerateObjectsWithOptions:NSEnumerationReverse usingBlock:^(NSTextCheckingResult *emojiStr, NSUInteger idx, BOOL * _Nonnull stop) {
        NSRange strRange = emojiStr.range;
        //通过range取出对应text中的字符串
        NSString *textEmojiStr = [text substringWithRange:strRange];
        //通过字符串拿到表情的图片
        NSTextAttachment *attachment = [[NSTextAttachment alloc]init];
        attachment.image = [UIImage imageNamed:textEmojiStr];
        attachment.bounds = CGRectMake(0, -5, 25, 25);
        //创建一个带图标的可变字符串
        if (attachment.image) {//判断是否存在图片 不存在还是显示原来的比如 [00120]
            NSAttributedString *imageStr = [NSAttributedString attributedStringWithAttachment:attachment];
            [attributeStr replaceCharactersInRange:strRange withAttributedString:imageStr];
        }
    }];
    
    return attributeStr;
}


@end
