//
//  AddMoreView.m
//  WeChat_D
//
//  Created by tztddong on 16/7/13.
//  Copyright © 2016年 dongjiangpeng. All rights reserved.
//

#import "AddMoreView.h"

#define BUTTON_TAG 20160713

@interface AddMoreView ()<UIScrollViewDelegate>

@property(nonatomic,strong)NSArray *dataArray;
@property(nonatomic,strong)UIScrollView *scrollView;
@property(nonatomic,strong)UIPageControl *pageControl;
@end

@implementation AddMoreView

- (instancetype)initWithFrame:(CGRect)frame data:(NSArray *)dataArray{
    
    self = [super initWithFrame:frame];
    if (self) {
        self.dataArray = dataArray;
        [self configViews];
    }
    return self;
}

#pragma mark 懒加载
- (NSArray *)dataArray{
    
    if (!_dataArray) {
        _dataArray = [[NSArray alloc]init];
//        _dataArray = [self.delegate dataOfMoreView:self];
    }
    return _dataArray;
}

- (UIScrollView *)scrollView{
    
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height-2*KMARGIN)];
        _scrollView.pagingEnabled = YES;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.delegate = self;
    }
    return _scrollView;
}

- (UIPageControl *)pageControl{
    
    if (!_pageControl) {
        _pageControl = [[UIPageControl alloc]initWithFrame:CGRectMake(0, self.frame.size.height-2*KMARGIN, self.frame.size.width, 2*KMARGIN)];
        _pageControl.currentPageIndicatorTintColor = [UIColor darkGrayColor];
        _pageControl.pageIndicatorTintColor = [UIColor lightGrayColor];
        _pageControl.hidesForSinglePage = YES;
    }
    return _pageControl;
}

#pragma mark 加载子view
- (void)configViews{
    
    CGFloat offsetX = (self.dataArray.count/8+1)*self.frame.size.width;
    self.scrollView.contentOffset = CGPointMake(0, 0);
    self.scrollView.contentSize = CGSizeMake(offsetX, self.frame.size.height-3*KMARGIN);
    self.pageControl.numberOfPages = self.dataArray.count/8+1;
    [self addSubview:self.scrollView];
    [self addSubview:self.pageControl];
    [self configButton];
}

- (void)configButton{
    
    NSInteger line_num = 4;//一行放几个图片
    NSInteger row_num = 2;//一共几行
    CGFloat left_padding = ScaleValueW(2*KMARGIN);//左右间距
    CGFloat top_padding = ScaleValueH(KMARGIN);//上下间距
    CGFloat button_padding = ScaleValueW(2*KMARGIN);//图片之间的间距
    CGFloat buttonW_H = (self.frame.size.width - (line_num+1)*left_padding)/line_num;//图片的宽高
    NSInteger count = self.dataArray.count;//总数
    
    for (int i = 0; i < count; i++) {
        //取出数据
        NSDictionary *dict = [self.dataArray objectAtIndex:i];
        UIButton *itemBtn = [[UIButton alloc]init];
        MoreViewButtonType type = i;
        itemBtn.tag = type;
        [itemBtn addTarget:self action:@selector(clickItemBtn:) forControlEvents:UIControlEventTouchUpInside];
        [itemBtn setImage:[UIImage imageNamed:[dict objectForKey:@"imageName"]] forState:UIControlStateNormal];
        [self.scrollView addSubview:itemBtn];
        
        NSInteger pageNum = i/(line_num*row_num);//计算当前图片应该在第几页显示  超过line_row行后会另起一页
        CGFloat row_left = i%line_num +line_num*pageNum;//当前图片在第几列
        CGFloat row_top = i/line_num - pageNum*row_num;//当前图片在第几行
        left_padding = ScaleValueW(2*KMARGIN)+ScaleValueW(pageNum*2*KMARGIN);

        CGFloat left = left_padding + row_left*(buttonW_H+button_padding);//计算X
        CGFloat top = top_padding + (self.scrollView.frame.size.height/2)*row_top;//计算Y
        [itemBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.height.equalTo(@(buttonW_H));
            make.left.offset(left);
            make.top.offset(top);
        }];
        
        UILabel *textLabel = [[UILabel alloc]init];
        textLabel.textAlignment = NSTextAlignmentCenter;
        textLabel.text = [dict objectForKey:@"title"];
        textLabel.font = FONTSIZE(10);
        textLabel.textColor = [UIColor blackColor];
        [self.scrollView addSubview:textLabel];
        [textLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(itemBtn.mas_bottom).with.offset(KMARGIN/2);
            make.left.equalTo(itemBtn.mas_left);
            make.right.equalTo(itemBtn.mas_right);
            make.height.equalTo(@(10));
        }];
    }

}

#pragma mark 点击按钮
- (void)clickItemBtn:(UIButton *)btn{
    
    NSInteger index = btn.tag;
    if ([self.delegate respondsToSelector:@selector(addMoreView:didSelectedItem:)]) {
        [self.delegate addMoreView:self didSelectedItem:index];
    }
}

#pragma mark UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    NSInteger currentIndex = scrollView.contentOffset.x / self.frame.size.width;
    self.pageControl.currentPage = currentIndex;
}

@end
