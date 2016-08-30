//
//  DDWXVideoControllerViewController.m
//  DDWXVideo
//
//  Created by tztddong on 16/3/2.
//  Copyright © 2016年 dongjiangpeng. All rights reserved.
//

#import "JPWXVideoController.h"
#import <AVFoundation/AVFoundation.h>
#import "JPPlayVideoController.h"



typedef NS_ENUM(NSInteger,VideoStatus){
    VideoStatusEnded = 0,
    VideoStatusStarted
};

@interface JPWXVideoController ()<AVCaptureFileOutputRecordingDelegate>
{
/**
 *  是一个会话对象,是设备音频/视频整个录制期间的管理者
 */
AVCaptureSession *_captureSession;
/**
 *  其实是咱们的物理设备映射到程序中的一个对象.咱们可以通过其来操作:闪光灯,手电筒,聚焦模式等
 */
AVCaptureDevice *_videoDevice;
AVCaptureDevice *_audioDevice;
/**
 *  是录制期间输入流数据的管理对象.
 */
AVCaptureDeviceInput *_videoInput;
AVCaptureDeviceInput *_audioInput;
/**
 *  是输出流数据的管理对象,通过头文件可以看到有很多子类,而我们通常也使用其子类
 */
AVCaptureMovieFileOutput *_movieOutput;
/**
 *  是一个 `CALyer` ,可以让我们预览拍摄过程中的图像
 */
AVCaptureVideoPreviewLayer *_captureVideoPreviewLayer;
}
@property(nonatomic,weak)UIView *videoView;//录像的view
@property(nonatomic,weak)UIButton *flashBtn;//闪光灯
@property(nonatomic,weak)UIButton *cameraBtn;//切换摄像头
@property(nonatomic,weak)UILabel *tipCancleLabel;//录像提示的label
@property(nonatomic,weak)UIView *progressView;//进度条
@property(nonatomic,weak)UILabel *tipLabel;//提示label-点击
@property(nonatomic,weak)UILabel *tapLabel;//按住开始录像
@property (nonatomic,weak) UIView *focusCircle;//聚焦圈
@property (nonatomic,assign) VideoStatus status;//录像状态
@property (nonatomic,assign) BOOL canSave;
@property (nonatomic,strong) CADisplayLink *link;//计时器
@property(nonatomic,weak)UIButton *backBtn;//返回

@end

@implementation JPWXVideoController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = VIEWBACKGROUND_COLOR;
    [self makeUI];
    [self getAuthorization];
}

