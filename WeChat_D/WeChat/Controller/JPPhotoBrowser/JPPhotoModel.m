//
//  JPPhotoModel.m
//  WeChat_D
//
//  Created by tztddong on 16/8/10.
//  Copyright © 2016年 dongjiangpeng. All rights reserved.
//

#import "JPPhotoModel.h"

@implementation JPPhotoModel

- (UIImage *)thumbImage{
    //在ios9上，用thumbnail方法取得的缩略图显示出来不清晰，所以用aspectRatioThumbnail
    if (IOS9_OR_LATER) {
        return [UIImage imageWithCGImage:[self.asset aspectRatioThumbnail]];
    } else {
        return [UIImage imageWithCGImage:[self.asset thumbnail]];
    }
    
}

- (UIImage *)compressionImage{
    UIImage *fullScreenImage = [UIImage imageWithCGImage:[[self.asset defaultRepresentation] fullScreenImage]];
    NSData *data2 = UIImageJPEGRepresentation(fullScreenImage, 0.1);
    UIImage *image = [UIImage imageWithData:data2];
    fullScreenImage = nil;
    data2 = nil;
    return image;
}

- (UIImage *)fullScreenImage{
    UIImage *image = [UIImage imageWithCGImage:[[self.asset defaultRepresentation] fullScreenImage]];
    return image;
}

- (UIImage *)fullResolutionImage{
    ALAssetRepresentation *rep = [self.asset defaultRepresentation];
    CGImageRef iref = [rep fullResolutionImage];
    
    return [UIImage imageWithCGImage:iref scale:[rep scale] orientation:(UIImageOrientation)[rep orientation]];
}

- (CGFloat)fullResolutionImageData{
    
    ALAssetRepresentation *rep = [self.asset defaultRepresentation];
    return [rep size]/(1024*1024.0);
}

- (NSData *)fullResolutData{
    
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
