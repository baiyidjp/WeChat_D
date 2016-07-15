//
//  FaceView.h
//  WeChat_D
//
//  Created by tztddong on 16/7/13.
//  Copyright © 2016年 dongjiangpeng. All rights reserved.
//

#import <UIKit/UIKit.h>

@class FaceView,FaceViewModel;
@protocol FaceViewDelegate <NSObject>

@required
/**
 *  返回需要的所有数据 数组中包含字典 字典必须有两个key对应的值 title imageName
 */
//- (NSArray *)dataOfFaceView:(FaceView *)FaceView;

@optional
/**
 *  点击对应的图标
 */
- (void)faceView:(FaceView *)FaceView didSelectedItem:(FaceViewModel *)model;
/**
 *  删除按钮
 */
- (void)didSelectDelectedItemOfFaceView:(FaceView *)faceView;
/**
 *  发送按钮
 */
- (void)didSendItemOfFaceView:(FaceView *)faceView;

@end

@interface FaceView : UIView

@property(nonatomic,weak)id<FaceViewDelegate> delegate;

@end
