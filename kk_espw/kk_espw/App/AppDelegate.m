//
//  AppDelegate.m
//  kk_espw
//
//  Created by david on 2019/7/5.
//  Copyright © 2019 david. All rights reserved.
//

#import "AppDelegate.h"
//tool
#import "KKNotifacationManager.h"
#import "KKConversationController.h"
//loginKit
#import <LoginKit/MLLKHeader.h>
#import <IMUIKit/KKConversation.h>
//三方
#import "WXApi.h"
#import <AMapFoundationKit/AMapFoundationKit.h>
#import <AMapSearchKit/AMapSearchKit.h>
#import <Bugly/Bugly.h>
//controller
#import "KKShareGameBoardViewController.h"
#import "KKShareVoiceRoomViewController.h"
#import "KKHomeVC.h"
#import "KKGameRoomOwnerController.h"

//rtc
#import "KKVoiceRoomRtcMgr.h"
#import "KKLiveStudioRtcMgr.h"


@interface AppDelegate ()<WXApiDelegate>
@property (nonatomic, assign) BOOL loginAlertShowing;
@end

@implementation AppDelegate


#pragma mark - common
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    //1.tableV在iOS11以上的设置
    if (@available(iOS 11.0, *)) {
        UITableView.appearance.estimatedRowHeight = 0;
        UITableView.appearance.estimatedSectionFooterHeight = 0;
        UITableView.appearance.estimatedSectionHeaderHeight = 0;
    }
    UITableView.appearance.separatorColor = KKES_COLOR_GRAY_LINE;
    //2.适配暗色模式
    [self becomeUserInterfaceStyleLight];
    //3.定标准尺寸
    [[CC_UIHelper getInstance]initUIDemoWidth:375 andHeight:667];
    
    //4.rootVC
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor whiteColor];
    [KKRootContollerMgr loadRootVC:launchOptions];
    
    //5.配置域名和网络
    [self configDomainAndNetWork];
    
    //6.配置sdk
    [self configSDKs];
    

    return YES;
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    //1.徽章赋值为0
    application.applicationIconBadgeNumber = 0;
    
    //2.添加 登录异常通知
    [self addLoginStatusAbnormalNotification];
    NSLog(@"%d", [KKFloatViewMgr shareInstance].hiddenFloatView);
    //3.在H5加入了开黑房, 状态同步.
    if ([KKUserInfoMgr isLogin]) {
        [[KKFloatViewMgr shareInstance] checkShowFloatView];
    }
    [self becomeUserInterfaceStyleLight];
}

- (void)becomeUserInterfaceStyleLight {
    //1.临时解决深色模式
    if (@available(iOS 13.0, *)) {
        self.window.overrideUserInterfaceStyle = UIUserInterfaceStyleLight;
    }
}

- (void)applicationWillResignActive:(UIApplication *)application {
    //关闭通知
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    
}

- (void)applicationWillTerminate:(UIApplication *)application {
    
}

/// 仅支持 iOS9 以上系统，iOS8 及以下系统不会回调
- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<UIApplicationOpenURLOptionsKey, id> *)options {
    
    //1.微信登录
    if ([url.scheme isEqualToString:[KKAppSdkMgr wechatAppKey]]){
         [WXApi handleOpenURL:url delegate:self];
    }
    
    //2.极光
    [JSHAREService handleOpenUrl:url];
    
    //3.点击开黑房的h5返回
    if ([url.absoluteString containsString:@"kkespw"]) {
        [self handleUrlFromH5:url];
    }
    return YES;
}

/// 从浏览器打开开黑房的邀请进入开黑房分享页面
- (void)handleUrlFromH5:(NSURL *)url {
    NSArray *hostArr = [url.absoluteString componentsSeparatedByString:@"?"];
    if (hostArr.count <= 1) {
        return;
    }
    NSArray *kvArr = [hostArr.lastObject componentsSeparatedByString:@"&"];
    NSMutableDictionary *newDic = [NSMutableDictionary new];
    for (NSString *kv in kvArr) {
        NSArray *arr = [kv componentsSeparatedByString:@"="];
        NSString *value = arr[1];
        [newDic setObject:[value stringByRemovingPercentEncoding] forKey:[arr firstObject]];
    }
    if ([newDic[@"type"] isEqualToString:@"game"]) {
        KKShareGameBoardViewController *vc = New(KKShareGameBoardViewController);
        vc.gameBoradId = newDic[@"gameBoardId"];
        vc.shareUserId = newDic[@"shareUserId"];
        CCLOG("gameBoard = %@ userId = %@", newDic[@"gameBoardId"], newDic[@"shareUserId"]);
        [[KKRootContollerMgr getRootNav] pushViewController:vc animated:YES];
        return;
    }
    
    if ([newDic[@"type"] isEqualToString:@"voice"]) {
        KKShareVoiceRoomViewController *vc = New(KKShareVoiceRoomViewController);
        vc.roomId = newDic[@"roomId"];
        vc.shareUserId = newDic[@"shareUserId"];
        CCLOG("roomId = %@ userId = %@", newDic[@"roomId"], newDic[@"shareUserId"]);
        [[KKRootContollerMgr getRootNav] pushViewController:vc animated:YES];
    }
}

