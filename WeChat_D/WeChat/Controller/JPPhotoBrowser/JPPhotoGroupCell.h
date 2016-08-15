//
//  JPPhotoGroupCell.h
//  WeChat_D
//
//  Created by tztddong on 16/8/10.
//  Copyright © 2016年 dongjiangpeng. All rights reserved.
//

#import <UIKit/UIKit.h>

@class JPPhotoGroupModel;
@interface JPPhotoGroupCell : UITableViewCell

@property(nonatomic,strong)JPPhotoGroupModel *groupModel;
/**
 *  缩略图
 */
@property(nonatomic,strong)UIImageView *thumbImage;
/**
 *  组名
 */
@property(nonatomic,strong)UILabel *groupName;
/**
 *  图片个数
 */
@property(nonatomic,strong)UILabel *imageCount;
@end
