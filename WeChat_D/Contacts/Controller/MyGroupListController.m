//
//  MyGroupListController.m
//  WeChat_D
//
//  Created by tztddong on 16/7/28.
//  Copyright © 2016年 dongjiangpeng. All rights reserved.
//

#import "MyGroupListController.h"
#import "ChatDetailViewController.h"

#define CellID @"GroupCell"
@interface MyGroupListController ()<UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate>
@property(nonatomic,strong)NSMutableArray *dataArray;
/** 群组列表View */
@property(nonatomic,strong) UITableView *groupTableView;
/** 搜索框 */
@property(nonatomic,strong) UISearchBar *searchBar;

@end

@implementation MyGroupListController

- (NSMutableArray *)dataArray{
    
    if (!_dataArray) {
        
        _dataArray = [NSMutableArray array];
        
    }
    return _dataArray;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    
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
    
    self.groupTableView = [[UITableView alloc]init];
    self.groupTableView.delegate = self;
    self.groupTableView.dataSource = self;
    [self.groupTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:CellID];
    self.groupTableView.tableFooterView = [[UIView alloc]init];
    [self.view addSubview:self.groupTableView];
    [self.groupTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.offset(0);
        make.top.equalTo(self.searchBar.mas_bottom).with.offset(KMARGIN);
    }];
    
    [[EMClient sharedClient].groupManager asyncGetMyGroupsFromServer:^(NSArray *aList) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.dataArray addObjectsFromArray:aList];
            [self.groupTableView reloadData];
        });
    } failure:^(EMError *aError) {
        //则从本地获取
        [self.dataArray addObjectsFromArray:[[EMClient sharedClient].groupManager getAllGroups]];
        [self.groupTableView reloadData];
    }];
    
}

#pragma mark 代理/数据源

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.dataArray.count;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellID];
    EMGroup *group = [self.dataArray objectAtIndex:indexPath.row];
    cell.imageView.image = [UIImage imageNamed:DefaultHeadImageName];
    cell.textLabel.text = group.subject;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 50;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    EMGroup *group = [self.dataArray objectAtIndex:indexPath.row];
    ChatDetailViewController *chatVC = [[ChatDetailViewController alloc]init];
    chatVC.groupID = group.groupId;
    chatVC.title = group.subject;
    [self.navigationController pushViewController:chatVC animated:YES];
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    [SVProgressHUD show];
    EMGroup *group = [self.dataArray objectAtIndex:indexPath.row];
    [[EMClient sharedClient].groupManager asyncLeaveGroup:group.groupId success:^(EMGroup *aGroup) {
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [SVProgressHUD showSuccessWithStatus:@"退群成功"];
            [self.dataArray removeObjectAtIndex:indexPath.row];
            [self.groupTableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
        });
    } failure:^(EMError *aError) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [SVProgressHUD showSuccessWithStatus:@"退群失败"];
        });
    }];
    
}
#pragma mark titleForDeleteConfirmationButtonForRowAtIndexPath
- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath{
    return @"退群";
}

@end
