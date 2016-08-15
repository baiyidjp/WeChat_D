//
//  JPPhotoModel.m
//  WeChat_D
//
//  Created by tztddong on 16/8/10.
//  Copyright © 2016年 dongjiangpeng. All rights reserved.
//

#import "JPPhotoModel.h"

static PHImageManager *imageManager = nil;

@implementation JPPhotoModel

+ (PHImageManager *)sharedPHImageManager{
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        imageManager = [[PHImageManager alloc] init];
    });
    return imageManager;
}


- (void)JPThumbImageWithBlock:(GetThumbImageBlock)GetThumbImageBlock{
    
    if (GetThumbImageBlock && self.thumbImage) {
        GetThumbImageBlock(self.thumbImage);
    }
    CGFloat itemWH = (KWIDTH - (4+1)*KMARGIN/2)/4;
    CGFloat screenScale = [UIScreen mainScreen].scale;
    if (IOS_VERSION_8_OR_LATER) {
        [[JPPhotoModel sharedPHImageManager] requestImageForAsset:self.phAsset
                                                            targetSize:CGSizeMake(itemWH*screenScale, itemWH*screenScale)
                                                           contentMode:PHImageContentModeAspectFill
                                                               options:nil
                                                         resultHandler:^(UIImage *result, NSDictionary *info) {
                                                             self.thumbImage = result;
                                                             if (GetThumbImageBlock) {
                                                                 GetThumbImageBlock(result);
                                                             }
                                                         }];

    } else {
        UIImage *thumbImage = [UIImage imageWithCGImage:[self.asset aspectRatioThumbnail]];
        self.thumbImage = thumbImage;
        if (GetThumbImageBlock) {
            GetThumbImageBlock(thumbImage);
        }

    }
    
}

/*
 PHImageFileOrientationKey = 0;
 PHImageFileSandboxExtensionTokenKey = "19fff0b45bbf129ad15d8a2aeac8000f5718ea1d;00000000;00000000;000000000000001a;com.apple.app-sandbox.read;00000001;01000004;0000000002c7e0a3;/users/dong/library/developer/coresimulator/devices/7c36c643-3d47-4894-9284-43d7c0d4d244/data/media/dcim/100apple/img_0004.jpg";
 PHImageFileURLKey = "file:///Users/dong/Library/Developer/CoreSimulator/Devices/7C36C643-3D47-4894-9284-43D7C0D4D244/data/Media/DCIM/100APPLE/IMG_0004.JPG";
 PHImageFileUTIKey = "public.jpeg";
 PHImageResultDeliveredImageFormatKey = 9999;
 PHImageResultIsDegradedKey = 0;
 PHImageResultIsInCloudKey = 0;
 PHImageResultIsPlaceholderKey = 0;
 PHImageResultOptimizedForSharing = 0;
 PHImageResultRequestIDKey = 10;
 PHImageResultWantedImageFormatKey = 4035;
 
 */

- (void)JPFullScreenImageWithBlock:(GetFullScreenImageBlock)GetFullScreenImageBlock{
#warning 先从缓存中取出  后续处理  .. . ... ..
    if (GetFullScreenImageBlock && self.fullScreenImage) {
        GetFullScreenImageBlock(self.fullScreenImage);
    }else{
        if (IOS_VERSION_8_OR_LATER) {
            
            [[JPPhotoModel sharedPHImageManager] requestImageForAsset:self.phAsset
                                                           targetSize:CGSizeMake(KWIDTH, KHEIGHT)
                                                          contentMode:PHImageContentModeAspectFill
                                                              options:nil
                                                        resultHandler:^(UIImage *result, NSDictionary *info) {
                                                            NSLog(@"%@",info);
                                                            self.fullScreenImage = result;
                                                            if (GetFullScreenImageBlock) {
                                                                GetFullScreenImageBlock(result);
                                                            }
                                                        }];
            
        } else {
            UIImage *fullImage = [UIImage imageWithCGImage:[[self.asset defaultRepresentation] fullScreenImage]];
            self.fullScreenImage = fullImage;
            if (GetFullScreenImageBlock) {
                GetFullScreenImageBlock(fullImage);
            }
            
        }
    }

}

- (UIImage *)JPFullResolutionImage{
    ALAssetRepresentation *rep = [self.asset defaultRepresentation];
    CGImageRef iref = [rep fullResolutionImage];
    
    return [UIImage imageWithCGImage:iref scale:[rep scale] orientation:(UIImageOrientation)[rep orientation]];
}

