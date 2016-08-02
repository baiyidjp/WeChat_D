//
//  MyInfoController.m
//  WeChat_D
//
//  Created by tztddong on 16/8/2.
//  Copyright © 2016年 dongjiangpeng. All rights reserved.
//

#import "MyInfoController.h"

@interface MyInfoController ()<UITableViewDelegate,UITableViewDataSource>

@end

@implementation MyInfoController
{
    UITableView *myInfoTableView;
    NSMutableArray *dataArray;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"个人信息";
    
    [self configTableView];
    
}

- (void)configTableView{
    
    myInfoTableView = [[UITableView alloc]init];
    myInfoTableView.delegate = self;
    myInfoTableView.dataSource = self;
    myInfoTableView.tableFooterView = [[UIView alloc]init];
    myInfoTableView.backgroundColor = [UIColor colorWithHexString:@"f4f4f4"];
    [self.view addSubview:myInfoTableView];
    [myInfoTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    dataArray = [NSMutableArray array];
    NSDictionary *dict1 = [NSDictionary dictionaryWithObjects:@[@"头像",DefaultHeadImageName_Message] forKeys:@[@"title",@"desctitle"]];
    NSDictionary *dict2 = [NSDictionary dictionaryWithObjects:@[@"名字",[EMClient sharedClient].currentUsername] forKeys:@[@"title",@"desctitle"]];
    NSDictionary *dict3 = [NSDictionary dictionaryWithObjects:@[@"微信号",[EMClient sharedClient].currentUsername] forKeys:@[@"title",@"desctitle"]];
    NSDictionary *dict4 = [NSDictionary dictionaryWithObjects:@[@"我的二维码",@"setting_myQR_18x18_"] forKeys:@[@"title",@"desctitle"]];
    NSDictionary *dict5 = [NSDictionary dictionaryWithObjects:@[@"我的地址",@""] forKeys:@[@"title",@"desctitle"]];
    NSDictionary *dict6 = [NSDictionary dictionaryWithObjects:@[@"性别",@""] forKeys:@[@"title",@"desctitle"]];
    NSDictionary *dict7 = [NSDictionary dictionaryWithObjects:@[@"地区",@""] forKeys:@[@"title",@"desctitle"]];
    NSDictionary *dict8 = [NSDictionary dictionaryWithObjects:@[@"个性签名",@""] forKeys:@[@"title",@"desctitle"]];
    NSMutableArray *arr1 = [NSMutableArray arrayWithObjects:dict1,dict2,dict3,dict4,dict5, nil];
    NSMutableArray *arr2 = [NSMutableArray arrayWithObjects:dict6,dict7,dict8, nil];
    [dataArray addObject:arr1];
    [dataArray addObject:arr2];
    [myInfoTableView reloadData];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return dataArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    NSArray *arr = [dataArray objectAtIndex:section];
    return arr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cellid"];
    NSDictionary *dict = [[dataArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    if (indexPath.section == 0 && indexPath.row == 0) {
        
            UIImageView *headImage = [[UIImageView alloc]init];
            headImage.image = [UIImage imageNamed:[dict objectForKey:@"desctitle"]];
            [cell.contentView addSubview:headImage];
            [headImage mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.offset(KMARGIN/2);
                make.right.bottom.offset(-KMARGIN/2);
                make.width.equalTo(headImage.mas_height);
            }];
        }else if (indexPath.section == 0 && indexPath.row == 3){
            UIImageView *QRImage = [[UIImageView alloc]init];
            QRImage.image = [UIImage imageNamed:[dict objectForKey:@"desctitle"]];
            [cell.contentView addSubview:QRImage];
            [QRImage mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.offset(KMARGIN/2);
                make.right.bottom.offset(-KMARGIN/2);
                make.width.equalTo(QRImage.mas_height);
            }];
        }else{
            UILabel *descLable = [[UILabel alloc]init];
            descLable.textColor = [UIColor colorWithHexString:@"000000"];
            descLable.font = FONTSIZE(14);
            descLable.numberOfLines = 2;
            descLable.text = [dict objectForKey:@"desctitle"];
            [cell.contentView addSubview:descLable];
            descLable.preferredMaxLayoutWidth = ScaleValueW(200);
            [descLable mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.offset(KMARGIN/2);
                make.right.bottom.offset(-KMARGIN/2);
            }];
    }
    cell.textLabel.text = [dict objectForKey:@"title"];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            return 70;
        }
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
