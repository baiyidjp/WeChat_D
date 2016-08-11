//
//  DefineHeader.h
//  WeChat_D
//
//  Created by tztddong on 16/7/8.
//  Copyright © 2016年 dongjiangpeng. All rights reserved.
//

#ifndef DefineHeader_h
#define DefineHeader_h

#define FONTSIZE(x)  [UIFont systemFontOfSize:x]//设置字体大小
#define KWIDTH  [UIScreen mainScreen].bounds.size.width//屏幕的宽
#define KHEIGHT [UIScreen mainScreen].bounds.size.height//屏幕的高
#define KMARGIN 10//默认间距
#define KNAVHEIGHT 64 //导航栏的高度
#define KTABBARHEIGHT 49 //底部tabbar高度
#define KTOOLVIEW_MINH 45 //键盘工具栏的最小高度
#define KTOOLVIEW_MAXH 60 //键盘工具栏的最大高度
#define KFACEVIEW_H 210//表情和更多view的高度
#define TEXTSIZEWITHFONT(text,font) [text sizeWithAttributes:[NSMutableDictionary dictionaryWithObject:font forKey:NSFontAttributeName]]//根据文本及其字号返回size
#define ScaleValueH(valueh) ((valueh)*667.0f/[UIScreen mainScreen].bounds.size.height)
#define ScaleValueW(valuew) ((valuew)*375.0f/[UIScreen mainScreen].bounds.size.width)
#define WEAK_SELF(value) __weak typeof(self) value = self
#define JP_NotificationCenter [NSNotificationCenter defaultCenter]

#define LOGINCHANGE @"loginstatechange" //重新登录后
#define AUTOLOGINSUCCESS @"autoLoginSuccess" //自动登录成功
#define ADDFRIENDSUCCESS @"addFriendSuccess" //添加好友成功后的通知名
#define AGREEFRIENDSUCCESS @"agreeFriendSuccess" //同意好友申请通知
#define DELECTFRIENDSUEESS @"delectFriendSuccess" //删除好友成功的通知名
#define NETWORKSTATE @"netWorkState" //网络状态
#define RECEIVEMESSAGES @"ReceiveMessages"// 接收消息的通知
#define NEWFRIENDREQUEST @"newFriendRequest" //新朋友请求
#define NEWFRIENDREQUESTRESULT @"newFriendRequestResult" //新朋友请求的结果的通知
#define RECORDPLAYBEGIN @"recordPlayBegin" //录音开始播放
#define RECORDPLAYFINISH @"recordPlayFinish" //录音播放完毕
#define SENDMESSAGEFIELD @"sendMessageField" //发送消息失败
#define SENDMESSAGESUCCESS @"sendMessageSuccess" //发送消息成功
#define CREATGROUPSUCCESS @"CreatGroupSuccess" //创建群组成功
#define RECEIVEGROUPINVITE @"ReceiveGroupInvite" //接到入群邀请
#define SELECTPHOTO @"SelectPhoto" //选择图片的通知
#define SELECTPHOTO_REFRESH @"SelectPhotoRefresh" //选择图片的通知刷新小图选中状态
#define SENDPHOTO @"SendPhoto" //点击发送图片

//define this constant if you want to use Masonry without the 'mas_' prefix
//#define MAS_SHORTHAND
//define this constant if you want to enable auto-boxing for default syntax
#define MAS_SHORTHAND_GLOBALS

//新好友申请的Key值
#define NewFriendName           @"NewFriendName"
#define NewFriendMessage        @"NewFriendMessage"
#define NewFriendAgreeState     @"NewFriendAgreeState"
#define NewFriendLocationArray  @"NewFriendLocationArray"

//群组Key值
#define GroupValue          @"GroupValue" //群组实例
#define GroupName           @"GroupName" //群组名
#define GroupID             @"GroupID" //群组ID
#define GroupInviter        @"GroupInviter" //邀请者
#define GroupInviterMessage @"GroupInviterMessage" //邀请信息

//修改值所用key
#define CHANGEINFO_KEY      @"descTitle"
//城市选择成功
#define CITYCHOOSESUCCESS   @"CityChooseSuccess"
//修改名字成功
#define CHANGENAMESUCCESS   @"ChangeNameSuccess"
//添加好友的二维码字符串前缀
#define ADDFRIEND           @"addFriend"
//改变性别
#define CHANGESEXSUCCESS    @"ChangeSexSuccess"
//个性签名
#define CHANGESIGNSUCCESS   @"ChangeSignSuccess"
//高效打印
#ifdef DEBUG
#define NSLog(...) NSLog(@"%s 第%d行 \n %@\n",__func__,__LINE__,[NSString stringWithFormat:__VA_ARGS__])
#else
#define NSLog(...)
#endif

//判断iOS版本
#define IOS7_OR_LATER   ( [[[UIDevice currentDevice] systemVersion] compare:@"7.0"] != NSOrderedAscending )
#define IOS8_OR_LATER   ( [[[UIDevice currentDevice] systemVersion] compare:@"8.0"] != NSOrderedAscending )
#define IOS9_OR_LATER   ( [[[UIDevice currentDevice] systemVersion] compare:@"9.0"] != NSOrderedAscending )

//默认头像
#define DefaultHeadImageName_Message @"DefaultHead_48x48_"
#define DefaultHeadImageName @"fts_default_headimage_36x36_"
#endif /* DefineHeader_h */
