//
//  MyAddressController.m
//  WeChat_D
//
//  Created by Keep丶Dream on 16/8/6.
//  Copyright © 2016年 dongjiangpeng. All rights reserved.
//

#import "MyAddressController.h"
#import "AddressListCell.h"
#import "AddressCellModel.h"
#import "EditAddressController.h"

@interface MyAddressController ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,strong)NSArray *dataArray;
@property(nonatomic,strong)UITableView *addressListView;

@end

@implementation MyAddressController

- (NSArray *)dataArray{
    
    if (!_dataArray) {
        
        NSArray *addArr = [[NSUserDefaults standardUserDefaults] objectForKey:ADDRESSSAVEKEY];
        if (addArr) {
            _dataArray = [AddressCellModel mj_objectArrayWithKeyValuesArray:addArr];
        }else{
            _dataArray = [[NSArray alloc]init];
        }
    }
    return _dataArray;
}

- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    if (self.addressListView) {
        [self.addressListView reloadData];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"我的地址";
    [self setTableView];
}

- (void)setTableView{
    
    self.addressListView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStylePlain];
    self.addressListView.delegate = self;
    self.addressListView.dataSource = self;
    self.addressListView.tableFooterView = [[UIView alloc]init];
    [self.addressListView registerNib:[UINib nibWithNibName:@"AddressListCell" bundle:nil] forCellReuseIdentifier:@"AddressListCell"];
    [self.view addSubview:self.addressListView];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return self.dataArray.count ? 2 : 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (self.dataArray.count) {
        if (section == 0) {
            return self.dataArray.count;
        }
    }
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (self.dataArray.count) {
        if (indexPath.section == 0) {
            
            AddressListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AddressListCell"];
            AddressCellModel *model = [self.dataArray objectAtIndex:indexPath.row];
            cell.nameLabel.text = model.name;
            cell.addressLabel.text = [NSString stringWithFormat:@"%@%@",model.city,model.address];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }
    }
    UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"addCell"];
    cell.textLabel.text = @"  新增地址";;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 60;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (self.dataArray.count) {
        if (indexPath.section == 1) {
         
            EditAddressController *editContro = [[EditAddressController alloc]init];
            [self presentViewController:editContro animated:YES completion:nil];
        }
    }
   
}

- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath{
    
    NSLog(@"点击进去编辑界面");
    AddressCellModel *model = [self.dataArray objectAtIndex:indexPath.row];
    EditAddressController *editContro = [[EditAddressController alloc]init];
    editContro.addressModel = model;
    [self presentViewController:editContro animated:YES completion:nil];
}

@end
