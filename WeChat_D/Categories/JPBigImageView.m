//
//  JPBigImageView.m
//  WeChat_D
//
//  Created by tztddong on 16/8/12.
//  Copyright © 2016年 dongjiangpeng. All rights reserved.
//

#import "JPBigImageView.h"

@interface JPBigImageView ()

@property(nonatomic,strong)UIImageView *showImageView;
@property(nonatomic,assign)CGRect initialFrame;
@property(nonatomic,strong)UIButton *saveBtn;


@end

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
        self.saveBtn = [[UIButton alloc]init];
        self.saveBtn.backgroundColor = [UIColor blackColor];
        [self.saveBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        self.saveBtn.layer.cornerRadius = 5;
        self.saveBtn.layer.borderColor = [UIColor whiteColor].CGColor;
        self.saveBtn.layer.borderWidth = 1;
        self.saveBtn.layer.masksToBounds = YES;
        [self.saveBtn.titleLabel setFont:FONTSIZE(15)];
        [self.saveBtn setTitle:@"保存" forState:UIControlStateNormal];
        [self.saveBtn addTarget:self action:@selector(saveBtnSelected) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.saveBtn];
        [self.saveBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.offset(-2*KMARGIN);
            make.right.offset(-2*KMARGIN);
            make.size.mas_equalTo(CGSizeMake(50, 30));
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

- (void)saveBtnSelected{
    
    UIImageWriteToSavedPhotosAlbum(self.showImageView.image, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
    
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo{
    
    if (!error) {
        [SVProgressHUD showSuccessWithStatus:@"已保存到系统相册"];
    }
}


@end
