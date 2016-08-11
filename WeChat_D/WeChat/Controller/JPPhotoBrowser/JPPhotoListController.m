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
#import "JPScreenPhotoController.h"

#define ROW_COUNT 4
#define PHOTOCELL_ID @"JPPhotoCollectionViewCell"
@interface JPPhotoListController ()<UICollectionViewDelegate,UICollectionViewDataSource>
@property(nonatomic,strong)NSMutableArray *photoDataArray;
@end

@implementation JPPhotoListController
{
    UICollectionView *photoCollectionView;
    NSInteger selectPhotoCount;
    UIButton *preViewBtn;
    UIButton *sendBtn;
    UILabel *countLabel;
    NSInteger showImageCount;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    showImageCount = KHEIGHT/((KWIDTH - 5*KMARGIN)/ROW_COUNT)*ROW_COUNT;
    
    UIButton *cancleBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 30, 30)];
    [cancleBtn setTitle:@"取消" forState:UIControlStateNormal];
    [cancleBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [cancleBtn.titleLabel setFont:FONTSIZE(15)];
    [cancleBtn addTarget:self action:@selector(clickCancleBtn) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc]initWithCustomView:cancleBtn];
    self.navigationItem.rightBarButtonItem = item;
    
    [self setCollectionView];
    [self getGroupPhotoData];
    [JP_NotificationCenter addObserver:self selector:@selector(selectPhoto:) name:SELECTPHOTO object:nil];
    [JP_NotificationCenter addObserver:self selector:@selector(selectPhotoRefresh:) name:SELECTPHOTO_REFRESH object:nil];
}

- (void)selectPhoto:(NSNotification *)notification{
    
    NSDictionary *dict = notification.userInfo;
    if ([[dict objectForKey:@"isSelect"] integerValue]) {
        selectPhotoCount++;
    }else{
        selectPhotoCount--;
    }
    [self changeBottomViewState];
}

- (void)selectPhotoRefresh:(NSNotification *)notification{
    
    NSDictionary *dict = notification.userInfo;
    NSIndexPath *indexPath = [dict objectForKey:@"indexPath"];
    [photoCollectionView reloadItemsAtIndexPaths:@[indexPath]];
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
    layout.minimumLineSpacing = 5;
    layout.minimumInteritemSpacing = 5;
    CGFloat itemWH = (KWIDTH - (ROW_COUNT+1)*KMARGIN/2)/ROW_COUNT;
    layout.itemSize = CGSizeMake(itemWH, itemWH);
    photoCollectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(KMARGIN/2, KMARGIN/2, KWIDTH-KMARGIN, KHEIGHT-44-KMARGIN) collectionViewLayout:layout];
    photoCollectionView.delegate = self;
    photoCollectionView.dataSource = self;
    photoCollectionView.backgroundColor = [UIColor colorWithHexString:@"f4f4f4"];
    [photoCollectionView registerClass:[JPPhotoCollectionViewCell class] forCellWithReuseIdentifier:PHOTOCELL_ID];
    [self.view addSubview:photoCollectionView];
    
    UIView *bottomView = [[UIView alloc]init];
    bottomView.backgroundColor = [UIColor grayColor];
    [self.view addSubview:bottomView];
    [bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.offset(0);
        make.height.equalTo(@44);
    }];
    
    preViewBtn = [[UIButton alloc]init];
    [preViewBtn setTitle:@"预览" forState:UIControlStateNormal];
    [preViewBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [preViewBtn setTitleColor:[UIColor colorWithWhite:0.438 alpha:1.000] forState:UIControlStateDisabled];
    [preViewBtn.titleLabel setFont:FONTSIZE(15)];
    [preViewBtn addTarget:self action:@selector(preViewBtn) forControlEvents:UIControlEventTouchUpInside];
    preViewBtn.enabled = NO;
    [bottomView addSubview:preViewBtn];
    [preViewBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(KMARGIN);
        make.centerY.equalTo(bottomView);
    }];
    
    sendBtn = [[UIButton alloc]init];
    [sendBtn setTitle:@"发送" forState:UIControlStateNormal];
    [sendBtn setTitleColor:[UIColor greenColor] forState:UIControlStateNormal];
    [sendBtn setTitleColor:[UIColor colorWithRed:0.000 green:0.411 blue:0.000 alpha:1.000] forState:UIControlStateDisabled];
    [sendBtn.titleLabel setFont:FONTSIZE(15)];
    sendBtn.enabled = NO;
    [sendBtn addTarget:self action:@selector(sendPhoto) forControlEvents:UIControlEventTouchUpInside];
    [bottomView addSubview:sendBtn];
    [sendBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.offset(-KMARGIN);
        make.centerY.equalTo(bottomView);
    }];
    
    countLabel = [[UILabel alloc]init];
    countLabel.backgroundColor = [UIColor greenColor];
    countLabel.textColor = [UIColor whiteColor];
    countLabel.textAlignment = NSTextAlignmentCenter;
    countLabel.font = FONTSIZE(15);
    countLabel.layer.cornerRadius = 10;
    countLabel.layer.masksToBounds = YES;

    countLabel.hidden = YES;
    [bottomView addSubview:countLabel];
    [countLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(sendBtn.mas_left).with.offset(-KMARGIN/2);
        make.centerY.equalTo(bottomView);
        make.size.mas_equalTo(CGSizeMake(20, 20));
    }];
    [countLabel layoutIfNeeded];
}

