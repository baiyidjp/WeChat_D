//
//  WeChatViewController.m
//  WeChat_Djp
//
//  Created by tztddong on 16/7/8.
//  Copyright © 2016年 dongjiangpeng. All rights reserved.
//

#import "WeChatViewController.h"
#import "ChatDetailViewController.h"
#import "WeChatListModel.h"
#import "WeChatTableViewCell.h"
#import "ListView.h"
#import "GroupViewController.h"
#import "AddFriendController.h"
#import "ScanQRCodeController.h"
#import "LoginViewController.h"

@interface WeChatViewController ()<UISearchBarDelegate,UITableViewDelegate,UITableViewDataSource>
/**
 *  搜索栏
 */
@property(nonatomic,strong)UISearchBar *searchBar;
/**
 *  状态栏的底部
 */
@property(nonatomic,strong)UIView *topStatusView;
/**
 *  取消按钮
 */
@property(nonatomic,strong)UIButton *cancleBtn;
/**
 *  会话列表
 */
@property(nonatomic,strong)UITableView *weChatTableView;
/**
 *  搜索的view
 */
@property(nonatomic,strong)UIScrollView *searchView;
/**
 *  数据源
 */
@property(nonatomic,strong)NSMutableArray *dataArray;
/**
 *  未读消息的总数
 */
@property(nonatomic,assign)NSInteger unreadCount;
/**
 *  右上角的列表
 */
@property(nonatomic,strong)ListView *listView;
/**
 *  列表的数据
 */
@property(nonatomic,strong)NSMutableArray *listDataArray;

@end

@implementation WeChatViewController
{
    NSInteger searchBarTop;
}

- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = NO;
    [self getAllConversations];
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