- (void)makeUI{
    
    UIView *videoView = [[UIView alloc]initWithFrame:CGRectMake(0, 2*KMARGIN, KWIDTH, KHEIGHT/2)];
    self.videoView = videoView;
    [self.view addSubview:videoView];
    
    UIButton *flashBtn = [[UIButton alloc]init];
    self.flashBtn = flashBtn;
    flashBtn.left = KMARGIN;
    flashBtn.top = 3*KMARGIN;
    [flashBtn setTitle:FLASHBTN_TITLE_N forState:UIControlStateNormal];
    [flashBtn setTitle:FLASHBTN_TITLE_S forState:UIControlStateSelected];
    [flashBtn.titleLabel setFont:FONTSIZE(FLASHBTN_FONT)];
    [flashBtn sizeToFit];
    [flashBtn setTitleColor:FLASHBTN_COLOR forState:UIControlStateNormal];
    [flashBtn addTarget:self action:@selector(clickFlashBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:flashBtn];
    
    UIButton *cameraBtn = [[UIButton alloc]init];
    self.cameraBtn = cameraBtn;
    [cameraBtn setTitle:CAMERABTN_TITLE_N forState:UIControlStateNormal];
    [cameraBtn setTitle:CAMERABTN_TITLE_S forState:UIControlStateSelected];
    [cameraBtn.titleLabel setFont:FONTSIZE(CAMERABTN_FONT)];
    [cameraBtn sizeToFit];
    cameraBtn.left = KWIDTH - KMARGIN - cameraBtn.width;
    cameraBtn.top = 3*KMARGIN;
    [cameraBtn setTitleColor:CAMERABTN_COLOR forState:UIControlStateNormal];
    [cameraBtn addTarget:self action:@selector(clickCameraBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:cameraBtn];
    
    UILabel *tipCancleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(videoView.frame)-3*KMARGIN, KWIDTH, 2*KMARGIN)];
    self.tipCancleLabel = tipCancleLabel;
    tipCancleLabel.textAlignment = NSTextAlignmentCenter;
    tipCancleLabel.font = FONTSIZE(TIPCANCLELABEL_FONT);
    tipCancleLabel.textColor = TIPCANCLELABEL_COLOR_1;
    tipCancleLabel.text = TIPCANCLELABEL_TITLE_1;
    tipCancleLabel.alpha = 0.0;
    [self.view addSubview:tipCancleLabel];
    
    UIView *progressView = [[UIView alloc]init];
    self.progressView = progressView;
    progressView.backgroundColor = PROGRESSVIEW_COLOR;
    progressView.width = KWIDTH;
    progressView.height = 2;
    progressView.centerX = CGRectGetMidX(videoView.frame);
    progressView.top = CGRectGetMaxY(videoView.frame)-1;
    progressView.alpha = 0.0;
    [self.view addSubview:progressView];
    
    UILabel *tipLabel = [[UILabel alloc]init];
    self.tipLabel = tipLabel;
    tipLabel.numberOfLines = 0;
    tipLabel.text = TIPLABEL_TITLE;
    tipLabel.textColor = TIPLABEL_COLOR;
    tipLabel.font = FONTSIZE(TIPLABEL_FONT);
    [tipLabel sizeToFit];
    tipLabel.top = CGRectGetMaxY(videoView.frame)+KMARGIN;
    tipLabel.left = KWIDTH - tipLabel.width - KMARGIN/2;
    [self.view addSubview:tipLabel];
    
    UILabel *tapLabel = [[UILabel alloc]init];
    self.tapLabel = tapLabel;
    tapLabel.textAlignment = NSTextAlignmentCenter;
    tapLabel.text = TAPLABEL_TITLE;
    tapLabel.font = FONTSIZE(TAPLABEL_FONT);
    tapLabel.textColor = TAPLABEL_COLOR;
    tapLabel.size = CGSizeMake(TAPLABEL_W_H, TAPLABEL_W_H);
    tapLabel.center = CGPointMake(KWIDTH/2, KHEIGHT*3/4);
    tapLabel.layer.cornerRadius =  TAPLABEL_W_H/2;
    tapLabel.layer.masksToBounds = YES;
    tapLabel.layer.borderWidth = 1;
    tapLabel.layer.borderColor = TAPLABEL_BORDERCOLOR.CGColor;
    [self.view addSubview:tapLabel];
    
    UIButton *backBtn = [[UIButton alloc]init];
    [backBtn setTitleColor:BACKBTN_COLOR forState:UIControlStateNormal];
    [backBtn setTitle:BACKBTN_TITLE forState:UIControlStateNormal];
    [backBtn.titleLabel setFont:FONTSIZE(BACKBTN_FONT)];
    [backBtn sizeToFit];
    backBtn.left = KWIDTH/2 - backBtn.width/2;
    backBtn.top = KHEIGHT - 44;
    [backBtn addTarget:self action:@selector(backBtnClick) forControlEvents:UIControlEventTouchUpInside];
    self.backBtn = backBtn;
    [self.view addSubview:backBtn];
    
    //给屏幕添加手势
    [self addGenstureRecognizer];
}

- (void)backBtnClick{
    [self dismissViewControllerAnimated:YES completion:nil];
}
/**
 *  添加点按手势，点按时聚焦
 */
