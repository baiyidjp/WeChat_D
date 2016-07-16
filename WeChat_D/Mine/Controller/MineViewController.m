//
//  MineViewController.m
//  WeChat_Djp
//
//  Created by tztddong on 16/7/8.
//  Copyright © 2016年 dongjiangpeng. All rights reserved.
//

#import "MineViewController.h"
#import "LoginViewController.h"

@interface MineViewController ()<UITableViewDelegate,UITableViewDataSource>

@end

@implementation MineViewController
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

    UIBarButtonItem *right = [[UIBarButtonItem alloc]initWithTitle:@"Login" style:UIBarButtonItemStylePlain target:self action:@selector(login)];
    self.navigationItem.rightBarButtonItem = right;
    
    
    [self configTableView];
}

- (void)login{
    
    LoginViewController *login = [[LoginViewController alloc]init];
    [self.navigationController pushViewController:login animated:YES];
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
    
    dataArray = @[@[@{@"imageName":@"Tabbar_contact",@"title":@"相册"},
                    @{@"imageName":@"Tabbar_contact",@"title":@"收藏"},
                    @{@"imageName":@"Tabbar_contact",@"title":@"钱包"},
                    @{@"imageName":@"Tabbar_contact",@"title":@"卡包"}],
                @[@{@"imageName":@"Tabbar_contact",@"title":@"表情"}],
                @[@{@"imageName":@"Tabbar_contact",@"title":@"设置"}]];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (section == 1){
        return 4;
    }
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cellid"];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    if (indexPath.section == 0) {
        [self configSectionOneView:cell.contentView];
    }else{
        NSArray *section = [dataArray objectAtIndex:indexPath.section-1];
        NSDictionary *dataDict = [section objectAtIndex:indexPath.row];
        [self configSectionView:cell.contentView data:dataDict];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)configSectionOneView:(UIView *)backView{
    
    UIImageView *headImage = [[UIImageView alloc]init];
    headImage.backgroundColor = [UIColor purpleColor];
    headImage.layer.cornerRadius = 5;
    [backView addSubview:headImage];
    [headImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(KMARGIN);
        make.left.offset(KMARGIN*3/2);
        make.bottom.offset(-KMARGIN);
        make.width.equalTo(@70);
    }];
    
    UILabel *nameLabel = [[UILabel alloc]init];
    nameLabel.text = @"微信昵称";
    nameLabel.font = FONTSIZE(15);
    [backView addSubview:nameLabel];
    [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(headImage.mas_right).with.offset(KMARGIN);
        make.centerY.equalTo(headImage.mas_centerY).with.offset(-KMARGIN*3/2);
    }];
    
    UILabel *codeLabel = [[UILabel alloc]init];
    codeLabel.text = @"微信号码";
    codeLabel.font = FONTSIZE(15);
    [backView addSubview:codeLabel];
    [codeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(headImage.mas_right).with.offset(KMARGIN);
        make.centerY.equalTo(headImage.mas_centerY).with.offset(KMARGIN*3/2);
    }];
    
    UIButton *qrCode = [[UIButton alloc]init];
    [qrCode setBackgroundColor:[UIColor grayColor]];
    [backView addSubview:qrCode];
    [qrCode mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.offset(0);
        make.centerY.equalTo(backView);
        make.size.mas_equalTo(CGSizeMake(20, 20));
    }];
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
    
    if (indexPath.section == 0) {
        return 90;
    }
    return 44;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    if (section == 0) {
        return KMARGIN;
    }
    return 2*KMARGIN;
}


@end