- (NSMutableArray *)listDataArray{
    
    if (!_listDataArray) {
        _listDataArray = [NSMutableArray array];
        NSDictionary *dict1 = [NSDictionary dictionaryWithObjects:@[@"发起群聊",@"contacts_add_newmessage_30x30_"] forKeys:@[@"title",@"imageName"]];
        NSDictionary *dict2 = [NSDictionary dictionaryWithObjects:@[@"添加朋友",@"contacts_add_friend_30x30_"] forKeys:@[@"title",@"imageName"]];
        NSDictionary *dict3 = [NSDictionary dictionaryWithObjects:@[@"扫 一 扫",@"contacts_add_scan_30x30_"] forKeys:@[@"title",@"imageName"]];
        NSDictionary *dict4 = [NSDictionary dictionaryWithObjects:@[@"收 付 款",@"contacts_add_scan_30x30_"] forKeys:@[@"title",@"imageName"]];
        [_listDataArray addObject:dict1];
        [_listDataArray addObject:dict2];
        [_listDataArray addObject:dict3];
        [_listDataArray addObject:dict4];
    }
    return _listDataArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //判断是否自动登录
    BOOL isAutoLogin = [EMClient sharedClient].isAutoLogin;
    if (!isAutoLogin){
        LoginViewController *login = [[LoginViewController alloc]init];
        self.tabBarController.tabBar.hidden = YES;
        [self presentViewController:login animated:YES completion:nil];
    }
    
    //登陆成功通知
    [JP_NotificationCenter addObserver:self selector:@selector(loginSuccess) name:LOGINCHANGE object:nil];
    [JP_NotificationCenter addObserver:self selector:@selector(autoLoginSuccess) name:AUTOLOGINSUCCESS object:nil];
    [JP_NotificationCenter addObserver:self selector:@selector(netWorkState:) name:NETWORKSTATE object:nil];
    [JP_NotificationCenter addObserver:self selector:@selector(reciveMessage:) name:RECEIVEMESSAGES object:nil];
    [JP_NotificationCenter addObserver:self selector:@selector(addFriendNoti:) name:ADDFRIENDSUCCESS object:nil];
    [JP_NotificationCenter addObserver:self selector:@selector(delectFriendNoti) name:DELECTFRIENDSUEESS object:nil];
    [JP_NotificationCenter addObserver:self selector:@selector(creatGroupSuccess:) name:CREATGROUPSUCCESS object:nil];
    [JP_NotificationCenter addObserver:self selector:@selector(receiveGroupInvite:) name:RECEIVEGROUPINVITE object:nil];
    
    searchBarTop = KNAVHEIGHT;
    UISearchBar *searchBar = [[UISearchBar alloc]init];
    searchBar.backgroundColor = [UIColor colorWithRed:0.779 green:0.779 blue:0.779 alpha:1.0];
    searchBar.placeholder = @"搜索";
    searchBar.delegate = self;
    [self.view addSubview:searchBar];
    self.searchBar = searchBar;
    
    self.topStatusView = [[UIView alloc]init];
    self.topStatusView.backgroundColor = [UIColor colorWithRed:54/255.0 green:53/255.0 blue:58/255.0 alpha:1];
    [self.view addSubview:self.topStatusView];
    [self.topStatusView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.offset(0);
        make.height.equalTo(@20);
    }];
    
    self.weChatTableView = [[UITableView alloc]init];
    self.weChatTableView.delegate = self;
    self.weChatTableView.dataSource = self;
    [self.weChatTableView registerNib:[UINib nibWithNibName:@"WeChatTableViewCell" bundle:nil] forCellReuseIdentifier:@"weChatTableView"];
    self.weChatTableView.tableFooterView = [[UIView alloc]init];
    [self.view addSubview:self.weChatTableView];
    
    UIScrollView *scrollView = [[UIScrollView alloc]init];
    scrollView.pagingEnabled = NO;
    [self.view addSubview:scrollView];
    self.searchView = scrollView;
    
    [self isHidden:YES];
    
    //告诉某个view需要更新约束
    [self.view setNeedsUpdateConstraints];
    //检测这个view是否有约束需要更新 如果有在调用下面的方法 更新约束
    [self.view updateConstraintsIfNeeded];
    [self.view layoutIfNeeded];
    
    //添加 加号
    UIImage *addImage = [UIImage imageNamed:@"barbuttonicon_add_30x30_"];
    addImage = [addImage imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    UIButton *addBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
    [addBtn setBackgroundImage:addImage forState:UIControlStateNormal];
    [addBtn addTarget:self action:@selector(addClicked:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *addItem = [[UIBarButtonItem alloc] initWithCustomView:addBtn];
    self.navigationItem.rightBarButtonItem = addItem;
    
}

#pragma mark 点击加号 更多列表
- (void)addClicked:(UIButton *)addBtn{
    
    addBtn.selected = !addBtn.selected;
    WEAK_SELF(weakSelf);
    if (addBtn.selected) {
        if (!self.listView) {
            self.listView = [ListView creatListViewWithTopView:(UIView *)addBtn dataArray:self.listDataArray frame:self.view.bounds selectBlock:^(NSInteger index) {
                [weakSelf addClicked:addBtn];
                //处理点击事件
                [weakSelf listViewClickWith:index];
            }];
            self.listView.alpha = 0.0;
            [UIView animateWithDuration:0.1 animations:^{
                self.listView.alpha = 1.0;
            }];
            [self.view addSubview:self.listView];
        }
    }else{
        [UIView animateWithDuration:0.1 animations:^{
            self.listView.alpha = 0.0;
        } completion:^(BOOL finished) {
            if (self.listView) {
                
                [self.listView removeFromSuperview];
                self.listView = nil;
            }
        }];
    }

}
//处理加号列表的点击事件
- (void)listViewClickWith:(NSInteger)index{
    switch (index) {
        case 0:{
            GroupViewController *groupCtrl = [[GroupViewController alloc]init];
            [self presentViewController:groupCtrl animated:YES completion:nil];
        }
            break;
        case 1:{
            AddFriendController *friendCtrl = [[AddFriendController alloc]init];
            self.tabBarController.tabBar.hidden = YES;
            [self.navigationController pushViewController:friendCtrl animated:YES];

        }
            break;
        case 2:{
            ScanQRCodeController *QRCtrl = [[ScanQRCodeController alloc]init];
            self.tabBarController.tabBar.hidden = YES;
            [self.navigationController pushViewController:QRCtrl animated:YES];
        }
            break;
        case 3:{
            [self.view makeToast:@"点击收付款"];
        }
            break;
            
        default:
            break;
    }
}

- (void)updateViewConstraints{
    
    [self.searchBar mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.offset(0);
        make.top.offset(searchBarTop);
        make.height.equalTo(@44);
        make.right.offset(0);

    }];
    
    [self.weChatTableView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.right.offset(0);
        make.top.equalTo(self.searchBar.mas_bottom);
        make.bottom.offset(-KTABBARHEIGHT);
    }];
    
    [self.searchView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.weChatTableView);
        make.bottom.equalTo(self.weChatTableView.mas_bottom).with.offset(KMARGIN);
    }];
    
    [super updateViewConstraints];
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    if (searchBarTop == 20) {
        return UIStatusBarStyleDefault;
    }
    return UIStatusBarStyleLightContent;
}
- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar{
    
    searchBar.showsCancelButton = YES;
    UIButton *canceLBtn = [searchBar valueForKey:@"cancelButton"];
    [canceLBtn setTitle:@"取消" forState:UIControlStateNormal];
    [canceLBtn setTitleColor:[UIColor colorWithRed:28.9/255.0 green:187.0/255.0 blue:3.5/255.0 alpha:1.0] forState:UIControlStateNormal];
    
    searchBarTop = 20;
    //告诉某个view需要更新约束
    [self.view setNeedsUpdateConstraints];
    //检测这个view是否有约束需要更新 如果有在调用下面的方法 更新约束
    [self.view updateConstraintsIfNeeded];
    [self isHidden:NO];
    [UIView animateWithDuration:0.3 animations:^{
        [self.view layoutIfNeeded];
//        [self setNeedsStatusBarAppearanceUpdate];
    }];
    
    return YES;
}                     // return NO to not become first responder
- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar{
}                     // called when text starts editing
- (BOOL)searchBarShouldEndEditing:(UISearchBar *)searchBar{
    return YES;
}                        // return NO to not resign first responder
- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar{
}                       // called when text ends editing
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
}   // called when text changes (including clear)
- (BOOL)searchBar:(UISearchBar *)searchBar shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    return YES;
}// NS_AVAILABLE_IOS(3_0); // called before text changes

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
}                     // called when keyboard search button pressed
- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar{
    
    searchBar.showsCancelButton = NO;
    searchBarTop = KNAVHEIGHT;
    [self.searchBar resignFirstResponder];
    //告诉某个view需要更新约束
    [self.view setNeedsUpdateConstraints];
    //检测这个view是否有约束需要更新 如果有在调用下面的方法 更新约束
    [self.view updateConstraintsIfNeeded];
    [UIView animateWithDuration:0.3 animations:^{
        [self.view layoutIfNeeded];
        [self isHidden:YES];
    }];

}