-(void)addGenstureRecognizer{
    
    UITapGestureRecognizer *oneTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(oneTap:)];
    oneTap.numberOfTapsRequired = 1;
    oneTap.delaysTouchesBegan = YES;
    
    UITapGestureRecognizer *twoTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(twoTap:)];
    twoTap.numberOfTapsRequired = 2;
    twoTap.delaysTouchesBegan = YES;
    
    [oneTap requireGestureRecognizerToFail:twoTap];
    
    [self.videoView addGestureRecognizer:oneTap];
    [self.videoView addGestureRecognizer:twoTap];
}

- (void)oneTap:(UITapGestureRecognizer *)oneTap{
    
    CGPoint point = [oneTap locationInView:self.videoView];
    [self setFocusCirclePoint:point];
    //聚焦 需要先锁定
    [self changeDevicePropertySafety:^(AVCaptureDevice *captureDevice) {
        /*
        @constant AVCaptureFocusModeLocked 锁定在当前焦距
        Indicates that the focus should be locked at the lens' current position.
        
        @constant AVCaptureFocusModeAutoFocus 自动对焦一次,然后切换到焦距锁定
        Indicates that the device should autofocus once and then change the focus mode to AVCaptureFocusModeLocked.
        
        @constant AVCaptureFocusModeContinuousAutoFocus 当需要时.自动调整焦距
        Indicates that the device should automatically focus when needed.
        */
        if ([captureDevice isFocusModeSupported:AVCaptureFocusModeContinuousAutoFocus]) {
            [captureDevice setFocusMode:AVCaptureFocusModeContinuousAutoFocus];
            NSLog(@"聚焦成功");
        }else{
            NSLog(@"聚焦失败");
        }
        //将手指点击的坐标转换成摄像头坐标
        CGPoint focusPoint = [_captureVideoPreviewLayer pointForCaptureDevicePointOfInterest:point];
        //设置聚焦点的位置
        if ([captureDevice isFocusPointOfInterestSupported]) {
            [captureDevice setFocusPointOfInterest:focusPoint];
        }
        /*
         @constant AVCaptureExposureModeLocked  曝光锁定在当前值
         Indicates that the exposure should be locked at its current value.
         
         @constant AVCaptureExposureModeAutoExpose 曝光自动调整一次然后锁定
         Indicates that the device should automatically adjust exposure once and then change the exposure mode to AVCaptureExposureModeLocked.
         
         @constant AVCaptureExposureModeContinuousAutoExposure 曝光自动调整
         Indicates that the device should automatically adjust exposure when needed.
         
         @constant AVCaptureExposureModeCustom 曝光只根据设定的值来
         Indicates that the device should only adjust exposure according to user provided ISO, exposureDuration values.
         
         */
        //设置曝光模式
        if ([captureDevice isExposureModeSupported:AVCaptureExposureModeAutoExpose]) {
            [captureDevice setExposureMode:AVCaptureExposureModeAutoExpose];
            NSLog(@"曝光成功");
        }else{
            NSLog(@"曝光失败");
        }
        //设置曝光点
        if ([captureDevice isExposurePointOfInterestSupported]) {
            [captureDevice setExposurePointOfInterest:focusPoint];
        }
    }];
}

//调整焦距
- (void)twoTap:(UITapGestureRecognizer *)twoTap{
    
    [self changeDevicePropertySafety:^(AVCaptureDevice *captureDevice) {
        if (captureDevice.videoZoomFactor == 1.0) {
            CGFloat current = 1.5;
            if (current < captureDevice.activeFormat.videoMaxZoomFactor) {
                [captureDevice rampToVideoZoomFactor:current withRate:10.0];
            }
        }else{
            [captureDevice rampToVideoZoomFactor:1.0 withRate:10.0];
        }
    }];
}