#pragma mark - push
- (void)registerNotification {
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0) {
        [[UIApplication sharedApplication] registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:(UIUserNotificationTypeSound | UIUserNotificationTypeAlert | UIUserNotificationTypeBadge) categories:nil]];
        [[UIApplication sharedApplication] registerForRemoteNotifications];
    } else {
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes: (UIUserNotificationTypeBadge | UIUserNotificationTypeSound | UIUserNotificationTypeAlert)];
    }
}

- (void)application:(UIApplication *)application didRegisterUserNotificationSettings: (UIUserNotificationSettings *)notificationSettings {
    // register to receive notifications
    [application registerForRemoteNotifications];
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    NSString *token =
    [[[[deviceToken description] stringByReplacingOccurrencesOfString:@"<"
                                                           withString:@""]
      stringByReplacingOccurrencesOfString:@">"
      withString:@""]
     stringByReplacingOccurrencesOfString:@" "
     withString:@""];
    
    [[RCIMClient sharedRCIMClient] setDeviceToken:token];
    NSLog(@"[DeviceToken ==================]:%@\n",token);
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error{
    NSLog(@"[DeviceToken Error]:%@\n",error.description);
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult result))completionHandler {
    
    NSDictionary *remoteNotificationUserInfo = userInfo;
    NSDictionary *rc = [remoteNotificationUserInfo objectForKey:@"rc"];
    NSString *tId = [rc objectForKey:@"tId"];
    NSString *appData = [remoteNotificationUserInfo objectForKey:@"appData"];
    NSData *jsonData = [appData dataUsingEncoding:NSUTF8StringEncoding];
    NSError *error;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&error];
    KKConversation *conversation = [[KKConversation alloc] init];
    if (!error) {
        conversation.conversationTitle = [dic objectForKey:@"loginName"];
        conversation.head = [dic objectForKey:@"userLogoUrl"];
    }
    KKConversationController *conversationController = [[KKConversationController alloc] initWithConversation:conversation extra:nil];
    conversation.targetId = tId;
    conversation.conversationType = KKConversationType_PRIVATE;
    [[KKRootContollerMgr getRootNav] pushViewController:conversationController animated:YES];
    completionHandler(UIBackgroundFetchResultNewData);
}



#pragma mark - SDKs
-(void)configSDKs {
    //1.微信
    [WXApi registerApp:[KKAppSdkMgr wechatAppKey]];
    
    //2.极光分享
    [KKShareTool configJShare];
    
    //3.配置bugly
    [Bugly startWithAppId:[KKAppSdkMgr buglyAppId]];
    
    //4.地图
    [AMapServices sharedServices].apiKey = [KKAppSdkMgr aMapAppKey];
}

#pragma mark 微信
/** 微信登录授权 收到微信的请求*/
-(void)onReq:(BaseReq *)req{
    NSLog(@"%@",req.openID);
}

/** 微信登录授权 收到微信响应*/
-(void)onResp:(BaseResp *)resp{
    
    BBLOG(@"wechat --- onResp");
    
    //1.授权
    if ([resp isKindOfClass:[SendAuthResp class]]) {
        //获取code
        SendAuthResp *authResp = (SendAuthResp *)resp;
        NSString *code = authResp.code;
        //发通知给loginKit (注意:key只能是code)
        NSDictionary *userInfo = @{@"code" : code};
        [[NSNotificationCenter defaultCenter] postNotificationName:MLLK_NOTIFICATION_WECHAT_LOGIN_BY_CODE object:nil userInfo:userInfo];
    }
    
    //    WXSuccess           = 0,    /**< 成功    */
    //    WXErrCodeCommon     = -1,   /**< 普通错误类型    */
    //    WXErrCodeUserCancel = -2,   /**< 用户点击取消并返回    */
    //    WXErrCodeSentFail   = -3,   /**< 发送失败    */
    //    WXErrCodeAuthDeny   = -4,   /**< 授权失败    */
    //    WXErrCodeUnsupport  = -5,   /**< 微信不支持    */
    
    //2.分享
    if ([resp isKindOfClass:[SendMessageToWXResp class]]){
        //把返回的类型转换成与发送时相对于的返回类型,这里为SendMessageToWXResp
        SendMessageToWXResp *sendResp = (SendMessageToWXResp *)resp;
        //显示回调信息
        NSString *str;
        switch (sendResp.errCode) {
            case 0:
                str = @"分享成功";
                break;
            case -1:
                str = @"分享出错";
                break;
            case -2:
                str = @"分享取消";
                break;
            case -3:
                str = @"发送失败";
                break;
            case -4:
                str = @"授权失败";
                break;
            case -5:
                str = @"微信版本不支持";
                break;
            default:
                break;
        }
        [CC_Notice show:str];
    }
}


