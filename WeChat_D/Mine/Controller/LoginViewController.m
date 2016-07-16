//
//  LoginViewController.m
//  WeChat_D
//
//  Created by Keep丶Dream on 16/7/16.
//  Copyright © 2016年 dongjiangpeng. All rights reserved.
//

#import "LoginViewController.h"

@interface LoginViewController ()<UITextFieldDelegate>

@end

@implementation LoginViewController
{
    UITextField *userTextFiled;
    UITextField *passWordTextFiled;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"登录/注册";
    
    userTextFiled = [[UITextField alloc]init];
    userTextFiled.delegate = self;
    userTextFiled.layer.borderWidth = 1;
    userTextFiled.layer.borderColor = [UIColor purpleColor].CGColor;
    userTextFiled.layer.cornerRadius = 5;
    userTextFiled.placeholder = @"请输入账号";
    userTextFiled.font = FONTSIZE(15);
    userTextFiled.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
    userTextFiled.returnKeyType = UIReturnKeyNext;
    userTextFiled.clearButtonMode = UITextFieldViewModeWhileEditing;
    [self.view addSubview:userTextFiled];
    [userTextFiled mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(KNAVHEIGHT*2);
        make.left.offset(3*KMARGIN);
        make.right.offset(-3*KMARGIN);
        make.height.equalTo(@44);
    }];
    
    passWordTextFiled = [[UITextField alloc]init];
    passWordTextFiled.delegate = self;
    passWordTextFiled.layer.borderWidth = 1;
    passWordTextFiled.layer.borderColor = [UIColor purpleColor].CGColor;
    passWordTextFiled.layer.cornerRadius = 5;
    passWordTextFiled.placeholder = @"请输入密码";
    passWordTextFiled.font = FONTSIZE(15);
    passWordTextFiled.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
    passWordTextFiled.returnKeyType = UIReturnKeyDone;
    passWordTextFiled.clearButtonMode = UITextFieldViewModeWhileEditing;
    passWordTextFiled.secureTextEntry = YES;
    [self.view addSubview:passWordTextFiled];
    [passWordTextFiled mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(userTextFiled.mas_bottom).with.offset(KMARGIN);
        make.left.offset(3*KMARGIN);
        make.right.offset(-3*KMARGIN);
        make.height.equalTo(@44);
    }];
    
    UIButton *loginBtn = [[UIButton alloc]init];
    [loginBtn setTitle:@"login" forState:UIControlStateNormal];
    [loginBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [loginBtn addTarget:self action:@selector(login) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:loginBtn];
    [loginBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(passWordTextFiled.mas_bottom).with.offset(KMARGIN*2);
        make.left.equalTo(passWordTextFiled);
    }];
    
    UIButton *registerBtn = [[UIButton alloc]init];
    [registerBtn setTitle:@"register" forState:UIControlStateNormal];
    [registerBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [registerBtn addTarget:self action:@selector(registerBtn) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:registerBtn];
    [registerBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(passWordTextFiled.mas_bottom).with.offset(KMARGIN*2);
        make.right.equalTo(passWordTextFiled);
    }];

    
}

- (void)login{
    
}

- (void)registerBtn{

}


@end
