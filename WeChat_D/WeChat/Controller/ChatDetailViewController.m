//
//  ChatDetailViewController.m
//  WeChat_D
//
//  Created by tztddong on 16/7/12.
//  Copyright © 2016年 dongjiangpeng. All rights reserved.
//

#import "ChatDetailViewController.h"
#import "JPKeyBoardToolView.h"

@interface ChatDetailViewController ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)UITableView *ChatTableView;
@property(nonatomic,strong)JPKeyBoardToolView *toolView;
@end

@implementation ChatDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.toolView];
    [self.view addSubview:self.ChatTableView];
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
    }
    return _toolView;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 20;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ChatTableView"];
    cell.textLabel.text = [NSString stringWithFormat:@"%zd",indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

@end
