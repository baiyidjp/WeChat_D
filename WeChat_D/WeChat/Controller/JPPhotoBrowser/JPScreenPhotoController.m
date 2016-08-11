//
//  JPScreenPhotoController.m
//  WeChat_D
//
//  Created by tztddong on 16/8/11.
//  Copyright © 2016年 dongjiangpeng. All rights reserved.
//

#import "JPScreenPhotoController.h"
#import "JPPhotoModel.h"
#import "JPPhotoCollectionLayout.h"

#define PHOTOCELL_ID @"UICollectionViewCell"
@interface JPScreenPhotoController ()<UICollectionViewDelegate,UICollectionViewDataSource>

@end

@implementation JPScreenPhotoController
{
    UIView *topView;
    UIView *bottomView;
    UIButton *backBtn;
    UIButton *selectBtn;
    UIButton *sendBtn;
    UILabel *countLabel;
    UIButton *roundBtn;
    UILabel *fullImageLabel;
    UILabel *dataLabel;
    BOOL isHiddenView;
    BOOL isShowFullImage;
    UICollectionView *photoCollectionView;
    NSInteger currentCount;
}

- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setHidden:YES];
}

- (void)viewWillDisappear:(BOOL)animated{
    
    [super viewWillDisappear:animated];
    [self.navigationController.navigationBar setHidden:NO];
}

- (BOOL)prefersStatusBarHidden{
    
    return YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    JPPhotoCollectionLayout *layout = [[JPPhotoCollectionLayout alloc]init];
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    layout.itemSize = CGSizeMake(KWIDTH+KMARGIN*2, KHEIGHT);
    layout.minimumInteritemSpacing = 0;
    layout.minimumLineSpacing = 0;
    photoCollectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, KWIDTH+KMARGIN*2, KHEIGHT) collectionViewLayout:layout];
    photoCollectionView.delegate = self;
    photoCollectionView.dataSource = self;
    photoCollectionView.pagingEnabled = YES;
    photoCollectionView.backgroundColor = [UIColor blackColor];
    photoCollectionView.showsHorizontalScrollIndicator = NO;
    [photoCollectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:PHOTOCELL_ID];
    [self.view addSubview:photoCollectionView];
    
    topView = [[UIView alloc]init];
    topView.backgroundColor = [UIColor blackColor];
    topView.alpha = 0.9;
    [self.view addSubview:topView];
    
    backBtn = [[UIButton alloc]init];
    [backBtn setBackgroundImage:[UIImage imageNamed:@"barbuttonicon_back_15x30_"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(backToList) forControlEvents:UIControlEventTouchUpInside];
    [topView addSubview:backBtn];
    
    selectBtn = [[UIButton alloc]init];
    [selectBtn setBackgroundImage:[UIImage imageNamed:@"FriendsSendsPicturesSelectBigNIcon_42x42_"] forState:UIControlStateNormal];
    [selectBtn setBackgroundImage:[UIImage imageNamed:@"FriendsSendsPicturesSelectBigYIcon_42x42_"] forState:UIControlStateSelected];
    [selectBtn addTarget:self action:@selector(clickSelectBtn) forControlEvents:UIControlEventTouchUpInside];
    [topView addSubview:selectBtn];
    
    bottomView = [[UIView alloc]init];
    bottomView.backgroundColor = [UIColor blackColor];
    bottomView.alpha = 0.9;
    [self.view addSubview:bottomView];
    
    sendBtn = [[UIButton alloc]init];
    [sendBtn setTitle:@"发送" forState:UIControlStateNormal];
    [sendBtn setTitleColor:[UIColor greenColor] forState:UIControlStateNormal];
    [sendBtn setTitleColor:[UIColor colorWithRed:0.000 green:0.411 blue:0.000 alpha:1.000] forState:UIControlStateDisabled];
    [sendBtn.titleLabel setFont:FONTSIZE(15)];
    [sendBtn addTarget:self action:@selector(sendPhoto) forControlEvents:UIControlEventTouchUpInside];
    sendBtn.enabled = self.selectPhotoCount;
    [bottomView addSubview:sendBtn];
    
    countLabel = [[UILabel alloc]init];
    countLabel.backgroundColor = [UIColor greenColor];
    countLabel.textColor = [UIColor whiteColor];
    countLabel.textAlignment = NSTextAlignmentCenter;
    countLabel.font = FONTSIZE(15);
    countLabel.layer.cornerRadius = 10;
    countLabel.layer.masksToBounds = YES;
    countLabel.hidden = !self.selectPhotoCount;
    [bottomView addSubview:countLabel];
    
    roundBtn = [[UIButton alloc]init];
    [roundBtn setBackgroundColor:bottomView.backgroundColor];
    roundBtn.layer.cornerRadius = 10;
    roundBtn.layer.borderColor = [UIColor colorWithRed:0.5416 green:0.5416 blue:0.5416 alpha:1.0].CGColor;
    roundBtn.layer.borderWidth = 1;
    roundBtn.layer.masksToBounds = YES;
    [roundBtn addTarget:self action:@selector(clickRound:) forControlEvents:UIControlEventTouchUpInside];
    [bottomView addSubview:roundBtn];
    
    fullImageLabel = [[UILabel alloc]init];
    fullImageLabel.text = @"原图";
    fullImageLabel.textColor = [UIColor colorWithRed:0.5416 green:0.5416 blue:0.5416 alpha:1.0];
    fullImageLabel.font = FONTSIZE(13);
    [bottomView addSubview:fullImageLabel];
    
    dataLabel = [[UILabel alloc]init];
    dataLabel.textColor = [UIColor whiteColor];
    dataLabel.font = FONTSIZE(13);
    dataLabel.hidden = YES;
    [bottomView addSubview:dataLabel];
    
    [self.view setNeedsUpdateConstraints];
    //检测这个view是否有约束需要更新 如果有在调用下面的方法 更新约束
    [self.view updateConstraintsIfNeeded];
    [self.view layoutIfNeeded];
    
    //当前所在图片的下标
    currentCount = self.currentIndexPath.item;
    [photoCollectionView scrollToItemAtIndexPath:self.currentIndexPath atScrollPosition:0 animated:NO];
    [self changeBottomViewState];
    [JP_NotificationCenter addObserver:self selector:@selector(selectPhoto:) name:SELECTPHOTO object:nil];
}

