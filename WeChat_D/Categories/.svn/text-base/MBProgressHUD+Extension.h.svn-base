//
//  MBProgressHUD+Extension.h
//
//  Created by apple on 14-8-8.
//  Copyright (c) 2014年 itcast. All rights reserved.
//

#import "MBProgressHUD.h"

#define MBPROGRESSHUD_SHOWLOADINGWITH(view) [MBProgressHUD showLoading:view]//显示loading
#define MBPROGRESSHUD_HIDELOADINGWITH(view) [MBProgressHUD hideHUDForView:view]//隐藏loading
#define MBPROGRESSHUD_ERRORDESC [MBProgressHUD showError:[result objectForKey:@"result_desc"]]//错误信息
#define MBPROGRESSHUD_TIMEOUT [MBProgressHUD showError:@"请求超时"]//请求超时
@interface MBProgressHUD (Extension)
+ (void)showSuccess:(NSString *)success toView:(UIView *)view;
+ (void)showError:(NSString *)error toView:(UIView *)view;

+ (MBProgressHUD *)showMessage:(NSString *)message toView:(UIView *)view;


+ (void)showSuccess:(NSString *)success;
+ (void)showError:(NSString *)error;

+ (MBProgressHUD *)showMessage:(NSString *)message;

+ (MBProgressHUD *)showLoading:(UIView *)view;

+ (void)hideHUDForView:(UIView *)view;

@end
