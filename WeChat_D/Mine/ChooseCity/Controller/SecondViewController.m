//
//  SecondViewController.m
//  cityName
//
//  Created by tztddong on 16/3/29.
//  Copyright © 2016年 dongjiangpeng. All rights reserved.
//

#import "SecondViewController.h"
#import "JPTableViewDelegate.h"
#import "CityNameModel.h"
#import "ThirdViewController.h"
#import "MyInfoController.h"

@interface SecondViewController ()
@property(nonatomic,strong)UITableView *cityTableView;
@property(nonatomic,strong)JPTableViewDelegate *tableViewDelegate;
@end

@implementation SecondViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"地区";
    
    [self creatTableView];
}

- (void)creatTableView{
    
    self.tableViewDelegate = [JPTableViewDelegate createTableViewDelegateWithDataList:self.cityArray selectBlock:^(NSIndexPath *indexPath) {
        NSLog(@"点击第%zd行",indexPath.row);
        CityNameModel *model = self.cityArray[indexPath.row];
        if (model.children.count) {
            
            ThirdViewController *ctrl = [[ThirdViewController alloc]init];
            ctrl.cityArray = model.children;
            ctrl.cityName = model.name;
            [self.navigationController pushViewController:ctrl animated:YES];
        }else{
            NSDictionary *dict = @{@"name":[NSString stringWithFormat:@"%@ %@",self.cityName,model.name]};
            [[NSNotificationCenter defaultCenter]postNotificationName:CITYCHOOSESUCCESS object:nil userInfo:dict];
            for (UIViewController *viewCtrl in self.navigationController.viewControllers) {
                if ([viewCtrl isKindOfClass:[MyInfoController class]]) {
                    [self.navigationController popToViewController:viewCtrl animated:YES];
                }
            }
        }
    }];
    
    self.cityTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) style:UITableViewStylePlain];
    self.cityTableView.delegate = self.tableViewDelegate;
    self.cityTableView.dataSource = self.tableViewDelegate;
    self.cityTableView.tableFooterView = [[UIView alloc]init];
    [self.view addSubview:self.cityTableView];
}

@end