- (void)selectPhoto:(NSNotification *)notification{
    
    NSDictionary *dict = notification.userInfo;
    if ([[dict objectForKey:@"isSelect"] integerValue]) {
        self.selectPhotoCount++;
    }else{
        self.selectPhotoCount--;
    }
    [self changeBottomViewState];
}


#pragma mark 改变约束
- (void)updateViewConstraints{
    
    [topView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.offset(0);
        make.height.equalTo(@(KNAVHEIGHT));
        if (isHiddenView) {
            make.top.offset(-KNAVHEIGHT);
        }else{
            make.top.offset(0);
        }
    }];
    
    [backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(KMARGIN);
        make.centerY.equalTo(topView);
    }];
    
    [selectBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.offset(-KMARGIN);
        make.centerY.equalTo(topView);
        make.size.mas_equalTo(CGSizeMake(42, 42));
    }];
    
    [bottomView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.offset(0);
        make.height.equalTo(@(44));
        if (isHiddenView) {
            make.bottom.offset(44);
        }else{
            make.bottom.offset(0);
        }
    }];
    
    [sendBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.offset(-KMARGIN);
        make.centerY.equalTo(bottomView);
    }];
    [countLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(sendBtn.mas_left).with.offset(-KMARGIN/2);
        make.centerY.equalTo(bottomView);
        make.size.mas_equalTo(CGSizeMake(20, 20));
    }];
    
    [roundBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(KMARGIN);
        make.centerY.equalTo(bottomView);
        make.size.mas_equalTo(CGSizeMake(20, 20));
    }];
    [fullImageLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(roundBtn.mas_right).with.offset(KMARGIN/2);
        make.centerY.equalTo(bottomView);
    }];
    [dataLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(fullImageLabel.mas_right);
        make.centerY.equalTo(bottomView);
    }];
    
    [super updateViewConstraints];
}

