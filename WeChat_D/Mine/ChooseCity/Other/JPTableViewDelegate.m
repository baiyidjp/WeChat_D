//
//  JPTableViewDelegate.m
//  JPTableViewDelegate
//
//  Created by tztddong on 16/3/17.
//  Copyright © 2016年 dongjiangpeng. All rights reserved.
//

#import "JPTableViewDelegate.h"
#import "CityNameModel.h"

static NSString *cellId = @"tableViewCellID";

@interface JPTableViewDelegate ()

@property (nonatomic, strong) NSArray   *dataList;
@property (nonatomic, copy)  selectCell selectBlock;

@end

@implementation JPTableViewDelegate


+ (instancetype)createTableViewDelegateWithDataList:(NSArray *)dataList selectBlock:(selectCell)selectBlock{
    
    return [[[self class] alloc]initTableViewDelegateWithDataList:dataList selectBlock:selectBlock];
}

- (instancetype)initTableViewDelegateWithDataList:(NSArray *)dataList selectBlock:(selectCell)selectBlock{
    
    self = [super init];
    if (self) {
        self.dataList = dataList;
        self.selectBlock = selectBlock;
    }
    
    return self;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.dataList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    CityNameModel *model = self.dataList[indexPath.row];
    cell.textLabel.text = model.name;
    
    if (model.children.count) {
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }else{
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    if (self.selectBlock) {
        self.selectBlock(indexPath);
    }
}

@end
