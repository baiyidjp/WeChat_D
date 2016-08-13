//
//  JPPhotoModel.m
//  WeChat_D
//
//  Created by tztddong on 16/8/10.
//  Copyright © 2016年 dongjiangpeng. All rights reserved.
//

#import "JPPhotoModel.h"

#define itemWH (KWIDTH - (4+1)*KMARGIN/2)/4
#define screenScale [UIScreen mainScreen].scale

static PHImageManager *imageManager = nil;

@implementation JPPhotoModel

+ (PHImageManager *)sharedPHImageManager{
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        imageManager = [[PHImageManager alloc] init];
    });
    return imageManager;
}


- (UIImage *)JPThumbImage{
    
    __block UIImage *resultImage;
    if (IOS8_OR_LATER) {
        [[JPPhotoModel sharedPHImageManager] requestImageForAsset:self.phAsset
                                                            targetSize:CGSizeMake(itemWH*screenScale, itemWH*screenScale)
                                                           contentMode:PHImageContentModeAspectFill
                                                               options:nil
                                                         resultHandler:^(UIImage *result, NSDictionary *info) {
                                                             resultImage = result;
                                                         }];

    } else {
        resultImage = [UIImage imageWithCGImage:[self.asset aspectRatioThumbnail]];
    }
    return resultImage;
}


- (UIImage *)JPFullScreenImage{
    __block UIImage *resultImage;
    if (IOS8_OR_LATER) {
        PHImageRequestOptions *imageRequestOptions = [[PHImageRequestOptions alloc] init];
        imageRequestOptions.synchronous = YES;
        imageRequestOptions.deliveryMode = PHImageRequestOptionsDeliveryModeHighQualityFormat;
        [[JPPhotoModel sharedPHImageManager] requestImageForAsset:self.phAsset
                                                       targetSize:CGSizeMake(KWIDTH*screenScale, KHEIGHT*screenScale)
                                                      contentMode:PHImageContentModeAspectFill
                                                          options:imageRequestOptions
                                                    resultHandler:^(UIImage *result, NSDictionary *info) {
                                                        resultImage = result;
                                                    }];
        
    } else {
        resultImage = [UIImage imageWithCGImage:[[self.asset defaultRepresentation] fullScreenImage]];
    }
    return resultImage;
}

- (UIImage *)JPFullResolutionImage{
    ALAssetRepresentation *rep = [self.asset defaultRepresentation];
    CGImageRef iref = [rep fullResolutionImage];
    
    return [UIImage imageWithCGImage:iref scale:[rep scale] orientation:(UIImageOrientation)[rep orientation]];
}

- (CGFloat)JPFullResolutionImageData{
    
    ALAssetRepresentation *rep = [self.asset defaultRepresentation];
    return [rep size]/(1024*1024.0);
}

- (NSData *)JPFullResolutData{
    
    ALAssetRepresentation *assetRep = [self.asset defaultRepresentation];
    NSUInteger size = [assetRep size];
    uint8_t *buff = malloc(size);
    
    NSError *err = nil;
    NSUInteger gotByteCount = [assetRep getBytes:buff fromOffset:0 length:size error:&err];
    
    if (gotByteCount) {
        if (err) {
            free(buff);
            return nil;
        }
    }
    
    return [NSData dataWithBytesNoCopy:buff length:size freeWhenDone:YES];
}

- (BOOL)isVideoType{
    NSString *type = [self.asset valueForProperty:ALAssetPropertyType];
    //媒体类型是视频
    return [type isEqualToString:ALAssetTypeVideo];
}

- (NSURL *)assetURL{
    return [[self.asset defaultRepresentation] url];
}


@end
