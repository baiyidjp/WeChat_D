//
//  JPBigImageView.m
//  WeChat_D
//
//  Created by tztddong on 16/8/12.
//  Copyright © 2016年 dongjiangpeng. All rights reserved.
//

#import "JPBigImageView.h"

@implementation JPBigImageView

- (instancetype)initWithFrame:(CGRect)frame showImage:(UIImage *)showImage initialFrame:(CGRect)initialFrame{
    
    self = [super init];
    if (self) {
        self.frame = frame;
        self.backgroundColor = [UIColor blackColor];
        self.userInteractionEnabled = YES;
        self.initialFrame = initialFrame;
        self.showImageView.frame = initialFrame;
        self.showImageView.image = showImage;
        [self addSubview:self.showImageView];
        CGFloat imageH = showImage.size.height/showImage.size.width*self.frame.size.width;
        CGFloat imageY = self.frame.size.height/2 - imageH/2;
        [UIView animateWithDuration:0.5 animations:^{
            self.showImageView.frame = CGRectMake(0, imageY, self.frame.size.width, imageH);
        }];
    }
    return self;
}

- (UIImageView *)showImageView{
    
    if (!_showImageView) {
        _showImageView = [[UIImageView alloc]init];
    }
    return _showImageView;
}

//- (void)setShowImage:(UIImage *)showImage{
//    
//    _showImage = showImage;
//    self.showImageView.image = showImage;
//}
//
//- (void)setInitialFrame:(CGRect)initialFrame{
//    
//    _initialFrame = initialFrame;
//    self.showImageView.frame = initialFrame;
//}

//- (void)updateConstraints{
//    
//    [super updateConstraints];
//    [self.showImageView mas_updateConstraints:^(MASConstraintMaker *make) {
//        make.centerY.equalTo(self);
//        make.centerX.equalTo(self);
//        if (self.isDownSuccess) {
//            make.size.mas_equalTo(CGSizeMake(self.frame.size.width, self.showImageView.image.size.height/self.showImageView.image.size.width*self.frame.size.width));
//        }else{
////            make.size.mas_equalTo(self.initialSize);
//        }
//    }];
//}
//
//- (void)setBigImage_Url:(NSString *)bigImage_Url{
//    
//    _bigImage_Url = bigImage_Url;
//    [self.showImageView setShowActivityIndicatorView:YES];
//    [self.showImageView sd_setImageWithURL:[NSURL URLWithString:bigImage_Url] placeholderImage:[UIImage imageNamed:@"location"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
//        if (!error) {
//            //下载是异步下载 一定要回到主线程赋值
//            dispatch_async(dispatch_get_main_queue(), ^{
//                self.isDownSuccess = YES;
//                NSLog(@"%@",NSStringFromCGSize(image.size));
//                [self setNeedsUpdateConstraints];
//                //检测这个view是否有约束需要更新 如果有在调用下面的方法 更新约束
//                [self updateConstraintsIfNeeded];
//                [self layoutIfNeeded];
//            });
//        }
//    }];
//}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    if (self.clickViewHidden) {
        [UIView animateWithDuration:0.5 animations:^{
            self.showImageView.frame = self.initialFrame;
        }];
        self.clickViewHidden();
    }
}

@end