#pragma mark UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    return self.photoDataArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    JPPhotoCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:PHOTOCELL_ID forIndexPath:indexPath];
    cell.photoModel = [self.photoDataArray objectAtIndex:indexPath.item];
    WEAK_SELF(weakSelf);
    [cell setClickSelectBtnBlock:^{
        
        [weakSelf cellSelectWithIndexPath:indexPath];
    }];
    return cell;
}

#pragma mark UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    JPScreenPhotoController *screenPhotoCtrl = [[JPScreenPhotoController alloc]init];
    screenPhotoCtrl.selectPhotoCount = selectPhotoCount;
    screenPhotoCtrl.photoDataArray = self.photoDataArray;
    screenPhotoCtrl.currentIndexPath = indexPath;
    [self.navigationController pushViewController:screenPhotoCtrl animated:YES];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
}

#pragma mark 获取当前组下的图片
- (void)getGroupPhotoData{
    
    [self.group enumerateAssetsWithOptions:NSEnumerationReverse usingBlock:^(ALAsset *result, NSUInteger index, BOOL *stop) {
//        if (ABS((NSInteger)index - [self.group numberOfAssets]) > showImageCount) {
//            *stop = YES;
//            //刷新数据
//            [photoCollectionView reloadData];
//        }else{
            if (result) {
                NSInteger row = ABS((NSInteger)index - [self.group numberOfAssets]+1);
                JPPhotoModel *photoModel = [[JPPhotoModel alloc]init];
                photoModel.asset = result;
                photoModel.indexPath = [NSIndexPath indexPathForRow:row inSection:0];
                [self.photoDataArray addObject:photoModel];
            }else{
                //刷新数据
                [photoCollectionView reloadData];
            }
//        }
    }];
}

#pragma mark 点击选中按钮的回调
- (void)cellSelectWithIndexPath:(NSIndexPath *)indexPath{
    
    NSLog(@"%zd",indexPath.item);
    JPPhotoModel *photoModel = [self.photoDataArray objectAtIndex:indexPath.item];
    photoModel.isSelect = !photoModel.isSelect;
    if (photoModel.isSelect && selectPhotoCount == 9) {
        photoModel.isSelect = NO;
        UIAlertController *alertCtrl = [UIAlertController alertControllerWithTitle:@"最多选择九张图片" message:nil preferredStyle:UIAlertControllerStyleAlert];
        [alertCtrl addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:nil]];
        [self presentViewController:alertCtrl animated:YES completion:nil];
    }else{
        [photoCollectionView reloadItemsAtIndexPaths:@[indexPath]];
        [JP_NotificationCenter postNotificationName:SELECTPHOTO object:nil userInfo:@{@"isSelect":photoModel.isSelect?@"1":@"0"}];
    }

}

#pragma mark 点击图片后 改变状态
- (void)changeBottomViewState{
    
    if (selectPhotoCount) {
        sendBtn.enabled = YES;
        preViewBtn.enabled = YES;
        countLabel.hidden = NO;
        countLabel.text = [NSString stringWithFormat:@"%zd",selectPhotoCount];
    }else{
        sendBtn.enabled = NO;
        preViewBtn.enabled = NO;
        countLabel.hidden = YES;

    }

}

#pragma mark 预览
- (void)preViewBtn{
    
    NSMutableArray *preDataArray = [NSMutableArray array];
    for (JPPhotoModel *photoModel in self.photoDataArray) {
        if (photoModel.isSelect) {
            [preDataArray addObject:photoModel];
        }
    }
    JPScreenPhotoController *screenPhotoCtrl = [[JPScreenPhotoController alloc]init];
    screenPhotoCtrl.selectPhotoCount = selectPhotoCount;
    screenPhotoCtrl.photoDataArray = preDataArray;
    screenPhotoCtrl.currentIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    [self.navigationController pushViewController:screenPhotoCtrl animated:YES];
}

- (void)sendPhoto{
    
    NSMutableArray *dataArr = [NSMutableArray array];
    for (JPPhotoModel *model in self.photoDataArray) {
        if (model.isSelect) {
            [dataArr addObject:model];
        }
    }
    NSDictionary *dict = [NSDictionary dictionaryWithObject:dataArr forKey:@"sendPhoto"];
    [JP_NotificationCenter postNotificationName:SENDPHOTO object:nil userInfo:dict];
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

- (void)dealloc{
    
    [JP_NotificationCenter removeObserver:self name:SELECTPHOTO object:nil];
    [JP_NotificationCenter removeObserver:self name:SELECTPHOTO_REFRESH object:nil];
}
@end