//聚焦的光圈
- (UIView *)focusCircle{
    if (!_focusCircle) {
        UIView *focusCircle = [[UIView alloc]init];
        focusCircle.frame = CGRectMake(0, 0, 100, 100);
        focusCircle.layer.cornerRadius = 50;
        focusCircle.layer.borderColor = FOCUSVIEW_BORDERCOLOR.CGColor;
        focusCircle.layer.borderWidth = 2;
        focusCircle.layer.masksToBounds = YES;
        _focusCircle = focusCircle;
        [self.videoView addSubview:focusCircle];
    }
    return _focusCircle;
}

//根据点击的point改变光圈的位置
- (void)setFocusCirclePoint:(CGPoint)point{

    self.focusCircle.center = point;
    self.focusCircle.transform = CGAffineTransformIdentity;
    self.focusCircle.alpha = 1.0;
    [UIView animateWithDuration:0.5 animations:^{
        self.focusCircle.alpha = 0.0;
        self.focusCircle.transform = CGAffineTransformMakeScale(0.5, 0.5);
    }];
}
//点击闪光灯
- (void)clickFlashBtn:(UIButton *)button{
    
    BOOL con1 = [_videoDevice hasTorch];    //支持手电筒模式
    BOOL con2 = [_videoDevice hasFlash];    //支持闪光模式
    
    if (con1 && con2)
    {
        [self changeDevicePropertySafety:^(AVCaptureDevice *captureDevice) {
            if (_videoDevice.flashMode == AVCaptureFlashModeOn)         //闪光灯开
            {
                [_videoDevice setFlashMode:AVCaptureFlashModeOff];
                [_videoDevice setTorchMode:AVCaptureTorchModeOff];
            }else if (_videoDevice.flashMode == AVCaptureFlashModeOff)  //闪光灯关
            {
                [_videoDevice setFlashMode:AVCaptureFlashModeOn];
                [_videoDevice setTorchMode:AVCaptureTorchModeOn];
            }
            //            else{                                                      //闪光灯自动
            //                [_videoDevice setFlashMode:AVCaptureFlashModeAuto];
            //                [_videoDevice setTorchMode:AVCaptureTorchModeAuto];
            //            }
            NSLog(@"现在的闪光模式是AVCaptureFlashModeOn么?是你就扣1, %zd",_videoDevice.flashMode == AVCaptureFlashModeOn);
        }];
        button.selected = !button.selected;
    }else{
        NSLog(@"不能切换闪光模式");
    }

    
}

//点击摄像头
- (void)clickCameraBtn:(UIButton *)button{
    
    switch (_videoDevice.position) {
        case AVCaptureDevicePositionBack:
            _videoDevice = [self deviceWithMediaType:AVMediaTypeVideo preferringPosition:AVCaptureDevicePositionFront];
            break;
        case AVCaptureDevicePositionFront:
            _videoDevice = [self deviceWithMediaType:AVMediaTypeVideo preferringPosition:AVCaptureDevicePositionBack];
            break;
        default:
            return;
            break;
    }
    
    [self changeDevicePropertySafety:^(AVCaptureDevice *captureDevice) {
        NSError *error;
        AVCaptureDeviceInput *newVideoInput = [[AVCaptureDeviceInput alloc] initWithDevice:_videoDevice error:&error];
        
        if (newVideoInput != nil) {
            //必选先 remove 才能询问 canAdd
            [_captureSession removeInput:_videoInput];
            if ([_captureSession canAddInput:newVideoInput]) {
                [_captureSession addInput:newVideoInput];
                _videoInput = newVideoInput;
                button.selected = !button.selected;
            }else{
                [_captureSession addInput:_videoInput];
            }
            
        } else if (error) {
            NSLog(@"切换前/后摄像头失败, error = %@", error);
        }
    }];

}

