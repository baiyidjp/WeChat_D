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

#define CellID @"contactTableViewCell"

@interface ContactsViewController ()<EMContactManagerDelegate,UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate>
/** 好友列表 */
@property(nonatomic,strong) NSMutableArray *dataArray;
/** 好友列表View */
@property(nonatomic,strong) UITableView *contactTableView;
/** 搜索框 */
@property(nonatomic,strong) UISearchBar *searchBar;
/** 第一组列表 */
@property(nonatomic,strong) NSArray *topDataArray;
@end

@implementation ContactsViewController
- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = NO;
    
}

- (void)viewWillDisappear:(BOOL)animated{
    
    [super viewWillDisappear:animated];
    
}

- (NSArray *)topDataArray{
    
    if (!_topDataArray) {
        
        _topDataArray = @[@"新的朋友",@"群聊",@"公众号"];
    }
    return _topDataArray;
}

- (NSMutableArray *)dataArray{
    
    if (!_dataArray) {
        
        _dataArray = [NSMutableArray array];
        //从服务器获取所有的好友列表
        [[EMClient sharedClient].contactManager asyncGetContactsFromServer:^(NSArray *aList) {
            [_dataArray addObjectsFromArray:aList];
        } failure:^(EMError *aError) {
            //若获取失败则从本地获取好友列表
            [_dataArray addObjectsFromArray:[[EMClient sharedClient].contactManager getContactsFromDB]];
        }];

    }
    return _dataArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //添加 加号
    UIBarButtonItem *rightitem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addFriend)];
    self.navigationItem.rightBarButtonItem = rightitem;
    
    //搜索框
    UISearchBar *searchBar = [[UISearchBar alloc]init];
    searchBar.backgroundColor = [UIColor whiteColor];
    searchBar.placeholder = @"搜索";
    searchBar.delegate = self;
    searchBar.layer.cornerRadius = 5;
    searchBar.layer.masksToBounds = YES;
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
        make.left.right.bottom.offset(0);
        make.top.equalTo(self.searchBar.mas_bottom);
    }];
    
    //好友操作的代理添加
    [[EMClient sharedClient].contactManager addDelegate:self delegateQueue:nil];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(loginChange) name:KNOTIFICATION_LOGINCHANGE object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(delectFriend) name:DELECTFRIENDSUEESS object:nil];
}

#pragma mark 登陆成功的通知
- (void)loginChange{
    
    [self getContactListFromServer];
}
#pragma mark 删除好友通知
- (void)delectFriend{
    
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
    
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 1) {
        return self.dataArray.count;
    }
    return self.topDataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellID];
    switch (indexPath.section) {
        case 0:
            cell.textLabel.text = [self.topDataArray objectAtIndex:indexPath.row];
            cell.imageView.image = [UIImage imageNamed:@"Tabar_mine"];
            break;
        case 1:
            cell.textLabel.text = [self.dataArray objectAtIndex:indexPath.row];
            cell.imageView.image = [UIImage imageNamed:@"Tabar_mine"];
            break;
        default:
            break;
    }
    cell.selectionStyle = UITableViewCellAccessoryNone;
    return cell;
    
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    
    if (section == 1) {
        return @"好友列表";
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 1) {
        return 3*KMARGIN;
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    return 2*KMARGIN;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0) {
        return;
    }
    ChatDetailViewController *chatCtrl = [[ChatDetailViewController alloc]init];
    chatCtrl.title = [self.dataArray objectAtIndex:indexPath.row];
    self.tabBarController.tabBar.hidden = YES;
    [self.navigationController pushViewController:chatCtrl animated:YES];
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    [SVProgressHUD show];
    [[EMClient sharedClient].contactManager asyncDeleteContact:[self.dataArray objectAtIndex:indexPath.row] success:^{
        [SVProgressHUD showSuccessWithStatus:@"删除成功"];
        [self.dataArray removeObjectAtIndex:indexPath.row];
        [self.contactTableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    } failure:^(EMError *aError) {
        [SVProgressHUD showSuccessWithStatus:@"删除失败"];
    }];
    
}
#pragma mark titleForDeleteConfirmationButtonForRowAtIndexPath
- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath{
    return @"删除";
}


#pragma mark -------------------------------------------------------

/*!
 *  \~chinese
 *  用户B同意用户A的好友申请后，用户A和用户B都会收到这个回调
 *
 *  @param aUsername   用户好友关系的另一方
 */
- (void)didReceiveAddedFromUsername:(NSString *)aUsername{
    
    NSLog(@"*  用户B同意用户A的好友申请后，用户A和用户B都会收到这个回调");
    [self getContactListFromServer];
    
}

#pragma mark 从服务器获取好友列表
- (void)getContactListFromServer{
    
    [_dataArray removeAllObjects];
    //从服务器获取所有的好友列表
    [[EMClient sharedClient].contactManager asyncGetContactsFromServer:^(NSArray *aList) {
        [_dataArray addObjectsFromArray:aList];
        [self.contactTableView reloadData];
    } failure:^(EMError *aError) {
        //若获取失败则从本地获取好友列表
        [_dataArray addObjectsFromArray:[[EMClient sharedClient].contactManager getContactsFromDB]];
        [self.contactTableView reloadData];
    }];
}

- (void)dealloc{
    [[EMClient sharedClient].contactManager removeDelegate:self];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:KNOTIFICATION_LOGINCHANGE object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:DELECTFRIENDSUEESS object:nil];
}
@end
