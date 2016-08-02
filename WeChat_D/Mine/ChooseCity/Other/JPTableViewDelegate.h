//
//  JPTableViewDelegate.h
//  JPTableViewDelegate
//
//  Created by tztddong on 16/3/17.
//  Copyright © 2016年 dongjiangpeng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef void(^selectCell)(NSIndexPath *indexPath);

@interface JPTableViewDelegate : NSObject<UITableViewDataSource,UITableViewDelegate>

+ (instancetype)createTableViewDelegateWithDataList:(NSArray *)dataList
                                        selectBlock:(selectCell)selectBlock;

@end
