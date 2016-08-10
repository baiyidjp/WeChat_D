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

- (UIImage *)originImage{
    UIImage *image = [UIImage imageWithCGImage:[[self.asset defaultRepresentation] fullScreenImage]];
    return image;
}

- (UIImage *)fullResolutionImage{
    ALAssetRepresentation *rep = [self.asset defaultRepresentation];
    CGImageRef iref = [rep fullResolutionImage];
    
    return [UIImage imageWithCGImage:iref scale:[rep scale] orientation:(UIImageOrientation)[rep orientation]];
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
