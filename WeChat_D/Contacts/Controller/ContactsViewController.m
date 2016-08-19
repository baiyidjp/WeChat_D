//
//  ContactsViewController.m
//  WeChat_Djp
//
//  Created by tztddong on 16/7/8.
//  Copyright © 2016年 dongjiangpeng. All rights reserved.
//

#import "ContactsViewController.h"
#import "AddFriendController.h"
#import "ChatDetailViewController.h"
#import "AgreeFriendViewController.h"
#import "MyGroupListController.h"
#import "JPTextChangeToPinYinManager.h"
#import "FriendListModel.h"

#define CellID @"contactTableViewCell"

@interface ContactsViewController ()<UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate>
/** 好友列表 */
@property(nonatomic,strong) NSMutableArray *dataArray;
/** 好友列表View */
@property(nonatomic,strong) UITableView *contactTableView;
/** 搜索框 */
@property(nonatomic,strong) UISearchBar *searchBar;
/** 第一组列表 */
@property(nonatomic,strong) NSArray *topDataArray;
/** 新好友请求 */
@property(nonatomic,strong) NSMutableArray *newFriendDataArray;
/** 新好友个数 */
@property(nonatomic,strong)UILabel *friendUnreadLabel;
/** 好友分组名(A-Z) */
@property(nonatomic,strong)NSMutableArray *friendSectionNameArray;
@end

@implementation ContactsViewController
- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = NO;
    
}

- (void)viewWillDisappear:(BOOL)animated{
    
    [super viewWillDisappear:animated];
    
}

- (NSMutableArray *)dataArray{
    
    if (!_dataArray) {
        
        _dataArray = [NSMutableArray array];
        
    }
    return _dataArray;
}

- (NSMutableArray *)friendSectionNameArray{
    
    if (!_friendSectionNameArray) {
        _friendSectionNameArray = [NSMutableArray array];
    }
    return _friendSectionNameArray;
}

- (NSMutableArray *)newFriendDataArray{
    
    if (!_newFriendDataArray) {
        _newFriendDataArray = [NSMutableArray array];
    }
    return _newFriendDataArray;
}

- (UILabel *)friendUnreadLabel{
    
    if (!_friendUnreadLabel) {
        _friendUnreadLabel = [[UILabel alloc]initWithFrame:CGRectMake(KWIDTH-KMARGIN-2*KMARGIN, 44/2-KMARGIN, 2*KMARGIN, 2*KMARGIN)];
        _friendUnreadLabel.textAlignment = NSTextAlignmentCenter;
        _friendUnreadLabel.layer.cornerRadius = KMARGIN;
        _friendUnreadLabel.layer.masksToBounds = YES;
        _friendUnreadLabel.backgroundColor = [UIColor redColor];
        _friendUnreadLabel.textColor = [UIColor whiteColor];
        _friendUnreadLabel.font = FONTSIZE(13);
        _friendUnreadLabel.hidden = YES;
    }
    return _friendUnreadLabel;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.topDataArray = @[@{@"imageName":@"add_friend_icon_addgroup_36x36_",@"title":@"新的朋友"},
                          @{@"imageName":@"add_friend_icon_addgroup_36x36_",@"title":@"群聊"},
                          @{@"imageName":@"Contact_icon_ContactTag_36x36_",@"title":@"标签"},
                          @{@"imageName":@"add_friend_icon_offical_36x36_",@"title":@"公共号"},];

    //添加 加号
    UIBarButtonItem *rightitem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addFriend)];
    self.navigationItem.rightBarButtonItem = rightitem;
    
    //搜索框
    UISearchBar *searchBar = [[UISearchBar alloc]init];
    searchBar.backgroundColor = [UIColor whiteColor];
    searchBar.placeholder = @"搜索";
    searchBar.delegate = self;
    [self.view addSubview:searchBar];
    self.searchBar = searchBar;
    [searchBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(KNAVHEIGHT);
        make.left.right.offset(0);
        make.height.equalTo(@44);
    }];
    
    self.contactTableView = [[UITableView alloc]init];
    self.contactTableView.delegate = self;
    self.contactTableView.dataSource = self;
    [self.contactTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:CellID];
    self.contactTableView.tableFooterView = [[UIView alloc]init];
    [self.view addSubview:self.contactTableView];
    [self.contactTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.offset(0);
        make.top.equalTo(self.searchBar.mas_bottom);
        make.bottom.offset(-KTABBARHEIGHT);
    }];
    [JP_NotificationCenter addObserver:self selector:@selector(loginChange) name:LOGINCHANGE object:nil];
    [JP_NotificationCenter addObserver:self selector:@selector(delectFriend) name:DELECTFRIENDSUEESS object:nil];
    [JP_NotificationCenter addObserver:self selector:@selector(agreenFriendNoti) name:ADDFRIENDSUCCESS object:nil];
    [JP_NotificationCenter addObserver:self selector:@selector(autoLogin) name:AUTOLOGINSUCCESS object:nil];
    [JP_NotificationCenter addObserver:self selector:@selector(newFriendRequest:) name:NEWFRIENDREQUEST object:nil];
    [JP_NotificationCenter addObserver:self selector:@selector(newFriendRequestResult) name:NEWFRIENDREQUESTRESULT object:nil];
}