#pragma mark - 配置域名,网络
-(void)configDomainAndNetWork {
    //1.网络配置 (在配置user签名时会配置defualtNet签名,签名时会配置IM的网络)
    [KKNetworkConfig configNetWork];
    
    //2.已登录
    if([KKUserInfoMgr isLogin]){
        //2.1 登录IM
        [[KKIMMgr shareInstance] login];
        
        //2.2 首次进入,如果已登录, 要刷新一次用户信息
        [[KKUserInfoMgr shareInstance] requestUserInfoSuccess:nil fail:nil];
    }

}


#pragma mark - notification
-(void)addLoginStatusAbnormalNotification {
    //1.需要签名
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notifacationSafeTransferToMainThread:) name:NOTIFICATION_PRESENT_LOGINVC_SIGN_REQUIRED object:nil];
    
    //2.异地登录通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notifacationSafeTransferToMainThread:) name:NOTIFICATION_PRESENT_LOGINVC_LOGIN_ELSE object:nil];
    
    //3.用户未登录
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notifacationSafeTransferToMainThread:) name:NOTIFICATION_PRESENT_LOGINVC_USER_NOT_LOGIN object:nil];
    
    //4.IM连接断开
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notifacationSafeTransferToMainThread:) name:IMKitNotification_IMConnListener object:nil];
    
}

/** 将通知安全的转到主线程上 */
-(void)notifacationSafeTransferToMainThread:(NSNotification *)notification {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self notifacationLoginStatusAbnormal:notification];
    });
}

#pragma mark 方法
/** 登录状态异常 通知 */
-(void)notifacationLoginStatusAbnormal:(NSNotification *)notification {
    
    //1.过滤alertShowing
    if (self.loginAlertShowing) {
        return;
    }
    
    //2.alert
    NSString *msg = @"";
    if ([notification.name isEqualToString:NOTIFICATION_PRESENT_LOGINVC_LOGIN_ELSE]) {
        msg = @"账号已在其他设备登录";
    }else if ([notification.name isEqualToString:NOTIFICATION_PRESENT_LOGINVC_SIGN_REQUIRED]){
        msg = @"请登录";
    }else if( [notification.name isEqualToString:NOTIFICATION_PRESENT_LOGINVC_USER_NOT_LOGIN]){
        msg = @"账号被禁用";
    }else if( [notification.name isEqualToString:IMKitNotification_IMConnListener]){
        if ([notification.object integerValue] == ConnectionStatus_KICKED_OFFLINE_BY_OTHER_CLIENT) {
             msg = @"账号已在其他设备登录";
        }
    }
    if (msg.length < 1) {
        return ;
    }
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:msg delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [alert show];
    
    //3.设为alertShowing
    self.loginAlertShowing = YES;
    
    //4.删除rtc
    if ([KKFloatViewMgr shareInstance].gameRoomModel.gameRoomId > 0) {
        [[KKGameRoomOwnerController sharedInstance] requestLeaveRtcRoomByLoginElse:nil];
        return;
    }
    
    if ([KKFloatViewMgr shareInstance].voiceRoomModel.roomId > 0) {
        [[KKVoiceRoomRtcMgr shareInstance] requestLeaveRtcRoomByLoginElse:nil];
        return;
    }
    
    if ([KKFloatViewMgr shareInstance].liveStudioModel.studioId.length > 0) {
        [[KKLiveStudioRtcMgr shareInstance] requestLeaveRtcRoomByLoginElse:nil];
        return;
    }
    
    
}

#pragma mark alert
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    //1.设置alertShowing
    self.loginAlertShowing = NO;
    
    //2.清除数据
    [[KKUserInfoMgr shareInstance] logoutAndSetNil:nil];
}

@end
