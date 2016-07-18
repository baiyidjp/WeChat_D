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
 *  时间控制器
 */
@property(nonatomic,strong)NSTimer *timer;
/**
 *  走过的时间
 */
@property(nonatomic,assign)NSInteger count;
/**
 *  模拟对方发消息
 */
@property(nonatomic,strong)NSMutableArray *friendMessage;
@end

@implementation ChatDetailViewController

- (NSMutableArray *)dataArray{
    
    if (!_dataArray) {
        NSMutableArray *array = [[NSUserDefaults standardUserDefaults]objectForKey:MESSAGE];
        if (array.count) {
            _dataArray = [MessageModel mj_objectArrayWithKeyValuesArray:array];
        }else{
            _dataArray = [NSMutableArray array];
        }
    }
    return _dataArray;
}

- (NSTimer *)timer{
    
    if (!_timer) {
        _timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(update) userInfo:nil repeats:YES];
    }
    return _timer;
}

- (NSMutableArray *)friendMessage{
    
    if (!_friendMessage) {
        NSArray *array = @[@"约么?帅哥 ! ! [害羞]",@"你好呀你好呀[微笑]好呀[微笑]好呀[微笑]好呀[微笑]好呀[微笑]好呀[微笑]",@"我是美女我是美女[色]我是美女我是美女[色]我是美女我是美女[色]我是美女我是美女[色]"];
        _friendMessage = [NSMutableArray array];
        for (int i = 0 ; i < 3; i++) {
            MessageModel *model = [[MessageModel alloc]init];
            model.messagetext = array[i];
            model.isMineMessage = NO;
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
    
    UIBarButtonItem *right = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemEdit target:self action:@selector(delect)];
    self.navigationItem.rightBarButtonItem = right;
    
    if (self.dataArray.count) {
        [self.ChatTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:self.dataArray.count-1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    }
    
    //加一个时间控制 模拟对方发消息
    [self.timer setFireDate:[NSDate distantPast]];
}

//时间控制
- (void)update{
    
    self.count++;
    if (self.count % 15 != 0){
        return;
    }else{
        NSInteger arccount = arc4random_uniform(3);
        MessageModel *model = [self.friendMessage objectAtIndex:arccount];
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
    if (self.dataArray.count) {
        [self.ChatTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:self.dataArray.count-1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    }
}

- (void)didSendMessageOfFaceView:(JPKeyBoardToolView *)toolView message:(MessageModel *)message{
    
    [self.dataArray addObject:message];
    NSArray *array = [MessageModel mj_keyValuesArrayWithObjectArray:self.dataArray];
    [[NSUserDefaults standardUserDefaults]setObject:array forKey:MESSAGE];
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
    MessageModel *model = [self.dataArray objectAtIndex:indexPath.row];
    cell.model = model;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.delegate = self;
    return cell;
}

//- (void)tableView:(UITableView *)tableView didEndDisplayingCell:(MessageTableViewCell *)cell forRowAtIndexPath:(nonnull NSIndexPath *)indexPath{
//    
//    for (UIView *view in cell.contentView.subviews) {
//        [view removeFromSuperview];
//    }
//}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    CGFloat panTranslationY = [scrollView.panGestureRecognizer translationInView:self.ChatTableView].y;//在tableVIEW的移动的坐标
    if (panTranslationY < 0) {//上滑趋势
        [self.toolView beginEditing];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    MessageModel *model = [self.dataArray objectAtIndex:indexPath.row];
    CGFloat height = [MessageTableViewCell cellHeightWithModel:model];
    return height;
}

#pragma mark MessageTableViewCellDelegate
- (void)messageCellTappedBlank:(MessageTableViewCell *)messageCell{
    [self.toolView endEditing];
}

- (void)viewWillDisappear:(BOOL)animated{
    
    [super viewWillDisappear:animated];
    [self.timer setFireDate:[NSDate distantFuture]];
}

@end
