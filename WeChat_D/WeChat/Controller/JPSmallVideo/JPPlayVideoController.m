//
//  DDPlayVideoController.m
//  DDWXVideo
//
//  Created by tztddong on 16/3/2.
//  Copyright © 2016年 dongjiangpeng. All rights reserved.
//

#import "JPPlayVideoController.h"
#import <AVKit/AVKit.h>
#import <AVFoundation/AVFoundation.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import "JPWXVideoController.h"
@interface JPPlayVideoController (){
    
    AVPlayer *_player;
    AVPlayerItem *_playItem;
    AVPlayerLayer *_playerLayer;
    AVPlayerLayer *_fullPlayer;
    BOOL _isPlaying;
}
@property (weak, nonatomic) UIButton *saveBtn;
@property(nonatomic,weak)UIButton *backBtn;
@end

@implementation JPPlayVideoController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self create];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playbackFinished:)name:AVPlayerItemDidPlayToEndTimeNotification object:nil];
    
//    //时间差
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        self.saveBtn.enabled = YES;
//    });
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [_player pause];
    _player = nil;
}

- (void)create
{
    _playItem = [AVPlayerItem playerItemWithURL:self.videoUrl];
    _player = [AVPlayer playerWithPlayerItem:_playItem];
    _playerLayer =[AVPlayerLayer playerLayerWithPlayer:_player];
    _playerLayer.frame = CGRectMake(KWIDTH/2-75, KHEIGHT/2-100, 150, 150);
    _playerLayer.videoGravity=AVLayerVideoGravityResizeAspectFill;//视频填充模式
    [self.view.layer addSublayer:_playerLayer];
    [_player play];
    
    UIButton *backBtn = [[UIButton alloc]init];
    [backBtn setTitleColor:[UIColor purpleColor] forState:UIControlStateNormal];
    [backBtn setTitle:@"返回" forState:UIControlStateNormal];
    [backBtn.titleLabel setFont:FONTSIZE(15)];
    [backBtn sizeToFit];
    backBtn.left = KWIDTH/2 - backBtn.width/2;
    backBtn.top = KHEIGHT - 44;
    [backBtn addTarget:self action:@selector(backBtnClick) forControlEvents:UIControlEventTouchUpInside];
    self.backBtn = backBtn;
    [self.view addSubview:backBtn];
    
    UIButton *saveBtn = [[UIButton alloc]init];
    self.saveBtn = saveBtn;
    [saveBtn setTitle:@"保存视频到手机" forState:UIControlStateNormal];
    [saveBtn sizeToFit];
    saveBtn.top = CGRectGetMinY(backBtn.frame) - 50;
    saveBtn.centerX = KWIDTH/2;
    [saveBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [saveBtn setTitleColor:[UIColor grayColor] forState:UIControlStateDisabled];
    [saveBtn addTarget:self action:@selector(compressVideo:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:saveBtn];
}

- (void)backBtnClick{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    if (!_isPlaying) {
        _playerLayer.frame = [UIScreen mainScreen].bounds;
        self.saveBtn.alpha = 0.0;
        self.backBtn.alpha = 0.0;
    }else{
        _playerLayer.frame = CGRectMake(KWIDTH/2-75, KHEIGHT/2-100, 150, 150);
        self.saveBtn.alpha = 1.0;
        self.backBtn.alpha = 1.0;
    }
    _isPlaying = !_isPlaying;
}

-(void)playbackFinished:(NSNotification *)notification
{
    [_player seekToTime:CMTimeMake(0, 1)];
    [_player play];
}

#pragma mark 保存压缩
- (NSURL *)compressedURL
{
    return [NSURL fileURLWithPath:[[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, true) lastObject] stringByAppendingPathComponent:[NSString stringWithFormat:@"compressed.mp4"]]];
}

- (CGFloat)fileSize:(NSURL *)path
{
    return [[NSData dataWithContentsOfURL:path] length]/1024.00 /1024.00;
}

// 压缩视频
- (void)compressVideo:(id)sender
{
    NSLog(@"开始压缩,压缩前大小 %f MB",[self fileSize:self.videoUrl]);
    
    self.saveBtn.enabled = NO;
    [[NSFileManager defaultManager] removeItemAtURL:[self compressedURL] error:nil];
    AVURLAsset *avAsset = [[AVURLAsset alloc] initWithURL:self.videoUrl options:nil];
    NSArray *compatiblePresets = [AVAssetExportSession exportPresetsCompatibleWithAsset:avAsset];
    if ([compatiblePresets containsObject:AVAssetExportPresetLowQuality]) {
        
        AVAssetExportSession *exportSession = [[AVAssetExportSession alloc] initWithAsset:avAsset presetName:AVAssetExportPreset640x480];
        exportSession.outputURL = [self compressedURL];
        //优化网络
        exportSession.shouldOptimizeForNetworkUse = true;
        //转换后的格式
        exportSession.outputFileType = AVFileTypeMPEG4;
        //异步导出
        [exportSession exportAsynchronouslyWithCompletionHandler:^{
            // 如果导出的状态为完成
            if ([exportSession status] == AVAssetExportSessionStatusCompleted) {
                NSLog(@"压缩完毕,压缩后大小 %f MB",[self fileSize:[self compressedURL]]);
                [self saveVideo:[self compressedURL]];
            }else{
                NSLog(@"压缩失败 当前压缩进度:%f",exportSession.progress);
                self.saveBtn.enabled = YES;
                [self saveVideo:[self compressedURL]];
            }

            
        }];
    }
}

- (void)saveVideo:(NSURL *)outputFileURL
{
    ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
    [library writeVideoAtPathToSavedPhotosAlbum:outputFileURL
                                completionBlock:^(NSURL *assetURL, NSError *error) {
                                    if (error) {
                                        NSLog(@"保存视频失败:%@",error);
                                    } else {
                                        NSLog(@"保存视频到相册成功");
                                        [[NSFileManager defaultManager] removeItemAtURL:[self compressedURL] error:nil];
                                    }
                                }];
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
@end
