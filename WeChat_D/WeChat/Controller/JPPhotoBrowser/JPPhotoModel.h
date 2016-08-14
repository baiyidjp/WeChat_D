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

- (UIImage *)JPFullResolutionImage;//未作处理的原图
- (void)JPFullResolutDataWithBlock:(GetFullResolutDataBlock)GetFullResolutDataBlock;//原图的二进制数据
/** 保存获取的data */
@property(nonatomic,strong) NSData *fullResolutData;

- (void)JPFullResolutionDataSizeWithBlock:(GetFullResolutDataSizeBlock)GetFullResolutDataSizeBlock; //原图的大小
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
 *  是否显示原图
 */
@property(nonatomic,assign)BOOL isShowFullImage;

@property(nonatomic,strong)NSIndexPath *indexPath;
@end
