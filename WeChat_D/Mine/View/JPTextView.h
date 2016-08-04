//
//  JPTextView.h
//  01-新浪微博(UITabarButton)
//
//  Created by I Smile going on 15/8/6.
//  Copyright (c) 2015年 I Smile going. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JPTextView : UITextView

//设置font
@property(nonatomic,assign) NSInteger fontNum;
//设置占位字符
@property(nonatomic,weak)UILabel  *placeLabel;
//占位字符的内容
@property(nonatomic,copy)NSString *placeholder;
//设置提示文本
@property(nonatomic,weak)UILabel  *numLabel;
//设置提示剩余多少字
@property(nonatomic,assign) NSInteger wordNum;

@end
