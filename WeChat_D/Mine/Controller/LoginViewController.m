//
//  LoginViewController.m
//  WeChat_D
//
//  Created by Keep丶Dream on 16/7/16.
//  Copyright © 2016年 dongjiangpeng. All rights reserved.
//

#import "LoginViewController.h"
#import "MainTabbarController.h"

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
    userTextFiled.text = [self lastLoginUsername];
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
    
    if (![self textIsEmpty]) {
        [self.view endEditing:YES];
        WEAK_SELF(weakSelf);
        //异步登陆 先判断是否有自动登录
        BOOL isAutoLogin = [EMClient sharedClient].options.isAutoLogin;
        if (!isAutoLogin) {
            [SVProgressHUD show];
            dispatch_async(dispatch_get_global_queue(0, 0), ^{
                EMError *error = [[EMClient sharedClient] loginWithUsername:userTextFiled.text password:passWordTextFiled.text];
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (!error) {
                        SVProgressHUD.minimumDismissTimeInterval = 1.0;
                        [SVProgressHUD showSuccessWithStatus:@"登录成功"];
                        //设置是否自动登录
                        [[EMClient sharedClient].options setIsAutoLogin:YES];
                        //保存当前登录账号
                        [weakSelf saveLastLoginUsername];
                        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                            if ([[UIApplication sharedApplication].keyWindow.rootViewController isKindOfClass:[self class]]) {
                                
                                MainTabbarController *mainController = [[MainTabbarController alloc]init];
                                [UIApplication sharedApplication].keyWindow.rootViewController = mainController;
                            }else{
                                [self.navigationController popViewControllerAnimated:YES];
                            }

                        });
                    }
                });
            });
        }
    }

}

- (void)registerBtn{
    
    if (![self textIsEmpty]) {
        //隐藏键盘
        [self.view endEditing:YES];
        WEAK_SELF(weakSelf);
        //异步线程注册
        [SVProgressHUD show];
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
           
            EMError *error = [[EMClient sharedClient] registerWithUsername:userTextFiled.text password:passWordTextFiled.text];
            //回到主线程进行判断
            dispatch_async(dispatch_get_main_queue(), ^{
                SVProgressHUD.minimumDismissTimeInterval = 1.0;
                if (!error) {
                    //注册成功
                    [SVProgressHUD showSuccessWithStatus:@"注册成功"];
                }else{
//                    [SVProgressHUD showErrorWithStatus:@"注册失败"];
                    switch (error.code) {
                        case EMErrorServerNotReachable:
                            [weakSelf.view makeToast:@"error.connectServerFail---Connect to the server failed!"];
                            break;
                        case EMErrorUserAlreadyExist:
                            [weakSelf.view makeToast:@"register.repeat---You registered user already exists!"];
                            break;
                        case EMErrorNetworkUnavailable:
                            [weakSelf.view makeToast:@"error.connectNetworkFail--No network connection!"];
                            break;
                        case EMErrorServerTimeout:
                            [weakSelf.view makeToast:@"error.connectServerTimeout---Connect to the server timed out!"];
                            break;
                        default:
                            [weakSelf.view makeToast:@"register.fail---Registration failed"];
                            break;
                    }

                }
            });
            
        });
    }

}

- (BOOL)textIsEmpty{
    
    BOOL empty = NO;
    NSString *userName = userTextFiled.text;
    NSString *password = passWordTextFiled.text;
    if (userName.length == 0 || password.length == 0) {
        NSLog(@"请输入账号或者密码");
        empty = YES;
    }
    return empty;
}

#pragma  mark - private  保存最近登录账号 取出最近登录账号
- (void)saveLastLoginUsername
{
    NSString *username = [[EMClient sharedClient] currentUsername];
    if (username && username.length > 0) {
        NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
        [ud setObject:username forKey:[NSString stringWithFormat:@"em_lastLogin_username"]];
        [ud synchronize];
    }
}

- (NSString*)lastLoginUsername
{
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSString *username = [ud objectForKey:[NSString stringWithFormat:@"em_lastLogin_username"]];
    if (username && username.length > 0) {
        return username;
    }
    return nil;
}

@end
