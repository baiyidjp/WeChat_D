//
//  MineViewController.m
//  WeChat_Djp
//
//  Created by tztddong on 16/7/8.
//  Copyright © 2016年 dongjiangpeng. All rights reserved.
//

#import "MineViewController.h"
#import "LoginViewController.h"
#import "MyInfoController.h"

@interface MineViewController ()<UITableViewDelegate,UITableViewDataSource>

@end

@implementation MineViewController
{
    UITableView *mineTableView;
    NSMutableArray *dataArray;
    UILabel *nameLabel;
    CGFloat cacheSize;
}
- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    if (mineTableView) {
        [self getSizeWithCacheData];
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:3];
        [mineTableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
    self.tabBarController.tabBar.hidden = NO;
    
}

- (void)viewWillDisappear:(BOOL)animated{
    
    [super viewWillDisappear:animated];
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self getSizeWithCacheData];
    [self configTableView];
    
    [JP_NotificationCenter addObserver:self selector:@selector(loginChange) name:LOGINCHANGE object:nil];
    [JP_NotificationCenter addObserver:self selector:@selector(changeName:) name:CHANGENAMESUCCESS object:nil];
}

#pragma mark 登陆成功的通知
- (void)loginChange{
    
    NSString *locationName = [[NSUserDefaults standardUserDefaults] objectForKey:[EMClient sharedClient].currentUsername];
    if (locationName) {
        nameLabel.text = locationName;
    }else{
        nameLabel.text = [EMClient sharedClient].currentUsername;
    }
}
#pragma mark 改变名字 的通知
- (void)changeName:(NSNotification *)notification{

    NSDictionary *dict = notification.userInfo;
    nameLabel.text = [dict objectForKey:CHANGEINFO_KEY];
    [[NSUserDefaults standardUserDefaults] setObject:nameLabel.text forKey:[EMClient sharedClient].currentUsername];
}
#pragma mark  登录 / 登出
- (void)login{

    LoginViewController *login = [[LoginViewController alloc]init];
    self.tabBarController.tabBar.hidden = YES;
    [self presentViewController:login animated:YES completion:nil];
    
}

- (void)logout{
    
    [SVProgressHUD show];
    [[EMClient sharedClient] asyncLogout:YES success:^{
        dispatch_async(dispatch_get_main_queue(), ^{
            [SVProgressHUD showSuccessWithStatus:@"退出成功"];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self login];
            });
        });
    } failure:^(EMError *aError) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [SVProgressHUD showSuccessWithStatus:@"退出失败"];
        });

    }];
}

- (void)configTableView{
    
    mineTableView = [[UITableView alloc]init];
    mineTableView.delegate = self;
    mineTableView.dataSource = self;
    mineTableView.tableFooterView = [[UIView alloc]init];
    mineTableView.backgroundColor = [UIColor colorWithHexString:@"f4f4f4"];
    [self.view addSubview:mineTableView];
    [mineTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    dataArray = [NSMutableArray array];
    NSArray *infoArr = @[@[@{@"imageName":@"MoreMyAlbum_25x25_",@"title":@"相册"},
                    @{@"imageName":@"MoreMyFavorites_25x25_",@"title":@"收藏"},
                    @{@"imageName":@"MoreMyBankCard_25x25_",@"title":@"钱包"},
                    @{@"imageName":@"MyCardPackageIcon_25x25_",@"title":@"卡包"}],
                @[@{@"imageName":@"MoreExpressionShops_25x25_",@"title":@"表情"}],
                @[@{@"imageName":@"MoreSetting_25x25_",@"title":[NSString stringWithFormat:@"设置(先写成清除缓存)-%.1fM",cacheSize]}]];
    [dataArray addObjectsFromArray:infoArr];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 5;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (section == 1){
        return 4;
    }
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cellid"];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    if (indexPath.section == 0) {
        [self configSectionOneView:cell.contentView];
    }else if (indexPath.section == 4){
        UILabel *logouttext = [[UILabel alloc]init];
        logouttext.text = @"退出登录";
        logouttext.textAlignment = NSTextAlignmentCenter;
        logouttext.font = FONTSIZE(15);
        [cell.contentView addSubview:logouttext];
        cell.accessoryType = UITableViewCellAccessoryNone;
        [logouttext mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.bottom.right.offset(0);
        }];
    }else{
        NSArray *section = [dataArray objectAtIndex:indexPath.section-1];
        NSDictionary *dataDict = [section objectAtIndex:indexPath.row];
        [self configSectionView:cell.contentView data:dataDict];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)configSectionOneView:(UIView *)backView{
    
    UIImageView *headImage = [[UIImageView alloc]init];
    headImage.image = [UIImage imageNamed:DefaultHeadImageName_Message];
    headImage.layer.cornerRadius = 5;
    [backView addSubview:headImage];
    [headImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(KMARGIN);
        make.left.offset(KMARGIN*3/2);
        make.bottom.offset(-KMARGIN);
        make.width.equalTo(@70);
    }];
    
    nameLabel = [[UILabel alloc]init];
    NSString *locationName = [[NSUserDefaults standardUserDefaults] objectForKey:[EMClient sharedClient].currentUsername];
    if (locationName) {
        nameLabel.text = locationName;
    }else{
        nameLabel.text = [EMClient sharedClient].currentUsername;
    }

    nameLabel.font = FONTSIZE(15);
    [backView addSubview:nameLabel];
    [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(headImage.mas_right).with.offset(KMARGIN);
        make.centerY.equalTo(headImage.mas_centerY).with.offset(-KMARGIN*3/2);
    }];
    
    UILabel *codeLabel = [[UILabel alloc]init];
    codeLabel.text = @"微信号码";
    codeLabel.font = FONTSIZE(15);
    [backView addSubview:codeLabel];
    [codeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(headImage.mas_right).with.offset(KMARGIN);
        make.centerY.equalTo(headImage.mas_centerY).with.offset(KMARGIN*3/2);
    }];
    
    UIButton *qrCode = [[UIButton alloc]init];
    [qrCode setBackgroundImage:[UIImage imageNamed:@"setting_myQR_18x18_"] forState:UIControlStateNormal];
    [backView addSubview:qrCode];
    [qrCode mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.offset(0);
        make.centerY.equalTo(backView);
        make.size.mas_equalTo(CGSizeMake(20, 20));
    }];
}

