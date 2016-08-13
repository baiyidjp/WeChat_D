//
//  JPPhotoModel.h
//  WeChat_D
//
//  Created by tztddong on 16/8/10.
//  Copyright © 2016年 dongjiangpeng. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface JPPhotoModel : NSObject

+ (PHImageManager *)sharedPHImageManager;

@property (strong,nonatomic) ALAsset *asset;
/** ios8 PHAsset */
@property(nonatomic,strong) PHAsset *phAsset;

/**
 *  缩略图
 */
- (UIImage *)JPThumbImage;
/**
 *  原图
 */
- (UIImage *)JPFullScreenImage;//适应屏幕的原图
- (UIImage *)JPFullResolutionImage;//未作处理的原图
- (NSData *)JPFullResolutData;//原图的二进制数据
- (CGFloat)JPFullResolutionImageData; //原图的大小
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
