//
//  MyQRCodeController.m
//  WeChat_D
//
//  Created by Keep丶Dream on 16/8/2.
//  Copyright © 2016年 dongjiangpeng. All rights reserved.
//

#import "MyQRCodeController.h"
#import "QRCodeManger.h"

#define TIPTITLETEXT @"扫一扫上面的二维码图案,加我微信"
@interface MyQRCodeController ()

@end

@implementation MyQRCodeController
{
    UIView *whiteBackView ;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor colorWithWhite:0.292 alpha:1.000];
    self.title = @"我的二维码";
    [self setSubViews];
    
    UIBarButtonItem *saveItem = [[UIBarButtonItem alloc]initWithTitle:@"保存" style:UIBarButtonItemStylePlain target:self action:@selector(saveImage)];
    self.navigationItem.rightBarButtonItem = saveItem;
}

- (void)saveImage{
    
    CGSize imageSize = self.view.frame.size;
    //开启上下文
    UIGraphicsBeginImageContext(imageSize);
    //获取当前的上下文
    CGContextRef contextRef = UIGraphicsGetCurrentContext();
    [self.view.layer renderInContext:contextRef];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIImage *QRImg = [UIImage imageWithCGImage:CGImageCreateWithImageInRect(image.CGImage, whiteBackView.frame)];
    UIGraphicsEndImageContext();
    UIImageWriteToSavedPhotosAlbum(QRImg, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);

}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo{

    if (!error) {
        [SVProgressHUD showSuccessWithStatus:@"已保存到系统相册"];
    }
}

- (void)setSubViews{
    
    whiteBackView = [[UIView alloc]init];
    whiteBackView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:whiteBackView];
    [whiteBackView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(ScaleValueW(KMARGIN*2));
        make.right.offset(ScaleValueW(-KMARGIN*2));
        make.top.offset(KNAVHEIGHT+ScaleValueH(80));
        make.bottom.offset(-ScaleValueH(80));
    }];
    
    UIImageView *headImage = [[UIImageView alloc]init];
    headImage.image = [UIImage imageNamed:DefaultHeadImageName_Message];
    [whiteBackView addSubview:headImage];
    [headImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.offset(KMARGIN*3/2);
        make.size.mas_equalTo(CGSizeMake(60, 60));
    }];
    
    UILabel *nameLabel = [[UILabel alloc]init];
    nameLabel.text = [EMClient sharedClient].currentUsername;
    [whiteBackView addSubview:nameLabel];
    [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(headImage.mas_right).with.offset(KMARGIN);
        make.top.equalTo(headImage.mas_top).with.offset(KMARGIN);
    }];
    
    UIImageView *sexImage = [[UIImageView alloc]init];
    sexImage.image = [UIImage imageNamed:@"Contact_Male_18x18_"];
    [whiteBackView addSubview:sexImage];
    [sexImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(nameLabel);
        make.left.equalTo(nameLabel.mas_right);
        make.width.equalTo(sexImage.mas_height);
    }];
    
    UILabel *regionLabel = [[UILabel alloc]init];
    regionLabel.text = self.region;
    regionLabel.font = FONTSIZE(13);
    [whiteBackView addSubview:regionLabel];
    [regionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(headImage.mas_right).with.offset(KMARGIN);
        make.bottom.equalTo(headImage.mas_bottom).with.offset(-KMARGIN);
    }];
    
    UILabel *tipLabel = [[UILabel alloc]init];
    tipLabel.text = TIPTITLETEXT;
    tipLabel.textColor = [UIColor colorWithHexString:@"888888"];
    tipLabel.textAlignment = NSTextAlignmentCenter;
    tipLabel.font = FONTSIZE(10);
    [whiteBackView addSubview:tipLabel];
    [tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.offset(0);
        make.bottom.offset(-KMARGIN);
        make.height.equalTo(@(KMARGIN*2));
    }];
    
    UIImageView *qRImage = [[UIImageView alloc]init];
    UIImage *logoImage = [UIImage imageNamed:DefaultHeadImageName_Message];
    qRImage.image = [[QRCodeManger shareInstance] getQRCodeImageWithImputMessage:nameLabel.text logoImage:nil];
    [whiteBackView addSubview:qRImage];
    [qRImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(headImage.mas_left);
        make.right.offset(-KMARGIN*3/2);
        make.top.equalTo(headImage.mas_bottom).with.offset(KMARGIN);
        make.bottom.equalTo(tipLabel.mas_top).with.offset(-KMARGIN);
    }];
}

@end
