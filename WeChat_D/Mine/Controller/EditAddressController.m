//
//  EditAddressController.m
//  WeChat_D
//
//  Created by tztddong on 16/8/26.
//  Copyright © 2016年 dongjiangpeng. All rights reserved.
//

#import "EditAddressController.h"
#import "JPTextView.h"

#define TOP_PADDING 10
#define LABEL_TOP 20
#define BOTTOM_PADDING 8
#define CELLVIEW_H 50

@interface EditAddressController ()<UITextViewDelegate>

@property(nonatomic,strong)UIButton *doneBtn;
@property(nonatomic,strong)NSMutableArray *textArray;

@end

@implementation EditAddressController

- (NSMutableArray *)textArray{
    
    if (!_textArray) {
        _textArray = [NSMutableArray array];
    }
    return _textArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
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
    [self.doneBtn setTitle:@"确定" forState:UIControlStateNormal];
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
    
    UIView *view_1 = [self creatViewWithTitle:@"收  货  人:" placeholder:@"请输入姓名" type:1];
    [self.view addSubview:view_1];
    [view_1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(topBackView.mas_bottom).with.offset(KMARGIN);
        make.left.right.offset(0);
        make.height.equalTo(@(CELLVIEW_H));
    }];
    
    UIView *view_2 = [self creatViewWithTitle:@"手机号码:" placeholder:@"请输入手机号码" type:2];
    [self.view addSubview:view_2];
    [view_2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(view_1.mas_bottom);
        make.left.right.offset(0);
        make.height.equalTo(@(CELLVIEW_H));
    }];
    
    UIView *view_3 = [self creatViewWithTitle:@"选择地区:" placeholder:@"地区信息" type:3];
    [self.view addSubview:view_3];
    [view_3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(view_2.mas_bottom);
        make.left.right.offset(0);
        make.height.equalTo(@(CELLVIEW_H));
    }];
    
    UIView *view_4 = [self creatViewWithTitle:@"详细地址:" placeholder:@"街道门牌信息" type:4];
    [self.view addSubview:view_4];
    [view_4 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(view_3.mas_bottom);
        make.left.right.offset(0);
        make.height.equalTo(@(CELLVIEW_H*2));
    }];
    
    UIView *view_5 = [self creatViewWithTitle:@"邮政编码:" placeholder:@"邮政编码" type:5];
    [self.view addSubview:view_5];
    [view_5 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(view_4.mas_bottom);
        make.left.right.offset(0);
        make.height.equalTo(@(CELLVIEW_H));
    }];
}

- (void)clickBackBtn{
    
    UIAlertController *alertCtrl = [UIAlertController alertControllerWithTitle:@"确定放弃此次编辑么" message:nil preferredStyle:UIAlertControllerStyleAlert];
    [alertCtrl addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }]];
    [alertCtrl addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
    [self presentViewController:alertCtrl animated:YES completion:nil];
}

- (void)clickDoneBtn{
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (UIView *)creatViewWithTitle:(NSString *)title placeholder:(NSString *)placeholder type:(NSInteger)type{
    
    UIView *backView = [[UIView alloc]init];
    backView.backgroundColor = [UIColor whiteColor];
    
    UILabel *nameLabel = [[UILabel alloc]init];
    [nameLabel setText:title];
    [nameLabel setTextColor:[UIColor colorWithHexString:@"000000"]];
    [nameLabel setFont:FONTSIZE(15)];
    nameLabel.textAlignment = NSTextAlignmentCenter;
    [backView addSubview:nameLabel];
    [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(KMARGIN);
        make.top.equalTo(backView.mas_top).with.offset(LABEL_TOP);
        make.width.equalTo(@70);
        make.height.equalTo(@15);
    }];
    
    
    UIView *lineView = [[UIView alloc]init];
    [lineView setBackgroundColor:[UIColor colorWithHexString:@"e5e5e5"]];
    [backView addSubview:lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.offset(0);
        make.left.offset(0);
        make.width.equalTo(@(KWIDTH));
        make.height.equalTo(@1);
    }];
    
    if (type == 4) {
        JPTextView *textView = [[JPTextView alloc]init];
        textView.textColor = [UIColor colorWithHexString:@"888888"];
        textView.delegate = self;//设置代理
        textView.placeholder = placeholder;
        textView.wordNum = 300;
        textView.fontNum = 13;
        [backView addSubview:textView];
        [textView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(nameLabel.mas_right).with.offset(KMARGIN/4.0);
            make.top.equalTo(backView.mas_top).with.offset(LABEL_TOP/2);
            make.bottom.equalTo(backView.mas_bottom).with.offset(-LABEL_TOP/2);
            make.width.equalTo(@(KWIDTH-2*KMARGIN-70));
        }];
        [self.textArray addObject:textView];
    }else{
        UITextField *textField = [[UITextField alloc]init];
        [textField setPlaceholder:placeholder];
        textField.font = FONTSIZE(13);
        textField.textColor = [UIColor colorWithHexString:@"888888"];
        textField.textAlignment = NSTextAlignmentLeft; //水平左对齐
        textField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;  //垂直居中
        textField.clearButtonMode = UITextFieldViewModeWhileEditing;
        [backView addSubview:textField];
        [textField mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(nameLabel.mas_right).with.offset(KMARGIN/2);
            make.centerY.equalTo(nameLabel);
            make.width.equalTo(@(KWIDTH-2*KMARGIN-70));
            make.height.equalTo(nameLabel.mas_height);
        }];
        [self.textArray addObject:textField];
        if (type == 2) {
            textField.keyboardType = UIKeyboardTypePhonePad;
        }
    }
    
    
    
    return backView;
}

@end
