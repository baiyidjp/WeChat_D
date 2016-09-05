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
@interface AppDelegate ()<EMClientDelegate,EMContactManagerDelegate,EMChatManagerDelegate,EMGroupManagerDelegate>

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
//    [self changeNav];
    
    EMOptions *option = [EMOptions optionsWithAppkey:AppKey];
    option.apnsCertName = ApnsCertName;
    [[EMClient sharedClient]initializeSDKWithOptions:option];
    
    //回调监听代理
    [[EMClient sharedClient] addDelegate:self delegateQueue:nil];
    [[EMClient sharedClient].contactManager addDelegate:self delegateQueue:nil];//通讯管理
    [[EMClient sharedClient].chatManager addDelegate:self delegateQueue:nil];//聊天管理
    [[EMClient sharedClient].groupManager addDelegate:self delegateQueue:nil]; //群组管理
    
    self.window = [[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
    
    //判断是否自动登录
    BOOL isAutoLogin = [EMClient sharedClient].isAutoLogin;
    if (isAutoLogin){
        MainTabbarController *mainController = [[MainTabbarController alloc]init];
        self.window.rootViewController = mainController;
        [self.window makeKeyAndVisible];
        
    }
    else
    {
        LoginViewController *mainController = [[LoginViewController alloc]init];
        self.window.rootViewController = mainController;
        [self.window makeKeyAndVisible];
    }
    
    return YES;
}

/*!
 *  SDK连接服务器的状态变化时会接收到该回调
 *
 *  有以下几种情况，会引起该方法的调用：
 *  1. 登录成功后，手机无法上网时，会调用该回调
 *  2. 登录成功后，网络状态变化时，会调用该回调
 *
 *  @param aConnectionState 当前状态
 */
- (void)didConnectionStateChanged:(EMConnectionState)aConnectionState{
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    switch (aConnectionState) {
        case EMConnectionConnected:
            NSLog(@"网络已连接");
            [dict setObject:@1 forKey:@"isConnect"];
            [JP_NotificationCenter postNotificationName:NETWORKSTATE object:nil userInfo:dict];
            break;
        case EMConnectionDisconnected:
            NSLog(@"网络断开");
            [dict setObject:@0 forKey:@"isConnect"];
            [JP_NotificationCenter postNotificationName:NETWORKSTATE object:nil userInfo:dict];
            break;
        default:
            break;
    }
}

//自动登录是否成功
- (void)didAutoLoginWithError:(EMError *)aError{
    if (!aError) {
        NSLog(@"Auto login success");
        [JP_NotificationCenter postNotificationName:AUTOLOGINSUCCESS object:nil];
    }else{
        NSLog(@"Auto login erreo,%@",aError);
        
    }
}

/*
 *  当前登录账号在其它设备登录时会接收到该回调
 */
- (void)didLoginFromOtherDevice{
    
    UIAlertController *alertCtrl = [UIAlertController alertControllerWithTitle:@"当前登录账号在其它设备登录" message:@"如非本人操作,请及时修改密码" preferredStyle:UIAlertControllerStyleAlert];
    [alertCtrl addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        LoginViewController *loginController = [[LoginViewController alloc]init];
        [self.window.rootViewController presentViewController:loginController animated:YES completion:nil];
    }]];
    [self.window.rootViewController presentViewController:alertCtrl animated:YES completion:nil];
}

/*
 *  当前登录账号已经被从服务器端删除时会收到该回调
 */
- (void)didRemovedFromServer{
    
    UIAlertController *alertCtrl = [UIAlertController alertControllerWithTitle:@"当前登录账号已被从服务器删除" message:@"请联系客户解决,电话-110" preferredStyle:UIAlertControllerStyleAlert];
    [alertCtrl addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        LoginViewController *loginController = [[LoginViewController alloc]init];
        [self.window.rootViewController presentViewController:loginController animated:YES completion:nil];
    }]];
    [self.window.rootViewController presentViewController:alertCtrl animated:YES completion:nil];

}

/*!
 *  用户B同意用户A的加好友请求后，用户A会收到这个回调
 *
 *  @param aUsername   用户B
 */
- (void)didReceiveAgreedFromUsername:(NSString *)aUsername{
    
    UIAlertController *alertCtrl = [UIAlertController alertControllerWithTitle:aUsername message:@"同意了您的好友申请" preferredStyle:UIAlertControllerStyleAlert];
    [alertCtrl addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        NSDictionary *dict = [NSDictionary dictionaryWithObject:aUsername forKey:@"name"];
        [JP_NotificationCenter postNotificationName:ADDFRIENDSUCCESS object:nil userInfo:dict];
    }]];


    [self.window.rootViewController presentViewController:alertCtrl animated:YES completion:nil];
}

/*!
 *  \~chinese
 *  用户B同意用户A的好友申请后，用户A和用户B都会收到这个回调
 *
 *  @param aUsername   用户好友关系的另一方
 */
- (void)didReceiveAddedFromUsername:(NSString *)aUsername{
    
//    [JP_NotificationCenter postNotificationName:AGREEFRIENDSUCCESS object:nil];
    
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
 *  用户B删除与用户A的好友关系后，用户A和B会收到这个回调
 *
 *  @param aUsername   用户B
 */
- (void)didReceiveDeletedFromUsername:(NSString *)aUsername{
    
    [JP_NotificationCenter postNotificationName:DELECTFRIENDSUEESS object:nil];
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
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:aMessage forKey:NewFriendMessage];
    [dict setObject:aUsername forKey:NewFriendName];
    [JP_NotificationCenter postNotificationName:NEWFRIENDREQUEST object:nil userInfo:dict];
    
}
//接收消息
- (void)didReceiveMessages:(NSArray *)aMessages{
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:aMessages forKey:@"Message"];
    [JP_NotificationCenter postNotificationName:RECEIVEMESSAGES object:nil userInfo:dict];
}
/*!
 *  \~chinese
 *  SDK自动同意了用户A的加B入群邀请后，用户B接收到该回调，需要设置EMOptions的isAutoAcceptGroupInvitation为YES
 *
 *  @param aGroup    群组实例
 *  @param aInviter  邀请者
 *  @param aMessage  邀请消息
 */
- (void)didJoinedGroup:(EMGroup *)aGroup
               inviter:(NSString *)aInviter
               message:(NSString *)aMessage{
    UIAlertController *alertCtrl = [UIAlertController alertControllerWithTitle:aInviter message:aMessage preferredStyle:UIAlertControllerStyleAlert];
    [alertCtrl addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        [dict setObject:aGroup forKey:GroupValue];
        [dict setObject:aInviter forKey:GroupInviter];
        [dict setObject:aMessage forKey:GroupInviterMessage];
        [JP_NotificationCenter postNotificationName:RECEIVEGROUPINVITE object:nil userInfo:dict];
    }]];
    [self.window.rootViewController presentViewController:alertCtrl animated:YES completion:nil];

}

//移除代理
- (void)dealloc{
    
    [[EMClient sharedClient] removeDelegate:self];
    [[EMClient sharedClient].contactManager removeDelegate:self];
    [[EMClient sharedClient].chatManager removeDelegate:self];
    [[EMClient sharedClient].groupManager removeDelegate:self];
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
