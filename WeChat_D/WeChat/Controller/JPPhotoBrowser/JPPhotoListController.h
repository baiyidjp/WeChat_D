//
//  JPPhotoListController.h
//  WeChat_D
//
//  Created by tztddong on 16/8/10.
//  Copyright © 2016年 dongjiangpeng. All rights reserved.
//

#import "BaseViewController.h"
#import <AssetsLibrary/AssetsLibrary.h>

@class JPPhotoGroupModel;
@interface JPPhotoListController : BaseViewController
@property (nonatomic , strong) ALAssetsGroup *group;
/** name */
@property(nonatomic,strong) JPPhotoGroupModel *groupModel;

@end
