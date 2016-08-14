//
//  JPPhotoManger.m
//  WeChat_D
//
//  Created by Keep丶Dream on 16/8/13.
//  Copyright © 2016年 dongjiangpeng. All rights reserved.
//

#import "JPPhotoManager.h"
#import "JPPhotoKitManager.h"
#import "JPALAssetLibraryManager.h"

static JPPhotoManager *photoManger = nil;

@implementation JPPhotoManager

+ (JPPhotoManager *)sharedPhotoManager{
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
       
        photoManger = [[JPPhotoManager alloc]init];
    });
    return photoManger;
}

- (void)getPhotoGroupWithBlock:(GroupArrBlock)GroupArrBlock{
    
    if (IOS_VERSION_8_OR_LATER) {
        [[JPPhotoKitManager sharedPhotoKitManager] PHGetPhotoGroupArrayWithBlock:^(NSArray *groupArray) {
            if (GroupArrBlock) {
                GroupArrBlock(groupArray);
            }
        }];
    }else{
        [[JPALAssetLibraryManager sharedAlAssetLibraryManager] ALGetPhotoGroupArrayWithBlock:^(NSArray *groupArray) {
            if (GroupArrBlock) {
                GroupArrBlock(groupArray);
            }
        }];
    }
}

- (void)getPhotoListWithModel:(JPPhotoGroupModel *)groupModel Block:(PhotoListBlock)PhotoListBlock{
    
    if (IOS_VERSION_8_OR_LATER) {
            [[JPPhotoKitManager sharedPhotoKitManager] PHGetPhotoListWithModel:groupModel Block:^(NSArray *photoList) {
                if (PhotoListBlock) {
                    PhotoListBlock(photoList);
                }
            }];
    }else{
        [[JPALAssetLibraryManager sharedAlAssetLibraryManager] ALGetPhotoListWithModel:groupModel Block:^(NSArray *photoList) {
            if (PhotoListBlock) {
                PhotoListBlock(photoList);
            }
        }];
    }
    
}
@end