#pragma mark 登陆成功的通知
- (void)loginChange{
    
    [self getContactListFromServer];
}
#pragma mark 删除好友通知
- (void)delectFriend{
    
    [self getContactListFromServer];
}
#pragma mark 添加好友成功 主动添加收到
- (void)agreenFriendNoti{
    
    [self getContactListFromServer];
}
#pragma mark 自动登录成功
- (void)autoLogin{
    
    [self getContactListFromServer];
}
#pragma mark 新好友请求
- (void)newFriendRequest:(NSNotification *)notification{
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:notification.userInfo];
    [dict setObject:@0 forKey:NewFriendAgreeState]; //添加一个值判断是都查看 或者是否同意或者拒绝 0未处理 1已同意 2已拒绝
    NSMutableArray *arr = [NSMutableArray arrayWithArray:[[NSUserDefaults standardUserDefaults] objectForKey:NewFriendLocationArray]];
    //因为环信好友申请不再保存服务器 所以需要自己存到本地
    //遍历本地存储的好友请求信息 若有相同好友请求 则移除本地 再次添加新的好友请求
    for (NSDictionary *locationDict in arr) {
        if ([[dict objectForKey:NewFriendName] isEqualToString:[locationDict objectForKey:NewFriendName]]) {
            [arr removeObject:locationDict];
        }
    }
    [arr addObject:dict];
    [[NSUserDefaults standardUserDefaults] setObject:arr forKey:NewFriendLocationArray];
    [self.newFriendDataArray addObject:dict];
    [self getContactListFromServer];
}
#pragma mark 好友请求处理的通知
- (void)newFriendRequestResult{
    [self getContactListFromServer];
}
//添加好友按钮的点击
- (void)addFriend{
    
    AddFriendController *friendCtrl = [[AddFriendController alloc]init];
    self.tabBarController.tabBar.hidden = YES;
    [self.navigationController pushViewController:friendCtrl animated:YES];
}

#pragma mark 代理/数据源
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return self.dataArray.count+1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return self.topDataArray.count;
    }
    FriendListModel *model = [self.dataArray objectAtIndex:section-1];
    return model.sectionArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellID];
    
    if (cell.contentView.subviews.count) {
        for (UIView *view in cell.contentView.subviews) {
            [view removeFromSuperview];
        }
    }
    
    UIImageView *image = [[UIImageView alloc]init];
    [image setContentScaleFactor:[[UIScreen mainScreen] scale]];
    image.contentMode =  UIViewContentModeScaleAspectFill;
    image.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    image.clipsToBounds  = YES;
    [cell.contentView addSubview:image];
    [image mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(KMARGIN*3/2);
        make.centerY.equalTo(cell.contentView);
        make.size.mas_equalTo(CGSizeMake(36, 36));
    }];
    
    UILabel *title = [[UILabel alloc]init];
    title.font = FONTSIZE(15);
    [cell.contentView addSubview:title];
    [title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(image.mas_right).with.offset(KMARGIN*3/2);
        make.centerY.equalTo(cell.contentView);
    }];
    
    if (indexPath.section == 0) {
        
        image.image = [UIImage imageNamed:[[self.topDataArray objectAtIndex:indexPath.row] objectForKey:@"imageName"]];
        title.text = [[self.topDataArray objectAtIndex:indexPath.row] objectForKey:@"title"];
        
            if (indexPath.row == 0) {
                [cell.contentView addSubview:self.friendUnreadLabel];
            }
    }else{
        FriendListModel *sectionModel = [self.dataArray objectAtIndex:indexPath.section-1];
        FriendListModel *model = [sectionModel.sectionArr objectAtIndex:indexPath.row];
        title.text = model.name;
        [image sd_setImageWithURL:[NSURL URLWithString:FRIENDHEADERIMAGE_URL] placeholderImage:[UIImage imageNamed:DefaultHeadImageName]];
    }
    cell.selectionStyle = UITableViewCellAccessoryNone;
    return cell;
    
}

