//
//  ChatDetailViewController.m
//  WeChat_D
//
//  Created by tztddong on 16/7/12.
//  Copyright © 2016年 dongjiangpeng. All rights reserved.
//

#import "ChatDetailViewController.h"
#import "JPKeyBoardToolView.h"

#define MESSAGE @"message"
@interface ChatDetailViewController ()<UITableViewDelegate,UITableViewDataSource,JPKeyBoardToolViewDelegate,UIScrollViewDelegate>
@property(nonatomic,strong)UITableView *ChatTableView;
@property(nonatomic,strong)JPKeyBoardToolView *toolView;
@property(nonatomic,strong)NSMutableArray *dataArray;
@end

@implementation ChatDetailViewController

- (NSMutableArray *)dataArray{
    
    if (!_dataArray) {
        NSMutableArray *array = [[NSUserDefaults standardUserDefaults]objectForKey:MESSAGE];
        if (array.count) {
            _dataArray = [NSMutableArray arrayWithArray:[array copy]];//_dataArray = array 这样写是错误 并没有制定_dataArray是可变的对象 下面引用的时候在addobject就会崩溃
        }else{
            _dataArray = [NSMutableArray array];
        }
    }
    return _dataArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.toolView];
    [self.view addSubview:self.ChatTableView];
    
    UIBarButtonItem *right = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemEdit target:self action:@selector(delect)];
    self.navigationItem.rightBarButtonItem = right;
    
}

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
        [_ChatTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"ChatTableView"];
        _ChatTableView.tableFooterView = [[UIView alloc]init];
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
}

- (void)didSendMessageOfFaceView:(JPKeyBoardToolView *)toolView message:(NSString *)message{
    
    [self.dataArray addObject:message];
    [[NSUserDefaults standardUserDefaults]setObject:self.dataArray forKey:MESSAGE];
    [self.ChatTableView reloadData];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ChatTableView"];
    cell.textLabel.text = [self.dataArray objectAtIndex:indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    [self.toolView endEditing];
}

@end
