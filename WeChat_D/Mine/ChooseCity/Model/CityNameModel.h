//
//  cityNameModel.h
//  cityName
//
//  Created by tztddong on 16/3/29.
//  Copyright © 2016年 dongjiangpeng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MJExtension.h"

@interface CityNameModel : NSObject

@property(nonatomic,copy)NSString *name;
@property(nonatomic,assign)NSInteger code;
@property(nonatomic,strong)NSArray *children;

@end
