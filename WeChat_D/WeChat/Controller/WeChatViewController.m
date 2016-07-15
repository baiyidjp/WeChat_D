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

@interface WeChatViewController ()<UISearchBarDelegate,UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)UISearchBar *searchBar;
@property(nonatomic,strong)UIView *topStatusView;
@property(nonatomic,strong)UIButton *cancleBtn;
@property(nonatomic,strong)UITableView *weChatTableView;
@property(nonatomic,strong)UIScrollView *searchView;
@property(nonatomic,strong)NSMutableArray *dataArray;
@end

@implementation WeChatViewController
{
    NSInteger searchBarTop;
}

- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = NO;
    
}

- (void)viewWillDisappear:(BOOL)animated{
    
    [super viewWillDisappear:animated];
    
}

- (NSMutableArray *)dataArray{
    
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
        for (int i = 0; i < 10 ; i++) {
            WeChatListModel *model = [[WeChatListModel alloc]init];
            model.imageUrl = @"Tabar_mine";
            model.name = @"微信测试";
            model.message = @"晚上约么?";
            model.time = @"16:32";
            [_dataArray addObject:model];
        }
    }
    return _dataArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    searchBarTop = KNAVHEIGHT;
    UISearchBar *searchBar = [[UISearchBar alloc]init];
    searchBar.backgroundColor = [UIColor whiteColor];
    searchBar.placeholder = @"搜索";
    searchBar.delegate = self;
    searchBar.layer.cornerRadius = 5;
    searchBar.layer.masksToBounds = YES;
    [self.view addSubview:searchBar];
    self.searchBar = searchBar;
    
    self.topStatusView = [[UIView alloc]init];
    self.topStatusView.backgroundColor = [UIColor colorWithRed:54/255.0 green:53/255.0 blue:58/255.0 alpha:1];
    [self.view addSubview:self.topStatusView];
    [self.topStatusView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.offset(0);
        make.height.equalTo(@20);
    }];
    
    self.cancleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.cancleBtn setTitle:@"取消" forState:UIControlStateNormal];
    [self.cancleBtn.titleLabel setFont:FONTSIZE(15)];
    [self.cancleBtn setTitleColor:[UIColor greenColor] forState:UIControlStateNormal];
    [self.cancleBtn addTarget:self action:@selector(clickCancelBtn) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.cancleBtn];
    [self.cancleBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(20);
        make.right.equalTo(self.topStatusView.mas_right);
        make.height.equalTo(@44);
        make.width.equalTo(@44);
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

}

- (void)updateViewConstraints{
    
    [self.searchBar mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.offset(0);
        make.top.offset(searchBarTop);
        make.height.equalTo(@44);
        if (searchBarTop == 20) {
            make.right.offset(-44);
        }else{
            make.right.offset(0);
        }
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


//点击取消按钮
- (void)clickCancelBtn{
    searchBarTop = KNAVHEIGHT;
    [self.searchBar resignFirstResponder];
    //告诉某个view需要更新约束
    [self.view setNeedsUpdateConstraints];
    //检测这个view是否有约束需要更新 如果有在调用下面的方法 更新约束
    [self.view updateConstraintsIfNeeded];
    [UIView animateWithDuration:0.3 animations:^{
        [self.view layoutIfNeeded];
        [self isHidden:YES];
        //        [self setNeedsStatusBarAppearanceUpdate];
    }];

}

- (void)isHidden:(BOOL)hidden{
    
    self.cancleBtn.hidden = hidden;
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
    chatVC.title = [NSString stringWithFormat:@"%zd",indexPath.row];
    self.tabBarController.tabBar.hidden = YES;
    [self.navigationController pushViewController:chatVC animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 100;
}

@end
