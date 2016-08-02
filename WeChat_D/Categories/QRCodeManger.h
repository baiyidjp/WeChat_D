//
//  ORCodeManger.h
//  ORCodeDemo
//
//  Created by tztddong on 16/7/5.
//  Copyright © 2016年 dongjiangpeng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef void(^scanSuccessBlock)(NSArray *resultData);

@interface QRCodeManger : NSObject

+ (instancetype)shareInstance;

/**
 *  生成二维码图片
 */
- (UIImage *)getQRCodeImageWithImputMessage:(NSString *)inputMes logoImage:(UIImage *)logoImage;

/**
 *  扫描二维码
 */
- (void)startScanQRCodeImageWithBackView:(UIView *)backView scanView:(UIView *)scanView scanSuccessBlock:(scanSuccessBlock)scanSuccessBlock;

@property(nonatomic,copy)scanSuccessBlock scanSuccessBlock;

@end