- (void)isHidden:(BOOL)hidden{
    
    self.topStatusView.hidden = hidden;
    self.navigationController.navigationBar.hidden = !hidden;
    self.weChatTableView.hidden = !hidden;
    self.searchView.hidden = hidden;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    WeChatTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"weChatTableView"];
    WeChatListModel *model = [self.dataArray objectAtIndex:indexPath.row];
    cell.model = model;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    ChatDetailViewController *chatVC = [[ChatDetailViewController alloc]init];
    WeChatListModel *model = [self.dataArray objectAtIndex:indexPath.row];
    switch (model.conversationType) {
        case EMConversationTypeChat:
            chatVC.title = model.conversationID;
            break;
        case EMConversationTypeGroupChat:
            chatVC.title = [model.conversation.ext objectForKey:GroupName];
            chatVC.groupID = model.conversationID;
            break;
        default:
            break;
    }

    self.tabBarController.tabBar.hidden = YES;
    [self.navigationController pushViewController:chatVC animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 68;
}

//- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
//    [SVProgressHUD show];
//    WeChatListModel *model = [self.dataArray objectAtIndex:indexPath.row];
//    if ([[EMClient sharedClient].chatManager deleteConversation:model.conversationID deleteMessages:NO]){
//        [SVProgressHUD showSuccessWithStatus:@"删除成功"];
//        [self.dataArray removeObjectAtIndex:indexPath.row];
//        [self.weChatTableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
//    } else{
//        [SVProgressHUD showSuccessWithStatus:@"删除失败"];
//    };
//    
//}
//#pragma mark titleForDeleteConfirmationButtonForRowAtIndexPath
//- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath{
//    return @"删除";
//}

- (NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewRowAction *readAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal title:@"设置为已读" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        
        WeChatListModel *model = [self.dataArray objectAtIndex:indexPath.row];
        //将当前会话的消息全部设为已读
        [model.conversation markAllMessagesAsRead];
        //退出编辑状态
        tableView.editing = NO;
        [self getAllConversations];
    }];
    
    UITableViewRowAction *deleteAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDestructive title:@"删除" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        
        WeChatListModel *model = [self.dataArray objectAtIndex:indexPath.row];
        if ([[EMClient sharedClient].chatManager deleteConversation:model.conversationID deleteMessages:NO]){
            [SVProgressHUD showSuccessWithStatus:@"删除成功"];
            [self.dataArray removeObjectAtIndex:indexPath.row];
            [self.weChatTableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
            [self getAllConversations];
        } else{
            [SVProgressHUD showSuccessWithStatus:@"删除失败"];
        };

    }];
    
    return @[deleteAction, readAction];
}

