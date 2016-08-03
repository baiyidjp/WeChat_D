//
//  JPKeyBoardToolView.m
//  WeChat_D
//
//  Created by tztddong on 16/7/12.
//  Copyright © 2016年 dongjiangpeng. All rights reserved.
//

#import "JPKeyBoardToolView.h"
#import "AddMoreView.h"
#import "FaceView.h"
#import "FaceViewModel.h"
#import "MessageModel.h"
#import "Mp3recorder.h"
#import <Photos/Photos.h>
#import <AssetsLibrary/AssetsLibrary.h>

#define BackColor [UIColor colorWithRed:204.0/255.0f green:204.0/255.0f blue:204.0/255.0f alpha:1.0f]
@interface JPKeyBoardToolView ()<UITextViewDelegate,AddMoreViewDelegate,FaceViewDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate,Mp3RecorderDelegate>
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
/**
 *  加号view
 */
@property(nonatomic,strong)AddMoreView *addMoreView;
/**
 *  加号view的数据
 */
@property(nonatomic,strong)NSMutableArray *addMoreData;
/**
 *  表情View
 */
@property(nonatomic,strong)FaceView *faceView;
/**
 *  工具栏下面的高度
 */
@property(nonatomic,assign)CGFloat bottomHeight;
/**
 *  记录已经输入的文字或者表情
 */
@property(nonatomic,strong)NSString *inputText;
/**
 *  获取window的根控制器
 */
@property(nonatomic,strong)UIViewController *rootViewController;
/**
 *  记录已经输入的文本
 */
@property(nonatomic,strong)NSString *textViewtext;
/**
 *  录音管理
 */
@property(nonatomic,strong)Mp3Recorder *mp3Recorder;
/** 时间 */
@property(nonatomic,strong) NSTimer *timer;
/** 记录时间 */
@property(nonatomic,assign) NSInteger timerCount;
/**
 *  录音标示
 */
@property(nonatomic,strong)UIImageView *recordImage;
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
    [JP_NotificationCenter addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    [JP_NotificationCenter addObserver:self selector:@selector(keyboardWillChangeFrame:) name:UIKeyboardWillChangeFrameNotification object:nil];
    
    [self setNeedsUpdateConstraints];
    [self updateConstraintsIfNeeded];
    [self layoutIfNeeded];
}

#pragma mark 更新约束
- (void)updateConstraints{
    
    [self.recordBtn mas_updateConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.mas_centerY);
        make.left.offset(KMARGIN);
        make.width.equalTo(self.recordBtn.mas_height);
    }];
    
    [self.addMoreBtn mas_updateConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.mas_centerY);
        make.right.offset(-KMARGIN);
        make.width.equalTo(self.addMoreBtn.mas_height);
    }];
    
    [self.faceBtn mas_updateConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.mas_centerY);
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
        [_recordBtn setBackgroundImage:[UIImage imageNamed:@"ToolViewInputVoice_35x35_"] forState:UIControlStateNormal];
        [_recordBtn setBackgroundImage:[UIImage imageNamed:@"ToolViewKeyboard_35x35_"] forState:UIControlStateSelected];
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
        _recordLongBtn.layer.borderColor = BackColor.CGColor;
        _recordLongBtn.layer.borderWidth = .5f;
        _recordLongBtn.layer.masksToBounds = YES;
        _recordLongBtn.userInteractionEnabled = YES;
        UILongPressGestureRecognizer *longTap = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longTap:)];
        [_recordLongBtn addGestureRecognizer:longTap];
    }
    return _recordLongBtn;
}

