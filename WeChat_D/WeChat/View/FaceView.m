//
//  FaceView.m
//  WeChat_D
//
//  Created by tztddong on 16/7/13.
//  Copyright © 2016年 dongjiangpeng. All rights reserved.
//

#import "FaceView.h"
#import "FaceViewModel.h"

#define BTN_TAG 20160715
#define LASTEMOJI @"lastemoji"
@interface FaceView ()<UIScrollViewDelegate>
/**
 *  保存emoji表情
 */
@property(nonatomic,strong)NSMutableArray *dataArray;
/**
 *  保存最近使用的表情
 */
@property(nonatomic,strong)NSMutableArray *lastDataArray;
@property(nonatomic,strong)UIScrollView *scrollView;
@property(nonatomic,strong)UIPageControl *pageControl;

@end

@implementation FaceView
{
    NSInteger line_num;
    NSInteger row_num;
    CGFloat left_padding;
    CGFloat top_padding;
    CGFloat button_padding;
    CGFloat buttonW_H;
    NSInteger count;
    UIButton *emojiBtn;
    UIButton *lastBtn;
    NSInteger currentEmojiIndex;
}
- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        [self configViews];
    }
    return self;
}

#pragma mark 懒加载
- (NSMutableArray *)dataArray{
    
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
        _dataArray = [FaceViewModel mj_objectArrayWithFilename:@"face.plist"];
    }
    return _dataArray;
}

- (NSMutableArray *)lastDataArray{
    
    if (!_lastDataArray) {
        NSMutableArray *array = [[NSUserDefaults standardUserDefaults]objectForKey:LASTEMOJI];
        if (array.count) {
            _lastDataArray = [FaceViewModel mj_objectArrayWithKeyValuesArray:array];
        }else{
            _lastDataArray = [NSMutableArray array];
        }
    }
    return _lastDataArray;
}
- (UIScrollView *)scrollView{
    
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height-ScaleValueH(3*KMARGIN))];
        _scrollView.pagingEnabled = YES;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.delegate = self;
    }
    return _scrollView;
}

- (UIPageControl *)pageControl{
    
    if (!_pageControl) {
        _pageControl = [[UIPageControl alloc]initWithFrame:CGRectMake(0, self.frame.size.height-ScaleValueH(5*KMARGIN), self.frame.size.width, ScaleValueH(2*KMARGIN))];
        _pageControl.currentPageIndicatorTintColor = [UIColor darkGrayColor];
        _pageControl.pageIndicatorTintColor = [UIColor lightGrayColor];
        _pageControl.hidesForSinglePage = YES;
    }
    return _pageControl;
}

