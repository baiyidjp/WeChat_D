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

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    if (self.clickViewHidden) {
        [UIView animateWithDuration:0.5 animations:^{
            self.showImageView.frame = self.initialFrame;
        }];
        self.clickViewHidden();
    }
}

@end