- (UIButton *)faceBtn{
    
    if (!_faceBtn) {
        _faceBtn = [[UIButton alloc]init];
        _faceBtn.tag = ButtonType_Face;
        [_faceBtn setBackgroundImage:[UIImage imageNamed:@"ToolViewEmotion_35x35_"] forState:UIControlStateNormal];
        [_faceBtn setBackgroundImage:[UIImage imageNamed:@"ToolViewKeyboard_35x35_"] forState:UIControlStateSelected];
        [_faceBtn sizeToFit];
        [_faceBtn addTarget:self action:@selector(toolBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _faceBtn;
}

- (UIButton *)addMoreBtn{
    
    if (!_addMoreBtn) {
        _addMoreBtn = [[UIButton alloc]init];
        _addMoreBtn.tag = ButtonType_AddMore;
        [_addMoreBtn setBackgroundImage:[UIImage imageNamed:@"TypeSelectorBtn_Black_35x35_"] forState:UIControlStateNormal];
        [_addMoreBtn setBackgroundImage:[UIImage imageNamed:@"ToolViewKeyboard_35x35_"] forState:UIControlStateSelected];
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
        _inputTextView.layer.borderColor =BackColor.CGColor;
        _inputTextView.returnKeyType = UIReturnKeySend;
        _inputTextView.layer.borderWidth = .5f;
        _inputTextView.layer.masksToBounds = YES;
    }
    return _inputTextView;
}

- (UIViewController *)rootViewController{
    return [[UIApplication sharedApplication] keyWindow].rootViewController;
}

#pragma mark 懒加载功能view
- (NSMutableArray *)addMoreData{
    
    if (!_addMoreData) {
        _addMoreData = [NSMutableArray array];
        NSDictionary *dict1 = @{@"title":@"照片",@"imageName":@"sharemore_pic_59x59_"};
        NSDictionary *dict2 = @{@"title":@"拍摄",@"imageName":@"sharemore_video_59x59_"};
        NSDictionary *dict3 = @{@"title":@"小视频",@"imageName":@"sharemore_sight_60x60_"};
        NSDictionary *dict4 = @{@"title":@"语音聊天",@"imageName":@"sharemore_multitalk_59x59_"};
        NSDictionary *dict5 = @{@"title":@"红包",@"imageName":@"sharemore_pic_59x59_"};
        NSDictionary *dict6 = @{@"title":@"个人名片",@"imageName":@"sharemore_friendcard_59x59_"};
        NSDictionary *dict7 = @{@"title":@"位置",@"imageName":@"sharemore_location_59x59_"};
        NSDictionary *dict8 = @{@"title":@"收藏",@"imageName":@"sharemore_myfav_59x59_"};
        NSDictionary *dict9 = @{@"title":@"语音输入",@"imageName":@"sharemore_voiceinput_59x59_"};
        [_addMoreData addObject:dict1];
        [_addMoreData addObject:dict2];
        [_addMoreData addObject:dict3];
        [_addMoreData addObject:dict4];
        [_addMoreData addObject:dict5];
        [_addMoreData addObject:dict6];
        [_addMoreData addObject:dict7];
        [_addMoreData addObject:dict8];
        [_addMoreData addObject:dict9];
    }
    return _addMoreData;
}

- (AddMoreView *)addMoreView{
    
    if (!_addMoreView) {
        
        _addMoreView = [[AddMoreView alloc]initWithFrame:CGRectMake(0, self.superViewHeight, self.frame.size.width, KFACEVIEW_H) data:[self.addMoreData copy]];
        _addMoreView.delegate = self;
        _addMoreView.backgroundColor = self.backgroundColor;
    }
    return _addMoreView;
}

- (FaceView *)faceView{
    
    if (!_faceView) {
        _faceView = [[FaceView alloc]initWithFrame:CGRectMake(0, self.superViewHeight, self.frame.size.width, KFACEVIEW_H)];
        _faceView.delegate = self;
        _faceView.backgroundColor = self.backgroundColor;
    }
    return _faceView;
}

- (CGFloat)bottomHeight{
    
    if (self.faceView.superview || self.addMoreView.superview) {
        return MAX(self.keyBoardFrame.size.height, MAX(self.faceView.frame.size.height, self.addMoreView.frame.size.height));
    }else{
        return MAX(self.keyBoardFrame.size.height, CGFLOAT_MIN);
    }
}

- (Mp3Recorder *)mp3Recorder{
    
    if (!_mp3Recorder) {
        _mp3Recorder = [[Mp3Recorder alloc]initWithDelegate:self];
    }
    return _mp3Recorder;
}

- (UIImageView *)recordImage{
    
    if (!_recordImage) {
        _recordImage = [[UIImageView alloc]init];
        _recordImage.image = [UIImage imageNamed:@"VoiceSearchIcon_90x90_"];
        _recordImage.backgroundColor = [UIColor whiteColor];
    }
    return _recordImage;
}
#pragma mark 功能按钮的点击
- (void)toolBtnClicked:(UIButton *)toolBtn{
    
    ButtonType type = toolBtn.tag;
    toolBtn.selected = !toolBtn.selected;
    switch (type) {
        case ButtonType_Record:
            self.faceBtn.selected = NO;
            self.addMoreBtn.selected = NO;
            break;
        case ButtonType_Face:
            self.recordBtn.selected = NO;
            self.addMoreBtn.selected = NO;
            break;
        case ButtonType_AddMore:
            self.recordBtn.selected = NO;
            self.faceBtn.selected = NO;
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
    
    [self showMoreView:self.addMoreBtn.selected && type == ButtonType_AddMore];
    [self showFaceView:self.faceBtn.selected && type == ButtonType_Face];
    [self showRecordView:self.recordBtn.selected && type == ButtonType_Record];
    
    switch (type) {
        case ButtonType_None:
        {
            self.faceBtn.selected = self.addMoreBtn.selected = NO;
            [self.inputTextView resignFirstResponder];
            [self setFrame:CGRectMake(0, self.superViewHeight-KTOOLVIEW_MINH, KWIDTH, KTOOLVIEW_MINH) animated:YES];
        }
        case ButtonType_Record:
        {
            [self.inputTextView resignFirstResponder];
            [self setFrame:CGRectMake(0, self.superViewHeight-KTOOLVIEW_MINH, KWIDTH, KTOOLVIEW_MINH) animated:YES];
        }
            break;
        case ButtonType_Face:
        case ButtonType_AddMore:
        {
            [self setFrame:CGRectMake(0, self.superViewHeight-KTOOLVIEW_MINH-KFACEVIEW_H, KWIDTH, KTOOLVIEW_MINH) animated:YES];
            [self.inputTextView resignFirstResponder];
            [self textViewDidChange:self.inputTextView];
        }
            break;
        case ButtonType_KeyBoard:
        {
            [self textViewDidChange:self.inputTextView];
        }
            break;
        default:
            break;
    }
    
    
}

#pragma mark 显示或者隐藏功能view
- (void)showMoreView:(BOOL)show{
    
    if (show) {
        [self.superview addSubview:self.addMoreView];
        [UIView animateWithDuration:0.3 animations:^{
            [self.addMoreView setFrame:CGRectMake(0, self.superViewHeight-KFACEVIEW_H, self.frame.size.width, KFACEVIEW_H)];
        }];
    }else{
        [UIView animateWithDuration:0.3 animations:^{
            [self.addMoreView setFrame:CGRectMake(0, self.superViewHeight, self.frame.size.width, KFACEVIEW_H)];
        } completion:^(BOOL finished) {
            [self.addMoreView removeFromSuperview];
        }];
    }
}

- (void)showFaceView:(BOOL)show{
    
    if (show) {
        [self.superview addSubview:self.faceView];
        [UIView animateWithDuration:0.3 animations:^{
            [self.faceView setFrame:CGRectMake(0, self.superViewHeight-KFACEVIEW_H, self.frame.size.width, KFACEVIEW_H)];
        }];
    }else{
        [UIView animateWithDuration:0.3 animations:^{
            [self.faceView setFrame:CGRectMake(0, self.superViewHeight, self.frame.size.width, KFACEVIEW_H)];
        } completion:^(BOOL finished) {
            [self.faceView removeFromSuperview];
        }];
    }
}

- (void)showRecordView:(BOOL)show{
    
    self.recordLongBtn.hidden = !show;
    self.inputTextView.hidden = show;
}

#pragma mark AddMoreViewDelegate
//- (NSArray *)dataOfMoreView:(AddMoreView *)addMoreView{
//    
//    NSMutableArray *arr = [NSMutableArray array];
//    for (int i = 0; i < 2; i++) {
//        NSDictionary *dict1 = @{@"title":@"拍摄",@"imageName":@"chat_bar_icons_camera"};
//        NSDictionary *dict2 = @{@"title":@"照片",@"imageName":@"chat_bar_icons_pic"};
//        NSDictionary *dict3 = @{@"title":@"位置",@"imageName":@"chat_bar_icons_location"};
//        [arr addObject:dict1];
//        [arr addObject:dict2];
//        [arr addObject:dict3];
//    }
//    return [arr copy];
//}

- (void)addMoreView:(AddMoreView *)addMoreView didSelectedItem:(NSInteger)index{
    
    MoreViewButtonType type = index;
    NSLog(@"点击 %zd",type);
    /*
     MoreViewButtonType_Camera,//拍摄
     MoreViewButtonType_Photo,//照片
     MoreViewButtonType_Location,//位置
     MoreViewButtonType_Video,//视频
     MoreViewButtonType_VoiceChat,//语音聊天
     MoreViewButtonType_RedBag,//红包
     MoreViewButtonType_MineCard,//个人名片
     MoreViewButtonType_Collect,//收藏
     */
    switch (type) {
            
        case MoreViewButtonType_Photo:{
            UIImagePickerController *pickerC = [[UIImagePickerController alloc] init];
            pickerC.delegate = self;
            pickerC.editing = NO;
            [self.rootViewController presentViewController:pickerC animated:YES completion:nil];
        }
            break;
        case MoreViewButtonType_Camera:{
            UIImagePickerController *pickerC = [[UIImagePickerController alloc] init];
            pickerC.delegate = self;
            pickerC.sourceType = UIImagePickerControllerSourceTypeCamera;
            pickerC.editing = NO;
            [self.rootViewController presentViewController:pickerC animated:YES completion:nil];
        }
            break;
        case MoreViewButtonType_Location:
            
            break;
        case MoreViewButtonType_Video:
            
            break;
        case MoreViewButtonType_VoiceChat:
            
            break;
        case MoreViewButtonType_RedBag:
            
            break;
        case MoreViewButtonType_MineCard:
            
            break;
        case MoreViewButtonType_Collect:
            
            break;
            
        default:
            break;
    }
}

#pragma mark  FaceViewDelegate
- (void)faceView:(FaceView *)FaceView didSelectedItem:(FaceViewModel *)model{
    
    NSLog(@"点击 %@",model.face_name);
    NSString *face_name = model.face_name;
    self.inputTextView.text = [self.inputTextView.text stringByAppendingString:face_name];
    [self textViewDidChange:self.inputTextView];
}

- (void)didSelectDelectedItemOfFaceView:(FaceView *)faceView{
    
    NSLog(@"删除");
    [self textView:self.inputTextView shouldChangeTextInRange:NSMakeRange(self.inputTextView.text.length - 1, 1) replacementText:@""];
}

- (void)didSendItemOfFaceView:(FaceView *)faceView{
    
    NSLog(@"发送");
    [self textView:self.inputTextView shouldChangeTextInRange:NSMakeRange(self.inputTextView.text.length - 1, 1) replacementText:@"\n"];
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
    [self showRecordView:NO];
    [self showFaceView:NO];
    [self showMoreView:NO];
    return YES;
}

- (void)textViewDidChange:(UITextView *)textView{
    
    CGRect textViewFrame = self.inputTextView.frame;
    CGSize textSize = [self.inputTextView sizeThatFits:CGSizeMake(CGRectGetWidth(textViewFrame), 1000.0f)];//计算当前文字的宽高
    
    CGFloat offset = 10;
    textView.scrollEnabled = (textSize.height + 0.1 > KTOOLVIEW_MAXH-offset);//判断是否已经需要换行
    textViewFrame.size.height = MAX(KTOOLVIEW_MINH-offset, MIN(KTOOLVIEW_MAXH, textSize.height));//找出一个最大值最为高度
    
    CGRect addBarFrame = self.frame;
    addBarFrame.size.height = textViewFrame.size.height+offset;
    addBarFrame.origin.y = self.superViewHeight - self.bottomHeight - addBarFrame.size.height;
    [self setFrame:addBarFrame animated:NO];
    if (textView.scrollEnabled) {
        [textView scrollRangeToVisible:NSMakeRange(textView.text.length - 2, 1)];
    }
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    
    if ([text isEqualToString:@"\n"]) {
        //发送消息
        NSString *message = textView.text;
        EMTextMessageBody *body = [[EMTextMessageBody alloc] initWithText:message];
        NSString *from = [[EMClient sharedClient] currentUsername];
        //生成Message
        EMMessage *emmessage = [[EMMessage alloc]initWithConversationID:self.toUser from:from to:self.toUser body:body ext:nil];
        [self sendMessageWithMessage:emmessage];
        textView.text = nil;
        [self textViewDidChange:self.inputTextView];
        return NO;
    }else if (text.length == 0){//没有新增text 那就是删除text
        NSString *delectText = [textView.text substringWithRange:range];
        if ([delectText isEqualToString:@"]"]) {//匹配表情字符串
            NSUInteger rangeLocation = range.location;
            NSUInteger rangeLength = range.length;
            NSString *rangeText;
            while (1) {//创建一个无限循环 遍历当前之前的字符 直到有[]符合表情规则
                rangeLocation--;
                rangeLength++;
                rangeText = [textView.text substringWithRange:NSMakeRange(rangeLocation, rangeLength)];
                if ([rangeText hasPrefix:@"["] && [rangeText hasSuffix:@"]"]) {
                    break;
                }
            }
            textView.text = [textView.text stringByReplacingCharactersInRange:NSMakeRange(rangeLocation, rangeLength) withString:@""];
            [textView setSelectedRange:NSMakeRange(rangeLocation, 0)];//设置光标的位置
            [self textViewDidChange:self.inputTextView];
            return NO;
        }
    }

    
    return YES;
}

#pragma mark UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    //组装消息模型
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyyMMddHHmmss";
    NSString *str = [formatter stringFromDate:[NSDate date]];
    
    UIImage *orgImage = info[UIImagePickerControllerOriginalImage];
    NSData *data = UIImageJPEGRepresentation(orgImage, 1);
    NSData *thumdata = UIImageJPEGRepresentation(orgImage, 0.1);
    EMImageMessageBody *body = [[EMImageMessageBody alloc]initWithData:data displayName:@"image.png"];
#warning 如果此处不对图片进行本地保存 并且对消息体的本地路径和本地尺寸进行赋值 那么发送方在当前聊天界面便无法显示当前图片 因为环信在发送消息时并没有给用户返回路径 所以需要自己设置路径 这是一大坑!!!
    NSString *thumlocaImagePath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:[NSString stringWithFormat:@"thumimage_%@.png",str]];
    body.thumbnailLocalPath = thumlocaImagePath;
    body.thumbnailSize = [UIImage imageWithData:thumdata].size;
    body.compressRatio = 1.0;
    [thumdata writeToFile:thumlocaImagePath atomically:YES];
    NSString *from = [[EMClient sharedClient] currentUsername];
    //生成Message
    EMMessage *emmessage = [[EMMessage alloc]initWithConversationID:self.toUser from:from to:self.toUser body:body ext:nil];
    //发送消息
    [self sendMessageWithMessage:emmessage];
    [picker dismissViewControllerAnimated:YES completion:nil];
}
#pragma mark 键盘的通知方法
- (void)keyboardWillHide:(NSNotification *)notification{
    self.keyBoardFrame = CGRectZero;
    [self textViewDidChange:self.inputTextView];
}
- (void)keyboardWillChangeFrame:(NSNotification *)notification{
    self.keyBoardFrame = [notification.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    [self textViewDidChange:self.inputTextView];
}

#pragma mark 销毁时移除通知
- (void)dealloc{
    [JP_NotificationCenter removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    [JP_NotificationCenter removeObserver:self name:UIKeyboardWillChangeFrameNotification object:nil];
}

#pragma mark 结束编辑状态
- (void)endEditing{
    if (self.recordBtn.selected) {
        return;
    }
    [self showViewWithType:ButtonType_None];
}
#pragma mark 开始编辑
- (void)beginEditing{
    if (self.recordBtn.selected) {
        return;
    }
    [self.inputTextView becomeFirstResponder];
    [self showViewWithType:ButtonType_KeyBoard];

}

#pragma mark 长按录音
- (void)longTap:(UILongPressGestureRecognizer *)longTap{
    
    switch (longTap.state) {
        
        case UIGestureRecognizerStateBegan:{
            //开始录音
            [self.mp3Recorder startRecord];
            [self.timer setFireDate:[NSDate distantPast]];
            [self.superview addSubview:self.recordImage];
            self.recordImage.hidden = NO;
            [self.recordImage mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerX.equalTo(self.superview.mas_centerX);
                make.centerY.equalTo(self.superview.mas_centerY);
                make.size.mas_equalTo(CGSizeMake(90, 90));
            }];
            [self.recordLongBtn setBackgroundColor:[UIColor grayColor]];
        }
            break;
        case UIGestureRecognizerStateEnded:{
            //结束录音
            [self.mp3Recorder stopRecord];
            [self.recordLongBtn setBackgroundColor:[UIColor colorWithHexString:@"f4f4f4"]];
            [self.timer setFireDate:[NSDate distantFuture]];
            self.timerCount = 0;
            self.recordImage.hidden = YES;
            [self.recordImage removeFromSuperview];
        }
            break;
        default:
            break;
    }
}

#pragma mark 录音
- (NSTimer *)timer{
    
    if (!_timer) {
        
        _timer = [NSTimer scheduledTimerWithTimeInterval:0.2 target:self selector:@selector(updateSliderValue) userInfo:nil repeats:YES];
        [_timer setFireDate:[NSDate distantFuture]];
    }
    return _timer;
}

- (void)updateSliderValue{
    
    NSInteger progress = [self.mp3Recorder updateMeters];
    NSLog(@"%zd",progress);
    if (progress < 40) {
        self.recordImage.image = [UIImage imageNamed:[NSString stringWithFormat:@"VoiceSearchLoading0%.2zd_90x90_",progress/4+1]];
    }else if(progress > 40 && progress < 120){
        self.recordImage.image = [UIImage imageNamed:@"VoiceSearchLoading010_90x90_"];
    }else{
        self.recordImage.image = [UIImage imageNamed:[NSString stringWithFormat:@"VoiceSearchFeedback0%.2zd_90x90_",(progress-120)/2]];
    }
}

#pragma mark Mp3RecorderDelegate
- (void)failRecord{
    
    [self.superview makeToast:@"!录音时间太短!"];
}

- (void)endConvertWithMP3FileName:(NSString *)fileName recordTime:(NSInteger)recordTime{
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyyMMddHHmmss";
    NSString *str = [formatter stringFromDate:[NSDate date]];
    EMVoiceMessageBody *body = [[EMVoiceMessageBody alloc] initWithLocalPath:fileName displayName:[NSString stringWithFormat:@"voice_%@",str]];
    body.duration = (int)recordTime;
    NSString *from = [[EMClient sharedClient] currentUsername];
    // 生成message
    EMMessage *message = [[EMMessage alloc] initWithConversationID:self.toUser from:from to:self.toUser body:body ext:nil];
    [self sendMessageWithMessage:message];
}

#pragma mark 发送消息
- (void)sendMessageWithMessage:(EMMessage *)emmessage{
    emmessage.chatType = self.chatType;
    if ([self.delegate respondsToSelector:@selector(didSendMessageOfFaceView:message:)]) {
        [self.delegate didSendMessageOfFaceView:self message:emmessage];
    }
}
@end
