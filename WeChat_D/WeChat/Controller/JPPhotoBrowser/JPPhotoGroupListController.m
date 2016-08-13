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
    
    UIButton *cancleBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 30, 30)];
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
    }

    
    [self setTableView];
    
    //获取相册列表
    [[JPPhotoManager sharedPhotoManager] getPhotoGroupWithBlock:^(NSArray *groupArray) {
        [self.groupDataArray removeAllObjects];
        [self.groupDataArray addObjectsFromArray:groupArray];
        [groupTableView reloadData];
    }];
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
    photoListCtrl.groupModel = groupModel;
    [self.navigationController pushViewController:photoListCtrl animated:YES];
}

//- (void)getImageGroupData{
//    
//    NSString *tipTextWhenNoPhotosAuthorization; // 提示语
//    // 获取当前应用对照片的访问授权状态
//    ALAuthorizationStatus authorizationStatus = [ALAssetsLibrary authorizationStatus];
//    // 如果没有获取访问授权，或者访问授权状态已经被明确禁止，则显示提示语，引导用户开启授权
//    if (authorizationStatus == ALAuthorizationStatusRestricted || authorizationStatus == ALAuthorizationStatusDenied) {
//        NSDictionary *mainInfoDictionary = [[NSBundle mainBundle] infoDictionary];
//        NSString *appName = [mainInfoDictionary objectForKey:@"CFBundleDisplayName"];
//        tipTextWhenNoPhotosAuthorization = [NSString stringWithFormat:@"请在设备的\"设置-隐私-照片\"选项中，允许%@访问你的手机相册", appName];
//        // 展示提示语
//    }
//    /*
//     实例一个 AssetsLibrary 后，如上面所示，我们可以通过一系列枚举方法获取到需要的相册和资源，并把其储存到数组中，方便用于展示。但是，当我们把这些获取到的相册和资源储存到数组时，实际上只是在数组中储存了这些相册和资源在 AssetsLibrary 中的引用（指针），因而无论把相册和资源储存数组后如何利用这些数据，都首先需要确保 AssetsLibrary 没有被 ARC 释放，否则把数据从数组中取出来时，会发现对应的引用数据已经丢失（参见下图）。这一点较为容易被忽略，因此建议在使用 AssetsLibrary 的 viewController 中，把 AssetsLibrary 作为一个强持有的 property 或私有变量，避免在枚举出 AssetsLibrary 中所需要的数据后，AssetsLibrary 就被 ARC 释放了。
//     */
//    ALAssetsLibrary *assetLibrary = [[ALAssetsLibrary alloc]init];
////    self.assetLibrary = assetLibrary;
//    [assetLibrary enumerateGroupsWithTypes:ALAssetsGroupAll usingBlock:^(ALAssetsGroup *group, BOOL *stop) {
//        if (group) {
//            [group setAssetsFilter:[ALAssetsFilter allAssets]];
//            if ([group numberOfAssets] > 0) {
//                // 把相册储存到数组中，方便后面展示相册时使用
//                //直接将数据存储在模型中
//                JPPhotoGroupModel *groupModel = [[JPPhotoGroupModel alloc]init];
//                groupModel.groupName = [group valueForProperty:@"ALAssetsGroupPropertyName"];
//                groupModel.thumbImage = [UIImage imageWithCGImage:[group posterImage]];
//                groupModel.assetsCount = [group numberOfAssets];
//                groupModel.group = group;
//                [self.groupDataArray addObject:groupModel];
//            }
//        } else {
//            if ([self.groupDataArray count] > 0) {
//                // 把所有的相册储存完毕，可以展示相册列表
//                [groupTableView reloadData];
//                //遍历找出相机胶卷组 直接打开
//                for (JPPhotoGroupModel *model in self.groupDataArray) {
//                    if ([model.groupName isEqualToString:@"相机胶卷"] || [model.groupName isEqualToString:@"Camera Roll"] ) {
//                        JPPhotoListController *photoListCtrl = [[JPPhotoListController alloc]init];
//                        photoListCtrl.group = model.group;
//                        photoListCtrl.title = model.groupName;
//                        [self.navigationController pushViewController:photoListCtrl animated:NO];
//                    }
//                }
//            } else {
//                // 没有任何有资源的相册，输出提示
//            }
//        }
//    } failureBlock:^(NSError *error) {
//        
//    }];
//}
///*
//#pragma mark - Navigation
//
//// In a storyboard-based application, you will often want to do a little preparation before navigation
//- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
//    // Get the new view controller using [segue destinationViewController].
//    // Pass the selected object to the new view controller.
//}
//*/

@end
