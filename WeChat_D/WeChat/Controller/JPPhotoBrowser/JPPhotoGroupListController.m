//
//  JPPhotoGroupListController.m
//  WeChat_D
//
//  Created by tztddong on 16/8/10.
//  Copyright © 2016年 dongjiangpeng. All rights reserved.
//

#import "JPPhotoGroupListController.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "JPPhotoGroupModel.h"
#import "JPPhotoGroupCell.h"
#import "JPPhotoListController.h"
#import "JPPhotoManager.h"
#import "JPALAssetLibraryManager.h"

#define GroupCellID @"JPPhotoGroupCell"
@interface JPPhotoGroupListController ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)NSMutableArray *groupDataArray;
@end

@implementation JPPhotoGroupListController
{
    UITableView *groupTableView;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"照片";
    
    UIButton *cancleBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 32, 32)];
    [cancleBtn setTitle:@"取消" forState:UIControlStateNormal];
    [cancleBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [cancleBtn.titleLabel setFont:FONTSIZE(15)];
    [cancleBtn addTarget:self action:@selector(clickCancleBtn) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc]initWithCustomView:cancleBtn];
    self.navigationItem.rightBarButtonItem = item;
    
    NSString *tipTextWhenNoPhotosAuthorization; // 提示语
    // 获取当前应用对照片的访问授权状态
    ALAuthorizationStatus authorizationStatus = [ALAssetsLibrary authorizationStatus]; 
    // 如果没有获取访问授权，或者访问授权状态已经被明确禁止，则显示提示语，引导用户开启授权
    if (authorizationStatus == ALAuthorizationStatusRestricted || authorizationStatus == ALAuthorizationStatusDenied) {
        NSDictionary *mainInfoDictionary = [[NSBundle mainBundle] infoDictionary];
        NSString *appName = [mainInfoDictionary objectForKey:@"CFBundleDisplayName"];
        tipTextWhenNoPhotosAuthorization = [NSString stringWithFormat:@"请在设备的\"设置-隐私-照片\"选项中，允许%@访问你的手机相册", appName];
        // 展示提示语
    }else{
    
        [self setTableView];
        
        //获取相册列表
        [[JPPhotoManager sharedPhotoManager] getPhotoGroupWithBlock:^(NSArray *groupArray) {
            
            [self.groupDataArray addObjectsFromArray:groupArray];
            [groupTableView reloadData];
            //        遍历找出相机胶卷组 直接打开
            for (JPPhotoGroupModel *model in self.groupDataArray) {
                if ([model.groupName isEqualToString:@"相机胶卷"] || [model.groupName isEqualToString:@"Camera Roll"] ) {
                    JPPhotoListController *photoListCtrl = [[JPPhotoListController alloc]init];
                    photoListCtrl.groupModel = model;
                    photoListCtrl.title = model.groupName;
                    [self.navigationController pushViewController:photoListCtrl animated:NO];
                }
            }
            
        }];
    }

    
}

- (void)clickCancleBtn{
    
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

- (NSMutableArray *)groupDataArray{
    
    if (!_groupDataArray) {
        _groupDataArray = [NSMutableArray array];
    }
    return _groupDataArray;
}

- (void)setTableView{
    
    groupTableView = [[UITableView alloc]init];
    groupTableView.delegate = self;
    groupTableView.dataSource = self;
    [groupTableView registerClass:[JPPhotoGroupCell class] forCellReuseIdentifier:GroupCellID];
    groupTableView.tableFooterView = [[UIView alloc]init];
    groupTableView.rowHeight = 80;
    [self.view addSubview:groupTableView];
    [groupTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(0);
        make.left.right.bottom.offset(0);
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.groupDataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    JPPhotoGroupCell *cell = [tableView dequeueReusableCellWithIdentifier:GroupCellID];
    cell.groupModel = [self.groupDataArray objectAtIndex:indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    JPPhotoGroupModel *groupModel = [self.groupDataArray objectAtIndex:indexPath.row];
    JPPhotoListController *photoListCtrl = [[JPPhotoListController alloc]init];
    photoListCtrl.title = groupModel.groupName;
    photoListCtrl.groupModel = groupModel;
    [self.navigationController pushViewController:photoListCtrl animated:YES];
}


@end
