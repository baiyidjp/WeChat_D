//
//  JPPhotoGroupCell.m
//  WeChat_D
//
//  Created by tztddong on 16/8/10.
//  Copyright © 2016年 dongjiangpeng. All rights reserved.
//

#import "JPPhotoGroupCell.h"
#import "JPPhotoGroupModel.h"

@implementation JPPhotoGroupCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        [self.contentView addSubview:self.thumbImage];
        [self.contentView addSubview:self.groupName];
        [self.contentView addSubview:self.imageCount];
    }
    return self;
}

- (UIImageView *)thumbImage{
    
    if (!_thumbImage) {
        _thumbImage = [[UIImageView alloc]init];
    }
    return _thumbImage;
}

- (UILabel *)groupName{
    
    if (!_groupName) {
        _groupName = [[UILabel alloc]init];
        _groupName.textColor = [UIColor blackColor];
        _groupName.font = FONTSIZE(15);
    }
    return _groupName;
}

- (UILabel *)imageCount{
    
    if (!_imageCount) {
        _imageCount = [[UILabel alloc]init];
        _imageCount.textColor = [UIColor grayColor];
        _imageCount.font = FONTSIZE(15);
    }
    return _imageCount;
}



- (void)setGroupModel:(JPPhotoGroupModel *)groupModel{
    
    _groupModel = groupModel;
    
    self.thumbImage.image = groupModel.thumbImage;
    self.groupName.text = groupModel.groupName;
    self.imageCount.text = [NSString stringWithFormat:@"(%zd)",groupModel.assetsCount];
    
    [self.thumbImage mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.offset(0);
        make.width.equalTo(self.thumbImage.mas_height);
    }];
    [self.groupName mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView);
        make.left.equalTo(self.thumbImage.mas_right).with.offset(KMARGIN);
    }];
    [self.imageCount mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView);
        make.left.equalTo(self.groupName.mas_right).with.offset(KMARGIN);
    }];
}

@end
