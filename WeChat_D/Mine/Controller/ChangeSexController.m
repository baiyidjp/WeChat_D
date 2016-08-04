//
//  ChangeSexController.m
//  WeChat_D
//
//  Created by Keep丶Dream on 16/8/4.
//  Copyright © 2016年 dongjiangpeng. All rights reserved.
//

#import "ChangeSexController.h"

typedef enum : NSUInteger {
    SexButtonType_None,
    SexButtonType_Man,
    SexButtonType_Woman,
} SexButtonType;

@interface ChangeSexController ()

/** 对号button的集合 */
@property(nonatomic,strong) NSMutableArray *buttonArray;

@end

@implementation ChangeSexController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"性别";
    
    UIButton *backView1 = [[UIButton alloc]init];
    backView1.tag = SexButtonType_Man;
    [backView1 setBackgroundColor:[UIColor whiteColor]];
    [backView1 addTarget:self action:@selector(chooseSex:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backView1];
    [backView1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(KMARGIN+KNAVHEIGHT);
        make.left.right.offset(0);
        make.height.equalTo(@45);
    }];
    
    UIView *lineView = [[UIView alloc]init];
    lineView.backgroundColor = [UIColor colorWithHexString:@"f4f4f4"];
    [backView1 addSubview:lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.offset(0);
        make.left.offset(KMARGIN);
        make.bottom.equalTo(backView1.mas_bottom);
        make.height.equalTo(@1);
    }];
    
    UILabel *sexLabel1 = [[UILabel alloc]init];
    sexLabel1.text = @"男";
    [backView1 addSubview:sexLabel1];
    [sexLabel1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(KMARGIN);
        make.top.bottom.offset(0);
    }];
    
    UIImageView *chooseImage1 = [[UIImageView alloc]init];
    [chooseImage1 setImage:[UIImage imageNamed:@"watch-yo-checked_28x28_"]];
    [backView1 addSubview:chooseImage1];
    [chooseImage1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(14, 14));
        make.centerY.equalTo(backView1.mas_centerY);
        make.right.offset(-KMARGIN);
    }];
    
    UIButton *backView2 = [[UIButton alloc]init];
    backView2.tag = SexButtonType_Woman;
    [backView2 setBackgroundColor:[UIColor whiteColor]];
    [backView2 addTarget:self action:@selector(chooseSex:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backView2];
    [backView2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(backView1.mas_bottom);
        make.left.right.offset(0);
        make.height.equalTo(@44);
    }];
    
    UILabel *sexLabel2 = [[UILabel alloc]init];
    sexLabel2.text = @"女";
    [backView2 addSubview:sexLabel2];
    [sexLabel2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(KMARGIN);
        make.top.bottom.offset(0);
    }];
    
    UIImageView *chooseImage2 = [[UIImageView alloc]init];
    [chooseImage2 setImage:[UIImage imageNamed:@"watch-yo-checked_28x28_"]];
    [backView2 addSubview:chooseImage2];
    [chooseImage2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(14, 14));
        make.centerY.equalTo(backView2.mas_centerY);
        make.right.offset(-KMARGIN);
    }];
    
    if (self.sex.length) {
        
        if ([self.sex isEqualToString:@"男"]) {
            chooseImage1.hidden = NO;
            chooseImage2.hidden = YES;
        }else{
            chooseImage1.hidden = YES;
            chooseImage2.hidden = NO;
        }
        
    }else{
        chooseImage1.hidden = chooseImage2.hidden = YES;
    }
}

- (void)chooseSex:(UIButton *)chooseBtn{
    
    NSDictionary *dict;
    switch (chooseBtn.tag) {
        case SexButtonType_Man:
            dict = [NSDictionary dictionaryWithObject:@"男" forKey:CHANGEINFO_KEY];
            break;
        case SexButtonType_Woman:
            dict = [NSDictionary dictionaryWithObject:@"女" forKey:CHANGEINFO_KEY];
            break;
            
        default:
            break;
    }
    [JP_NotificationCenter postNotificationName:CHANGESEXSUCCESS object:nil userInfo:dict];
    [self.navigationController popViewControllerAnimated:YES];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
