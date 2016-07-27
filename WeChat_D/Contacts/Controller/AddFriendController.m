//
//  AddFriendControllerViewController.m
//  WeChat_D
//
//  Created by Keep丶Dream on 16/7/20.
//  Copyright © 2016年 dongjiangpeng. All rights reserved.
//

#import "AddFriendController.h"

@interface AddFriendController ()<UITextFieldDelegate>

/** 好有名称 */
@property(nonatomic,strong) UITextField *friendNameText;

@end

@implementation AddFriendController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"添加好友";
    self.friendNameText = [[UITextField alloc]init];
    self.friendNameText.placeholder = @"请输入好友名称";
    self.friendNameText.layer.borderWidth = 1;
    self.friendNameText.layer.borderColor = [UIColor purpleColor].CGColor;
    self.friendNameText.layer.cornerRadius = 5;
    self.friendNameText.font = FONTSIZE(15);
    self.friendNameText.returnKeyType = UIReturnKeyDone;
    self.friendNameText.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.friendNameText.secureTextEntry = NO;
    self.friendNameText.delegate = self;
    
    [self.view addSubview:self.friendNameText];
    [self.friendNameText mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(KNAVHEIGHT+2*KMARGIN);
        make.left.offset(2*KMARGIN);
        make.right.offset(-2*KMARGIN);
        make.height.equalTo(@44);
    }];
    
    UIButton *addBtn = [[UIButton alloc]init];
    [addBtn setTitle:@"添加" forState:UIControlStateNormal];
    [addBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    addBtn.layer.borderWidth = 1;
    addBtn.layer.borderColor = [UIColor purpleColor].CGColor;
    addBtn.layer.cornerRadius = 5;
    [addBtn addTarget:self action:@selector(addBtn) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:addBtn];
    [addBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.friendNameText.mas_bottom).with.offset(2*KMARGIN);
        make.centerX.equalTo(self.friendNameText.mas_centerX);
        make.width.equalTo(@50);
    }];
    
}

- (void)addBtn{
    
    if (self.friendNameText.text.length == 0) {
        [self.view makeToast:@"请输入好友名称"];
        return;
    }
    [self.friendNameText resignFirstResponder];
    NSString *currentName = [EMClient sharedClient].currentUsername;
    UIAlertController *alertCtrl = [UIAlertController alertControllerWithTitle:@"打个招呼吧" message:nil preferredStyle:UIAlertControllerStyleAlert];
    [alertCtrl addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.text = [NSString stringWithFormat:@"我是%@",currentName];
    }];
    [alertCtrl addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
    [alertCtrl addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        //添加好友
        [SVProgressHUD show];
        [[EMClient sharedClient].contactManager asyncAddContact:self.friendNameText.text message:[alertCtrl.textFields objectAtIndex:0].text  success:^{
            dispatch_async(dispatch_get_main_queue(), ^{
                [SVProgressHUD showSuccessWithStatus:@"发送申请成功"];
            });
            
        } failure:^(EMError *aError) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [SVProgressHUD showSuccessWithStatus:@"发送申请失败"];
            });
        }];
        
    }]];
    [self presentViewController:alertCtrl animated:YES completion:nil];
    
}

//点击return键
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    [textField resignFirstResponder];
    [self addBtn];
    return YES;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    [self.view endEditing:YES];
}

@end
