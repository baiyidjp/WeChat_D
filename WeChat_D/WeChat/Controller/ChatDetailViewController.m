//
//  ChatDetailViewController.m
//  WeChat_D
//
//  Created by tztddong on 16/7/12.
//  Copyright © 2016年 dongjiangpeng. All rights reserved.
//

#import "ChatDetailViewController.h"
#import "JPKeyBoardToolView.h"
#import "MessageTableViewCell.h"
#import "MessageModel.h"

#define MESSAGE @"message"
#define GETMESSAGE_TIME 15
@interface ChatDetailViewController ()<UITableViewDelegate,UITableViewDataSource,JPKeyBoardToolViewDelegate,UIScrollViewDelegate,MessageTableViewCellDelegate,EMChatManagerDelegate>
/**
 *  聊天界面
 */
@property(nonatomic,strong)UITableView *ChatTableView;
/**
 *  键盘工具栏
 */
@property(nonatomic,strong)JPKeyBoardToolView *toolView;
/**
 *  聊天数据(all)
 */
@property(nonatomic,strong)NSMutableArray *dataArray;
/**
 *  时间控制器
 */
@property(nonatomic,strong)NSTimer *timer;
/**
 *  走过的时间
 */
@property(nonatomic,assign)NSInteger timeCount;
/**
 *  模拟对方发消息
 */
@property(nonatomic,strong)NSMutableArray *friendMessage;
@end

@implementation ChatDetailViewController

- (NSMutableArray *)dataArray{
    
    if (!_dataArray) {
        EMConversation *conversation = [[EMClient sharedClient].chatManager getConversation:self.title type:EMConversationTypeChat createIfNotExist:YES];
        NSArray *messages = [conversation loadMoreMessagesFromId:nil limit:-1 direction:EMMessageSearchDirectionUp];
        if (messages.count) {
            _dataArray = [NSMutableArray array];
            [_dataArray addObjectsFromArray:messages];
        }else{
            _dataArray = [NSMutableArray array];
        }
    }
    return _dataArray;
}

- (NSTimer *)timer{
    
    if (!_timer) {
//        _timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(update) userInfo:nil repeats:YES];
    }
    return _timer;
}

- (NSMutableArray *)friendMessage{
    
    if (!_friendMessage) {
        NSArray *array = @[@"约么?帅哥 ! ! [害羞]",@"你好呀你好呀[微笑]好呀[微笑]好呀[微笑]好呀[微笑]好呀[微笑]好呀[微笑]",@"我是美女我是美女[色]我是美女我是美女[色]我是美女我是美女[色]我是美女我是美女[色]",@"陈妍希与陈晓这段“神雕之恋”以16个月时间订下终身",@"伴娘团包括：钟欣潼（阿娇）、陈乔恩，还有林依晨、潘玮柏、郑元畅等好友送嫁。"];
        _friendMessage = [NSMutableArray array];
        for (int i = 0 ; i < array.count; i++) {
            MessageModel *model = [[MessageModel alloc]init];
            model.messagetext = array[i];
            model.isMineMessage = NO;
            model.messageType = MessageType_Text;
            [_friendMessage addObject:model];
        }
    }
    return _friendMessage;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.toolView];
    [self.view addSubview:self.ChatTableView];
    
    UIBarButtonItem *right =  [[UIBarButtonItem alloc]initWithTitle:@"Delect" style:UIBarButtonItemStylePlain target:self action:@selector(delect)];
    self.navigationItem.rightBarButtonItem = right;
    
    if (self.dataArray.count) {
        [self.ChatTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:self.dataArray.count-1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    }
    
    [[EMClient sharedClient].chatManager addDelegate:self delegateQueue:nil];
}

