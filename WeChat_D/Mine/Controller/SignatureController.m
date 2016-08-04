//
//  SignatureController.m
//  WeChat_D
//
//  Created by Keep丶Dream on 16/8/4.
//  Copyright © 2016年 dongjiangpeng. All rights reserved.
//

#import "SignatureController.h"
#import "JPTextView.h"

@interface SignatureController ()<UITextViewDelegate>
/**
 *  确定按钮
 */
@property(nonatomic,strong) UIButton *doneBtn;
@property(nonatomic,strong) JPTextView *textView;
@end

@implementation SignatureController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIView *topBackView = [[UIView alloc]init];
    topBackView.backgroundColor = [UIColor colorWithRed:54/255.0 green:53/255.0 blue:58/255.0 alpha:1];
    [self.view addSubview:topBackView];
    [topBackView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.offset(0);
        make.height.equalTo(@(KNAVHEIGHT));
    }];
    UIButton *backBtn = [[UIButton alloc]init];
    [backBtn setTitle:@"取消" forState:UIControlStateNormal];
    [backBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [backBtn.titleLabel setFont:FONTSIZE(15)];
    [backBtn addTarget:self action:@selector(clickBackBtn) forControlEvents:UIControlEventTouchUpInside];
    [topBackView addSubview:backBtn];
    [backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(KMARGIN);
        make.centerY.equalTo(topBackView.mas_centerY).with.offset(KMARGIN);
    }];
    self.doneBtn = [[UIButton alloc]init];
    [self.doneBtn setTitle:@"确定" forState:UIControlStateNormal];
    [self.doneBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.doneBtn setTitleColor:[UIColor grayColor] forState:UIControlStateDisabled];
    [self.doneBtn.titleLabel setFont:FONTSIZE(15)];
    self.doneBtn.enabled = NO;
    [self.doneBtn addTarget:self action:@selector(clickDoneBtn) forControlEvents:UIControlEventTouchUpInside];
    [topBackView addSubview:self.doneBtn];
    [self.doneBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.offset(-KMARGIN);
        make.centerY.equalTo(topBackView.mas_centerY).with.offset(KMARGIN);
    }];
    UILabel *titleL = [[UILabel alloc]init];
    titleL.text = @"个性签名";
    titleL.textColor = [UIColor whiteColor];
    [topBackView addSubview:titleL];
    [titleL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(topBackView.mas_centerX);
        make.centerY.equalTo(topBackView.mas_centerY).with.offset(KMARGIN);
    }];
    
    JPTextView *textView = [[JPTextView alloc]initWithFrame:CGRectMake(0, KMARGIN+KNAVHEIGHT, KWIDTH, ScaleValueH(100))];
    self.textView = textView;
    textView.backgroundColor = [UIColor whiteColor];
    textView.fontNum = 15;
    textView.placeholder = @"请输入个性签名";
    textView.wordNum = 30;
    textView.delegate = self;
    textView.returnKeyType = UIReturnKeyDone;
    textView.text = self.signText;
    textView.placeLabel.hidden = self.signText.length;
    textView.numLabel.text = [NSString stringWithFormat:@"%zd",30-self.signText.length];
    [self.view addSubview:textView];
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    
    self.doneBtn.enabled = YES;
    if (range.location > 30 - 1) {
        [self.view makeToast:@"最多输入30字"];
        return NO;
    }
    if ([text isEqualToString:@"\n"]) {
        [self.textView resignFirstResponder];
        return NO;
    }

    return YES;
}

- (void)textViewDidChange:(UITextView *)textView{
    
    if ([textView.text isEqualToString:self.signText]) {
        self.doneBtn.enabled = NO;
    }
}

- (BOOL)textViewShouldEndEditing:(UITextView *)textView{
    
    if ([textView.text isEqualToString:self.signText]) {
        self.doneBtn.enabled = NO;
    }
    return YES;
}


- (void)clickBackBtn{
    
    [self.textView resignFirstResponder];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)clickDoneBtn{
    
    [self.textView resignFirstResponder];
    NSDictionary *dict = [NSDictionary dictionaryWithObject:self.textView.text forKey:CHANGEINFO_KEY];
    [JP_NotificationCenter postNotificationName:CHANGESIGNSUCCESS object:nil userInfo:dict];
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
