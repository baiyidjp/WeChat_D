//
//  JPKeyBoardToolView.m
//  WeChat_D
//
//  Created by tztddong on 16/7/12.
//  Copyright © 2016年 dongjiangpeng. All rights reserved.
//

#import "JPKeyBoardToolView.h"

@interface JPKeyBoardToolView ()<UITextViewDelegate>
/**
 *  左边录音按钮
 */
@property(nonatomic,strong)UIButton *recordBtn;
/**
 *  按住录音按钮
 */
@property(nonatomic,strong)UIButton *recordLongBtn;
/**
 *  表情按钮
 */
@property(nonatomic,strong)UIButton *faceBtn;
/**
 *  加号按钮
 */
@property(nonatomic,strong)UIButton *addMoreBtn;
/**
 *  输入框
 */
@property(nonatomic,strong)UITextView *inputTextView;
/**
 *  键盘的frame
 */
@property(nonatomic,assign)CGRect keyBoardFrame;
@end

@implementation JPKeyBoardToolView

- (instancetype)initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor colorWithHexString:@"f4f4f4"];
        [self configViews];
    }
    return self;
}

#pragma mark 加载子控件
- (void)configViews{
    
    [self addSubview:self.recordBtn];
    [self addSubview:self.faceBtn];
    [self addSubview:self.addMoreBtn];
    [self addSubview:self.inputTextView];
    [self addSubview:self.recordLongBtn];
    
#pragma mark 添加键盘出现与消失的通知
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWillChangeFrame:) name:UIKeyboardWillChangeFrameNotification object:nil];
    
    [self setNeedsUpdateConstraints];
    [self updateConstraintsIfNeeded];
    [self layoutIfNeeded];
}

