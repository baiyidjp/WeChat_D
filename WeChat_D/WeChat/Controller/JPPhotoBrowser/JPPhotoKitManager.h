//
//  JPPhotoKitManger.h
//  WeChat_D
//
//  Created by Keep丶Dream on 16/8/13.
//  Copyright © 2016年 dongjiangpeng. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^PHGroupArrBlock)(NSArray *groupArray);
typedef void(^PHPhotoListBlock)(NSArray *photoList);

@class JPPhotoGroupModel;
@interface JPPhotoKitManager : NSObject

+ (JPPhotoKitManager *)sharedPhotoKitManager;


- (void)PHGetPhotoGroupArrayWithBlock:(PHGroupArrBlock)PHGroupArrBlock;
- (void)PHGetPhotoListWithModel:(JPPhotoGroupModel *)groupModel Block:(PHPhotoListBlock)PHPhotoListBlock;


@end
