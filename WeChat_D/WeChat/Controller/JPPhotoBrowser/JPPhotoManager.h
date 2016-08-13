//
//  JPPhotoManger.h
//  WeChat_D
//
//  Created by Keep丶Dream on 16/8/13.
//  Copyright © 2016年 dongjiangpeng. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^GroupArrBlock)(NSArray *groupArray);
typedef void(^PhotoListBlock)(NSArray *photoList);


@class JPPhotoGroupModel;
@interface JPPhotoManager : NSObject

/*获取单例*/
+ (JPPhotoManager *)sharedPhotoManager;

/*获取相片组*/
- (void)getPhotoGroupWithBlock:(GroupArrBlock)GroupArrBlock;

/*获取相片list*/
- (void)getPhotoListWithModel:(JPPhotoGroupModel *)groupModel Block:(PhotoListBlock)PhotoListBlock;


@end