- (void)backToList{
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)clickSelectBtn{
    
    NSLog(@"%zd",currentCount);
    JPPhotoModel *photoModel = [self.photoDataArray objectAtIndex:currentCount];
    photoModel.isSelect = !photoModel.isSelect;
    if (photoModel.isSelect && self.selectPhotoCount == 9) {
        photoModel.isSelect = NO;
        UIAlertController *alertCtrl = [UIAlertController alertControllerWithTitle:@"最多选择九张图片" message:nil preferredStyle:UIAlertControllerStyleAlert];
        [alertCtrl addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:nil]];
        [self presentViewController:alertCtrl animated:YES completion:nil];
    }else{
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:currentCount inSection:0];
        [photoCollectionView reloadItemsAtIndexPaths:@[indexPath]];
        [JP_NotificationCenter postNotificationName:SELECTPHOTO object:nil userInfo:@{@"isSelect":photoModel.isSelect?@"1":@"0"}];
        [JP_NotificationCenter postNotificationName:SELECTPHOTO_REFRESH object:nil userInfo:@{@"indexPath":photoModel.indexPath}];
    }

}

- (void)clickRound:(UIButton *)btn{

    btn.selected = !btn.selected;
    JPPhotoModel *photoModel = [self.photoDataArray objectAtIndex:currentCount];
    photoModel.isShowFullImage = btn.selected;
    if (btn.selected) {
        [roundBtn setBackgroundColor:[UIColor greenColor]];
        fullImageLabel.textColor = [UIColor whiteColor];
        dataLabel.hidden = NO;
    }else{
        [roundBtn setBackgroundColor:bottomView.backgroundColor];
        fullImageLabel.textColor = [UIColor colorWithRed:0.5416 green:0.5416 blue:0.5416 alpha:1.0];
        dataLabel.hidden = YES;
    }
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

#pragma mark UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    return self.photoDataArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:PHOTOCELL_ID forIndexPath:indexPath];
    JPPhotoModel *photoModel = [self.photoDataArray objectAtIndex:indexPath.item];
    UIImageView *photoImage = [[UIImageView alloc]init];
    photoImage.contentMode = UIViewContentModeScaleAspectFit;
    photoImage.image = photoModel.fullScreenImage;
    [cell.contentView addSubview:photoImage];
    [photoImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(cell.contentView);
        make.left.offset(0);
        make.size.mas_equalTo(CGSizeMake(KWIDTH, KHEIGHT));
    }];
    selectBtn.selected = photoModel.isSelect;
    selectBtn.hidden = photoModel.isVideoType;
    dataLabel.text = [NSString stringWithFormat:@"(%.1fM)",photoModel.fullResolutionImageData];
    return cell;
}

#pragma mark UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    isHiddenView = !isHiddenView;
    [self.view setNeedsUpdateConstraints];
    //检测这个view是否有约束需要更新 如果有在调用下面的方法 更新约束
    [self.view updateConstraintsIfNeeded];
    [self.view layoutIfNeeded];
    
}

- (void)collectionView:(UICollectionView *)collectionView didEndDisplayingCell:(nonnull UICollectionViewCell *)cell forItemAtIndexPath:(nonnull NSIndexPath *)indexPath{
    
    if (cell.contentView.subviews.count) {
        for (UIView *view in cell.contentView.subviews) {
            [view removeFromSuperview];
        }
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{

    currentCount = scrollView.contentOffset.x/(KWIDTH+2*KMARGIN);
    if (currentCount < 0 ||currentCount > self.photoDataArray.count-1) {
        return;
    }
}

#pragma mark 点击图片后 改变状态
- (void)changeBottomViewState{
    
    if (self.selectPhotoCount) {
        sendBtn.enabled = YES;
        countLabel.hidden = NO;
        countLabel.text = [NSString stringWithFormat:@"%zd",self.selectPhotoCount];
    }else{
        sendBtn.enabled = NO;
        countLabel.hidden = YES;
        
    }
    
}
@end
