//
//  FirstViewController.m
//  cityName
//
//  Created by tztddong on 16/3/29.
//  Copyright © 2016年 dongjiangpeng. All rights reserved.
//

#import "FirstViewController.h"
#import "CityNameModel.h"
#import "JPTableViewDelegate.h"
#import "SecondViewController.h"

@interface FirstViewController ()
@property(nonatomic,strong)UITableView *cityTableView;
@property(nonatomic,strong)NSArray *cityModelArray;
@property(nonatomic,strong)JPTableViewDelegate *tableViewDelegate;
@end

@implementation FirstViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"地区";
    
    [self creatTableView];
}

- (NSArray *)cityModelArray{

    if (!_cityModelArray) {
        _cityModelArray = [[NSArray alloc]init];
        NSString *filePath=[[NSBundle mainBundle]pathForResource:@"zh_CN" ofType:@"json"];
        NSData *cityData = [NSData dataWithContentsOfFile:filePath];
        NSArray *array = [NSJSONSerialization JSONObjectWithData:cityData options:NSJSONReadingAllowFragments error:nil];
        _cityModelArray = [CityNameModel mj_objectArrayWithKeyValuesArray:array];
    }
    return _cityModelArray;
}

- (void)creatTableView{
    
    self.tableViewDelegate = [JPTableViewDelegate createTableViewDelegateWithDataList:self.cityModelArray selectBlock:^(NSIndexPath *indexPath) {
        
        CityNameModel *model = self.cityModelArray[indexPath.row];
        if (model.children.count) {
            
            SecondViewController *ctrl = [[SecondViewController alloc]init];
            ctrl.cityArray = model.children;
            ctrl.cityName = model.name;
            [self.navigationController pushViewController:ctrl animated:YES];
        }else{
            NSDictionary *dict = @{CHANGEINFO_KEY:model.name};
            [[NSNotificationCenter defaultCenter]postNotificationName:CITYCHOOSESUCCESS object:nil userInfo:dict];
            [self.navigationController popViewControllerAnimated:YES];
        }
    }];
    
    self.cityTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) style:UITableViewStylePlain];
    self.cityTableView.delegate = self.tableViewDelegate;
    self.cityTableView.dataSource = self.tableViewDelegate;
    self.cityTableView.tableFooterView = [[UIView alloc]init];
    [self.view addSubview:self.cityTableView];
}

@end
