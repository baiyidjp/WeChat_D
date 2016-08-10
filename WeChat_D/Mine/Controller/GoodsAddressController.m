//
//  GoodsAddressController.m
//  WeChat_D
//
//  Created by Keep丶Dream on 16/8/5.
//  Copyright © 2016年 dongjiangpeng. All rights reserved.
//

#import "GoodsAddressController.h"

@interface GoodsAddressController ()
/** 保存 */
@property(nonatomic,strong) UIButton *doneBtn;
@end

@implementation GoodsAddressController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIView *topBackView = [[UIView alloc]init];
    topBackView.backgroundColor = [UIColor colorWithRed:54/255.0 green:53/255.0 blue:58/255.0 alpha:1];
    [self.view addSubview:topBackView];
    [topBackView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.offset(0);
        make.height.equalTo(@(KNAVHEIGHT));
    }];
    UIButton *backBtn = [[UIButton alloc]init];
    [backBtn setTitle:@"取消" forState:UIControlStateNormal];
    [backBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [backBtn.titleLabel setFont:FONTSIZE(15)];
    [backBtn addTarget:self action:@selector(clickBackBtn) forControlEvents:UIControlEventTouchUpInside];
    [topBackView addSubview:backBtn];
    [backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(KMARGIN);
        make.centerY.equalTo(topBackView.mas_centerY).with.offset(KMARGIN);
    }];
    self.doneBtn = [[UIButton alloc]init];
    [self.doneBtn setTitle:@"保存" forState:UIControlStateNormal];
    [self.doneBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.doneBtn setTitleColor:[UIColor grayColor] forState:UIControlStateDisabled];
    [self.doneBtn.titleLabel setFont:FONTSIZE(15)];
    self.doneBtn.enabled = NO;
    [self.doneBtn addTarget:self action:@selector(clickDoneBtn) forControlEvents:UIControlEventTouchUpInside];
    [topBackView addSubview:self.doneBtn];
    [self.doneBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.offset(-KMARGIN);
        make.centerY.equalTo(topBackView.mas_centerY).with.offset(KMARGIN);
    }];
    UILabel *titleL = [[UILabel alloc]init];
    titleL.text = @"修改地址";
    titleL.textColor = [UIColor whiteColor];
    [topBackView addSubview:titleL];
    [titleL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(topBackView.mas_centerX);
        make.centerY.equalTo(topBackView.mas_centerY).with.offset(KMARGIN);
    }];
    

    
}

- (void)clickBackBtn{
    
    UIAlertController *alertCtrl = [UIAlertController alertControllerWithTitle:@"确定要放弃此次编辑么?" message:nil preferredStyle:UIAlertControllerStyleAlert];
    [alertCtrl addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:nil]];
    [alertCtrl addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        
        [self dismissViewControllerAnimated:YES completion:nil];
    }]];
    [self presentViewController:alertCtrl animated:YES completion:nil];

}

- (void)clickDoneBtn{
    
    NSDictionary *dict = [NSDictionary dictionaryWithObject:nil forKey:CHANGEINFO_KEY];
    [JP_NotificationCenter postNotificationName:CHANGESIGNSUCCESS object:nil userInfo:dict];
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
