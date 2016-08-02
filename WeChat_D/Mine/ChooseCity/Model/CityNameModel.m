//
//  cityNameModel.m
//  cityName
//
//  Created by tztddong on 16/3/29.
//  Copyright © 2016年 dongjiangpeng. All rights reserved.
//

#import "CityNameModel.h"

@implementation CityNameModel

+ (NSDictionary *)mj_objectClassInArray
{
    return @{@"children":[CityNameModel class]};
}

@end
