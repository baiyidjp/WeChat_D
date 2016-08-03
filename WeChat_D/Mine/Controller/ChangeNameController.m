//
//  ChangeNameController.m
//  WeChat_D
//
//  Created by tztddong on 16/8/3.
//  Copyright © 2016年 dongjiangpeng. All rights reserved.
//

#import "ChangeNameController.h"

@interface ChangeNameController ()<UITextFieldDelegate>
/**
 *  确定按钮
 */
@property(nonatomic,strong) UIButton *doneBtn;
@property(nonatomic,strong) UITextField *nameTextFiled;
@end

@implementation ChangeNameController

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
    titleL.text = @"名字";
    titleL.textColor = [UIColor whiteColor];
    [topBackView addSubview:titleL];
    [titleL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(topBackView.mas_centerX);
        make.centerY.equalTo(topBackView.mas_centerY).with.offset(KMARGIN);
    }];
    
    UIView *textView = [[UIView alloc]init];
    textView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:textView];
    [textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.offset(0);
        make.top.offset(KMARGIN +KNAVHEIGHT);
        make.height.equalTo(@44);
    }];
    
    self.nameTextFiled = [[UITextField alloc]init];
    self.nameTextFiled.text = self.name;
    self.nameTextFiled.delegate = self;
    self.nameTextFiled.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.nameTextFiled.backgroundColor = [UIColor whiteColor];
    self.nameTextFiled.returnKeyType = UIReturnKeyDone;
    [self.nameTextFiled becomeFirstResponder];
    [textView addSubview:self.nameTextFiled];
    [self.nameTextFiled mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.top.bottom.offset(0);
        make.left.offset(KMARGIN);
    }];
    
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    self.doneBtn.enabled = YES;
    return YES;
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField{
    
    if ([textField.text isEqualToString:self.name]) {
        self.doneBtn.enabled = NO;
    }
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    [textField resignFirstResponder];
    return YES;
}

- (void)clickBackBtn{
    
    [self.nameTextFiled resignFirstResponder];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)clickDoneBtn{
    
    NSDictionary *dict = [NSDictionary dictionaryWithObject:self.nameTextFiled.text forKey:CHANGEINFO_KEY];
    [JP_NotificationCenter postNotificationName:CHANGENAMESUCCESS object:nil userInfo:dict];
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
