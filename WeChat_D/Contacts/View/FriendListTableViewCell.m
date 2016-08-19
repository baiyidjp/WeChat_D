//
//  FriendListTableViewCell.m
//  WeChat_D
//
//  Created by Keep丶Dream on 16/8/19.
//  Copyright © 2016年 dongjiangpeng. All rights reserved.
//

#import "FriendListTableViewCell.h"

@implementation FriendListTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    for (UIView *subView in self.subviews)
    {
        if([subView isKindOfClass:NSClassFromString(@"UITableViewCellDeleteConfirmationView")])
        {
            UIView *confirmView=(UIView *)[subView.subviews firstObject];
            //改背景颜色
            confirmView.backgroundColor=[UIColor grayColor];
            for(UIView *sub in confirmView.subviews)
            {
                if([sub isKindOfClass:NSClassFromString(@"UIButtonLabel")])
                {
                    UILabel *deleteLabel=(UILabel *)sub;
                    //改删除按钮的字体大小
                    deleteLabel.font=FONTSIZE(16);
                    //改删除按钮的文字
                    deleteLabel.text=@"备注";
                }
            }
            break;
        }
    }
    
}


@end
