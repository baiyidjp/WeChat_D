//
//  AgreeFriendViewController.m
//  WeChat_D
//
//  Created by tztddong on 16/7/22.
//  Copyright © 2016年 dongjiangpeng. All rights reserved.
//

#import "AgreeFriendViewController.h"
#import "NewFriendCell.h"

@interface AgreeFriendViewController ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)UITableView *friendTableView;
@end

@implementation AgreeFriendViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"新的朋友";
    self.view.backgroundColor = [UIColor colorWithHexString:@"f4f4f4"];
    
    self.friendTableView = [[UITableView alloc]init];
    self.friendTableView.delegate = self;
    self.friendTableView.dataSource = self;
    [self.friendTableView registerNib:[UINib nibWithNibName:@"NewFriendCell" bundle:nil] forCellReuseIdentifier:@"NewFriendCell"];
    self.friendTableView.tableFooterView = [[UIView alloc]init];
    [self.view addSubview:self.friendTableView];
    [self.friendTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.offset(0);
        make.top.offset(0);
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NewFriendCell *cell = [tableView dequeueReusableCellWithIdentifier:@"NewFriendCell"];
    cell.dict = [NSMutableDictionary dictionaryWithDictionary:[self.dataArray objectAtIndex:indexPath.row]];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 70;
}

@end
