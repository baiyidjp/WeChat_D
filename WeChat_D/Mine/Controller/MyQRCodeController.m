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
    UIGraphicsBeginImageContextWithOptions(imageSize, NO, 0.0);
    //获取当前的上下文
    CGContextRef contextRef = UIGraphicsGetCurrentContext();
    //创建需要所截图的区域路径
    UIBezierPath *path = [UIBezierPath bezierPathWithRect:whiteBackView.frame];
//    //设置路径的宽和颜色
//    CGContextSetLineWidth(contextRef, 1);
//    [[UIColor blackColor] set];
    //将路径添加到上下文中
    CGContextAddPath(contextRef, path.CGPath);
    //截取路径内的上下文
    CGContextClip(contextRef);
    //把控制器的view中的内容渲染到上下文中
    [self.view.layer renderInContext:contextRef];
    //取出图片
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);

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
    nameLabel.text = self.name;
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
//    UIImage *logoImage = [UIImage imageNamed:DefaultHeadImageName_Message];
    qRImage.image = [[QRCodeManger shareInstance] getQRCodeImageWithImputMessage:[NSString stringWithFormat:@"%@:%@",ADDFRIEND,[EMClient sharedClient].currentUsername] logoImage:nil];
    [whiteBackView addSubview:qRImage];
    [qRImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(headImage.mas_left);
        make.right.offset(-KMARGIN*3/2);
        make.top.equalTo(headImage.mas_bottom).with.offset(KMARGIN);
        make.bottom.equalTo(tipLabel.mas_top).with.offset(-KMARGIN);
    }];
}

@end
