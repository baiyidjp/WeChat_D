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
    
    UIButton *cancleBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 30, 30)];
    [cancleBtn setTitle:@"取消" forState:UIControlStateNormal];
    [cancleBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [cancleBtn.titleLabel setFont:FONTSIZE(15)];
    [cancleBtn addTarget:self action:@selector(clickCancleBtn) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc]initWithCustomView:cancleBtn];
    self.navigationItem.rightBarButtonItem = item;
    
    [self setTableView];
    [self getImageGroupData];
    
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
    photoListCtrl.group = groupModel.group;
    photoListCtrl.title = groupModel.groupName;
    [self.navigationController pushViewController:photoListCtrl animated:YES];
}

- (void)getImageGroupData{
    
    NSString *tipTextWhenNoPhotosAuthorization; // 提示语
    // 获取当前应用对照片的访问授权状态
    ALAuthorizationStatus authorizationStatus = [ALAssetsLibrary authorizationStatus];
    // 如果没有获取访问授权，或者访问授权状态已经被明确禁止，则显示提示语，引导用户开启授权
    if (authorizationStatus == ALAuthorizationStatusRestricted || authorizationStatus == ALAuthorizationStatusDenied) {
        NSDictionary *mainInfoDictionary = [[NSBundle mainBundle] infoDictionary];
        NSString *appName = [mainInfoDictionary objectForKey:@"CFBundleDisplayName"];
        tipTextWhenNoPhotosAuthorization = [NSString stringWithFormat:@"请在设备的\"设置-隐私-照片\"选项中，允许%@访问你的手机相册", appName];
        // 展示提示语
    }
    
    ALAssetsLibrary *assetLibrary = [[ALAssetsLibrary alloc]init];
    [assetLibrary enumerateGroupsWithTypes:ALAssetsGroupAll usingBlock:^(ALAssetsGroup *group, BOOL *stop) {
        if (group) {
            [group setAssetsFilter:[ALAssetsFilter allAssets]];
            if ([group numberOfAssets] > 0) {
                // 把相册储存到数组中，方便后面展示相册时使用
                //直接将数据存储在模型中
                JPPhotoGroupModel *groupModel = [[JPPhotoGroupModel alloc]init];
                groupModel.groupName = [group valueForProperty:@"ALAssetsGroupPropertyName"];
                groupModel.thumbImage = [UIImage imageWithCGImage:[group posterImage]];
                groupModel.assetsCount = [group numberOfAssets];
                groupModel.group = group;
                [self.groupDataArray addObject:groupModel];
            }
        } else {
            if ([self.groupDataArray count] > 0) {
                // 把所有的相册储存完毕，可以展示相册列表
                [groupTableView reloadData];
            } else {
                // 没有任何有资源的相册，输出提示
            }
        }
    } failureBlock:^(NSError *error) {
        
    }];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
