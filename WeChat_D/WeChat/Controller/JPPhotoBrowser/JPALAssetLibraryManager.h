//
//  JPAlAssetLibraryManger.h
//  WeChat_D
//
//  Created by Keep丶Dream on 16/8/13.
//  Copyright © 2016年 dongjiangpeng. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^ALGroupArrBlock)(NSArray *groupArray);
typedef void(^ALPhotoListBlock)(NSArray *photoList);

@class JPPhotoGroupModel;
@interface JPALAssetLibraryManager : NSObject

+ (JPALAssetLibraryManager *)sharedAlAssetLibraryManager;

- (void)ALGetPhotoGroupArrayWithBlock:(ALGroupArrBlock)ALGroupArrBlock;
- (void)ALGetPhotoListWithModel:(JPPhotoGroupModel *)groupModel Block:(ALPhotoListBlock)ALPhotoListBlock;

@end
