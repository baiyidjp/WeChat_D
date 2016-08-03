//
//  MyInfoController.m
//  WeChat_D
//
//  Created by tztddong on 16/8/2.
//  Copyright © 2016年 dongjiangpeng. All rights reserved.
//

#import "MyInfoController.h"
#import "FirstViewController.h"
#import "MyQRCodeController.h"
#import "ChangeNameController.h"

#define INFOARRAY @"infoArray"
#define TITLE     @"title"
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
    
    [JP_NotificationCenter addObserver:self selector:@selector(chooseCity:) name:CITYCHOOSESUCCESS object:nil];
    [JP_NotificationCenter addObserver:self selector:@selector(changeName:) name:CHANGENAMESUCCESS object:nil];
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
    NSArray *infoArr = [[NSUserDefaults standardUserDefaults]objectForKey:INFOARRAY];
    if (infoArr.count) {
        [dataArray addObjectsFromArray:infoArr];
    }else{
        NSDictionary *dict1 = [NSDictionary dictionaryWithObjects:@[@"头像",DefaultHeadImageName_Message] forKeys:@[TITLE,CHANGEINFO_KEY]];
        NSDictionary *dict2 = [NSDictionary dictionaryWithObjects:@[@"名字",[EMClient sharedClient].currentUsername] forKeys:@[TITLE,CHANGEINFO_KEY]];
        NSDictionary *dict3 = [NSDictionary dictionaryWithObjects:@[@"微信号",[EMClient sharedClient].currentUsername] forKeys:@[TITLE,CHANGEINFO_KEY]];
        NSDictionary *dict4 = [NSDictionary dictionaryWithObjects:@[@"我的二维码",@"setting_myQR_18x18_"] forKeys:@[TITLE,CHANGEINFO_KEY]];
        NSDictionary *dict5 = [NSDictionary dictionaryWithObjects:@[@"我的地址",@""] forKeys:@[TITLE,CHANGEINFO_KEY]];
        NSDictionary *dict6 = [NSDictionary dictionaryWithObjects:@[@"性别",@""] forKeys:@[TITLE,CHANGEINFO_KEY]];
        NSDictionary *dict7 = [NSDictionary dictionaryWithObjects:@[@"地区",@""] forKeys:@[TITLE,CHANGEINFO_KEY]];
        NSDictionary *dict8 = [NSDictionary dictionaryWithObjects:@[@"个性签名",@""] forKeys:@[TITLE,CHANGEINFO_KEY]];
        NSMutableArray *arr1 = [NSMutableArray arrayWithObjects:dict1,dict2,dict3,dict4,dict5, nil];
        NSMutableArray *arr2 = [NSMutableArray arrayWithObjects:dict6,dict7,dict8, nil];
        [dataArray addObject:arr1];
        [dataArray addObject:arr2];

    }
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
            headImage.image = [UIImage imageNamed:[dict objectForKey:CHANGEINFO_KEY]];
            [cell.contentView addSubview:headImage];
            [headImage mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.offset(KMARGIN/2);
                make.right.bottom.offset(-KMARGIN/2);
                make.width.equalTo(headImage.mas_height);
            }];
        }else if (indexPath.section == 0 && indexPath.row == 3){
            UIImageView *QRImage = [[UIImageView alloc]init];
            QRImage.image = [UIImage imageNamed:[dict objectForKey:CHANGEINFO_KEY]];
            [cell.contentView addSubview:QRImage];
            [QRImage mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(cell.contentView.mas_centerY);
                make.right.offset(-KMARGIN/2);
                make.size.mas_equalTo(CGSizeMake(20, 20));
            }];
        }else{
            UILabel *descLable = [[UILabel alloc]init];
            descLable.textColor = [UIColor colorWithHexString:@"888888"];
            descLable.font = FONTSIZE(14);
            descLable.numberOfLines = 2;
            descLable.textAlignment = NSTextAlignmentRight;
            descLable.text = [dict objectForKey:CHANGEINFO_KEY];
            [cell.contentView addSubview:descLable];
            descLable.preferredMaxLayoutWidth = ScaleValueW(200);
            [descLable mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.offset(KMARGIN/2);
                make.right.bottom.offset(-KMARGIN/2);
            }];
    }
    cell.textLabel.text = [dict objectForKey:TITLE];
    cell.textLabel.font = FONTSIZE(15);
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSDictionary *dict = [[dataArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    
    if (indexPath.section == 0) {
        switch (indexPath.row) {
            case 0:
                [self.view makeToast:@"更换头像"];
                break;
            case 1:
            {
                ChangeNameController *ctrl = [[ChangeNameController alloc]init];
                ctrl.name = [dict objectForKey:CHANGEINFO_KEY];
                [self presentViewController:ctrl animated:YES completion:nil];
            }
                break;
            case 3:
            {
                MyQRCodeController *ctrl = [[MyQRCodeController alloc]init];
                NSDictionary *addressdict = [[dataArray objectAtIndex:1] objectAtIndex:1];
                NSDictionary *namedict = [[dataArray objectAtIndex:0] objectAtIndex:1];
                ctrl.region = [addressdict objectForKey:CHANGEINFO_KEY];
                ctrl.name = [namedict objectForKey:CHANGEINFO_KEY];
                [self.navigationController pushViewController:ctrl animated:YES];
                
            }
                break;
            case 4:
                [self.view makeToast:@"收货地址"];
                break;
            default:
                break;
        }
    }else{
        switch (indexPath.row) {
            case 0:
                [self.view makeToast:@"更改性别"];
                break;
            case 1:
            {
                FirstViewController *ctrl = [[FirstViewController alloc]init];
                [self.navigationController pushViewController:ctrl animated:YES];
                
            }
                break;
            case 2:
                [self.view makeToast:@"个性签名"];
                break;
            default:
                break;
        }

        
    }
}

//选择城市 的通知
- (void)chooseCity:(NSNotification *)notification{
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:1 inSection:1];
    NSDictionary *dict = notification.userInfo;
    [self changeWithNotifationDict:dict indexPath:indexPath];
}

//改变名字 的通知
- (void)changeName:(NSNotification *)notification{
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:1 inSection:0];
    NSDictionary *dict = notification.userInfo;
    [self changeWithNotifationDict:dict indexPath:indexPath];
}

- (void)changeWithNotifationDict:(NSDictionary *)dict indexPath:(NSIndexPath *)indexPath{
    
    NSMutableArray *arr = [NSMutableArray arrayWithArray:[dataArray objectAtIndex:indexPath.section]];
    NSDictionary *pastDict = [arr objectAtIndex:indexPath.row];
    NSDictionary *nowDict = [NSDictionary dictionaryWithObjects:@[[pastDict objectForKey:TITLE],[dict objectForKey:CHANGEINFO_KEY] ] forKeys:@[TITLE,CHANGEINFO_KEY]];
    [arr replaceObjectAtIndex:indexPath.row withObject:nowDict];
    [dataArray replaceObjectAtIndex:indexPath.section withObject:arr];
    [[NSUserDefaults standardUserDefaults] setObject:dataArray forKey:INFOARRAY];
    [myInfoTableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
}

- (void)dealloc{
    
    [JP_NotificationCenter removeObserver:self name:CITYCHOOSESUCCESS object:nil];
    [JP_NotificationCenter removeObserver:self name:CHANGENAMESUCCESS object:nil];
}
@end
