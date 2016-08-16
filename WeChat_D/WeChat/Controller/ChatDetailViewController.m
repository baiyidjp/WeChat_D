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
#import "Mp3Recorder.h"
#import "MessageModel.h"
#import "UIViewController+BackButtonHandler.h"
#import "WeChatViewController.h"
#import "JPBigImageView.h"

static int message_count = 20;
@interface ChatDetailViewController ()<UITableViewDelegate,UITableViewDataSource,JPKeyBoardToolViewDelegate,UIScrollViewDelegate,MessageTableViewCellDelegate>
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
 *  当前会话
 */
@property(nonatomic,strong)EMConversation *conversation;
/**
 *  当前会话接收到的消息集合
 */
@property(nonatomic,strong)NSMutableArray *reciveMessageArray;
/** 播放语音 */
@property(nonatomic,strong) Mp3Recorder *mp3Recorder;
/** MessCell 用来停止播放语音 */
@property(nonatomic,strong) MessageTableViewCell *voiceMessageCell;
/**
 *  点击图片放大
 */
@property(nonatomic,strong)JPBigImageView *bigImageView;
/**
 *  下拉刷新控件
 */
@property(nonatomic,strong)UIView *topRefreshView;
@property(nonatomic,strong)UIActivityIndicatorView *topIndicatorView;
@property(nonatomic,strong)UILabel *refreshLabel;
@property (strong, nonatomic) UIPanGestureRecognizer *pan;

@end

@implementation ChatDetailViewController

- (NSMutableArray *)dataArray{
    
    if (!_dataArray) {
        
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

- (NSMutableArray *)reciveMessageArray{
    
    if (!_reciveMessageArray) {
        _reciveMessageArray = [NSMutableArray array];
    }
    return _reciveMessageArray;
}

- (void)SetrefreshControl{
    
    self.topRefreshView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, KWIDTH, KNAVHEIGHT)];
    self.topIndicatorView   = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(KWIDTH/2-50, KNAVHEIGHT/2-KMARGIN, 2*KMARGIN, 2*KMARGIN)];
    self.topIndicatorView.color = [UIColor whiteColor];
    self.topIndicatorView.hidesWhenStopped = NO;
    [self.topRefreshView addSubview:self.topIndicatorView];
    self.refreshLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.topIndicatorView.frame)+KMARGIN, KNAVHEIGHT/2-KMARGIN, KWIDTH/2, 2*KMARGIN)];
    self.refreshLabel.text = @"下拉获取消息";
    self.refreshLabel.textColor = [UIColor whiteColor];
    self.refreshLabel.font = FONTSIZE(15);
    [self.topRefreshView addSubview:self.refreshLabel];

}

