//
//  ContactsViewController.m
//  WeChat_Djp
//
//  Created by tztddong on 16/7/8.
//  Copyright © 2016年 dongjiangpeng. All rights reserved.
//

#import "ContactsViewController.h"
#import "AddFriendController.h"

@interface ContactsViewController ()<EMContactManagerDelegate>

@end

@implementation ContactsViewController
- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = NO;
    
}

- (void)viewWillDisappear:(BOOL)animated{
    
    [super viewWillDisappear:animated];
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //添加 加号
    UIBarButtonItem *rightitem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addFriend)];
    self.navigationItem.rightBarButtonItem = rightitem;
    
    //好友操作的代理添加
//    [[EMClient sharedClient].contactManager addDelegate:self delegateQueue:nil];
}

- (void)addFriend{
    
    AddFriendController *friendCtrl = [[AddFriendController alloc]init];
    self.tabBarController.tabBar.hidden = YES;
    [self.navigationController pushViewController:friendCtrl animated:YES];
}


- (void)dealloc{
//    [[EMClient sharedClient].contactManager removeDelegate:self];
}
@end
