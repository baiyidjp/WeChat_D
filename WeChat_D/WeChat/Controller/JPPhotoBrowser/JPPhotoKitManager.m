//
//  JPPhotoKitManger.m
//  WeChat_D
//
//  Created by Keep丶Dream on 16/8/13.
//  Copyright © 2016年 dongjiangpeng. All rights reserved.
//

#import "JPPhotoKitManager.h"
#import "JPPhotoGroupModel.h"
#import "JPPhotoModel.h"

static JPPhotoKitManager *photoKitManager = nil;

@implementation JPPhotoKitManager

+ (JPPhotoKitManager *)sharedPhotoKitManager{
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        photoKitManager = [[JPPhotoKitManager alloc]init];
    });
    
    return photoKitManager;
}

- (void)PHGetPhotoGroupArrayWithBlock:(PHGroupArrBlock)PHGroupArrBlock{
    
    NSMutableArray *photoGroupArray = [NSMutableArray array];
    // 列出所有相册智能相册
    PHFetchResult *smartAlbums = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeSmartAlbum subtype:PHAssetCollectionSubtypeAlbumRegular options:nil];
    NSLog(@"相册总数 --- %zd ",smartAlbums.count);
    // 这时 smartAlbums 中保存的应该是各个智能相册对应的 PHAssetCollection
    for (NSInteger i = 0; i < smartAlbums.count; i++) {
        // 获取一个相册（PHAssetCollection）
        PHCollection *collection = smartAlbums[i];
        if ([collection isKindOfClass:[PHAssetCollection class]]) {
            PHAssetCollection *assetCollection = (PHAssetCollection *)collection;
            // 从每一个智能相册中获取到的 PHFetchResult 中包含的才是真正的资源（PHAsset）
            // 获取所有资源的集合，并按资源的创建时间排序
            PHFetchOptions *fetchOptions = [[PHFetchOptions alloc] init];
            fetchOptions.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:NO]];
            PHFetchResult *fetchResult = [PHAsset fetchAssetsInAssetCollection:assetCollection options:fetchOptions];
            // 在资源的集合中获取第一个集合，并获取其中的图片
            PHImageManager *imageGroupManager = [[PHImageManager alloc]init];
            //默认的是异步获取图片 手动设置成同步  
            PHImageRequestOptions *opt = [[PHImageRequestOptions alloc]init];
            opt.synchronous = YES;
            PHAsset *asset = nil;
            CGFloat scale = [UIScreen mainScreen].scale;
            if (fetchResult.count != 0) {
                asset = fetchResult[0];
                [imageGroupManager requestImageForAsset:asset
                                        targetSize:CGSizeMake(80*scale, 80*scale)
                                       contentMode:PHImageContentModeDefault
                                           options:opt
                                     resultHandler:^(UIImage *result, NSDictionary *info) {
                                         
                                         // 得到一张 UIImage，展示到界面上
                                         JPPhotoGroupModel *groupModel = [[JPPhotoGroupModel alloc]init];
                                         groupModel.groupName = assetCollection.localizedTitle;
                                         groupModel.thumbImage = result;
                                         groupModel.assetsCount = fetchResult.count?fetchResult.count:0;
                                         groupModel.assetCollection = assetCollection;
                                         [photoGroupArray addObject:groupModel];
                                     }];
            }
            if (i == smartAlbums.count-1) {
                if (PHGroupArrBlock) {
                    PHGroupArrBlock([photoGroupArray copy]);
                }
            }

        }else {
                NSAssert(NO, @"Fetch collection not PHCollection: %@", collection);
            }
        }
}

- (void)PHGetPhotoListWithModel:(JPPhotoGroupModel *)groupModel Block:(PHPhotoListBlock)PHPhotoListBlock{
    
    NSMutableArray *photoListArr = [NSMutableArray array];
    PHAssetCollection *assetCollection = groupModel.assetCollection;
    // 从每一个智能相册中获取到的 PHFetchResult 中包含的才是真正的资源（PHAsset）
    // 获取所有资源的集合，并按资源的创建时间排序
    PHFetchOptions *fetchOptions = [[PHFetchOptions alloc] init];
    fetchOptions.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:NO]];
    PHFetchResult *fetchResult = [PHAsset fetchAssetsInAssetCollection:assetCollection options:fetchOptions];
    NSLog(@"相册图片数--->%zd",fetchResult.count);
    for (NSInteger i = 0; i < fetchResult.count; i++) {
        PHAsset *asset = fetchResult[i];
        JPPhotoModel *photoModel = [[JPPhotoModel alloc]init];
        photoModel.phAsset = asset;
        photoModel.indexPath = [NSIndexPath indexPathForRow:i inSection:0];
        [photoListArr addObject:photoModel];
        if (photoListArr.count == (NSInteger)fetchResult.count) {
            if (PHPhotoListBlock) {
                PHPhotoListBlock([photoListArr copy]);
            }
        }
    }
}

@end