- (void)configSectionView:(UIView *)backView data:(NSDictionary *)dataDict{
    
    UIImageView *image = [[UIImageView alloc]init];
    image.image = [UIImage imageNamed:[dataDict objectForKey:@"imageName"]];
    [backView addSubview:image];
    [image mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(KMARGIN*3/2);
        make.centerY.equalTo(backView);
        make.size.mas_equalTo(CGSizeMake(25, 25));
    }];
    
    UILabel *title = [[UILabel alloc]init];
    title.text = [dataDict objectForKey:@"title"];
    title.font = FONTSIZE(15);
    [backView addSubview:title];
    [title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(image.mas_right).with.offset(KMARGIN*3/2);
        make.centerY.equalTo(backView);
    }];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0) {
        return 90;
    }
    return 44;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    if (section == 0) {
        return KMARGIN;
    }
    return 2*KMARGIN;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    switch (indexPath.section) {
        case 0:
        {
            MyInfoController *infoCtrl = [[MyInfoController alloc]init];
            self.tabBarController.tabBar.hidden = YES;
            [self.navigationController pushViewController:infoCtrl animated:YES];
        }
            break;
        case 1:
        {
            switch (indexPath.row) {
                case 0:
                {
                    [self.view makeToast:@"相册"];
                }
                    break;
                case 1:
                {
                    [self.view makeToast:@"收藏"];
                }
                    break;
                case 2:
                {
                    [self.view makeToast:@"钱包"];
                }
                    break;
                case 3:
                {
                    [self.view makeToast:@"卡包"];
                }
                    break;

                default:
                    break;
            }
        }
            break;
        case 2:
        {
            [self.view makeToast:@"表情"];
        }
            break;
        case 3:
        {
            [self.view makeToast:@"设置"];
            [self clearCaches];
        }

            break;
        case 4:
            [self logout];
            break;
            
        default:
            break;
    }
}

#pragma mark 获取缓存大小
-(void)getSizeWithCacheData {
    NSString *cachPath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory,NSUserDomainMask, YES) objectAtIndex:0];
    
    NSArray *files = [[NSFileManager defaultManager] subpathsAtPath:cachPath];
    
    long long sum = 0;
    for (NSString *fileName in files) {
        NSString *filePath = [cachPath stringByAppendingPathComponent:fileName];
        
        NSDictionary *attribute = [[NSFileManager defaultManager] attributesOfItemAtPath:filePath error:nil];
        
        long long size = [attribute fileSize];
        
        sum += size;
    }
    cacheSize = sum/(1024*1024.0);;
    NSArray *newArr = @[@{@"imageName":@"MoreSetting_25x25_",@"title":[NSString stringWithFormat:@"设置(先写成清除缓存)-%.1fM",cacheSize]}];
    [dataArray replaceObjectAtIndex:2 withObject:newArr];
}

- (void)clearCaches{
    
    UIAlertController *alertCtrl = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"确定清楚缓存么" preferredStyle:UIAlertControllerStyleAlert];
    [alertCtrl addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)
                       , ^{
                           NSString *cachPath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory,NSUserDomainMask, YES) objectAtIndex:0];
                           
                           NSArray *files = [[NSFileManager defaultManager] subpathsAtPath:cachPath];
                           NSLog(@"files :%lu",(unsigned long)[files count]);
                           for (NSString *p in files) {
                               NSError *error;
                               NSString *path = [cachPath stringByAppendingPathComponent:p];
                               if ([[NSFileManager defaultManager] fileExistsAtPath:path]) {
                                   [[NSFileManager defaultManager] removeItemAtPath:path error:&error];
                               }
                           }
                           [self performSelectorOnMainThread:@selector(clearCacheSuccess) withObject:nil waitUntilDone:YES];
                       });
        
    }]];
    [alertCtrl addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
    [self presentViewController:alertCtrl animated:YES completion:nil];

}

//缓存清除成功
-(void)clearCacheSuccess {
    
    [self getSizeWithCacheData];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:3];
    [mineTableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    [SVProgressHUD showSuccessWithStatus:@"清除成功"];
}

- (void)dealloc{
    
    [JP_NotificationCenter removeObserver:self name:LOGINCHANGE object:nil];
    [JP_NotificationCenter removeObserver:self name:CHANGENAMESUCCESS object:nil];
}

@end
