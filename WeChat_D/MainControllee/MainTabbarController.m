//
//  MainTabbarController.m
//  ImatateWeChat
//
//  Created by tztddong on 16/7/8.
//  Copyright © 2016年 dongjiangpeng. All rights reserved.
//

#import "MainTabbarController.h"
#import "WeChatViewController.h"
#import "ContactsViewController.h"
#import "DiscoverViewController.h"
#import "MineViewController.h"

@interface MainTabbarController ()

@end

@implementation MainTabbarController

- (void)viewDidLoad {
    [super viewDidLoad];

    NSArray *titleArray = @[@"微信",@"通讯录",@"发现",@"我"];
    NSArray *imageArray = @[@"tabbar_mainframe_25x23_",@"tabbar_contacts_27x23_",@"tabbar_discover_23x23_",@"tabbar_me_23x23_"];
    NSArray *selectImageArray = @[@"tabbar_mainframeHL_25x23_",@"tabbar_contactsHL_27x23_@2x",@"tabbar_discoverHL_23x23_",@"tabbar_meHL_23x23_"];
    WeChatViewController *weChatCtrl = [[WeChatViewController alloc]init];
    ContactsViewController *contactsCtrl = [[ContactsViewController alloc]init];
    DiscoverViewController *discoverCtrl = [[DiscoverViewController alloc]init];
    MineViewController *mineCtrl = [[MineViewController alloc]init];
    NSArray *ctrlArray = @[weChatCtrl,contactsCtrl,discoverCtrl,mineCtrl];
    
    for (NSInteger i = 0; i < titleArray.count; i++) {
        [self setControllersWithController:ctrlArray[i] Title:titleArray[i] ImageName:imageArray[i] SelectImageName:selectImageArray[i]];
    }
}

- (void)setControllersWithController:(UIViewController *)controller Title:(NSString *)title ImageName:(NSString *)imageName SelectImageName:(NSString *)selectImageName{
    
    controller.view.backgroundColor = [UIColor colorWithHexString:@"f4f4f4"];
    controller.title = title;
    controller.tabBarItem.title = title;
    controller.tabBarItem.image = [UIImage imageNamed:imageName];
    controller.tabBarItem.selectedImage = [[UIImage imageNamed:selectImageName] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    [controller.tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor colorWithHexString:@"000000"]} forState:UIControlStateSelected];
    [controller.tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor colorWithHexString:@"888888"]} forState:UIControlStateNormal];
    UINavigationController *navCtrl = [[UINavigationController alloc]initWithRootViewController:controller];
    [self addChildViewController:navCtrl];
    
}

- (UIViewController *)childViewControllerForStatusBarStyle{
    
    return [self.childViewControllers objectAtIndex:0];
}
@end
