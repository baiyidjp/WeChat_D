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
@property(nonatomic,strong)UIImageView *thumbImage;
@property(nonatomic,strong)UILabel *groupName;
@property(nonatomic,strong)UILabel *imageCount;
@end