//时间控制
- (void)update{
    
    self.timeCount++;
    NSLog(@"时间 -- %zd",self.timeCount);
    if (self.timeCount % GETMESSAGE_TIME != 0){
        return;
    }else{
        NSInteger arccount = arc4random_uniform(10);
        NSLog(@"随机数--%zd",arccount);
        MessageModel *model;
        if (arccount %2 ) {//奇数 取固定数据
            arccount = arc4random_uniform((int)self.friendMessage.count);
            NSLog(@"奇数--%zd",arccount);
            model = [self.friendMessage objectAtIndex:arccount];
        }else{
            if (self.dataArray.count) {
                arccount = arc4random_uniform((int)self.dataArray.count);
                NSLog(@"偶数--%zd",arccount);
                model = [self.dataArray objectAtIndex:arccount];
                model.isMineMessage = NO;
            }else{
                return;
            }
        }
        [self.dataArray addObject:model];
        NSArray *array = [MessageModel mj_keyValuesArrayWithObjectArray:self.dataArray];
        [[NSUserDefaults standardUserDefaults]setObject:array forKey:MESSAGE];
        [self.ChatTableView reloadData];
        if (self.dataArray.count) {
            [self.ChatTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:self.dataArray.count-1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
        }
    }
}

//删除缓存的消息
- (void)delect{
    
    [self.dataArray removeAllObjects];
    [[NSUserDefaults standardUserDefaults]setObject:self.dataArray forKey:MESSAGE];
    [self.ChatTableView reloadData];
}

- (UITableView *)ChatTableView{
    
    if (!_ChatTableView) {
        _ChatTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, KNAVHEIGHT, KWIDTH, KHEIGHT-KNAVHEIGHT-KTOOLVIEW_MINH) style:UITableViewStylePlain];
        _ChatTableView.delegate = self;
        _ChatTableView.dataSource = self;
        [_ChatTableView registerClass:[MessageTableViewCell class] forCellReuseIdentifier:@"MessageTableViewCell"];
        _ChatTableView.tableFooterView = [[UIView alloc]init];
        _ChatTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _ChatTableView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"location"]];
    }
    return _ChatTableView;
}

- (JPKeyBoardToolView *)toolView{
    if (!_toolView) {
        _toolView = [[JPKeyBoardToolView alloc]initWithFrame:CGRectMake(0, KHEIGHT-KTOOLVIEW_MINH, KWIDTH, KTOOLVIEW_MINH)];
        _toolView.superViewHeight = KHEIGHT;
        _toolView.toUser = self.title;
        _toolView.delegate = self;
    }
    return _toolView;
}

#pragma mark JPKeyBoardToolViewDelegate
- (void)keyBoardToolViewFrameDidChange:(JPKeyBoardToolView *)toolView frame:(CGRect)frame{
    
    if (self.ChatTableView.frame.size.height == frame.origin.y) {
        return;
    }

    [UIView animateWithDuration:0.3 animations:^{
        self.ChatTableView.frame = CGRectMake(0, KNAVHEIGHT, KWIDTH,frame.origin.y-KNAVHEIGHT);
    }];
}

- (void)didSendMessageOfFaceView:(JPKeyBoardToolView *)toolView message:(EMMessage *)message{
    
    [SVProgressHUD show];
    [[EMClient sharedClient].chatManager asyncSendMessage:message progress:^(int progress) {
        
    } completion:^(EMMessage *message, EMError *error) {
        if (!error) {
            [SVProgressHUD showSuccessWithStatus:@"发送成功"];
            [self.dataArray addObject:message];
            [self.ChatTableView reloadData];
            if (self.dataArray.count) {
                [self.ChatTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:self.dataArray.count-1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
            }
        }
    }];
}

#pragma mark 接收消息
- (void)didReceiveMessages:(NSArray *)aMessages{
    
    [self.dataArray addObjectsFromArray:aMessages];
    [self.ChatTableView reloadData];
    if (self.dataArray.count) {
        [self.ChatTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:self.dataArray.count-1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    }

}

#pragma mark  UITableViewDelegate UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    MessageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MessageTableViewCell"];
    MessageModel *model = [[MessageModel alloc]init];
    EMMessage *emmessage = [self.dataArray objectAtIndex:indexPath.row];
    model.emmessage = emmessage;
    cell.model = model;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.delegate = self;
    return cell;
}

//- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
//    
//    CGFloat panTranslationY = [scrollView.panGestureRecognizer translationInView:self.ChatTableView].y;//在tableVIEW的移动的坐标
//    if (panTranslationY < 0) {//上滑趋势
//        [self.toolView beginEditing];
//    }
//}

//- (void)tableView:(UITableView *)tableView didEndDisplayingCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
//    
//    if (cell.contentView.subviews.count) {
//        for (UIView *view in cell.contentView.subviews) {
//            [view removeFromSuperview];
//        }
//    }
//}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    MessageModel *model = [[MessageModel alloc]init];
    EMMessage *emmessage = [self.dataArray objectAtIndex:indexPath.row];
    model.emmessage = emmessage;
    CGFloat height = [MessageTableViewCell cellHeightWithModel:model];
    return height;
}

#pragma mark MessageTableViewCellDelegate
- (void)messageCellTappedBlank:(MessageTableViewCell *)messageCell{
    [self.toolView endEditing];
}

- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    //加一个时间控制 模拟对方发消息
//    [self.timer setFireDate:[NSDate distantPast]];
}

- (void)viewWillDisappear:(BOOL)animated{
    
    [super viewWillDisappear:animated];
//    [self.timer setFireDate:[NSDate distantFuture]];
}

@end