//获取授权
- (void)getAuthorization{
    /*
     AVAuthorizationStatusNotDetermined = 0,// 未进行授权选择
     
     AVAuthorizationStatusRestricted,　　　　// 未授权，且用户无法更新，如家长控制情况下
     
     AVAuthorizationStatusDenied,　　　　　　 // 用户拒绝App使用
     
     AVAuthorizationStatusAuthorized,　　　　// 已授权，可使用
     */
    //此处获取摄像头授权
    switch ([AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo])
    {
        case AVAuthorizationStatusAuthorized:       //已授权，可使用    The client is authorized to access the hardware supporting a media type.
        {
            NSLog(@"授权摄像头使用成功");
            [self setupAVCaptureInfo];
            break;
        }
        case AVAuthorizationStatusNotDetermined:    //未进行授权选择     Indicates that the user has not yet made a choice regarding whether the client can access the hardware.
        {
            //则再次请求授权
            [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
                if(granted){    //用户授权成功
                    [self setupAVCaptureInfo];
                    return;
                } else {        //用户拒绝授权
                    [self pop];
                    [self showMsgWithTitle:@"出错了" andContent:@"用户拒绝授权摄像头的使用权,返回上一页.请打开\n设置-->隐私/通用等权限设置"];
                    return;
                }
            }];
            break;
        }
        default:                                    //用户拒绝授权/未授权
        {
            [self pop];
            [self showMsgWithTitle:@"出错了" andContent:@"拒绝授权,返回上一页.请检查下\n设置-->隐私/通用等权限设置"];
            break;
        }
    }

}

- (void)setupAVCaptureInfo
{
    [self.view bringSubviewToFront:self.tipCancleLabel];
    [self.view bringSubviewToFront:self.progressView];
    [self.view bringSubviewToFront:self.cameraBtn];
    [self.view bringSubviewToFront:self.flashBtn];
    
    [self addSession];
    
    [_captureSession beginConfiguration];
    
    [self addVideo];
    [self addAudio];
    [self addPreviewLayer];
    
    [_captureSession commitConfiguration];
    
    //开启会话-->注意,不等于开始录制
    [_captureSession startRunning];
    
}

- (void)addSession{
    
    _captureSession = [[AVCaptureSession alloc]init];
    //设置视频分辨率
    /*  通常支持如下格式
     (
     AVAssetExportPresetLowQuality,
     AVAssetExportPreset960x540,
     AVAssetExportPreset640x480,
     AVAssetExportPresetMediumQuality,
     AVAssetExportPreset1920x1080,
     AVAssetExportPreset1280x720,
     AVAssetExportPresetHighestQuality,
     AVAssetExportPresetAppleM4A
     )
     */
    if ([_captureSession canSetSessionPreset:AVAssetExportPreset640x480]) {
        [_captureSession setSessionPreset:AVAssetExportPreset640x480];
    }
}

- (void)addVideo{
    // 获取摄像头输入设备， 创建 AVCaptureDeviceInput 对象
    /* MediaType
     AVF_EXPORT NSString *const AVMediaTypeVideo                 NS_AVAILABLE(10_7, 4_0);       //视频
     AVF_EXPORT NSString *const AVMediaTypeAudio                 NS_AVAILABLE(10_7, 4_0);       //音频
     AVF_EXPORT NSString *const AVMediaTypeText                  NS_AVAILABLE(10_7, 4_0);
     AVF_EXPORT NSString *const AVMediaTypeClosedCaption         NS_AVAILABLE(10_7, 4_0);
     AVF_EXPORT NSString *const AVMediaTypeSubtitle              NS_AVAILABLE(10_7, 4_0);
     AVF_EXPORT NSString *const AVMediaTypeTimecode              NS_AVAILABLE(10_7, 4_0);
     AVF_EXPORT NSString *const AVMediaTypeMetadata              NS_AVAILABLE(10_8, 6_0);
     AVF_EXPORT NSString *const AVMediaTypeMuxed                 NS_AVAILABLE(10_7, 4_0);
     */
    
    /* AVCaptureDevicePosition
     typedef NS_ENUM(NSInteger, AVCaptureDevicePosition) {
     AVCaptureDevicePositionUnspecified         = 0,
     AVCaptureDevicePositionBack                = 1,            //后置摄像头
     AVCaptureDevicePositionFront               = 2             //前置摄像头
     } NS_AVAILABLE(10_7, 4_0) __TVOS_PROHIBITED;
     */
    //获取可以操作的摄像头
    _videoDevice = [self deviceWithMediaType:AVMediaTypeVideo preferringPosition:AVCaptureDevicePositionBack];
    
    [self addVideoInput];
    [self addMovieOutput];
}

