//
//  JPScreenPhotoController.h
//  WeChat_D
//
//  Created by tztddong on 16/8/11.
//  Copyright © 2016年 dongjiangpeng. All rights reserved.
//

#import "BaseViewController.h"

@interface JPScreenPhotoController : BaseViewController
@property(nonatomic,assign)NSInteger selectPhotoCount;
@property(nonatomic,strong)NSArray *photoDataArray;
@property(nonatomic,strong)NSIndexPath *currentIndexPath;
@end