- (void)JPFullResolutionDataSizeWithBlock:(GetFullResolutDataSizeBlock)GetFullResolutDataSizeBlock{
    if (GetFullResolutDataSizeBlock && self.fullResolutDataSize) {
        GetFullResolutDataSizeBlock(self.fullResolutDataSize);
    }else{
        if (IOS_VERSION_8_OR_LATER) {
            [[JPPhotoModel sharedPHImageManager] requestImageDataForAsset:self.phAsset options:nil resultHandler:^(NSData * _Nullable imageData, NSString * _Nullable dataUTI, UIImageOrientation orientation, NSDictionary * _Nullable info) {
                // 排除取消，错误，低清图三种情况，即已经获取到了高清图
                BOOL downloadFinined = ![[info objectForKey:PHImageCancelledKey] boolValue] && ![info objectForKey:PHImageErrorKey] && ![[info objectForKey:PHImageResultIsDegradedKey] boolValue];
                if (downloadFinined) {
                    CGFloat dataSize = imageData.length/(1024*1024.0);
                    self.fullResolutDataSize = dataSize;
                    self.fullResolutData = imageData;
                    if (GetFullResolutDataSizeBlock) {
                        GetFullResolutDataSizeBlock(dataSize);
                    }
                }

            }];
        }else{
            ALAssetRepresentation *rep = [self.asset defaultRepresentation];
            CGFloat dataSize = [rep size]/(1024*1024.0);
            self.fullResolutDataSize = dataSize;
            if (GetFullResolutDataSizeBlock) {
                GetFullResolutDataSizeBlock(dataSize);
            }
        }
    }
}

- (void)JPFullResolutDataWithBlock:(GetFullResolutDataBlock)GetFullResolutDataBlock{
    if (GetFullResolutDataBlock && self.fullResolutData) {
        GetFullResolutDataBlock(self.fullResolutData);
    }else{
        if (IOS_VERSION_8_OR_LATER) {
            [[JPPhotoModel sharedPHImageManager] requestImageDataForAsset:self.phAsset options:nil resultHandler:^(NSData * _Nullable imageData, NSString * _Nullable dataUTI, UIImageOrientation orientation, NSDictionary * _Nullable info) {
                // 排除取消，错误，低清图三种情况，即已经获取到了高清图
                BOOL downloadFinined = ![[info objectForKey:PHImageCancelledKey] boolValue] && ![info objectForKey:PHImageErrorKey] && ![[info objectForKey:PHImageResultIsDegradedKey] boolValue];
                if (downloadFinined) {
                    
                    self.fullResolutData = imageData;
                    if (GetFullResolutDataBlock) {
                        GetFullResolutDataBlock(imageData);
                    }
                }
                
            }];

        }else{
            ALAssetRepresentation *assetRep = [self.asset defaultRepresentation];
            NSUInteger size = [assetRep size];
            uint8_t *buff = malloc(size);
            
            NSError *err = nil;
            NSUInteger gotByteCount = [assetRep getBytes:buff fromOffset:0 length:size error:&err];
            
            NSData *fullImageData = nil;
            if (gotByteCount) {
                if (err) {
                    free(buff);
                    fullImageData = nil;
                }
            }
            
            fullImageData = [NSData dataWithBytesNoCopy:buff length:size freeWhenDone:YES];
            self.fullResolutData = fullImageData;
            if (GetFullResolutDataBlock) {
                GetFullResolutDataBlock(fullImageData);
            }
        }
    }
}

- (BOOL)isVideoType{
    
    if (IOS_VERSION_8_OR_LATER) {
        
        PHAssetMediaType mediaType = self.phAsset.mediaType;
        return mediaType == PHAssetMediaTypeVideo ? YES : NO;
    }
    
    NSString *type = [self.asset valueForProperty:ALAssetPropertyType];
    //媒体类型是视频
    return [type isEqualToString:ALAssetTypeVideo] ? YES : NO;
}

- (NSURL *)assetURL{
    return [[self.asset defaultRepresentation] url];
}

- (NSString *)videoTime{
    
    NSInteger time = (NSInteger)self.phAsset.duration;
    NSInteger minute = time / 60;
    CGFloat second = time % 60;
    return [NSString stringWithFormat:@"%zd:%.2f",minute,second];
}

@end
