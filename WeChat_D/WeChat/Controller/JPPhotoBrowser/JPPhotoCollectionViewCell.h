//
//  JPPhotoCollectionViewCell.h
//  WeChat_D
//
//  Created by tztddong on 16/8/10.
//  Copyright © 2016年 dongjiangpeng. All rights reserved.
//

#import <UIKit/UIKit.h>

@class JPPhotoModel;
@interface JPPhotoCollectionViewCell : UICollectionViewCell

@property(nonatomic,strong)JPPhotoModel *photoModel;
@property(nonatomic,strong)UIImageView *photoImage;
@property(nonatomic,strong)UIButton *selectBtn;
@property(nonatomic,strong)UIView *bottomView;
@property(nonatomic,strong)UIImageView *videoImage;
@property(nonatomic,strong)UILabel *videoTime;
/** block */
@property(nonatomic,copy)void(^clickSelectBtnBlock)();
@end
