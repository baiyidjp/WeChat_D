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

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.toolView];
    [self.view addSubview:self.ChatTableView];
    
    UIBarButtonItem *right =  [[UIBarButtonItem alloc]initWithTitle:@"Delect" style:UIBarButtonItemStylePlain target:self action:@selector(delect)];
    self.navigationItem.rightBarButtonItem = right;
    
    EMConversation *conversation = [[EMClient sharedClient].chatManager getConversation:self.title type:EMConversationTypeChat createIfNotExist:YES];
    self.conversation = conversation;
    [conversation markAllMessagesAsRead];
    NSArray *messages = [conversation loadMoreMessagesFromId:nil limit:20 direction:EMMessageSearchDirectionUp];
    [self.dataArray addObjectsFromArray:messages];
    
    if (self.dataArray.count) {
        [self.ChatTableView reloadData];
        [self.ChatTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:self.dataArray.count-1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    }
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveMessages:) name:RECEIVEMESSAGES object:nil];
}

#pragma mark 删除当前会话的所有消息
- (void)delect{
    
    UIAlertController *alertCtrl = [UIAlertController alertControllerWithTitle:@"确定删除消息记录么?" message:nil preferredStyle:UIAlertControllerStyleAlert];
    [alertCtrl addAction:[UIAlertAction actionWithTitle:@"删除" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        
        //添加好友
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
    [alertCtrl addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
    [self presentViewController:alertCtrl animated:YES completion:nil];

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
    if (emmessage.body.type == EMMessageBodyTypeText) {
        [SVProgressHUD show];
    }
    [[EMClient sharedClient].chatManager asyncSendMessage:emmessage progress:^(int progress) {
        [SVProgressHUD showProgress:progress/100.0 status:[NSString stringWithFormat:@"发送中 %d%%",progress]];
    } completion:^(EMMessage *message, EMError *error) {
        if (!error) {
            [SVProgressHUD showSuccessWithStatus:@"发送成功"];
            [self.dataArray addObject:message];
            [self.ChatTableView reloadData];
            if (self.dataArray.count) {
                [self.ChatTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:self.dataArray.count-1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
            }
        }else{
            [SVProgressHUD showSuccessWithStatus:@"发送失败"];
        }
    }];
}

#pragma mark 接收消息
- (void)receiveMessages:(NSNotification *)notification{
    
    NSArray *messages = [notification.userInfo objectForKey:@"Message"];
    [self.dataArray addObjectsFromArray:messages];
    [self.reciveMessageArray addObjectsFromArray:messages];
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

}
- (void)messageCellTappedMessage:(MessageTableViewCell *)messageCell MessageModel:(MessageModel *)messageModel{
    
    switch (messageModel.messageType) {
        case MessageType_Text:
            return;
            break;
        case MessageType_Picture:
            NSLog(@"点击图片放大");
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

- (void)dealloc{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:RECEIVEMESSAGES object:nil];
}

- (void)viewWillDisappear:(BOOL)animated{
    
    [super viewWillDisappear:animated];
    for (EMMessage *emmessage in self.reciveMessageArray) {
        [self.conversation markMessageAsReadWithId:emmessage.messageId];
    }
    [self.voiceMessageCell recordPlayFinish];
}

@end
