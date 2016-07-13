//
//  AddMoreView.h
//  WeChat_D
//
//  Created by tztddong on 16/7/13.
//  Copyright © 2016年 dongjiangpeng. All rights reserved.
//

#import <UIKit/UIKit.h>

@class AddMoreView;
@protocol AddMoreViewDelegate <NSObject>

@required
/**
 *  返回需要的所有数据 数组中包含字典 字典必须有两个key对应的值 title imageName
 */
- (NSArray *)dataOfMoreView:(AddMoreView *)addMoreView;

@optional
/**
 *  点击对应的图标
 */
- (void)addMoreView:(AddMoreView *)addMoreView didSelectedItem:(NSInteger)index;

@end

@interface AddMoreView : UIView

@property(nonatomic,weak)id<AddMoreViewDelegate> delegate;

- (instancetype)initWithFrame:(CGRect)frame data:(NSArray *)dataArray;

@end
