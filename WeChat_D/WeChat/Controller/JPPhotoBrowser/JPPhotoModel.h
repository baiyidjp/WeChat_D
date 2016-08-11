//
//  JPPhotoModel.h
//  WeChat_D
//
//  Created by tztddong on 16/8/10.
//  Copyright © 2016年 dongjiangpeng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AssetsLibrary/AssetsLibrary.h>

@interface JPPhotoModel : NSObject

@property (strong,nonatomic) ALAsset *asset;
/**
 *  缩略图
 */
- (UIImage *)thumbImage;
/**
 *  压缩原图
 */
- (UIImage *)compressionImage;
/**
 *  原图
 */
- (UIImage *)fullScreenImage;//适应屏幕的原图
- (UIImage *)fullResolutionImage;//未作处理的原图
- (NSData *)fullResolutData;//原图的二进制数据
/**
 *  获取是否是视频类型, Default = false
 */
@property (assign,nonatomic) BOOL isVideoType;
/**
 *  获取相册的URL
 */
- (NSURL *)assetURL;
- (CGFloat)fullResolutionImageData; //原图的大小
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
