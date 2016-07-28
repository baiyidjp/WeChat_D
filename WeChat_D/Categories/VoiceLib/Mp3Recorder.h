//
//  Mp3Recorder.h
//  BloodSugar
//
//  Created by PeterPan on 14-3-24.
//  Copyright (c) 2014年 shake. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol Mp3RecorderDelegate <NSObject>
- (void)failRecord; //录音失败 时间太短的原因
- (void)beginConvert; //开始录音
- (void)endConvertWithMP3FileName:(NSString *)fileName recordTime:(NSInteger)recordTime; //结束录音 并返回录音转MP3所存储的地址 和 时间
@end

@interface Mp3Recorder : NSObject
@property (nonatomic, weak) id<Mp3RecorderDelegate> delegate;

- (id)initWithDelegate:(id<Mp3RecorderDelegate>)delegate;
- (void)startRecord; //开始录音
- (void)stopRecord; //停止录音
- (void)cancelRecord; //取消录音
- (void)startPlayRecordWithPath:(NSString *)path; //开始播放语音 传入一个地址
- (void)stopPlayRecord; //停止播放语音
- (NSInteger)updateMeters; //更新分贝
@end
