//
//  DiscoverViewController.m
//  WeChat_Djp
//
//  Created by tztddong on 16/7/8.
//  Copyright © 2016年 dongjiangpeng. All rights reserved.
//

#import "DiscoverViewController.h"

@interface DiscoverViewController ()<UITableViewDelegate,UITableViewDataSource>

@end

@implementation DiscoverViewController
{
    UITableView *mineTableView;
    NSArray *dataArray;
}
- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = NO;
    
}

- (void)viewWillDisappear:(BOOL)animated{
    
    [super viewWillDisappear:animated];
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self configTableView];
}

- (void)configTableView{
    
    mineTableView = [[UITableView alloc]init];
    mineTableView.delegate = self;
    mineTableView.dataSource = self;
    mineTableView.tableFooterView = [[UIView alloc]init];
    mineTableView.backgroundColor = [UIColor colorWithHexString:@"f4f4f4"];
    [self.view addSubview:mineTableView];
    [mineTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    dataArray = @[@[@{@"imageName":@"Tabbar_contact",@"title":@"朋友圈"},
                    @{@"imageName":@"Tabbar_contact",@"title":@"附近的人"},
                    @{@"imageName":@"Tabbar_contact",@"title":@"摇一摇"}],
                  @[@{@"imageName":@"Tabbar_contact",@"title":@"扫一扫"}],
                  @[@{@"imageName":@"Tabbar_contact",@"title":@"购物"},
                    @{@"imageName":@"Tabbar_contact",@"title":@"游戏"}]];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return  dataArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    NSArray *sectionarr = [dataArray objectAtIndex:section];
    return sectionarr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cellid"];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
 
    NSArray *section = [dataArray objectAtIndex:indexPath.section];
    NSDictionary *dataDict = [section objectAtIndex:indexPath.row];
    [self configSectionView:cell.contentView data:dataDict];

    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)configSectionView:(UIView *)backView data:(NSDictionary *)dataDict{
    
    UIImageView *image = [[UIImageView alloc]init];
    image.image = [UIImage imageNamed:[dataDict objectForKey:@"imageName"]];
    [backView addSubview:image];
    [image mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(KMARGIN*3/2);
        make.centerY.equalTo(backView);
        make.size.mas_equalTo(CGSizeMake(30, 30));
    }];
    
    UILabel *title = [[UILabel alloc]init];
    title.text = [dataDict objectForKey:@"title"];
    title.font = FONTSIZE(15);
    [backView addSubview:title];
    [title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(image.mas_right).with.offset(KMARGIN*3/2);
        make.centerY.equalTo(backView);
    }];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 44;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    if (section == 0) {
        return KMARGIN;
    }
    return 2*KMARGIN;
}

@end
