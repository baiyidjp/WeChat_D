//
//  JPBigImageView.h
//  WeChat_D
//
//  Created by tztddong on 16/8/12.
//  Copyright © 2016年 dongjiangpeng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JPBigImageView : UIView

@property(nonatomic,strong)UIImage *showImage;
@property(nonatomic,copy)void(^clickViewHidden)();
@property(nonatomic,strong)UIImageView *showImageView;
@property(nonatomic,strong)NSString *bigImage_Url;
@property(nonatomic,assign)BOOL isDownSuccess;
@property(nonatomic,assign)CGSize initialSize;
@end
