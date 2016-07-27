//
//  CreatGroupCell.m
//  WeChat_D
//
//  Created by tztddong on 16/7/27.
//  Copyright © 2016年 dongjiangpeng. All rights reserved.
//

#import "CreatGroupCell.h"
#import "CreatGroupModel.h"

@interface CreatGroupCell ()
@property(nonatomic,strong)UIButton *selectBtn;
@property(nonatomic,strong)UIImageView *headImage;
@property(nonatomic,strong)UILabel *nameTitle;
@end

@implementation CreatGroupCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setSubViews];
    }
    return self;
}

- (void)setSubViews{
    
    self.selectBtn = [[UIButton alloc]init];
    [self.selectBtn setBackgroundImage:[UIImage imageNamed:@"[NO]"] forState:UIControlStateNormal];
    [self.selectBtn setBackgroundImage:[UIImage imageNamed:@"[OK]"] forState:UIControlStateSelected];
    [self.contentView addSubview:self.selectBtn];
    
    
    self.headImage = [[UIImageView alloc]init];
    [self.contentView addSubview:self.headImage];
    
    
    self.nameTitle = [[UILabel alloc]init];
    self.nameTitle.font = FONTSIZE(15);
    [self.contentView addSubview:self.nameTitle];
    

}

- (void)setModel:(CreatGroupModel *)model{
    
    self.selectBtn.selected = model.isSelect;
    self.headImage.image = [UIImage imageNamed:model.imageName];
    self.nameTitle.text = model.name;
    
    [self.selectBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView.mas_centerY);
        make.left.offset(KMARGIN);
    }];
    [self.headImage mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.selectBtn.mas_right).with.offset(KMARGIN);
        make.centerY.equalTo(self.contentView);
        make.size.mas_equalTo(CGSizeMake(36, 36));
    }];
    [self.nameTitle mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.headImage.mas_right).with.offset(KMARGIN*3/2);
        make.centerY.equalTo(self.contentView);
    }];
}
@end