#pragma mark 登录成功通知
- (void)loginSuccess{
    
    [self getAllConversations];
}
#pragma mark 自动登录成功通知
- (void)autoLoginSuccess{
    
    [self getAllConversations];
}
#pragma mark 网络状态的变化
- (void)netWorkState:(NSNotification *)notification{
    
    NSDictionary *dict = notification.userInfo;
    if ([[dict objectForKey:@"isConnect"] intValue]) {
        self.navigationItem.title = @"微信";
    }else{
        self.navigationItem.title = @"微信(未连接)";
    }
}
#pragma mark  接收到新消息
- (void)reciveMessage:(NSNotification *)notification{
    
    NSMutableArray *consations = [NSMutableArray arrayWithCapacity:self.dataArray.count];
    for (WeChatListModel *oldModel in self.dataArray) {
        [consations addObject:oldModel.conversation.latestMessage.messageId];
    }
    
    NSArray *messages = [notification.userInfo objectForKey:@"Message"];
    for (EMMessage *message in messages)
    {
        //检测当前会话列表是否包含新建的会话
        if ([consations containsObject:message.messageId])
        {
            for (NSInteger i = 0; i < consations.count; i++)
            {
                WeChatListModel *model = [self.dataArray objectAtIndex:i];
                if ([message.messageId isEqual:model.conversation.latestMessage.messageId])
                {
                    NSIndexPath *indexPathF = [NSIndexPath indexPathForRow:i inSection:0];
                    NSIndexPath *indexPathT = [NSIndexPath indexPathForRow:0 inSection:0];
                    EMConversation *conversation = model.conversation;
                    NSInteger unreadConut = model.unreadMessagesCount;
                    BOOL isAppendSuccess = [model.conversation appendMessage:message];
                    if (isAppendSuccess)
                    {
                        model.conversation = conversation;
                        model.unreadMessagesCount = unreadConut+1;
                        [self.weChatTableView reloadRowsAtIndexPaths:@[indexPathF] withRowAnimation:UITableViewRowAnimationFade];
                        if (i)
                        {
                            [self.weChatTableView moveRowAtIndexPath:indexPathF toIndexPath:indexPathT];
                        }
                    }else
                    {
                        [self.view makeToast:@"接收消息失败"];
                    }
                }

            }
            
        }else
        {
            WeChatListModel *newModel = [[WeChatListModel alloc]init];
            
            if (message.chatType == EMChatTypeChat)
            {
                EMConversation *newConversation = [[EMClient sharedClient].chatManager getConversation:message.from type:EMConversationTypeChat createIfNotExist:YES];
                newModel.conversation = newConversation;
                [self.dataArray insertObject:newModel atIndex:0];
                NSIndexPath *indexPathT = [NSIndexPath indexPathForRow:0 inSection:0];
                [self.weChatTableView insertRowsAtIndexPaths:@[indexPathT] withRowAnimation:UITableViewRowAnimationFade];
                [self.weChatTableView reloadRowsAtIndexPaths:@[indexPathT] withRowAnimation:UITableViewRowAnimationFade];
            }else if (message.chatType == EMChatTypeGroupChat)
            {
                [self getAllConversations];
            }
        }
    }
    NSInteger badge = [self.tabBarItem.badgeValue integerValue];
    self.tabBarItem.badgeValue = [NSString stringWithFormat:@"%zd",badge+messages.count];
    if ([self.tabBarItem.badgeValue integerValue]) {
        if ([self.tabBarItem.badgeValue integerValue] > 99) {
            self.tabBarItem.badgeValue = @"99+";
        }
    }else{
        self.tabBarItem.badgeValue = nil;
    }
}

