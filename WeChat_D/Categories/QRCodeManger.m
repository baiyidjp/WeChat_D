//
//  ORCodeManger.m
//  ORCodeDemo
//
//  Created by tztddong on 16/7/5.
//  Copyright © 2016年 dongjiangpeng. All rights reserved.
//

#import "QRCodeManger.h"
#import <AVFoundation/AVFoundation.h>

@interface QRCodeManger ()<AVCaptureMetadataOutputObjectsDelegate>
@property(nonatomic,strong)QRCodeManger *manger;
@property(nonatomic,strong)AVCaptureSession *captureSession;
@end

@implementation QRCodeManger

static QRCodeManger *manger = nil;

+ (instancetype)shareInstance{
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (manger == nil) {
            manger = [[QRCodeManger alloc]init];
        }
    });
    return manger;
}

- (UIImage *)getQRCodeImageWithImputMessage:(NSString *)inputMes logoImage:(UIImage *)logoImage{
    
    //创建滤镜
    CIFilter *filter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
    //恢复默认值
    [filter setDefaults];
    //设置滤镜的容错率 KVC
    //key = inputCorrectionLevel value = @"L/M/Q/H"
    [filter setValue:@"H" forKeyPath:@"inputCorrectionLevel"];
    //设置输入的内容 KVC
    // 注意:key = inputMessage, value必须是NSData类型
    NSData *inputData = [inputMes dataUsingEncoding:NSUTF8StringEncoding];
    [filter setValue:inputData forKeyPath:@"inputMessage"];
    //获取输出的图片
    CIImage *outImage = [filter outputImage];
    //转化成UIImage格式的大图
    CGAffineTransform transform = CGAffineTransformMakeScale(10.0, 10.0);
    outImage = [outImage imageByApplyingTransform:transform];
    UIImage *ORImage = [UIImage imageWithCIImage:outImage];
    //判断是否有logo图片
    if (logoImage == nil) {
        return ORImage;
    }
    
    CGSize imageSize = ORImage.size;
    //获取图形上下文
    UIGraphicsBeginImageContext(imageSize);
    //将二维码图片画到上下文中去
    [ORImage drawInRect:CGRectMake(0, 0, imageSize.width, imageSize.height)];
    //将LOGO图标画到上下文中去
    [logoImage drawInRect:CGRectMake(imageSize.width*0.5 - 40, imageSize.height*0.5-40, 80, 80)];
    //取出上下文中的图片
    UIImage *returnImage = UIGraphicsGetImageFromCurrentImageContext();
    return returnImage;
}

- (void)startScanQRCodeImageWithBackView:(UIView *)backView scanView:(UIView *)scanView scanSuccessBlock:(scanSuccessBlock)scanSuccessBlock{
    
    self.scanSuccessBlock = scanSuccessBlock;
    
    NSError *errer = nil;
    
    //创建捕获设备
    AVCaptureDevice *captureDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    //创建输入设备
    AVCaptureDeviceInput *captureInput = [AVCaptureDeviceInput deviceInputWithDevice:captureDevice error:&errer];
    if (errer != nil) {
        return;
    }
    //创建输出设备
    AVCaptureMetadataOutput *captureOutput = [[AVCaptureMetadataOutput alloc]init];
    [captureOutput setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
    //创建会话
    AVCaptureSession *captureSession = [[AVCaptureSession alloc]init];
    self.captureSession = captureSession;
    //将输入输出 加入到会话中管理
    if ([captureSession canAddInput:captureInput]) {
        [captureSession addInput:captureInput];
    }
    if ([captureSession canAddOutput:captureOutput]) {
        [captureSession addOutput:captureOutput];
    }
    // 4.设置输入的内容类型
    [captureOutput setMetadataObjectTypes:@[AVMetadataObjectTypeQRCode]];
    //创建取景图层
    AVCaptureVideoPreviewLayer *previewLayer = [[AVCaptureVideoPreviewLayer alloc]initWithSession:captureSession];
    previewLayer.frame = backView.bounds;
    [backView.layer addSublayer:previewLayer];
    [backView bringSubviewToFront:scanView];
//    [backView.layer insertSublayer:previewLayer below:scanView.layer];
    //设置扫描区域 default CGRectMake(0, 0, 1, 1).
    CGSize screenSize = [UIScreen mainScreen].bounds.size;
    CGFloat top = CGRectGetMinY(scanView.frame)/screenSize.height;
    CGFloat left = CGRectGetMinX(scanView.frame)/screenSize.width;
    CGFloat height = CGRectGetHeight(scanView.frame)/screenSize.height;
    CGFloat width = CGRectGetWidth(scanView.frame)/screenSize.width;
    captureOutput.rectOfInterest = CGRectMake(top, left, height, width);
    
    [captureSession startRunning];
    
}

- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection{
    
    [self.captureSession stopRunning];
    NSLog(@"1");
    NSMutableArray *resultArr = [NSMutableArray array];
    //遍历结果
    for (AVMetadataMachineReadableCodeObject *result in metadataObjects) {
        [resultArr addObject:result.stringValue];
    }
    if (self.scanSuccessBlock) {
        self.scanSuccessBlock([resultArr copy]);
    }
}

@end