- (void)addVideoInput{
    // 视频输入对象
    // 根据输入设备初始化输入对象，用户获取输入数据
    NSError *videoError;
    _videoInput = [[AVCaptureDeviceInput alloc]initWithDevice:_videoDevice error:&videoError];
    if (videoError) {
        NSLog(@"获取摄像头设备时出错-->%@",videoError);
        return;
    }
    // 将视频输入对象添加到会话 (AVCaptureSession) 中
    if ([_captureSession canAddInput:_videoInput]) {
        [_captureSession addInput:_videoInput];
    }
}

- (void)addMovieOutput{
    // 拍摄视频输出对象
    // 初始化输出设备对象，用户获取输出数据
    _movieOutput = [[AVCaptureMovieFileOutput alloc]init];
    if ([_captureSession canAddOutput:_movieOutput]) {
        [_captureSession addOutput:_movieOutput];
        
        AVCaptureConnection *captureConnection = [_movieOutput connectionWithMediaType:AVMediaTypeVideo];
        
        //设置视频旋转方向
        /*
         typedef NS_ENUM(NSInteger, AVCaptureVideoOrientation) {
         AVCaptureVideoOrientationPortrait           = 1,
         AVCaptureVideoOrientationPortraitUpsideDown = 2,
         AVCaptureVideoOrientationLandscapeRight     = 3,
         AVCaptureVideoOrientationLandscapeLeft      = 4,
         } NS_AVAILABLE(10_7, 4_0) __TVOS_PROHIBITED;
         */
        //        if ([captureConnection isVideoOrientationSupported]) {
        //            [captureConnection setVideoOrientation:AVCaptureVideoOrientationPortrait];
        //        }
        
        // 视频稳定设置
        if ([captureConnection isVideoStabilizationSupported]) {
            captureConnection.preferredVideoStabilizationMode = AVCaptureVideoStabilizationModeAuto;
        }
        
        captureConnection.videoScaleAndCropFactor = captureConnection.videoMaxScaleAndCropFactor;
    }
    
}

- (void)addAudio{
    
    //添加一个音频输入设备
    _audioDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeAudio];
    NSError *audioError;
    
    _audioInput = [[AVCaptureDeviceInput alloc]initWithDevice:_audioDevice error:&audioError];
    
    if (audioError) {
        NSLog(@"获取音频设备时出错-->%@",audioError);
        return;
    }
    // 将音频输入对象添加到会话 (AVCaptureSession) 中
    if ([_captureSession canAddInput:_audioInput]) {
        [_captureSession addInput:_audioInput];
    }
}

- (void)addPreviewLayer{
    //添加视频的预览层
    _captureVideoPreviewLayer = [[AVCaptureVideoPreviewLayer alloc]initWithSession:_captureSession];
    _captureVideoPreviewLayer.frame = self.view.layer.bounds;
    _captureVideoPreviewLayer.connection.videoOrientation = [_movieOutput connectionWithMediaType:AVMediaTypeVideo].videoOrientation;
    //有时候需要拍摄完整屏幕大小的时候可以修改这个
    //    _captureVideoPreviewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    // 如果预览图层和视频方向不一致,可以修改这个
    _captureVideoPreviewLayer.position = CGPointMake(self.view.width*0.5,self.videoView.height*0.5);
    
    //要显示的图层
    CALayer *layer = self.videoView.layer;
    layer.masksToBounds = YES;
    [self.view layoutIfNeeded];
    [layer addSublayer:_captureVideoPreviewLayer];
}
#pragma mark 获取摄像头-->前/后