#pragma mark 更新约束
- (void)updateConstraints{
    
    [self.recordBtn mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.left.offset(KMARGIN);
        make.width.equalTo(self.recordBtn.mas_height);
    }];
    
    [self.addMoreBtn mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.offset(KMARGIN);
        make.right.offset(-KMARGIN);
        make.width.equalTo(self.addMoreBtn.mas_height);
    }];
    
    [self.faceBtn mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.offset(KMARGIN);
        make.right.equalTo(self.addMoreBtn.mas_left).with.offset(-KMARGIN);
        make.width.equalTo(self.faceBtn.mas_height);
    }];
    
    [self.inputTextView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.offset(KMARGIN/2);
        make.bottom.offset(-KMARGIN/2);
        make.left.equalTo(self.recordBtn.mas_right).with.offset(KMARGIN);
        make.right.equalTo(self.faceBtn.mas_left).with.offset(-KMARGIN);
    }];
    
    [self.recordLongBtn mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.offset(KMARGIN/2);
        make.bottom.offset(-KMARGIN/2);
        make.left.equalTo(self.recordBtn.mas_right).with.offset(KMARGIN);
        make.right.equalTo(self.faceBtn.mas_left).with.offset(-KMARGIN);
    }];
    
    [super updateConstraints];
}
#pragma mark 懒加载工具栏的控件
- (UIButton *)recordBtn{
    
    if (!_recordBtn) {
        _recordBtn = [[UIButton alloc]init];
        _recordBtn.tag = ButtonType_Record;
        [_recordBtn setBackgroundImage:[UIImage imageNamed:@"chat_bar_voice_normal"] forState:UIControlStateNormal];
        [_recordBtn setBackgroundImage:[UIImage imageNamed:@"chat_bar_input_normal"] forState:UIControlStateSelected];
        [_recordBtn sizeToFit];
        [_recordBtn addTarget:self action:@selector(toolBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _recordBtn;
}

- (UIButton *)recordLongBtn{
    
    if (!_recordLongBtn) {
        _recordLongBtn = [[UIButton alloc]init];
        _recordLongBtn.tag = ButtonType_RecordLong;
        [_recordLongBtn setTitle:@"按住 说话" forState:UIControlStateNormal];
        [_recordLongBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        _recordLongBtn.titleLabel.font = FONTSIZE(16);
        _recordLongBtn.hidden = YES;
        _recordLongBtn.layer.cornerRadius = 4.0f;
        _recordLongBtn.layer.borderColor = [UIColor colorWithRed:204.0/255.0f green:204.0/255.0f blue:204.0/255.0f alpha:1.0f].CGColor;
        _recordLongBtn.layer.borderWidth = .5f;
        _recordLongBtn.layer.masksToBounds = YES;
    }
    return _recordLongBtn;
}

- (UIButton *)faceBtn{
    
    if (!_faceBtn) {
        _faceBtn = [[UIButton alloc]init];
        _faceBtn.tag = ButtonType_Face;
        [_faceBtn setBackgroundImage:[UIImage imageNamed:@"chat_bar_face_normal"] forState:UIControlStateNormal];
        [_faceBtn setBackgroundImage:[UIImage imageNamed:@"chat_bar_input_normal"] forState:UIControlStateSelected];
        [_faceBtn sizeToFit];
        [_faceBtn addTarget:self action:@selector(toolBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _faceBtn;
}

- (UIButton *)addMoreBtn{
    
    if (!_addMoreBtn) {
        _addMoreBtn = [[UIButton alloc]init];
        _addMoreBtn.tag = ButtonType_AddMore;
        [_addMoreBtn setBackgroundImage:[UIImage imageNamed:@"chat_bar_more_normal"] forState:UIControlStateNormal];
        [_addMoreBtn setBackgroundImage:[UIImage imageNamed:@"chat_bar_input_normal"] forState:UIControlStateSelected];
        [_addMoreBtn sizeToFit];
        [_addMoreBtn addTarget:self action:@selector(toolBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _addMoreBtn;
}

- (UITextView *)inputTextView{
    
    if (!_inputTextView) {
        _inputTextView = [[UITextView alloc]init];
        _inputTextView.font = FONTSIZE(16);
        _inputTextView.delegate = self;
        _inputTextView.layer.cornerRadius = 4.0f;
        _inputTextView.layer.borderColor = [UIColor colorWithRed:204.0/255.0f green:204.0/255.0f blue:204.0/255.0f alpha:1.0f].CGColor;
        _inputTextView.returnKeyType = UIReturnKeySend;
        _inputTextView.layer.borderWidth = .5f;
        _inputTextView.layer.masksToBounds = YES;
    }
    return _inputTextView;
}

#pragma mark 功能按钮的点击
- (void)toolBtnClicked:(UIButton *)toolBtn{
    
    ButtonType type = toolBtn.tag;
    toolBtn.selected = !toolBtn.selected;
    switch (type) {
        case ButtonType_Record:
            self.faceBtn.selected = NO;
            self.addMoreBtn.selected = NO;
            self.recordLongBtn.hidden = !toolBtn.selected;
            self.inputTextView.hidden = toolBtn.selected;
            break;
        case ButtonType_Face:
            self.recordBtn.selected = NO;
            self.addMoreBtn.selected = NO;
            self.recordLongBtn.hidden = YES;
            self.inputTextView.hidden = NO;
            break;
        case ButtonType_AddMore:
            self.recordBtn.selected = NO;
            self.faceBtn.selected = NO;
            self.recordLongBtn.hidden = YES;
            self.inputTextView.hidden = NO;
            break;
        default:
            break;
    }
    //如果按钮的selected是NO 说明没有一个按钮是在被点击的状态 此时应该显示键盘
    if (!toolBtn.selected) {
        type = ButtonType_KeyBoard;
        [self.inputTextView becomeFirstResponder];
    }
    
    [self showViewWithType:type];
}

#pragma mark 需要显示的view 一级toolView的frame设置
- (void)showViewWithType:(ButtonType)type{
    
    switch (type) {
        case ButtonType_None:
        case ButtonType_Record:
        {
            [self.inputTextView resignFirstResponder];
            [self setFrame:CGRectMake(0, self.superViewHeight-KTOOLVIEW_MINH, KWIDTH, KTOOLVIEW_MINH) animated:YES];
        }
            break;
        case ButtonType_Face:
        case ButtonType_AddMore:
        {
            [self.inputTextView resignFirstResponder];
            [self setFrame:CGRectMake(0, self.superViewHeight-KTOOLVIEW_MINH-200, KWIDTH, KTOOLVIEW_MINH) animated:YES];
        }
            break;
        case ButtonType_KeyBoard:
        {
            [self setFrame:CGRectMake(0, self.superViewHeight-KTOOLVIEW_MINH-self.keyBoardFrame.size.height, KWIDTH, KTOOLVIEW_MINH) animated:NO];
        }
            break;
        default:
            break;
    }
}

#pragma mark 改变toolview的frame
- (void)setFrame:(CGRect)frame animated:(BOOL)animated{
    if (animated) {
        [UIView animateWithDuration:0.3 animations:^{
            [self setFrame:frame];
        }];
    }else{
        [self setFrame:frame];
    }
    
    if ([self.delegate respondsToSelector:@selector(keyBoardToolViewFrameDidChange:frame:)]) {
        [self.delegate keyBoardToolViewFrameDidChange:self frame:frame];
    }
}

#pragma mark UITextViewDelegate
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView{
    
    self.recordBtn.selected = self.faceBtn.selected = self.addMoreBtn.selected = NO;
    [self showViewWithType:ButtonType_KeyBoard];
    return YES;
}

#pragma mark 键盘的通知方法
- (void)keyboardWillHide:(NSNotification *)notification{
    self.keyBoardFrame = CGRectZero;
    [self showViewWithType:ButtonType_KeyBoard];
}
- (void)keyboardWillChangeFrame:(NSNotification *)notification{
    self.keyBoardFrame = [notification.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    [self showViewWithType:ButtonType_KeyBoard];
}

#pragma mark 销毁时移除通知
- (void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:UIKeyboardWillChangeFrameNotification object:nil];
}

@end
