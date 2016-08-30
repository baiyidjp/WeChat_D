//
//  DDWXVideoControllerViewController.h
//  DDWXVideo
//
//  Created by tztddong on 16/3/2.
//  Copyright © 2016年 dongjiangpeng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIView+YYAdd.h"

/**
 *  所有可以定制的颜色
 */
#define VIEWBACKGROUND_COLOR [UIColor whiteColor]//背景色
#define FLASHBTN_COLOR [UIColor orangeColor]//开关闪光灯按钮颜色
#define CAMERABTN_COLOR [UIColor orangeColor]//切换前后摄像头颜色
#define TIPCANCLELABEL_COLOR_1 [UIColor orangeColor]//提示"向上取消"
#define TIPCANCLELABEL_COLOR_2 [UIColor redColor]//提示"松开取消"
#define PROGRESSVIEW_COLOR [UIColor purpleColor]//进度条
#define TIPLABEL_COLOR [UIColor blackColor]//提示"单击 双击"
#define TAPLABEL_COLOR [UIColor greenColor]//录制按钮文字
#define TAPLABEL_BORDERCOLOR [UIColor greenColor]//录制按钮圆弧
#define FOCUSVIEW_BORDERCOLOR [UIColor orangeColor]//聚焦光圈
#define BACKBTN_COLOR [UIColor purpleColor]//返回按钮
/**
 *  所有可以定制的尺寸
 */
#define TAPLABEL_W_H 100//录制按钮的宽高
#define PROGRESSVIEW_HEIGHT 2//进度条高
/**
 *  所有可以定制的字体大小
 */
#define FLASHBTN_FONT 13 //开关闪光灯按钮
#define CAMERABTN_FONT 13 //切换前后摄像头
#define TIPCANCLELABEL_FONT 13 //提示"向上取消"
#define TIPLABEL_FONT 14 //提示"单击 双击"
#define TAPLABEL_FONT 15 //录制按钮文字
#define BACKBTN_FONT 15 //返回按钮
/**
 *  所有可以定制的文字
 */
#define FLASHBTN_TITLE_N @"闪光灯 : 关"
#define FLASHBTN_TITLE_S @"闪光灯 : 开"
#define CAMERABTN_TITLE_N @"切换前置"
#define CAMERABTN_TITLE_S @"切换后置"
#define TIPCANCLELABEL_TITLE_1 @"上滑取消录制"
#define TIPCANCLELABEL_TITLE_2 @"松手取消录制"
#define TIPCANCLELABEL_TITLE_3 @"手指不要松开"
#define TIPLABEL_TITLE @"单击:调整焦点  \n双击:拉近/远镜头"
#define TAPLABEL_TITLE @"按住录制"
#define BACKBTN_TITLE @"返回"
@interface JPWXVideoController : UIViewController

/**
 *  定制最大录制时间(大于这个时间自动取消录制)
 */
@property(nonatomic,assign)CGFloat allTime;
/**
 *  定制最小录制时间(小于这个时间默认取消录制)
 */
@property(nonatomic,assign)CGFloat minTime;

@end