- (AVCaptureDevice *)deviceWithMediaType:(NSString *)mediaType preferringPosition:(AVCaptureDevicePosition)position
{
    NSArray *devices = [AVCaptureDevice devicesWithMediaType:mediaType];
    AVCaptureDevice *captureDevice = devices.firstObject;
    
    for ( AVCaptureDevice *device in devices ) {
        if ( device.position == position ) {
            captureDevice = device;
            break;
        }
    }
    
    return captureDevice;
}

-(void)pop
{
    if (self.navigationController) {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)showMsgWithTitle:(NSString *)title andContent:(NSString *)content
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:content preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:nil]];
    [self presentViewController:alert animated:YES completion:nil];
}

//点击屏幕开始录制

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{

    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self.view];
    BOOL isInTapLabel = [self isInTapLabelPoint:point];
    
    if (isInTapLabel) {
        
        [self isFitCondition:isInTapLabel];
        [self startAnimation];
    }
    
}


- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [super touchesMoved:touches withEvent:event];
    
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self.view];
    BOOL isInTapLabel = [self isInTapLabelPoint:point];
    
    [self isFitCondition:isInTapLabel];
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self.view];
    BOOL isInTapLabel = [self isInTapLabelPoint:point];
    /*
     结束时候咱们设定有两种情况依然算录制成功
     1.抬手时,录制时长 > 2s
     2.录制进度条完成时,就算手指超出按钮范围也算录制成功 -- 此时 end 方法不会调用,因为用户手指还在屏幕上,所以直接代码调用录制成功的方法,将控制器切换
     */
    NSLog(@"%@",@(self.progressView.width));
    if (isInTapLabel) {
        if (self.progressView.width < KWIDTH * (1-self.minTime/self.allTime)) {
            //录制完成
            [self recordComplete];
        }else{
            self.tipCancleLabel.text = TIPCANCLELABEL_TITLE_3;
            self.tipCancleLabel.textColor = TIPCANCLELABEL_COLOR_2;
        }
    }
    
    [self stopAnimation];

}
//判断点按的中心是否在tapLabel内
- (BOOL)isInTapLabelPoint:(CGPoint)point{
    CGFloat x = point.x;
    CGFloat y = point.y;
    return  ((x > KWIDTH/2-TAPLABEL_W_H/2 && x <= KWIDTH/2+TAPLABEL_W_H/2)&&(y > KHEIGHT*3/4-TAPLABEL_W_H/2 && y <= KHEIGHT*3/4+TAPLABEL_W_H/2));
}

- (void)isFitCondition:(BOOL)isInTapLabel
{
    if (isInTapLabel) {
        self.tipCancleLabel.text = TIPCANCLELABEL_TITLE_1;
        self.tipCancleLabel.textColor = TIPCANCLELABEL_COLOR_1;
    }else{
        self.tipCancleLabel.text = TIPCANCLELABEL_TITLE_2;
        self.tipCancleLabel.textColor = TIPCANCLELABEL_COLOR_2;
    }
}

- (CADisplayLink *)link
{
    if (!_link) {
        _link = [CADisplayLink displayLinkWithTarget:self selector:@selector(refresh:)];
        self.progressView.width = KWIDTH;
        [self startRecord];
    }
    return _link;
}

- (void)stopLink
{
    _link.paused = YES;
    [_link invalidate];
    _link = nil;
}

- (void)refresh:(CADisplayLink *)link
{
    if (self.progressView.width <= 0) {
        self.progressView.width = 0;
        [self recordComplete];
        [self stopAnimation];
        return;
    }
    self.progressView.width -= KWIDTH/(self.allTime*60);
    self.progressView.centerX = KWIDTH/2;
}

