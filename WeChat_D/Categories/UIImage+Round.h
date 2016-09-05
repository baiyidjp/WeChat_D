//
//  UIImage+Round.h
//  MeiKeLaMei
//
//  Created by tztddong on 16/8/31.
//  Copyright © 2016年 gyk. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Round)

/**
 *  一句代码切好圆角 解决离屏渲染
 *
 *  @param radius 圆角的半径
 *  @param size   所在imageView的size
 *
 *  @return 一个切好的图片
 */
- (UIImage *)imageWithCornerRadius:(CGFloat)radius size:(CGSize)size;

//配合SDWebImage 使用

/*
 iconImageView.image = [[UIImage imageNamed:@"D_morentouxiang"] imageWithCornerRadius:iconImageView.frame.size.width/2 size:iconImageView.frame.size];
 [[SDWebImageManager sharedManager] downloadImageWithURL:[NSURL URLWithString:consultantModelFrame.consultantModel.avatar] options:SDWebImageRetryFailed progress:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
 if (image) {
 iconImageView.image = [image imageWithCornerRadius:iconImageView.frame.size.width/2 size:iconImageView.frame.size];
 }
 }];

 */
@end
