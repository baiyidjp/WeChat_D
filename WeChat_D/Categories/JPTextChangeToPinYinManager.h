//
//  JPTextChangeToPinYinManager.h
//  WeChat_D
//
//  Created by tztddong on 16/8/18.
//  Copyright © 2016年 dongjiangpeng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JPTextChangeToPinYinManager : NSObject

+ (instancetype)sharedManager;

/**
 *  将一个汉字转换为拼音
 */
+ (NSString *)getPinYinFromText:(NSString *)text;
@end
