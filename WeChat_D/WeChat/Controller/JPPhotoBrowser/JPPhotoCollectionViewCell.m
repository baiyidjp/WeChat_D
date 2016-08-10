//
//  JPPhotoCollectionViewCell.m
//  WeChat_D
//
//  Created by tztddong on 16/8/10.
//  Copyright © 2016年 dongjiangpeng. All rights reserved.
//

#import "JPPhotoCollectionViewCell.h"
#import "JPPhotoModel.h"

@implementation JPPhotoCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    if (self) {
        
        self.userInteractionEnabled = YES;
        [self.contentView addSubview:self.photoImage];
        [self.contentView addSubview:self.selectBtn];
        [self.contentView addSubview:self.bottomView];
        [self.contentView addSubview:self.videoImage];
    }
    return self;
}

- (UIImageView *)photoImage{
    
    if (!_photoImage) {
        _photoImage = [[UIImageView alloc]init];
//        _photoImage.contentMode = UIViewContentModeRedraw;
    }
    return _photoImage;
}

- (UIButton *)selectBtn{
    
    if (!_selectBtn) {
        _selectBtn = [[UIButton alloc]init];
        [_selectBtn setBackgroundImage:[UIImage imageNamed:@"FriendsSendsPicturesSelectIcon_27x27_"] forState:UIControlStateNormal];
        [_selectBtn setBackgroundImage:[UIImage imageNamed:@"FriendsSendsPicturesSelectYIcon_27x27_"] forState:UIControlStateSelected];
        [_selectBtn addTarget:self action:@selector(clickSelectBtn) forControlEvents:UIControlEventTouchUpInside];
    }
    return _selectBtn;
}

- (UIView *)bottomView{
    
    if (!_bottomView) {
        
        _bottomView = [[UIView alloc]init];
        _bottomView.backgroundColor = [UIColor blackColor];
        _bottomView.alpha = 0.5;
    }
    return _bottomView;
}

- (UIImageView *)videoImage{
    
    if (!_videoImage) {
        
        _videoImage = [[UIImageView alloc]init];
        _videoImage.image = [UIImage imageNamed:@"News_VideoBIG_31x31_"];
    }
    return _videoImage;
}

- (void)setPhotoModel:(JPPhotoModel *)photoModel{
    
    _photoModel = photoModel;
    
    self.photoImage.image = photoModel.thumbImage;
    self.selectBtn.selected = photoModel.isSelect;
    
    [self.photoImage mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView);
    }];
    [self.selectBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(3);
        make.right.offset(-3);
        make.size.mas_equalTo(CGSizeMake(27, 27));
    }];
    self.selectBtn.hidden = photoModel.isVideoType;
    
    self.bottomView.hidden = !photoModel.isVideoType;
    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.offset(0);
        make.height.equalTo(@(2*KMARGIN));
    }];
    self.videoImage.hidden = !photoModel.isVideoType;
    [self.videoImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.bottomView.mas_centerY);
        make.left.offset(KMARGIN/2);
        make.size.mas_equalTo(CGSizeMake(15, 15));
    }];
}

- (void)clickSelectBtn{
    
    if (self.clickSelectBtnBlock) {
        self.clickSelectBtnBlock();
    }
}

@end