#pragma mark 加载子view
- (void)configViews{
    
    [self addSubview:self.scrollView];
    [self addSubview:self.pageControl];
    
    UIButton *sendBtn = [[UIButton alloc]init];
    [sendBtn setTitle:@"发送" forState:UIControlStateNormal];
    [sendBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [sendBtn setBackgroundColor:[UIColor whiteColor]];
    [sendBtn addTarget:self action:@selector(sendBtn) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:sendBtn];
    [sendBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.offset(-ScaleValueW(2*KMARGIN));
        make.bottom.offset(0);
        make.width.equalTo(@50);
    }];
    
    lastBtn = [[UIButton alloc]init];
    [lastBtn setTitle:@"最近" forState:UIControlStateNormal];
    [lastBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [lastBtn setTitleColor:[UIColor purpleColor] forState:UIControlStateSelected];
    [lastBtn setBackgroundColor:[UIColor whiteColor]];
    [lastBtn addTarget:self action:@selector(changeEmoji:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:lastBtn];
    [lastBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(ScaleValueW(2*KMARGIN));
        make.bottom.offset(0);
        make.width.equalTo(@50);
    }];
    emojiBtn = [[UIButton alloc]init];
    [emojiBtn setTitle:@"emoji" forState:UIControlStateNormal];
    [emojiBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [emojiBtn setTitleColor:[UIColor purpleColor] forState:UIControlStateSelected];
    [emojiBtn setBackgroundColor:[UIColor whiteColor]];
    [emojiBtn addTarget:self action:@selector(changeEmoji:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:emojiBtn];
    [emojiBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(lastBtn.mas_right).with.offset(2);
        make.bottom.offset(0);
        make.width.equalTo(@50);
    }];
    //改变表情分类
    [self changeEmoji:emojiBtn];
    
}
//这个方法是为了确定scrollview和pagecontroller的属性 scroll的滚动范围和page的页数 根据不同的分类调整
- (void)changeEmoji:(UIButton *)button{
    
    //先删除原有的button
    for (UIButton *btn in self.scrollView.subviews) {
        [btn removeFromSuperview];
    }
    line_num = 8;//一行放几个图片
    row_num = 3;//一共几行
    left_padding = ScaleValueW(2*KMARGIN);//左右间距
    top_padding = ScaleValueH(2*KMARGIN);//上下间距
    button_padding = ScaleValueW(KMARGIN);//图片之间的间距
    buttonW_H = (self.frame.size.width - 2*left_padding - (line_num-1)*button_padding)/line_num;//图片的宽高
    if (button == emojiBtn) {
        emojiBtn.selected = YES;
        lastBtn.selected = NO;
        count = self.dataArray.count;//总数
        self.scrollView.contentOffset = CGPointMake(currentEmojiIndex*self.frame.size.width, 0);
        CGFloat offsetX = (count/(line_num*row_num-1)+1)*self.frame.size.width; //每页的个数不再是行乘以列 需要减去一个 哪一个变为删除
        self.scrollView.contentSize = CGSizeMake(offsetX, self.frame.size.height-ScaleValueH(3*KMARGIN));
        self.pageControl.numberOfPages = count/(line_num*row_num-1)+1; //每页的个数不再是行乘以列 需要减去一个 哪一个变为删除
        self.pageControl.currentPage = currentEmojiIndex;//记录上次滚动的页数
    }else if (button == lastBtn){
        lastBtn.selected = YES;
        emojiBtn.selected = NO;
        count = self.lastDataArray.count;//总数
        self.scrollView.contentSize = CGSizeMake(self.frame.size.width, self.frame.size.height-ScaleValueH(3*KMARGIN));
        self.pageControl.numberOfPages = 1;
    }
    if (count){
        [self configButton];
    }
}

- (void)configButton{
    
    NSInteger j = 0;//记录按钮的实际位置 因为中间插入了删除 所以会使按钮的排序变化
    for (int i = 0; i < count; i++) {
        //取出数据
        FaceViewModel *model;
        if (emojiBtn.selected) {
            model = [self.dataArray objectAtIndex:i];
        }else if (lastBtn.selected){
            model = [self.lastDataArray objectAtIndex:count-1-i];
        }
        UIButton *itemBtn = [[UIButton alloc]init];
        itemBtn.tag = BTN_TAG+i;
        [itemBtn setBackgroundImage:[UIImage imageNamed:model.face_image_name] forState:UIControlStateNormal];
        [itemBtn addTarget:self action:@selector(clickFaceItemBtn:) forControlEvents:UIControlEventTouchUpInside];
        [self.scrollView addSubview:itemBtn];
        
        NSInteger pageNum = j/(line_num*row_num);//计算当前图片应该在第几页显示  超过line_row行后会另起一页 当前最后一个为删除按钮
        j = i+ pageNum;//翻页时候 由于第一个非正常本页的按钮 所以下标都应该根据页数变化 才能算出当前按钮所在的实际位置下标 (比如 当前是 i= 24 的按钮 占用的是 i=25 的按钮的位置 J变应该变成25)
        CGFloat row_left = j%line_num +line_num*pageNum;//当前图片在第几列
        CGFloat row_top = j/line_num - pageNum*row_num;//当前图片在第几行
        left_padding = ScaleValueW(2*KMARGIN)+ScaleValueW(pageNum*3*KMARGIN);
        CGFloat left = left_padding + row_left*(buttonW_H+button_padding);//计算X
        CGFloat top = top_padding + (buttonW_H+top_padding)*row_top;//计算Y
        itemBtn.frame = CGRectMake(left, top, buttonW_H, buttonW_H);
        if ((i+1+pageNum)%(line_num*row_num) == 0) {
            //此时是最后一个按钮 应该顺延到下一页 此按钮出应该放置一个删除
            
            UIButton *delectBtn = [[UIButton alloc]init];
            [delectBtn setBackgroundImage:[UIImage imageNamed:@"[删除]"] forState:UIControlStateNormal];
            [delectBtn addTarget:self action:@selector(clickDelectBtn) forControlEvents:UIControlEventTouchUpInside];
            delectBtn.frame = itemBtn.frame;
            [self.scrollView addSubview:delectBtn];
            
            //当前按钮顺延到下一页显示
            pageNum += 1;
            j = i+ pageNum;//此时按扭得实际位置下标(比如 当前是 i= 23 的按钮 翻页占用的是 i=24 的按钮的位置 J变应该变成24)
            CGFloat left_page =  ScaleValueW(2*KMARGIN)+self.frame.size.width*pageNum;
            itemBtn.frame = CGRectMake(left_page, top_padding, buttonW_H, buttonW_H);
        }
        
        //最后一个按钮加载完毕 在后面需要再加一个删除按钮
        if (i == count - 1) {
            NSInteger pageNum = j/(line_num*row_num);//计算当前图片应该在第几页显示  超过line_row行后会另起一页 当前最后一个为删除按钮
            j = count+ pageNum;//翻页时候 由于第一个非正常本页的按钮 所以下标都应该根据页数变化 才能算出当前按钮所在的实际位置下标 (比如 当前是 i= 24 的按钮 占用的是 i=25 的按钮的位置 J变应该变成25)
            CGFloat row_left = j%line_num +line_num*pageNum;//当前图片在第几列
            CGFloat row_top = j/line_num - pageNum*row_num;//当前图片在第几行
            left_padding = ScaleValueW(2*KMARGIN)+ScaleValueW(pageNum*3*KMARGIN);
            CGFloat left = left_padding + row_left*(buttonW_H+button_padding);//计算X
            CGFloat top = top_padding + (buttonW_H+top_padding)*row_top;//计算Y
            
            UIButton *delectBtn = [[UIButton alloc]init];
            [delectBtn setBackgroundImage:[UIImage imageNamed:@"[删除]"] forState:UIControlStateNormal];
            [delectBtn addTarget:self action:@selector(clickDelectBtn) forControlEvents:UIControlEventTouchUpInside];
            delectBtn.frame = CGRectMake(left, top, buttonW_H, buttonW_H);
            [self.scrollView addSubview:delectBtn];
        }
    }
    
}

#pragma mark 点击按钮
- (void)clickFaceItemBtn:(UIButton *)btn{
    
    NSInteger index = btn.tag - BTN_TAG;
    FaceViewModel *model;
    //取出数据需要区分点击是哪个分类里的
    if (lastBtn.selected) {
        model = [self.lastDataArray objectAtIndex:count-1-index];
    }else{
        model = [self.dataArray objectAtIndex:index];
    }
    if (self.lastDataArray.count == line_num*row_num-1) {//限制一页的数量
        [self.lastDataArray removeObjectAtIndex:0];
    }
    for (FaceViewModel *lastmodel in [self.lastDataArray copy]) {//遍历最近的表情 是否有重复的 有的话就删除点 并重新添加 为了排序
        if ([lastmodel.face_name isEqualToString:model.face_name]) {
            [self.lastDataArray removeObject:lastmodel];
        }
    }
    [self.lastDataArray addObject:model];
    NSArray *arr = [FaceViewModel mj_keyValuesArrayWithObjectArray:self.lastDataArray];
    [[NSUserDefaults standardUserDefaults] setObject:arr forKey:LASTEMOJI];//由于model不支持本地存储 所以转化为字典数组存储
    if (lastBtn.selected) {
        [self changeEmoji:lastBtn];
    }
    NSLog(@"%zd",self.lastDataArray.count);
    if ([self.delegate respondsToSelector:@selector(faceView:didSelectedItem:)]) {
        [self.delegate faceView:self didSelectedItem:model];
    }
}

- (void)clickDelectBtn{
    
    if ([self.delegate respondsToSelector:@selector(didSelectDelectedItemOfFaceView:)]) {
        [self.delegate didSelectDelectedItemOfFaceView:self];
    }
}

- (void)sendBtn{
    
    if ([self.delegate respondsToSelector:@selector(didSendItemOfFaceView:)]){
        [self.delegate didSendItemOfFaceView:self];
    }
}

#pragma mark UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    NSInteger currentIndex = scrollView.contentOffset.x / self.frame.size.width;
    self.pageControl.currentPage = currentIndex;
    if (emojiBtn.selected) {
        currentEmojiIndex = currentIndex;
    }
}


@end
