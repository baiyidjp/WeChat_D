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
#define KTABBARHEIGHT 49 //底部tabbar高度
#define KTOOLVIEW_MINH 49 //键盘工具栏的最小高度
#define KTOOLVIEW_MAXH 60 //键盘工具栏的最大高度
#define KFACEVIEW_H 210//表情和更多view的高度
#define TEXTSIZEWITHFONT(text,font) [text sizeWithAttributes:[NSMutableDictionary dictionaryWithObject:font forKey:NSFontAttributeName]]//根据文本及其字号返回size
#define ScaleValueH(valueh) ((valueh)*667.0f/[UIScreen mainScreen].bounds.size.height)
#define ScaleValueW(valuew) ((valuew)*375.0f/[UIScreen mainScreen].bounds.size.width)
#define WEAK_SELF(value) __weak typeof(self) value = self
#define KNOTIFICATION_LOGINCHANGE @"loginstatechange"
#define ADDFRIENDSUCCESS @"addFriendSuccess" //添加好友成功后的通知名

//define this constant if you want to use Masonry without the 'mas_' prefix
//#define MAS_SHORTHAND
//define this constant if you want to enable auto-boxing for default syntax
#define MAS_SHORTHAND_GLOBALS

#endif /* DefineHeader_h */
