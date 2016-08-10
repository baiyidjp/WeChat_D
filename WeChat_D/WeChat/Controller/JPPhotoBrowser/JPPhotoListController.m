//
//  JPPhotoListController.m
//  WeChat_D
//
//  Created by tztddong on 16/8/10.
//  Copyright © 2016年 dongjiangpeng. All rights reserved.
//

#import "JPPhotoListController.h"
#import "JPPhotoModel.h"
#import "JPPhotoCollectionViewCell.h"

#define ROW_COUNT 4
#define PHOTOCELL_ID @"JPPhotoCollectionViewCell"
@interface JPPhotoListController ()<UICollectionViewDelegate,UICollectionViewDataSource>
@property(nonatomic,strong)NSMutableArray *photoDataArray;
@end

@implementation JPPhotoListController
{
    UICollectionView *photoCollectionView;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIButton *cancleBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 30, 30)];
    [cancleBtn setTitle:@"取消" forState:UIControlStateNormal];
    [cancleBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [cancleBtn.titleLabel setFont:FONTSIZE(15)];
    [cancleBtn addTarget:self action:@selector(clickCancleBtn) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc]initWithCustomView:cancleBtn];
    self.navigationItem.rightBarButtonItem = item;
    
    [self setCollectionView];
    [self getGroupPhotoData];
}

- (void)clickCancleBtn{
    
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

- (NSMutableArray *)photoDataArray{
    
    if (!_photoDataArray) {
        _photoDataArray = [NSMutableArray array];
    }
    return _photoDataArray;
}

- (void)setCollectionView{
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
    layout.minimumLineSpacing = 0;
    layout.minimumInteritemSpacing = 0;
    CGFloat itemWH = (KWIDTH - (ROW_COUNT+1)*KMARGIN/2)/ROW_COUNT;
    layout.itemSize = CGSizeMake(itemWH, itemWH);
    photoCollectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, KWIDTH, KHEIGHT-44) collectionViewLayout:layout];
    photoCollectionView.delegate = self;
    photoCollectionView.dataSource = self;
    [photoCollectionView registerClass:[JPPhotoCollectionViewCell class] forCellWithReuseIdentifier:PHOTOCELL_ID];
    [self.view addSubview:photoCollectionView];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    return self.photoDataArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    JPPhotoCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:PHOTOCELL_ID forIndexPath:indexPath];
    cell.photoModel = [self.photoDataArray objectAtIndex:indexPath.item];
    return cell;
}

- (void)getGroupPhotoData{
    
    [self.group enumerateAssetsWithOptions:NSEnumerationReverse usingBlock:^(ALAsset *result, NSUInteger index, BOOL *stop) {
        if (result) {
            JPPhotoModel *photoModel = [[JPPhotoModel alloc]init];
            photoModel.asset = result;
            [self.photoDataArray addObject:photoModel];
        }else{
            //刷新数据
            [photoCollectionView reloadData];
        }
    }];
}

@end
