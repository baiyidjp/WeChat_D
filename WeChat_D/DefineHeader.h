//
//  DefineHeader.h
//  WeChat_D
//
//  Created by tztddong on 16/7/8.
//  Copyright © 2016年 dongjiangpeng. All rights reserved.
//

#ifndef DefineHeader_h
#define DefineHeader_h

#define FONTSIZE(x)  [UIFont systemFontOfSize:x]//设置字体大小
#define KWIDTH  [UIScreen mainScreen].bounds.size.width//屏幕的宽
#define KHEIGHT [UIScreen mainScreen].bounds.size.height//屏幕的高
#define KMARGIN 10//默认间距
#define KNAVHEIGHT 64 //导航栏的高度
#define TEXTSIZEWITHFONT(text,font) [text sizeWithAttributes:[NSMutableDictionary dictionaryWithObject:font forKey:NSFontAttributeName]]//根据文本及其字号返回size
#define ScaleValueH(valueh) ((valueh)*667.0f/[UIScreen mainScreen].bounds.size.height)
#define ScaleValueW(valuew) ((valuew)*375.0f/[UIScreen mainScreen].bounds.size.width)

#endif /* DefineHeader_h */
