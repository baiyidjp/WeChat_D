//
//  GroupViewController.m
//  WeChat_D
//
//  Created by tztddong on 16/7/27.
//  Copyright © 2016年 dongjiangpeng. All rights reserved.
//

#import "GroupViewController.h"
#import "CreatGroupModel.h"
#import "CreatGroupCell.h"

#define CellID @"creatGroupCell"
@interface GroupViewController ()<UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate>
@property(nonatomic,strong)NSMutableArray *dataArray;
/** 好友列表View */
@property(nonatomic,strong) UITableView *contactTableView;
/** 搜索框 */
@property(nonatomic,strong) UISearchBar *searchBar;
/**
 *  确定按钮
 */
@property(nonatomic,strong) UIButton *doneBtn;
@property(nonatomic,strong)EMConversation *conversation;
@end

@implementation GroupViewController

- (NSMutableArray *)dataArray{
    
    if (!_dataArray) {
        
        _dataArray = [NSMutableArray array];
        
    }
    return _dataArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    UIView *topBackView = [[UIView alloc]init];
    topBackView.backgroundColor = [UIColor colorWithRed:54/255.0 green:53/255.0 blue:58/255.0 alpha:1];
    [self.view addSubview:topBackView];
    [topBackView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.offset(0);
        make.height.equalTo(@(KNAVHEIGHT));
    }];
    UIButton *backBtn = [[UIButton alloc]init];
    [backBtn setTitle:@"取消" forState:UIControlStateNormal];
    [backBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [backBtn.titleLabel setFont:FONTSIZE(15)];
    [backBtn addTarget:self action:@selector(clickBackBtn) forControlEvents:UIControlEventTouchUpInside];
    [topBackView addSubview:backBtn];
    [backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(KMARGIN);
        make.centerY.equalTo(topBackView.mas_centerY).with.offset(KMARGIN);
    }];
    self.doneBtn = [[UIButton alloc]init];
    [self.doneBtn setTitle:@"确定" forState:UIControlStateNormal];
    [self.doneBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.doneBtn setTitleColor:[UIColor grayColor] forState:UIControlStateDisabled];
    [self.doneBtn.titleLabel setFont:FONTSIZE(15)];
    self.doneBtn.enabled = NO;
    [self.doneBtn addTarget:self action:@selector(clickDoneBtn) forControlEvents:UIControlEventTouchUpInside];
    [topBackView addSubview:self.doneBtn];
    [self.doneBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.offset(-KMARGIN);
        make.centerY.equalTo(topBackView.mas_centerY).with.offset(KMARGIN);
    }];
    UILabel *titleL = [[UILabel alloc]init];
    titleL.text = @"选择联系人";
    titleL.textColor = [UIColor whiteColor];
    [topBackView addSubview:titleL];
    [titleL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(topBackView.mas_centerX);
        make.centerY.equalTo(topBackView.mas_centerY).with.offset(KMARGIN);
    }];
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
    [self.contactTableView registerClass:[CreatGroupCell class] forCellReuseIdentifier:CellID];
    self.contactTableView.tableFooterView = [[UIView alloc]init];
    [self.view addSubview:self.contactTableView];
    [self.contactTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.offset(0);
        make.top.equalTo(self.searchBar.mas_bottom).with.offset(KMARGIN);
    }];

    
    //从服务器获取所有的好友列表
    [[EMClient sharedClient].contactManager asyncGetContactsFromServer:^(NSArray *aList) {
        dispatch_async(dispatch_get_main_queue(), ^{
            for (NSString *name in aList) {
                CreatGroupModel *model = [[CreatGroupModel alloc]init];
                model.name = name;
                model.imageName = DefaultHeadImageName;
                model.isSelect = NO;
                [self.dataArray addObject:model];
            }
            [self.contactTableView reloadData];
        });
    } failure:^(EMError *aError) {
        //若获取失败则从本地获取好友列表
        for (NSString *name in [[EMClient sharedClient].contactManager getContactsFromDB]) {
            CreatGroupModel *model = [[CreatGroupModel alloc]init];
            model.name = name;
            model.imageName = DefaultHeadImageName;
            model.isSelect = NO;
            [self.dataArray addObject:model];
        }
        [self.contactTableView reloadData];
    }];

}

- (void)clickBackBtn{
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)clickDoneBtn{
    
    NSMutableArray *nameArray = [NSMutableArray array];
    for (CreatGroupModel *model in self.dataArray) {
        if (model.isSelect) {
            [nameArray addObject:model.name];
        }
    }
    NSLog(@"%@",nameArray);
    EMGroupOptions *setting = [[EMGroupOptions alloc] init];
    setting.maxUsersCount = 500;
    setting.style = EMGroupStylePublicOpenJoin;// 创建不同类型的群组，这里需要才传入不同的类型
    /*!
     *  \~chinese
     *  创建群组
     *
     *  @param aSubject         群组名称
     *  @param aDescription     群组描述
     *  @param aInvitees        群组成员（不包括创建者自己）
     *  @param aMessage         邀请消息
     *  @param aSetting         群组属性
     *  @param aSuccessBlock    The callback block of success
     *  @param aFailureBlock    The callback block of failure
     *
     */
    NSString *subject = [NSString stringWithFormat:@"%@创建的群",[[EMClient sharedClient] currentUsername]];
    NSString *description = [NSString stringWithFormat:@"%@创建的群",[[EMClient sharedClient] currentUsername]];
    NSString *message = [NSString stringWithFormat:@"%@邀请你加入群",[[EMClient sharedClient] currentUsername]];
    [SVProgressHUD show];
    [[EMClient sharedClient].groupManager asyncCreateGroupWithSubject:subject description:description invitees:[nameArray copy] message:message setting:setting success:^(EMGroup *aGroup) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [SVProgressHUD showSuccessWithStatus:@"创建群成功"];
            NSDictionary *dict = [NSDictionary dictionaryWithObject:aGroup forKey:GroupValue];
            [JP_NotificationCenter postNotificationName:CREATGROUPSUCCESS object:nil userInfo:dict];
        });
        
    } failure:^(EMError *aError) {
        [SVProgressHUD showSuccessWithStatus:@"创建群失败"];
    }];
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark 代理/数据源

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.dataArray.count;

}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    CreatGroupCell *cell = [tableView dequeueReusableCellWithIdentifier:CellID];
    CreatGroupModel *model = [self.dataArray objectAtIndex:indexPath.row];
    cell.model = model;
    cell.selectionStyle = UITableViewCellAccessoryNone;
    
    return cell;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 50;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    CreatGroupModel *model = [self.dataArray objectAtIndex:indexPath.row];
    model.isSelect = !model.isSelect;
    [self.contactTableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    NSInteger selectCount = 0;
    for (CreatGroupModel *model in self.dataArray) {
        if (model.isSelect) {
            selectCount++;
        }
    }
    if (selectCount) {
        self.doneBtn.enabled = YES;
    }else{
        self.doneBtn.enabled = NO;
    }
}

@end
