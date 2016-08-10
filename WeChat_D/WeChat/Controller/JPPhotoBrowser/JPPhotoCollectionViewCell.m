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
        
        [self.contentView addSubview:self.photoImage];
        [self.contentView addSubview:self.selectBtn];
    }
    return self;
}

- (UIImageView *)photoImage{
    
    if (!_photoImage) {
        _photoImage = [[UIImageView alloc]init];
    }
    return _photoImage;
}

- (UIButton *)selectBtn{
    
    if (!_selectBtn) {
        _selectBtn = [[UIButton alloc]init];
        [_selectBtn setBackgroundImage:[UIImage imageNamed:@"FriendsSendsPicturesSelectIcon_27x27_"] forState:UIControlStateNormal];
        [_selectBtn setBackgroundImage:[UIImage imageNamed:@"FriendsSendsPicturesSelectYIcon_27x27_"] forState:UIControlStateSelected];
    }
    return _selectBtn;
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
}

@end