- (void)configSectionView:(UIView *)backView data:(NSDictionary *)dataDict{
    
    UIImageView *image = [[UIImageView alloc]init];
    image.image = [UIImage imageNamed:[dataDict objectForKey:@"imageName"]];
    [backView addSubview:image];
    [image mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(KMARGIN*3/2);
        make.centerY.equalTo(backView);
        make.size.mas_equalTo(CGSizeMake(36, 36));
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
    
    return 50;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    
    if (section == 0) {
        return nil;
    }
    FriendListModel *sectionModel = [self.dataArray objectAtIndex:section-1];
    return sectionModel.name;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return 0;
    }
    return 3*KMARGIN;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            AgreeFriendViewController *agreeCtrl = [[AgreeFriendViewController alloc]init];
            agreeCtrl.dataArray = self.newFriendDataArray;
            [self.navigationController pushViewController:agreeCtrl animated:YES];
        }else if (indexPath.row == 1){
            MyGroupListController *groupCtrl = [[MyGroupListController alloc]init];
            groupCtrl.title = @"我的群聊";
            self.tabBarController.tabBar.hidden = YES;
            [self.navigationController pushViewController:groupCtrl animated:YES];
        }else{
            return;
        }
    }else{
        FriendListModel *sectionModel = [self.dataArray objectAtIndex:indexPath.section-1];
        FriendListModel *model = [sectionModel.sectionArr objectAtIndex:indexPath.row];
        ChatDetailViewController *chatCtrl = [[ChatDetailViewController alloc]init];
        chatCtrl.title = model.name;
        self.tabBarController.tabBar.hidden = YES;
        [self.navigationController pushViewController:chatCtrl animated:YES];
    }
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    [SVProgressHUD show];
    FriendListModel *sectionModel = [self.dataArray objectAtIndex:indexPath.section-1];
    FriendListModel *model = [sectionModel.sectionArr objectAtIndex:indexPath.row];
    [[EMClient sharedClient].contactManager asyncDeleteContact:model.name success:^{
        [SVProgressHUD showSuccessWithStatus:@"删除成功"];
//        [self.dataArray removeObjectAtIndex:indexPath.row];
//        [self.contactTableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
        [self getContactListFromServer];
    } failure:^(EMError *aError) {
        [SVProgressHUD showSuccessWithStatus:@"删除失败"];
    }];
    
}
#pragma mark titleForDeleteConfirmationButtonForRowAtIndexPath
- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath{
    return @"删除";
}