//重写返回事件
- (BOOL)navigationShouldPopOnBackButton{
    for (UIViewController *ctrl in self.navigationController.viewControllers) {
        if ([ctrl isKindOfClass:[WeChatViewController class]]) {
            [self.navigationController popToViewController:ctrl animated:YES];
        }
    }
    return YES;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.toolView];
    [self.view addSubview:self.ChatTableView];
    
    [self SetrefreshControl];
    
    UIImage *groupInfoImage = [UIImage imageNamed:@"barbuttonicon_InfoSingle_30x30_"];
    
    NSString *aConversationId = self.title;
    EMConversationType aConversationType = EMConversationTypeChat;
    if (self.groupID.length) {
        aConversationId = self.groupID;
        aConversationType = EMConversationTypeGroupChat;
        //添加 加号
        groupInfoImage = [UIImage imageNamed:@"barbuttonicon_InfoMulti_30x30_"];
    }
    UIButton *groupInfoBtn = [[UIButton alloc] initWithFrame:CGRectMake(KMARGIN, 0, 30, 30)];
    [groupInfoBtn setBackgroundImage:groupInfoImage forState:UIControlStateNormal];
    [groupInfoBtn addTarget:self action:@selector(delect) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *right = [[UIBarButtonItem alloc]initWithCustomView:groupInfoBtn];
    self.navigationItem.rightBarButtonItem = right;
    
    EMConversation *conversation = [[EMClient sharedClient].chatManager getConversation:aConversationId type:aConversationType createIfNotExist:YES];
    if (self.groupID.length) {
        conversation.ext = [NSDictionary dictionaryWithObject:self.title forKey:GroupName];
    }
    self.conversation = conversation;
    [conversation markAllMessagesAsRead];
    NSArray *messages = [conversation loadMoreMessagesFromId:nil limit:message_count direction:EMMessageSearchDirectionUp];
    [self.dataArray addObjectsFromArray:messages];
    
    if (self.dataArray.count) {
        [self.ChatTableView reloadData];
        [self.ChatTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:self.dataArray.count-1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    }
    
    
    [JP_NotificationCenter addObserver:self selector:@selector(receiveMessages:) name:RECEIVEMESSAGES object:nil];
}

#pragma mark 删除当前会话的所有消息
- (void)delect{
    
    if (self.groupID.length) {
        [self.view makeToast:@"群组详情"];
    }else{
        UIAlertController *alertCtrl = [UIAlertController alertControllerWithTitle:@"确定删除消息记录么?" message:nil preferredStyle:UIAlertControllerStyleAlert];
        [alertCtrl addAction:[UIAlertAction actionWithTitle:@"删除" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
            
            [SVProgressHUD show];
            [self.dataArray removeAllObjects];
            BOOL isSuccess =  [self.conversation deleteAllMessages];
            if (isSuccess) {
                [SVProgressHUD showSuccessWithStatus:@"删除成功"];
                [self.ChatTableView reloadData];
            }else{
                [SVProgressHUD showSuccessWithStatus:@"删除失败"];
            }
            
        }]];
        [alertCtrl addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:nil]];
        [self presentViewController:alertCtrl animated:YES completion:nil];
    }

}

- (UITableView *)ChatTableView{
    
    if (!_ChatTableView) {
        _ChatTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, KNAVHEIGHT, KWIDTH, KHEIGHT-KNAVHEIGHT-KTOOLVIEW_MINH) style:UITableViewStylePlain];
        _ChatTableView.contentInset = UIEdgeInsetsMake(-KNAVHEIGHT, 0, 0, 0);
        _ChatTableView.delegate = self;
        _ChatTableView.dataSource = self;
        [_ChatTableView registerClass:[MessageTableViewCell class] forCellReuseIdentifier:@"MessageTableViewCell"];
        _ChatTableView.tableFooterView = [[UIView alloc]init];
        _ChatTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _ChatTableView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"location"]];
        [_ChatTableView addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew context:nil];
        self.pan = _ChatTableView.panGestureRecognizer;
        [self.pan addObserver:self forKeyPath:@"state" options:NSKeyValueObservingOptionNew context:nil];
    }
    return _ChatTableView;
}

- (JPKeyBoardToolView *)toolView{
    if (!_toolView) {
        _toolView = [[JPKeyBoardToolView alloc]initWithFrame:CGRectMake(0, KHEIGHT-KTOOLVIEW_MINH, KWIDTH, KTOOLVIEW_MINH)];
        _toolView.superViewHeight = KHEIGHT;
        _toolView.delegate = self;
        if (self.groupID.length) {
            _toolView.toUser = self.groupID;
            _toolView.chatType = EMChatTypeGroupChat;
        }else{
            _toolView.toUser = self.title;
            _toolView.chatType = EMChatTypeChat;
        }
    }
    return _toolView;
}

