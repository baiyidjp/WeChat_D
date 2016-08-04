//
//  JPTextView.m
//  01-新浪微博(UITabarButton)
//
//  Created by I Smile going on 15/8/6.
//  Copyright (c) 2015年 I Smile going. All rights reserved.
//

#import "JPTextView.h"

//字体大小
#define kFont(x) [UIFont systemFontOfSize:x]
@implementation JPTextView


- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
//        //设置圆角
//        self.layer.cornerRadius = 7;
//        //设置边框颜色
//        self.layer.borderColor = [UIColor colorWithRed:230/255.0 green:230/255.0 blue:230/255.0 alpha:1].CGColor;
//        //设置边框宽度
//        self.layer.borderWidth = 1.5;
        
        self.frame = frame; 
        
        //初始化站位文字的label
        UILabel *placeLabel = [[UILabel alloc]init];
        UILabel *numLabel = [[UILabel alloc]init];
        
        //设置文字颜色
        placeLabel.textColor = [UIColor colorWithHexString:@"d2d2d2"];
        numLabel.textColor = [UIColor colorWithHexString:@"888888"];
        //设置文字换行
        placeLabel.numberOfLines = 0;
        
        self.placeLabel = placeLabel;
        self.numLabel = numLabel;
        
        [self addSubview:numLabel];
        [self addSubview:placeLabel];
        
        //发送一个通知 当textview改变的时候调用
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textViewChange) name:UITextViewTextDidChangeNotification object:self];
        
        [self setLayout];
        
    }
    return self;
}

//重写setter方法 设置占位符的内容

- (void)setPlaceholder:(NSString *)placeholder
{
    _placeholder =placeholder;
    
    self.placeLabel.text = placeholder;
    
}

//设置限制字数
- (void)setWordNum:(NSInteger)wordNum
{
    _wordNum = wordNum;
    
    self.numLabel.text = [NSString stringWithFormat:@"%zd",wordNum];
}

//设置font
- (void)setFontNum:(NSInteger)fontNum
{
    _fontNum = fontNum;
    self.font = kFont(fontNum);
    self.placeLabel.font = self.font;
    self.numLabel.font = self.font;
}

- (void)setLayout{
    
    
    [self.placeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(5);
        make.top.offset(8);
    }];
    
    [self.numLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(ScaleValueH(100)- 20);
        make.left.offset(KWIDTH - 30);
    }];
}

- (void)textViewChange
{
    self.placeLabel.hidden = self.text.length;
    
    self.numLabel.text = [NSString stringWithFormat:@"%zd", self.wordNum - self.text.length];
    [self setLayout];
    if ([self.numLabel.text isEqualToString:@"0"]) {
        
        [self endEditing:YES];
    }
    
}



@end