#pragma mark 添加好友成功 A加B A收到的代理发通知
- (void)addFriendNoti:(NSNotification *)notification{
    NSString *userName = [notification.userInfo objectForKey:@"name"];
    [[EMClient sharedClient].chatManager getConversation:userName type:EMConversationTypeChat createIfNotExist:YES];
    EMTextMessageBody *body = [[EMTextMessageBody alloc] initWithText:@"我们已经是好友了,一起来聊天吧"];
    NSString *currentName = [[EMClient sharedClient] currentUsername];
    //生成Message
    EMMessage *emmessage = [[EMMessage alloc]initWithConversationID:userName from:currentName to:userName body:body ext:nil];
    emmessage.chatType = EMChatTypeChat;
    [[EMClient sharedClient].chatManager asyncSendMessage:emmessage progress:^(int progress) {
        
    } completion:^(EMMessage *message, EMError *error) {
        if (!error) {
            [self getAllConversations];
        }
    }];

}
#pragma mark 创建群组成功 
- (void)creatGroupSuccess:(NSNotification *)notifacation{
    
    EMGroup *group = [notifacation.userInfo objectForKey:GroupValue];
    EMConversation *conversation = [[EMClient sharedClient].chatManager getConversation:group.groupId type:EMConversationTypeGroupChat createIfNotExist:YES];
    conversation.ext = [NSDictionary dictionaryWithObject:group.subject forKey:GroupName];
    [self getAllConversations];
}
#pragma mark  接收到入群申请(自动同意加群)
- (void)receiveGroupInvite:(NSNotification *)notification{
    
    NSDictionary *dict = notification.userInfo;
    EMGroup *group = [dict objectForKey:GroupValue];
    EMTextMessageBody *body = [[EMTextMessageBody alloc] initWithText:@"我加进来了,一起来聊天吧"];
    NSString *currentName = [[EMClient sharedClient] currentUsername];
    //生成Message
    EMMessage *emmessage = [[EMMessage alloc]initWithConversationID:group.groupId from:currentName to:group.groupId body:body ext:nil];
    emmessage.chatType = EMChatTypeGroupChat;
    [[EMClient sharedClient].chatManager asyncSendMessage:emmessage progress:^(int progress) {
        
    } completion:^(EMMessage *message, EMError *error) {
        if (!error) {
            EMConversation *conversation = [[EMClient sharedClient].chatManager getConversation:group.groupId type:EMConversationTypeGroupChat createIfNotExist:YES];
            conversation.ext = [NSDictionary dictionaryWithObject:group.subject forKey:GroupName];
            [self getAllConversations];
        }
    }];
}

#pragma mark 删除好友刷新页面
- (void)delectFriendNoti{
    
    [self getAllConversations];
}
#pragma mark 获取会话列表
- (void)getAllConversations{
    
    [self.dataArray removeAllObjects];
    NSArray *convers = [[EMClient sharedClient].chatManager getAllConversations];
    NSInteger unreadCount = 0;//取出各个会话的未读消息数
    NSInteger unreadAllCount = 0;//全部会话的未读消息数
    for (NSInteger i = convers.count-1; i >=0; i--)
    {
        EMConversation *conversation = [convers objectAtIndex:i];
        WeChatListModel *model = [[WeChatListModel alloc]init];
        model.conversation = conversation;
        [self.dataArray addObject:model];
        unreadCount = conversation.unreadMessagesCount;
        unreadAllCount += unreadCount;
    }
    if (unreadAllCount) {
        self.tabBarItem.badgeValue = [NSString stringWithFormat:@"%zd",unreadAllCount];
        if (unreadAllCount > 99) {
            self.tabBarItem.badgeValue = @"99+";
        }
    }else{
        self.tabBarItem.badgeValue = nil;
    }

    //对拿到的会话列表按照时间 重新排序
    for (NSInteger i = 0; i < self.dataArray.count; i++)
    {
        WeChatListModel *maxtimeModel = [self.dataArray objectAtIndex:i];
        long long maxtime = maxtimeModel.conversation.latestMessage.timestamp;
        for (NSInteger j = 1+i; j < self.dataArray.count; j++)
        {
            WeChatListModel *model = [self.dataArray objectAtIndex:j];
            long long time = model.conversation.latestMessage.timestamp;
            if (time > maxtime)
            {
                WeChatListModel *currentMaxModel = [self.dataArray objectAtIndex:i];
                [self.dataArray replaceObjectAtIndex:i withObject:model];
                [self.dataArray replaceObjectAtIndex:j withObject:currentMaxModel];
                maxtime = model.conversation.latestMessage.timestamp;
            }
        }
        
    }
    [self.weChatTableView reloadData];
}


- (void)dealloc{
    
    [JP_NotificationCenter removeObserver:self name:LOGINCHANGE object:nil];
    [JP_NotificationCenter removeObserver:self name:AUTOLOGINSUCCESS object:nil];
    [JP_NotificationCenter removeObserver:self name:NETWORKSTATE object:nil];
    [JP_NotificationCenter removeObserver:self name:RECEIVEMESSAGES object:nil];
    [JP_NotificationCenter removeObserver:self name:ADDFRIENDSUCCESS object:nil];
    [JP_NotificationCenter removeObserver:self name:CREATGROUPSUCCESS object:nil];
}
@end
