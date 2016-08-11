//
//  JPPhotoCollectionLayout.m
//  WeChat_D
//
//  Created by tztddong on 16/8/11.
//  Copyright © 2016年 dongjiangpeng. All rights reserved.
//

#import "JPPhotoCollectionLayout.h"

@implementation JPPhotoCollectionLayout
{
    CGFloat ItemW;
    CGFloat ItemH;
}
- (void)prepareLayout{
    
    [super prepareLayout];
    
    ItemW = self.collectionView.frame.size.width;
    ItemH = self.collectionView.frame.size.height;
    //水平滚动
    self.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    self.itemSize = CGSizeMake(ItemW+KMARGIN, ItemH);
    self.minimumInteritemSpacing = 0;
}

- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds{
    
    return YES;
}

//proposedContentOffset是没有对齐到网格时本来应该停下的位置
- (CGPoint)targetContentOffsetForProposedContentOffset:(CGPoint)proposedContentOffset withScrollingVelocity:(CGPoint)velocity{
    
    
    CGFloat offsetAdjustment = MAXFLOAT;
    
    //CGRectGetWidth: 返回矩形的宽度
    CGFloat horizontalCenter = proposedContentOffset.x + (CGRectGetWidth(self.collectionView.bounds) / 2.0);
    
    //当前rect
    CGRect targetRect = CGRectMake(proposedContentOffset.x, 0, self.collectionView.bounds.size.width, self.collectionView.bounds.size.height);
    
    NSArray* array = [super layoutAttributesForElementsInRect:targetRect];
    //对当前屏幕中的UICollectionViewLayoutAttributes逐个与屏幕中心进行比较，找出最接近中心的一个
    for (UICollectionViewLayoutAttributes* layoutAttributes in array)
    {
        CGFloat itemHorizontalCenter = layoutAttributes.center.x;
        if (ABS(itemHorizontalCenter - horizontalCenter) < ABS(offsetAdjustment))
        {
            //与中心的位移差
            offsetAdjustment = itemHorizontalCenter - horizontalCenter;
        }
    }
    //返回修改后停下的位置
    return CGPointMake(proposedContentOffset.x + offsetAdjustment, proposedContentOffset.y);
}


@end