#pragma mark 返回每组标题索引 右边
-(NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView{
    NSMutableArray *indexs=[[NSMutableArray alloc]init];
    for(FriendListModel *model in self.dataArray){
        [indexs addObject:model.name];
    }
    return indexs;
}

#pragma mark 从服务器获取好友列表
- (void)getContactListFromServer{
    
    //显示新申请的个数
    [self.newFriendDataArray removeAllObjects];
    //先移除已加入的数据 在从本地获取当前最新的数据
    NSArray *arr = [[NSUserDefaults standardUserDefaults] objectForKey:NewFriendLocationArray];
    [self.newFriendDataArray addObjectsFromArray:arr];
    
    NSInteger newFriCount = 0;
    for (NSDictionary *dict in self.newFriendDataArray) {
        //通过比较数据中的处理状态 如果是0则是未处理 
        if (![[dict objectForKey:NewFriendAgreeState] integerValue]) {
            newFriCount++;
        }
    }
    if (newFriCount) {
        self.friendUnreadLabel.hidden = NO;
        self.friendUnreadLabel.text = [NSString stringWithFormat:@"%zd",newFriCount];
        self.tabBarItem.badgeValue = [NSString stringWithFormat:@"%zd",newFriCount];
    }else{
        self.friendUnreadLabel.hidden = YES;
        self.tabBarItem.badgeValue = nil;
    }
    //移除所有的好友信息
    [self.dataArray removeAllObjects];
    
    //从服务器获取所有的好友列表
    [[EMClient sharedClient].contactManager asyncGetContactsFromServer:^(NSArray *aList) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.dataArray addObjectsFromArray:[self getSectionNameArrayWithFriendData:aList]];
            [self.contactTableView reloadData];
        });
    } failure:^(EMError *aError) {
        //若获取失败则从本地获取好友列表
        NSArray *aList = [[EMClient sharedClient].contactManager getContactsFromDB];
        [self.dataArray addObjectsFromArray:[self getSectionNameArrayWithFriendData:aList]];
        [self.contactTableView reloadData];
    }];
}

- (NSArray *)getSectionNameArrayWithFriendData:(NSArray *)aList{
    
    //索引的 数组
    //返回系统的规则索引 A-Z #
    UILocalizedIndexedCollation *indexCollation = [UILocalizedIndexedCollation currentCollation];
    NSArray *sectionTitles = [indexCollation sectionTitles];
    NSInteger highSection = [sectionTitles count];
    NSMutableArray *sectionModelArr = [NSMutableArray arrayWithCapacity:highSection];
    for (int i = 0; i < highSection; i++) {
        FriendListModel *sectionModel = [[FriendListModel alloc]init];
        [sectionModelArr addObject:sectionModel];
    }
    
    for (NSString *name in aList) {
        NSString *pinYinStr = [JPTextChangeToPinYinManager getPinYinFromText:name];
        //取出拼音的第一个字母
        NSString *firstLetter = [pinYinStr substringToIndex:1];
        NSLog(@"昵称转换为拼音---%@ 首字母---%@",pinYinStr,firstLetter);
        for (NSInteger i = 0; i < sectionModelArr.count; i++) {
            NSString *letter = [sectionTitles objectAtIndex:i];
            FriendListModel *sectionModel = [sectionModelArr objectAtIndex:i];
            NSMutableArray *sectionArr = [NSMutableArray arrayWithArray:sectionModel.sectionArr];
            if ([letter isEqualToString:firstLetter]) {
                FriendListModel *model = [[FriendListModel alloc]init];
                model.name = name;
                [sectionArr addObject:model];
                sectionModel.name = letter;
                sectionModel.sectionArr = [sectionArr copy];
                break ;
            }
        }
    }
    for (NSInteger i = [sectionModelArr count] - 1; i >= 0; i--) {
        FriendListModel *model = [sectionModelArr objectAtIndex:i];
        if ([model.sectionArr count] == 0) {
            [sectionModelArr removeObjectAtIndex:i];
        }
    }
    return [sectionModelArr copy];
}

#pragma mark UISearchDelegate
- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar{
    
    searchBar.showsCancelButton = YES;
    UIButton *canceLBtn = [searchBar valueForKey:@"cancelButton"];
    [canceLBtn setTitle:@"取消" forState:UIControlStateNormal];
    [canceLBtn setTitleColor:[UIColor colorWithRed:28.9/255.0 green:187.0/255.0 blue:3.5/255.0 alpha:1.0] forState:UIControlStateNormal];
    
    return YES;
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar{
    
    searchBar.showsCancelButton = NO;
    [searchBar resignFirstResponder];
}

- (void)dealloc{
    //移除通知
    
    [JP_NotificationCenter removeObserver:self name:LOGINCHANGE object:nil];
    [JP_NotificationCenter removeObserver:self name:DELECTFRIENDSUEESS object:nil];
    [JP_NotificationCenter removeObserver:self name:ADDFRIENDSUCCESS object:nil];
    [JP_NotificationCenter removeObserver:self name:AUTOLOGINSUCCESS object:nil];
}
@end
