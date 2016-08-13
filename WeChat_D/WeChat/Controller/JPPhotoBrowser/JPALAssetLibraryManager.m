//
//  JPAlAssetLibraryManger.m
//  WeChat_D
//
//  Created by Keep丶Dream on 16/8/13.
//  Copyright © 2016年 dongjiangpeng. All rights reserved.
//

#import "JPALAssetLibraryManager.h"
#import "JPPhotoGroupModel.h"
#import "JPPhotoModel.h"

@interface JPALAssetLibraryManager ()

@end

static JPALAssetLibraryManager *manger = nil;
static ALAssetsLibrary *assetLibrary = nil;
@implementation JPALAssetLibraryManager

+ (JPALAssetLibraryManager *)sharedAlAssetLibraryManager{
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manger = [[JPALAssetLibraryManager alloc]init];
        assetLibrary = [[ALAssetsLibrary alloc]init];
    });
    return manger;
}

- (void)ALGetPhotoGroupArrayWithBlock:(ALGroupArrBlock)ALGroupArrBlock{
    
    NSMutableArray *photoGroupArray = [NSMutableArray array];
    [assetLibrary enumerateGroupsWithTypes:ALAssetsGroupAll usingBlock:^(ALAssetsGroup *group, BOOL *stop) {
        if (group) {
            [group setAssetsFilter:[ALAssetsFilter allAssets]];
            if ([group numberOfAssets] > 0) {
                // 把相册储存到数组中，方便后面展示相册时使用
                //直接将数据存储在模型中
                JPPhotoGroupModel *groupModel = [[JPPhotoGroupModel alloc]init];
                groupModel.groupName = [group valueForProperty:@"ALAssetsGroupPropertyName"];
                groupModel.thumbImage = [UIImage imageWithCGImage:[group posterImage]];
                groupModel.assetsCount = [group numberOfAssets];
                groupModel.group = group;
                [photoGroupArray addObject:groupModel];
            }
        } else {
            if ([photoGroupArray count] > 0) {
                if (ALGroupArrBlock) {
                    ALGroupArrBlock([photoGroupArray copy]);
                }
            } else {
                // 没有任何有资源的相册，输出提示
            }
        }
    } failureBlock:^(NSError *error) {
        
    }];

}

- (void)ALGetPhotoListWithModel:(JPPhotoGroupModel *)groupModel Block:(ALPhotoListBlock)ALPhotoListBlock{
    
    NSMutableArray *photoListArray = [NSMutableArray array];
    [groupModel.group enumerateAssetsWithOptions:NSEnumerationReverse usingBlock:^(ALAsset *result, NSUInteger index, BOOL *stop) {
        if (result) {
            NSInteger row = ABS((NSInteger)index - groupModel.assetsCount+1);
            JPPhotoModel *photoModel = [[JPPhotoModel alloc]init];
            photoModel.asset = result;
            photoModel.indexPath = [NSIndexPath indexPathForRow:row inSection:0];
            [photoListArray addObject:photoModel];
        }else{
            if (ALPhotoListBlock) {
                ALPhotoListBlock([photoListArray copy]);
            }
        }
    }];

}

- (NSArray *)getPhotoListWithModel:(JPPhotoGroupModel *)groupModel{
    
    NSMutableArray *photoListArray = [NSMutableArray array];
    [groupModel.group enumerateAssetsWithOptions:NSEnumerationReverse usingBlock:^(ALAsset *result, NSUInteger index, BOOL *stop) {
        if (result) {
            NSInteger row = ABS((NSInteger)index - groupModel.assetsCount+1);
            JPPhotoModel *photoModel = [[JPPhotoModel alloc]init];
            photoModel.asset = result;
            photoModel.indexPath = [NSIndexPath indexPathForRow:row inSection:0];
            [photoListArray addObject:photoModel];
        }
    }];

    return [photoListArray copy];
}

@end
