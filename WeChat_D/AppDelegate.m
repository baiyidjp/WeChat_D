//
//  AppDelegate.m
//  WeChat_Djp
//
//  Created by tztddong on 16/7/8.
//  Copyright © 2016年 dongjiangpeng. All rights reserved.
//

#import "AppDelegate.h"
#import "MainTabbarController.h"
#import "LoginViewController.h"

#define AppKey @"djp7393#wechatdjp"
#define ApnsCertName @"";
@interface AppDelegate ()<EMClientDelegate,EMContactManagerDelegate>

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    [self changeNav];
    
    EMOptions *option = [EMOptions optionsWithAppkey:AppKey];
    option.apnsCertName = ApnsCertName;
    [[EMClient sharedClient]initializeSDKWithOptions:option];
    
    //回调监听代理
    [[EMClient sharedClient] addDelegate:self delegateQueue:nil];
    [[EMClient sharedClient].contactManager addDelegate:self delegateQueue:nil];
    
    self.window = [[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
    
    //判断是否自动登录
    BOOL isAutoLogin = [EMClient sharedClient].isAutoLogin;
    if (isAutoLogin){
        [[NSNotificationCenter defaultCenter] postNotificationName:KNOTIFICATION_LOGINCHANGE object:@YES];
        MainTabbarController *mainController = [[MainTabbarController alloc]init];
        self.window.rootViewController = mainController;
        [self.window makeKeyAndVisible];
        
    }
    else
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:KNOTIFICATION_LOGINCHANGE object:@NO];
        LoginViewController *mainController = [[LoginViewController alloc]init];
        self.window.rootViewController = mainController;
        [self.window makeKeyAndVisible];
    }
    
    return YES;
}

//自动登录是否成功
- (void)didAutoLoginWithError:(EMError *)aError{
    if (!aError) {
        NSLog(@"Auto login success");
    }else{
        NSLog(@"Auto login erreo,%@",aError);
        
    }
}

/*
 *  当前登录账号在其它设备登录时会接收到该回调
 */
- (void)didLoginFromOtherDevice{
    
    NSLog(@"当前登录账号在其它设备登录时会接收到该回调");
}

/*
 *  当前登录账号已经被从服务器端删除时会收到该回调
 */
- (void)didRemovedFromServer{
    
    NSLog(@"当前登录账号已经被从服务器端删除时会收到该回调");
}

/*!
 *  用户B同意用户A的加好友请求后，用户A会收到这个回调
 *
 *  @param aUsername   用户B
 */
- (void)didReceiveAgreedFromUsername:(NSString *)aUsername{
    
    UIAlertController *alertCtrl = [UIAlertController alertControllerWithTitle:aUsername message:@"同意了您的好友申请" preferredStyle:UIAlertControllerStyleAlert];
    [alertCtrl addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:nil]];
    [self.window.rootViewController presentViewController:alertCtrl animated:YES completion:nil];
}

/*!
 *  \~chinese
 *  用户B拒绝用户A的加好友请求后，用户A会收到这个回调
 *
 *  @param aUsername   用户B
 */
- (void)didReceiveDeclinedFromUsername:(NSString *)aUsername{
    
    UIAlertController *alertCtrl = [UIAlertController alertControllerWithTitle:aUsername message:@"拒绝了您的好友申请" preferredStyle:UIAlertControllerStyleAlert];
    [alertCtrl addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:nil]];
    [self.window.rootViewController presentViewController:alertCtrl animated:YES completion:nil];
    
}

/*!
 *  \~chinese
 *  用户B删除与用户A的好友关系后，用户A会收到这个回调
 *
 *  @param aUsername   用户B
 */
- (void)didReceiveDeletedFromUsername:(NSString *)aUsername{
    
    UIAlertController *alertCtrl = [UIAlertController alertControllerWithTitle:aUsername message:@"解除了与您的好友关系" preferredStyle:UIAlertControllerStyleAlert];
    [alertCtrl addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:nil]];
    [self.window.rootViewController presentViewController:alertCtrl animated:YES completion:nil];
}

/*!
 *  \~chinese
 *  用户B申请加A为好友后，用户A会收到这个回调
 *
 *  @param aUsername   用户B
 *  @param aMessage    好友邀请信息
 */
- (void)didReceiveFriendInvitationFromUsername:(NSString *)aUsername
                                       message:(NSString *)aMessage{
    
    UIAlertController *alertCtrl = [UIAlertController alertControllerWithTitle:[NSString stringWithFormat:@"%@的好友申请",aUsername] message:aMessage preferredStyle:UIAlertControllerStyleAlert];
    [alertCtrl addAction:[UIAlertAction actionWithTitle:@"拒绝" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action){
        
        [SVProgressHUD show];
        [[EMClient sharedClient].contactManager asyncDeclineInvitationForUsername:aUsername success:^{
            dispatch_async(dispatch_get_main_queue(), ^{
                [SVProgressHUD showSuccessWithStatus:@"已拒绝"];
            });
            
        } failure:^(EMError *aError) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [SVProgressHUD showSuccessWithStatus:@"拒绝失败"];
            });
            
        }];
        
    }]];
    [alertCtrl addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        //添加好友
        [SVProgressHUD show];
        [[EMClient sharedClient].contactManager asyncAcceptInvitationForUsername:aUsername success:^{
            dispatch_async(dispatch_get_main_queue(), ^{
                [SVProgressHUD showSuccessWithStatus:@"添加成功"];
            });
            
        } failure:^(EMError *aError) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [SVProgressHUD showSuccessWithStatus:@"添加失败"];
            });
            
        }];
    }]];
    [self.window.rootViewController presentViewController:alertCtrl animated:YES completion:nil];
    
}


//移除代理
- (void)dealloc{
    
    [[EMClient sharedClient] removeDelegate:self];
    [[EMClient sharedClient].contactManager removeDelegate:self];
}

/**
 *  全局改变Nav
 */
- (void)changeNav{
    
    //设置NavigationBar背景颜色
    [[UINavigationBar appearance] setBarTintColor:[UIColor colorWithRed:54/255.0 green:53/255.0 blue:58/255.0 alpha:1]];
    //@{}代表Dictionary
    [[UINavigationBar appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    //设置item字体的颜色
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    //不设置这个无法修改状态栏字体颜色
    [[UINavigationBar appearance] setBarStyle:UIBarStyleBlack];
}

//#pragma mark - login changed
//
//- (void)loginStateChange:(NSNotification *)notification
//{
//    BOOL loginSuccess = [notification.object boolValue];
//}


// APP进入后台
- (void)applicationDidEnterBackground:(UIApplication *)application
{
    [[EMClient sharedClient] applicationDidEnterBackground:application];
}

// APP将要从后台返回
- (void)applicationWillEnterForeground:(UIApplication *)application
{
    [[EMClient sharedClient] applicationWillEnterForeground:application];
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