- (void)startAnimation{
    
    if (self.status == VideoStatusEnded) {
        self.status = VideoStatusStarted;
        [UIView animateWithDuration:0.5 animations:^{
            self.tipCancleLabel.alpha = self.progressView.alpha = 1.0;
            self.tapLabel.alpha = 0.0;
            self.flashBtn.alpha = 0.0;
            self.cameraBtn.alpha = 0.0;
            self.backBtn.alpha = 0.0;
            self.tapLabel.transform = CGAffineTransformMakeScale(2.0, 2.0);
        } completion:^(BOOL finished) {
            [self stopLink];
            [self.link addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
        }];
    }
    
}

- (void)stopAnimation{
    if (self.status == VideoStatusStarted) {
        self.status = VideoStatusEnded;
        
        [self stopLink];
        [self stopRecord];
        
        [UIView animateWithDuration:0.5 animations:^{
            self.tipCancleLabel.alpha = self.progressView.alpha = 0.0;
            self.tapLabel.alpha = 1.0;
            self.flashBtn.alpha = 1.0;
            self.cameraBtn.alpha = 1.0;
            self.backBtn.alpha = 1.0;
            self.tapLabel.transform = CGAffineTransformMakeScale(1.0, 1.0);
        } completion:^(BOOL finished) {
            self.progressView.width = KWIDTH;
            self.progressView.centerX = KWIDTH/2;
        }];
    }
}

#pragma mark 录制相关

- (NSURL *)outPutFileURL
{
    return [NSURL fileURLWithPath:[NSString stringWithFormat:@"%@%@", NSTemporaryDirectory(), @"outPut.mov"]];
}

- (void)startRecord
{
    [_movieOutput startRecordingToOutputFileURL:[self outPutFileURL] recordingDelegate:self];
}

- (void)stopRecord
{
    // 取消视频拍摄
    [_movieOutput stopRecording];
}

- (void)recordComplete
{
    self.canSave = YES;
}

- (void)captureOutput:(AVCaptureFileOutput *)captureOutput didStartRecordingToOutputFileAtURL:(NSURL *)fileURL fromConnections:(NSArray *)connections
{
    NSLog(@"---- 开始录制 ----");
}

- (void)captureOutput:(AVCaptureFileOutput *)captureOutput didFinishRecordingToOutputFileAtURL:(NSURL *)outputFileURL fromConnections:(NSArray *)connections error:(NSError *)error
{
    NSLog(@"---- 录制结束 ---%@-%@ ",outputFileURL,captureOutput.outputFileURL);
    
    if (outputFileURL.absoluteString.length == 0 && captureOutput.outputFileURL.absoluteString.length == 0 ) {
        [self showMsgWithTitle:@"出错了" andContent:@"录制视频保存地址出错"];
        return;
    }
    
    if (self.canSave) {
        [self pushToPlay:outputFileURL];
        self.canSave = NO;
    }
}

- (void)pushToPlay:(NSURL *)url
{
    JPPlayVideoController *playCtrl = [[JPPlayVideoController alloc]init];
    playCtrl.videoUrl = url;
    [self presentViewController:playCtrl animated:YES completion:nil];
}

//更改设备属性前一定要锁上
-(void)changeDevicePropertySafety:(void (^)(AVCaptureDevice *captureDevice))propertyChange{
    //也可以直接用_videoDevice,但是下面这种更好
    AVCaptureDevice *captureDevice= [_videoInput device];
    NSError *error;
    //注意改变设备属性前一定要首先调用lockForConfiguration:调用完之后使用unlockForConfiguration方法解锁,意义是---进行修改期间,先锁定,防止多处同时修改
    BOOL lockAcquired = [captureDevice lockForConfiguration:&error];
    if (!lockAcquired) {
        NSLog(@"锁定设备过程error，错误信息：%@",error.localizedDescription);
    }else{
        [_captureSession beginConfiguration];
        propertyChange(captureDevice);
        [captureDevice unlockForConfiguration];
        [_captureSession commitConfiguration];
    }
}


@end
