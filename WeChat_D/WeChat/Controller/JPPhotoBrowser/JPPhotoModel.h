//
//  JPPhotoModel.h
//  WeChat_D
//
//  Created by tztddong on 16/8/10.
//  Copyright © 2016年 dongjiangpeng. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^GetThumbImageBlock)(UIImage *thumbImage);
typedef void(^GetFullScreenImageBlock)(UIImage *fullScreenImage);
typedef void(^GetFullResolutDataBlock)(NSData *fullResolutData);
typedef void(^GetFullResolutDataSizeBlock)(CGFloat fullResolutDataSize);
typedef void(^GetFullScreenImageDataBlock)(NSData *fullScreenImageData);

@interface JPPhotoModel : NSObject

+ (PHImageManager *)sharedPHImageManager;

@property (strong,nonatomic) ALAsset *asset;
/** ios8 PHAsset */
@property(nonatomic,strong) PHAsset *phAsset;

/**
 *  获取缩略图
 */
- (void)JPThumbImageWithBlock:(GetThumbImageBlock)GetThumbImageBlock;
/** 保存获取到的缩略图 */
@property(nonatomic,strong) UIImage *thumbImage;

/**
 *  获取屏幕大小的原图
 */
- (void)JPFullScreenImageWithBlock:(GetFullScreenImageBlock)GetFullScreenImageBlock;//适应屏幕的原图
/** 保存获取到原图 */
@property(nonatomic,strong) UIImage *fullScreenImage;

/** 屏幕大小的原图的二进制数据 */
- (void)JPFullScreenImageDataWithBlock:(GetFullScreenImageDataBlock)GetFullScreenImageDataBlock;
/** 保存获取的data */
@property(nonatomic,strong) NSData *fullScreenImageData;

/** 原图的二进制数据 */
- (void)JPFullResolutDataWithBlock:(GetFullResolutDataBlock)GetFullResolutDataBlock;
/** 保存获取的data */
@property(nonatomic,strong) NSData *fullResolutData;

/** 获取到图片的大小(2.6M ... ) */
- (void)JPFullResolutionDataSizeWithBlock:(GetFullResolutDataSizeBlock)GetFullResolutDataSizeBlock;
/** 保存获取到图片的大小 */
@property(nonatomic,assign) CGFloat fullResolutDataSize;

/**
 *  获取是否是视频类型, Default = false
 */
@property (assign,nonatomic) BOOL isVideoType;
/**
 *  获取相册的URL
 */
- (NSURL *)assetURL;
/**
 *  是否被选中
 */
@property(nonatomic,assign)BOOL isSelect;
/**
 *  是否显示原图(后续发送的时候判断是否发送原图)
 */
@property(nonatomic,assign)BOOL isShowFullImage;
/**
 *  获取视频的时长
 */
- (NSString *)videoTime;

@property(nonatomic,strong)NSIndexPath *indexPath;

@end
