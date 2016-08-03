//
//  ScanQRCodeController.m
//  WeChat_D
//
//  Created by Keep丶Dream on 16/8/3.
//  Copyright © 2016年 dongjiangpeng. All rights reserved.
//

#import "ScanQRCodeController.h"
#import "QRCodeManger.h"

@interface ScanQRCodeController ()
/** 扫描区域view */
@property(nonatomic,strong) UIView *scanView;
/** 扫描区域的四周的横线 */
@property(nonatomic,strong) UIImageView *boardImage;
/**
 *  扫描的横线网
 */
@property(nonatomic,weak)UIImageView *scanImageView;
/**
 *  时间
 */
@property(nonatomic,strong)NSTimer *timer;

@end

@implementation ScanQRCodeController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"扫一扫";
    
    self.scanView = [[UIView alloc]init];
    self.scanView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.scanView];
    [self.scanView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX);
        make.centerY.equalTo(self.view.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(ScaleValueW(240), ScaleValueW(240)));
    }];
    [self.scanView layoutIfNeeded];
    // 加载图片
    UIImage *image = [UIImage imageNamed:@"qrcode_border"];
    // 设置端盖的值
    CGFloat top = image.size.height * 0.5;
    CGFloat left = image.size.width * 0.5;
    CGFloat bottom = image.size.height * 0.5;
    CGFloat right = image.size.width * 0.5;
    // 设置端盖的值
    UIEdgeInsets edgeInsets = UIEdgeInsetsMake(top, left, bottom, right);
    // 设置拉伸的模式
    UIImageResizingMode mode = UIImageResizingModeStretch;
    // 拉伸图片
    UIImage *newImage = [image resizableImageWithCapInsets:edgeInsets resizingMode:mode];
    self.boardImage = [[UIImageView alloc]init];
    self.boardImage.image = newImage;
    [self.scanView addSubview:self.boardImage];
    [self.boardImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.scanView);
    }];
    
    UIImageView *scanImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.scanView.frame), 0)];
    scanImageView.image = [UIImage imageNamed:@"qrcode_back"];
    [self.scanView addSubview:scanImageView];
    self.scanImageView = scanImageView;
    
    [self update];
    [self scanStart];
}

- (void)update{
    
    [UIView animateWithDuration:1.0 animations:^{
        self.scanImageView.frame = CGRectMake(0, 0, CGRectGetWidth(self.scanView.frame), CGRectGetHeight(self.scanView.frame));
    } completion:^(BOOL finished) {
        self.scanImageView.frame = CGRectMake(0, 0, CGRectGetWidth(self.scanView.frame), 0);
        [self update];
    }];
}

- (void)scanStart{
    
    [[QRCodeManger shareInstance] startScanQRCodeImageWithBackView:self.view scanView:self.scanView scanSuccessBlock:^(NSArray *resultData) {
        NSLog(@"正在处理");
        NSLog(@"%@",resultData);
        [self.navigationController popViewControllerAnimated:YES];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            NSString *text = @"";
            for (NSString *string in resultData) {
                if (string.length) {
                    text = [text stringByAppendingString:string];
                }
            }
            NSArray *textArr = [text componentsSeparatedByString:@":"];
            if ([textArr[0] isEqualToString:ADDFRIEND]) {
                UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
                NSString *currentName = [EMClient sharedClient].currentUsername;
                UIAlertController *alertCtrl = [UIAlertController alertControllerWithTitle:@"打个招呼吧" message:nil preferredStyle:UIAlertControllerStyleAlert];
                [alertCtrl addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
                    textField.text = [NSString stringWithFormat:@"我是%@",currentName];
                }];
                [alertCtrl addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
                [alertCtrl addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    if ([currentName isEqualToString:textArr[1]]) {
                        [keyWindow.rootViewController.view makeToast:@"不能添加自己为好友"];
                        return ;
                    }
                    //添加好友
                    [SVProgressHUD show];
                    [[EMClient sharedClient].contactManager asyncAddContact:textArr[1] message:[alertCtrl.textFields objectAtIndex:0].text  success:^{
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [SVProgressHUD showSuccessWithStatus:@"发送申请成功"];
                        });
                        
                    } failure:^(EMError *aError) {
                        
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [SVProgressHUD showSuccessWithStatus:@"发送申请失败"];
                        });
                    }];
                    
                }]];
                
                [keyWindow.rootViewController presentViewController:alertCtrl animated:YES completion:nil];

            }
        });
    }];
}

@end