- (Mp3Recorder *)mp3Recorder{
    
    if (!_mp3Recorder) {
        _mp3Recorder = [[Mp3Recorder alloc]init];
    }
    return _mp3Recorder;
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

#pragma mark 发送消息
- (void)didSendMessageOfFaceView:(JPKeyBoardToolView *)toolView message:(EMMessage *)emmessage{

    [self.dataArray addObject:emmessage];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:self.dataArray.count-1 inSection:0];
    [self.ChatTableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    if (self.dataArray.count) {
        [self.ChatTableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    }
    
    [[EMClient sharedClient].chatManager asyncSendMessage:emmessage progress:^(int progress) {
    } completion:^(EMMessage *message, EMError *error) {
        if (!error) {
            [SVProgressHUD showSuccessWithStatus:@"发送成功"];
            [self.ChatTableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        }else{
            [SVProgressHUD showSuccessWithStatus:@"发送失败"];
            [self.ChatTableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        }
    }];
}
#pragma mark 重发消息
- (void)resendMessageWith:(MessageTableViewCell *)messageCell indexPath:(NSIndexPath *)indexPath{
    
    EMMessage *emmessage = [self.dataArray objectAtIndex:indexPath.row];// 拿到要重新发送的消息

    [self.dataArray removeObject:emmessage];//移除发送失败的那条消息 也就是我们上面拿到的那一条
    [self.ChatTableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    [self.dataArray addObject:emmessage];//添加已经重新发送的消息
    NSIndexPath *newindexPath = [NSIndexPath indexPathForRow:self.dataArray.count-1 inSection:0];
    [self.ChatTableView insertRowsAtIndexPaths:@[newindexPath] withRowAnimation:UITableViewRowAnimationFade];
    if (self.dataArray.count) {
        [self.ChatTableView scrollToRowAtIndexPath:newindexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    }
    
    [[EMClient sharedClient].chatManager asyncResendMessage:emmessage progress:^(int progress) {
    } completion:^(EMMessage *message, EMError *error) {
        if (!error) {
            [SVProgressHUD showSuccessWithStatus:@"发送成功"];
            [self.ChatTableView reloadRowsAtIndexPaths:@[newindexPath] withRowAnimation:UITableViewRowAnimationFade];
        }else{
            [SVProgressHUD showSuccessWithStatus:@"发送失败"];
            [self.ChatTableView reloadRowsAtIndexPaths:@[newindexPath] withRowAnimation:UITableViewRowAnimationFade];
        }
    }];

}
#pragma mark 接收消息
- (void)receiveMessages:(NSNotification *)notification{
    
    NSArray *messages = [notification.userInfo objectForKey:@"Message"];
    [self.dataArray addObjectsFromArray:messages];
    [self.reciveMessageArray addObjectsFromArray:messages];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:self.dataArray.count-1 inSection:0];
    [self.ChatTableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
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
    cell.indexPath = indexPath;
    cell.model = model;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.delegate = self;
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    return self.topRefreshView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return KNAVHEIGHT;
}

//- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
//    
//    CGFloat panTranslationY = [scrollView.panGestureRecognizer translationInView:self.ChatTableView].y;//在tableVIEW的移动的坐标
//    if (panTranslationY < 0) {//上滑趋势
//        [self.toolView beginEditing];
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
- (void)messageCellTappedHead:(MessageTableViewCell *)messageCell{
    
    [self.view makeToast:@"点击头像未处理"];
}
- (void)messageCellTappedMessage:(MessageTableViewCell *)messageCell tapView:(UIView *)tapView MessageModel:(MessageModel *)messageModel{
    
    switch (messageModel.messageType) {
        case MessageType_Text:
            [self.view makeToast:@"点击文字未处理"];
            break;
        case MessageType_Picture:{
            
            [SVProgressHUD show];
            UIWindow *window = [UIApplication sharedApplication].keyWindow;
            CGRect tapViewFrame = [tapView convertRect:tapView.bounds toView:nil];
            NSLog(@"点击的图片的frame %@",NSStringFromCGRect(tapViewFrame));
            WEAK_SELF(weakSelf);
            [messageModel getBigImageWithBlock:^(UIImage *bigImage) {
                if (bigImage) {
                    self.bigImageView = [[JPBigImageView alloc]initWithFrame:window.bounds showImage:bigImage initialFrame:tapViewFrame];
                    self.bigImageView.alpha = 0.0;
                    [window addSubview:self.bigImageView];
                    [UIView animateWithDuration:0.5 animations:^{
                        weakSelf.bigImageView.alpha = 1.0;
                    }];
                    [self.bigImageView setClickViewHidden:^{
                        [UIView animateWithDuration:0.5 animations:^{
                            weakSelf.bigImageView.alpha = 0.0;
                        } completion:^(BOOL finished) {
                            [weakSelf.bigImageView removeFromSuperview];
                            weakSelf.bigImageView = nil;
                        }];
                    }];

                }else{
                    [self.view makeToast:@"加载失败"];
                }
            }];
        }
            break;

        case MessageType_Voice:{
            self.voiceMessageCell = messageCell;
            NSFileManager *fileManger = [NSFileManager defaultManager];
            if ([fileManger fileExistsAtPath:messageModel.voiceLocaPath]){
                [self.mp3Recorder startPlayRecordWithPath:messageModel.voiceLocaPath];
            }else{
                [self.mp3Recorder startPlayRecordWithPath:messageModel.voicePath];
            }
        }
            break;

        default:
            break;
    }
}
#pragma mark 删除消息
- (void)messageCellLonrPressMessage:(MessageTableViewCell *)messageCell MessageModel:(MessageModel *)messageModel indexPath:(NSIndexPath *)indexPath{
    
    NSLog(@"长按删除消息");
    UIAlertController *alertCtrl = [UIAlertController alertControllerWithTitle:@"是否删除本条消息" message:nil preferredStyle:UIAlertControllerStyleAlert];
    [alertCtrl addAction:[UIAlertAction actionWithTitle:@"删除" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action){

        [SVProgressHUD show];
        BOOL delectMessage = [self.conversation deleteMessageWithId:messageModel.messageId];
        if (delectMessage) {
            [SVProgressHUD showSuccessWithStatus:@"删除成功"];
            [self.dataArray removeObject:messageModel.emmessage];
            [self.ChatTableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
        }else{
            [SVProgressHUD showSuccessWithStatus:@"删除失败"];
        }
        
    }]];
    [alertCtrl addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:nil]];
    [self presentViewController:alertCtrl animated:YES completion:nil];

}

#pragma mark KVO监听
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context {
    
    if ([keyPath isEqualToString:@"contentOffset"]) {
        
        CGPoint contentOffset = [[change valueForKey:NSKeyValueChangeNewKey] CGPointValue];
        if (contentOffset.y < 0) {
            
            self.refreshLabel.text = @"松开立即刷新";
        }
        
    }else if ([keyPath isEqualToString:@"state"]){
        
        UIPanGestureRecognizer *tableViewPan = (UIPanGestureRecognizer *)object;
        if (tableViewPan.state == UIGestureRecognizerStateEnded && self.ChatTableView.contentOffset.y < 0) {
            [self beginRefresh];
        }
    }
}

- (void)beginRefresh{
    
    if ([self.topIndicatorView isAnimating]) {
        return;
    }
    [self.topIndicatorView startAnimating];
    self.refreshLabel.text = @"正在刷新数据";
    [UIView animateWithDuration:0.3 animations:^{
        self.ChatTableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    }];

    NSArray *messages = [self.conversation loadMoreMessagesFromId:[[self.dataArray objectAtIndex:0] messageId] limit:message_count direction:EMMessageSearchDirectionUp];

    [self.dataArray insertObjects:messages atIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, [messages count])]];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.ChatTableView reloadData];
        [self endRefresh];
        if (messages.count) {
            [self.ChatTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:messages.count-1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:NO];
        }else{
            [self.view makeToast:@"历史消息都被你加载完了,还想干嘛"];
        }
    });

}

- (void)endRefresh{
    
    [self.topIndicatorView stopAnimating];
    self.refreshLabel.text = @"下拉获取消息";
    [UIView animateWithDuration:0.3 animations:^{
        self.ChatTableView.contentInset = UIEdgeInsetsMake(-KNAVHEIGHT, 0, 0, 0);
    }];
}

- (void)dealloc{
    
    [JP_NotificationCenter removeObserver:self name:RECEIVEMESSAGES object:nil];
    [self.ChatTableView removeObserver:self forKeyPath:@"contentOffset" context:nil];
    [self.pan removeObserver:self forKeyPath:@"state"];
}

- (void)viewWillDisappear:(BOOL)animated{
    
    [super viewWillDisappear:animated];
    for (EMMessage *emmessage in self.reciveMessageArray) {
        [self.conversation markMessageAsReadWithId:emmessage.messageId];
    }
    [self.voiceMessageCell viewBack];//处理正在播放时候 离开聊天界面的问题
}

@end
