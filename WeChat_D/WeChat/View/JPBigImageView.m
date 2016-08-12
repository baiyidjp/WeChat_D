//
//  JPBigImageView.m
//  WeChat_D
//
//  Created by tztddong on 16/8/12.
//  Copyright © 2016年 dongjiangpeng. All rights reserved.
//

#import "JPBigImageView.h"

@implementation JPBigImageView

- (instancetype)initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor blackColor];
        [self addSubview:self.showImageView];
        self.userInteractionEnabled = YES;
        self.initialSize = self.frame.size;
        
        [self setNeedsUpdateConstraints];
        //检测这个view是否有约束需要更新 如果有在调用下面的方法 更新约束
        [self updateConstraintsIfNeeded];
        [self layoutIfNeeded];
    }
    return self;
}

- (UIImageView *)showImageView{
    
    if (!_showImageView) {
        _showImageView = [[UIImageView alloc]init];
    }
    return _showImageView;
}

- (void)setShowImage:(UIImage *)showImage{
    
    _showImage = showImage;
    self.showImageView.image = showImage;
    [self setNeedsUpdateConstraints];
    //检测这个view是否有约束需要更新 如果有在调用下面的方法 更新约束
    [self updateConstraintsIfNeeded];
    [UIView animateWithDuration:0.3 animations:^{
        [self layoutIfNeeded];
    }];

}

- (void)updateConstraints{
    
    [super updateConstraints];
    [self.showImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.left.offset(0);
        if (self.isDownSuccess) {
            make.size.mas_equalTo(CGSizeMake(self.frame.size.width, self.showImageView.image.size.height/self.showImageView.image.size.width*self.frame.size.width));
        }else{
            make.size.mas_equalTo(self.initialSize);
        }
    }];
}

- (void)setBigImage_Url:(NSString *)bigImage_Url{
    
    _bigImage_Url = bigImage_Url;
    [self.showImageView setShowActivityIndicatorView:YES];
    [[SDWebImageManager sharedManager] downloadImageWithURL:[NSURL URLWithString:bigImage_Url] options:SDWebImageRetryFailed progress:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
        if (finished) {
            //下载是异步下载 一定要回到主线程赋值
            dispatch_async(dispatch_get_main_queue(), ^{
                self.isDownSuccess = finished;
                self.showImageView.image = image;
                NSLog(@"%@",NSStringFromCGSize(image.size));
                [self setNeedsUpdateConstraints];
                //检测这个view是否有约束需要更新 如果有在调用下面的方法 更新约束
                [self updateConstraintsIfNeeded];
                [self layoutIfNeeded];
            });

        }
    }];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    if (self.clickViewHidden) {
        self.isDownSuccess = NO;
        [self setNeedsUpdateConstraints];
        //检测这个view是否有约束需要更新 如果有在调用下面的方法 更新约束
        [self updateConstraintsIfNeeded];
        [UIView animateWithDuration:0.3 animations:^{ 
            [self layoutIfNeeded];
        }];
        self.clickViewHidden();
    }
}

@end
