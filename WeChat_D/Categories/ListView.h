//
//  ListView.h
//  customBtn
//
//  Created by tztddong on 16/4/25.
//  Copyright © 2016年 dongjiangpeng. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^selectCell)(NSInteger index);

@interface ListView : UIView

/**
 *  创建一个下拉的tableview
 *
 *  @param topView     参照主界面的View(必传,未做nil处理)
 *  @param dataArray   需要展示的tableView的数据集合
 *  @param Frame       需要展示的tableView的frame
 *  @param selectBlock 点击cell的回调处理
 *
 *  @return 返回一个下拉的tableView
 */
+ (instancetype)creatListViewWithTopView:(UIView *)topView
                               dataArray:(NSArray *)dataArray
                                   frame:(CGRect)frame
                             selectBlock:(selectCell)selectBlock;

@end
