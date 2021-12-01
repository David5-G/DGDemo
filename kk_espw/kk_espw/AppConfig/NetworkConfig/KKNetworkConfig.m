//
//  KKNetworkConfig.m
//  kk_buluo
//
//  Created by david on 2019/3/16.
//  Copyright © 2019 yaya. All rights reserved.
//

#import "KKNetworkConfig.h"
#import "KKKeyChainStore.h"
//IMKit
#import <IMUIKit/IMHTTPTaskManager.h>
//bench
#import "CC_UserInfoMgr.h"
//LoginLib
#import "LoginLib.h"
//LoginKit
#import "MLLKHeader.h"
#import "MLLKLoginVC.h"

#define kConfig_loginKey  @"loginKey"//与后台约定的, 配置网络的loginKey的key
#define kConfig_oneAuthId @"oneAuthId"//与后台约定的, 配置oneAuth签名的key
#define kConfig_userId    @"authedUserId"//与后台约定的, 配置user签名的key

//(方舟LoginKit)oneAuth签名
#define kOneAuth_id        @"oneAuth_id"//与后台约定的
#define kOneAuth_loginKey  @"oneAuth_loginKey"//用于储存
#define kOneAuth_signKey   @"oneAuth_signKey" //用于储存
#define kOneAuth_cryptKey  @"oneAuth_cryptKey"//用于储存,暂时没用

//(方舟LoginKit)user签名
#define kAuth_id        @"auth_id"//与后台约定的
#define kAuth_loginKey  @"auth_loginKey"//用于储存
#define kAuth_signKey   @"auth_signKey" //用于储存
#define kAuth_cryptKey  @"auth_cryptKey"//用于储存,暂时没用

//app的user签名
#define kUser_id        @"user_id"//与后台约定的
#define kUser_loginKey  @"user_loginKey"//用于储存
#define kUser_signKey   @"user_signKey" //用于储存
#define kUser_cryptKey  @"user_cryptKey"//用于储存,暂时没用


@interface KKNetworkConfig ()
//用于清空
@property (nonatomic,strong) NSMutableArray *keyMutArr;

//appConfig
//由appConfig.plist的参数配置
/** app的类型 (0:线下, 1:线上) */
@property (nonatomic,assign,readwrite) NSInteger appType;
/** appName的类型 (0:默认, 1:单角色, 2:多角色) */
@property (nonatomic,assign,readwrite)NSInteger appNameType;
/** 用于签名的appName */
@property (nonatomic,copy,readwrite)NSString *appName;
/** 根据urlType和appType确定 */
@property (nonatomic,copy,readwrite)NSString *domainStr;
/** 根据loginUrlType和appType确定 */
@property (nonatomic,copy,readwrite)NSString *loginDomainStr;

@end

@implementation KKNetworkConfig

static KKNetworkConfig *_netWorkConfig = nil;
static dispatch_once_t onceToken;

#pragma mark - lazy load
-(NSMutableArray *)keyMutArr {
    if (!_keyMutArr) {
        _keyMutArr = [NSMutableArray array];
    }
    return _keyMutArr;
}



#pragma mark - life circle
+(instancetype)shareInstance{
    dispatch_once(&onceToken, ^{
        _netWorkConfig = [[KKNetworkConfig alloc] init];
    });
    return _netWorkConfig;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        [self loadAppConfig];
        [self setupSignInfo];
        [self registerLoginKitNotification];
    }
    return self;
}

-(void)dealloc{
    [self removeLoginKitNotification];//删除通知
}

- (void)removeHttpTaskConfig{
    //1.删除userDefault中的用户信息
    for (NSInteger i=0; i<self.keyMutArr.count; i++) {
        [ccs saveDefaultKey:self.keyMutArr[i] andV:nil];
    }
    
    //2.释放自己
    self.user_id = nil;
    self.user_loginKey = nil;
    self.user_signKey = nil;
    self.user_cryptKey = nil;
    
    self.oneAuth_id = nil;
    self.oneAuth_loginKey = nil;
    self.oneAuth_signKey = nil;
    self.oneAuth_cryptKey = nil;
    
    self.auth_id = nil;
    self.auth_loginKey = nil;
    self.auth_signKey = nil;
    self.auth_cryptKey = nil;
    
    //3.释放相关配置
    [LoginLib getInstance].httpTask = nil;
    [KKNetworkConfig removeDefaultNetworkSignAndExtraParams];
}


#pragma mark - 签名
/** 配置 签名信息 */
- (void)setupSignInfo{
    //1.user签名
    self.user_id = [ccs getDefault:kUser_id];
    self.user_loginKey = [ccs getDefault:kUser_loginKey];
    self.user_signKey=[ccs getDefault:kUser_signKey];
    self.user_cryptKey=[ccs getDefault:kUser_cryptKey];
    [self.keyMutArr addObject:kUser_id];
    [self.keyMutArr addObject:kUser_loginKey];
    [self.keyMutArr addObject:kUser_signKey];
    [self.keyMutArr addObject:kUser_cryptKey];
    
    //2.(方舟LoginKit)oneAuth签名
    self.oneAuth_id = [ccs getDefault:kOneAuth_id];
    self.oneAuth_loginKey = [ccs getDefault:kOneAuth_loginKey];
    self.oneAuth_signKey = [ccs getDefault:kOneAuth_signKey];
    self.oneAuth_cryptKey = [ccs getDefault:kOneAuth_cryptKey];
    [self.keyMutArr addObject:kOneAuth_id];
    [self.keyMutArr addObject:kOneAuth_loginKey];
    [self.keyMutArr addObject:kOneAuth_signKey];
    [self.keyMutArr addObject:kOneAuth_cryptKey];
    
    //3.(方舟LoginKit)user签名
    self.auth_id = [ccs getDefault:kAuth_id];
    self.auth_loginKey = [ccs getDefault:kAuth_loginKey];
    self.auth_signKey = [ccs getDefault:kAuth_signKey];
    self.auth_cryptKey = [ccs getDefault:kAuth_cryptKey];
    [self.keyMutArr addObject:kAuth_id];
    [self.keyMutArr addObject:kAuth_loginKey];
    [self.keyMutArr addObject:kAuth_signKey];
    [self.keyMutArr addObject:kAuth_cryptKey];
    
}

/** 保存用户的(方舟LoginKit)oneAuth签名信息 */
-(void)saveOneAuthInfo:(NSDictionary *)dic {
    
    //1.内存保存
    self.oneAuth_id = dic[kNetConfig_id];
    self.oneAuth_loginKey = dic[kNetConfig_loginKey];
    self.oneAuth_signKey  = dic[kNetConfig_signKey];
    self.oneAuth_cryptKey = dic[kNetConfig_cryptKey];
    
    //2.NSUserDefault保存
    [ccs saveDefaultKey:kOneAuth_id andV:self.oneAuth_id];
    [ccs saveDefaultKey:kOneAuth_loginKey andV:self.oneAuth_loginKey];
    [ccs saveDefaultKey:kOneAuth_signKey andV:self.oneAuth_signKey];
    [ccs saveDefaultKey:kOneAuth_cryptKey andV:self.oneAuth_cryptKey];
    
    //3.重新配置network
    [KKNetworkConfig configLoginLibNetworkForOneAuthSign];
}

/** 保存用户的(方舟LoginKit)user签名信息 */
-(void)saveAuthInfo:(NSDictionary *)dic {
    
    //1.内存保存
    self.auth_id = dic[kNetConfig_id];
    self.auth_loginKey = dic[kNetConfig_loginKey];
    self.auth_signKey  = dic[kNetConfig_signKey];
    self.auth_cryptKey = dic[kNetConfig_cryptKey];
    
    //2.NSUserDefault保存
    [ccs saveDefaultKey:kAuth_id andV:self.auth_id];
    [ccs saveDefaultKey:kAuth_loginKey andV:self.auth_loginKey];
    [ccs saveDefaultKey:kAuth_signKey andV:self.auth_signKey];
    [ccs saveDefaultKey:kAuth_cryptKey andV:self.auth_cryptKey];
    
    //3.重新配置network
    [KKNetworkConfig configLoginLibNetworkForUserSign];
}

/** 保存用户的user(角色)签名信息 */
-(void)saveUserInfo:(NSDictionary *)dic {
    
    //1.内存保存
    self.user_id = dic[kNetConfig_id];
    self.user_signKey = dic[kNetConfig_signKey];
    self.user_loginKey = dic[kNetConfig_loginKey];
    self.user_cryptKey = dic[kNetConfig_cryptKey];
    
    //2.NSUserDefault保存
    [ccs saveDefaultKey:kUser_id andV:self.user_id];
    [ccs saveDefaultKey:kUser_signKey andV:self.user_signKey];
    [ccs saveDefaultKey:kUser_loginKey andV:self.user_loginKey];
    [ccs saveDefaultKey:kUser_cryptKey andV:self.user_cryptKey];
    
    //3.重新配置network
    [KKNetworkConfig configDefaultNetwork];
}


#pragma mark - 配置网络

/** 配置网络 */
+(void)configNetWork {
    [self configDefaultNetwork];
    [self configLoginLibNetworkForOneAuthSign];
    [self configLoginLibNetworkForUserSign];
}

/** 获取 当前请求地址 */
+(NSURL *)currentUrl {
    NSString *urlStr = [NSString stringWithFormat:@"%@/client/service.json?",[KKNetworkConfig shareInstance].domainStr];
    return [NSURL URLWithString:urlStr];
}

+ (NSURL *)baseHeadURL {
    NSString *baseURL = [NSString stringWithFormat:@"%@/userLogoUrl.htm?",[KKNetworkConfig shareInstance].domainStr];
    return [NSURL URLWithString:baseURL];
}

#pragma mark  default 
/** 配置 默认网络 */
+(void)configDefaultNetwork {
    //1.设置请求头
    NSDictionary *headersDic = [KKNetworkConfig getHttpHeadersDic];
    [[CC_HttpTask getInstance] setRequestHTTPHeaderFieldDic:headersDic];
    
    //2.签名 额外参数
    //2.1 签名
    [[CC_HttpTask getInstance] setSignKeyStr:[KKNetworkConfig shareInstance].user_signKey];
    //2.2额外参数
    NSMutableDictionary *mutDic = [[NSMutableDictionary alloc]init];
    [mutDic safeSetObject:[KKNetworkConfig shareInstance].user_id forKey:kConfig_userId];
    [mutDic safeSetObject:[KKNetworkConfig shareInstance].user_loginKey forKey:kConfig_loginKey];
    [[CC_HttpTask getInstance] setExtreDic:mutDic];
    
    //3.通知
    [KKNetworkConfig addNotificationToHttpTask:[CC_HttpTask getInstance]];
    
    //4.配置IM的HTTP
    [IMHTTPTaskManager sharedInstance].currentURL = [KKNetworkConfig currentUrl];
    [IMHTTPTaskManager sharedInstance].baseHeadURL = [KKNetworkConfig baseHeadURL];
}

+(void)removeDefaultNetworkSignAndExtraParams {
    //1.签名
    [[CC_HttpTask getInstance] setSignKeyStr:nil];
    //2.额外参数
    NSMutableDictionary *mutDic = [[NSMutableDictionary alloc]init];
    [[CC_HttpTask getInstance] setExtreDic:mutDic];
}

#pragma mark loginLib
/** 配置 loginLib的oneAuth签名网络 */
+(void)configLoginLibNetworkForOneAuthSign {
    CC_HttpTask *httpTask = [[CC_HttpTask alloc]init];
    
    //1.设置请求头
    NSDictionary *headersDic = [KKNetworkConfig getHttpHeadersDic];
    [httpTask setRequestHTTPHeaderFieldDic:headersDic];
    
    //2.签名 额外参数
    //2.1 签名
    [httpTask setSignKeyStr:[KKNetworkConfig shareInstance].oneAuth_signKey];
    //2.2额外参数
    NSMutableDictionary *mutDic = [[NSMutableDictionary alloc]initWithDictionary:[CC_HttpTask getInstance].extreDic];
    [mutDic safeSetObject:[KKNetworkConfig shareInstance].oneAuth_id forKey:kConfig_oneAuthId];
    [mutDic safeSetObject:[KKNetworkConfig shareInstance].oneAuth_loginKey forKey:kConfig_loginKey];
    [httpTask setExtreDic:mutDic];
    
    //3.通知
    [KKNetworkConfig addNotificationToHttpTask:httpTask];
    
    //4.配置
    [LoginLib configTask:httpTask url:[KKNetworkConfig getLoginLibUrl]];
}

/** 配置 loginLib的user签名网络 */
+(void)configLoginLibNetworkForUserSign {
    CC_HttpTask *httpTask = [[CC_HttpTask alloc]init];
    
    //1.设置请求头
    NSDictionary *headersDic = [KKNetworkConfig getHttpHeadersDic];
    [httpTask setRequestHTTPHeaderFieldDic:headersDic];
    
    //2.签名 额外参数
    //2.1 签名
    [httpTask setSignKeyStr:[KKNetworkConfig shareInstance].auth_signKey];
    //2.2额外参数
    NSMutableDictionary *mutDic = [[NSMutableDictionary alloc]initWithDictionary:[CC_HttpTask getInstance].extreDic];
    [mutDic safeSetObject:[KKNetworkConfig shareInstance].auth_id forKey:kConfig_userId];
    [mutDic safeSetObject:[KKNetworkConfig shareInstance].auth_loginKey forKey:kConfig_loginKey];
    [httpTask setExtreDic:mutDic];
    
    //3.通知
    [KKNetworkConfig addNotificationToHttpTask:httpTask];
    
    //4.配置
    [LoginLib configUserTask:httpTask url:[KKNetworkConfig getLoginLibUrl]];
}

+(NSURL *)getLoginLibUrl {
    NSString *urlStr = [NSString stringWithFormat:@"%@/client/service.json?",[KKNetworkConfig shareInstance].loginDomainStr];
    return [NSURL URLWithString:urlStr];
}


#pragma mark tool
/** http请求的heads */
+(NSDictionary *)getHttpHeadersDic {
    //1.创建
    NSMutableDictionary *headers = [[NSMutableDictionary alloc]init];
    
    //2.添加
    //appCode
    NSArray* array = [[[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleIdentifier"] componentsSeparatedByString:@"."];
    NSString *subDomainStr = array.lastObject;
    [headers setObject:subDomainStr forKey:@"appCode"];
    //appName
    [headers setObject:[KKNetworkConfig shareInstance].appName forKey:@"appName"];
    //bundleId
    [headers setObject:CurrentAppBundleId forKey:@"appBundleId"];
    //appVersion
    [headers setObject:[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"] forKey:@"appVersion"];
    //appUserAgent
    float version = [[[UIDevice currentDevice] systemVersion] floatValue];
    float screenH = [UIScreen mainScreen].bounds.size.height;
    [headers setObject:[NSString stringWithFormat:@"IOS_VERSION%fSCREEN_HEIGHT%d",version,(int)screenH] forKey:@"appUserAgent"];
    //appDeviceId
    [headers setObject:[KKNetworkConfig getKeyChainUuid] forKey:@"appDeviceId"];
    
    //3.return
    return headers;
}

/** 储存于KeyChain中,用于表示设备 */
+ (NSString *)getKeyChainUuid {
    
    //@"com.hhslive.app.usernamepassword"
    //@"com.hhslive.app.username"
    //@"com.hhslive.app.password"
    
    //1.尝试获取
    NSString *uuidKey = @"com.hhslive.app.usernamepassword";
    NSString *uuidStr = (NSString*)[KKKeyChainStore load:uuidKey];
    
    //2.为空则创建
    //首次执行该方法时，uuid为空
    if([uuidStr isEqualToString:@""]|| !uuidStr) {
        //生成一个uuid的方法
        uuidStr = [NSUUID UUID].UUIDString;
        //将该uuid保存到keychain
        [KKKeyChainStore save:uuidKey data:uuidStr];
        
    }
    
    //3.return
    return uuidStr;
}

+(void)addNotificationToHttpTask:(CC_HttpTask *)httpTask {
    
    //1.通知 需要签名
    [httpTask addResponseLogic:@"SIGN_REQUIRED" logicStr:@"response,error,name=SIGN_REQUIRED" stop:0 popOnce:1 logicBlock:^(ResModel *result, void (^finishCallbackBlock)(NSString *error, ResModel *result)) {
        //这里添加的错误逻辑,在bench中以logicBlock终止, 不会回调发请求的block,
        //所以要终止菊花提示(loginKit中用这个做菊花提示,其他的请求菊花提示请自行处理,建议用CC_Mask)
        [[CC_Mask getInstance] stop];
        //发通知
         [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_PRESENT_LOGINVC_SIGN_REQUIRED object:nil];
    }];
    //2.通知 异地登录
    [httpTask addResponseLogic:@"LOGIN_ELSEWHERE" logicStr:@"response,error,name=LOGIN_ELSEWHERE" stop:1 popOnce:1 logicBlock:^(ResModel *result, void (^finishCallbackBlock)(NSString *error, ResModel *result)) {
        //这里添加的错误逻辑,在bench中以logicBlock终止, 不会回调发请求的block,
        //所以要终止菊花提示(loginKit中用这个做菊花提示,其他的请求菊花提示请自行处理,建议用CC_Mask)
        [[CC_Mask getInstance] stop];
        //发通知
        [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_PRESENT_LOGINVC_LOGIN_ELSE object:nil];
    }];
    //3.通知 用户未登录
    [httpTask addResponseLogic:@"USER_NOT_LOGIN" logicStr:@"response,error,name=USER_NOT_LOGIN" stop:1 popOnce:1 logicBlock:^(ResModel *result, void (^finishCallbackBlock)(NSString *error, ResModel *result)) {
        //这里添加的错误逻辑,在bench中以logicBlock终止, 不会回调发请求的block,
        //所以要终止菊花提示(loginKit中用这个做菊花提示,其他的请求菊花提示请自行处理,建议用CC_Mask)
        [[CC_Mask getInstance] stop];
        //发通知
        [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_PRESENT_LOGINVC_USER_NOT_LOGIN object:nil];
    }];
}

#pragma mark - appConfig
-(void)loadAppConfig {
    NSInteger appType = [self getAppConfigValue:@"appType"];
    NSInteger appNameType = [self getAppConfigValue:@"appName"];
    NSInteger urlType = [self getAppConfigValue:@"urlType"];
    NSInteger loginUrlType = [self getAppConfigValue:@"loginUrlType"];
    
    //1.appType
    self.appType = appType;
    
    //2.appName
    self.appNameType = appNameType;
    self.appName = @"kkespw-iphone";//默认
//    if (1 == appNameType) {
//        self.appName = @"kkespw-test-role-iphone";//单角色
//    } else if (2 ==appNameType) {
//        self.appName = @"kkespw-test-roles-iphone";//多角色
//    }
    
    
    //3.主域名
    //3.1 根据urlType 确定前半部分
    NSString *urlStr = @"http://kkdj-user-mapi1.kkbuluo";//分支
    if(1 == urlType){
        urlStr = @"http://kkdj-user-mapi.kkbuluo";//主干
    }
    //3.2 根据appType 确定后缀
    if (1 == appType){
        urlStr = [urlStr stringByAppendingString:@".com"];//线上
    }else{
        urlStr = [urlStr stringByAppendingString:@".net"];//线下
    }
    //3.3 赋值
    self.domainStr = urlStr;
    
    
    //4.loginLib的域名 (方舟域名)
    //4.1 根据loginUrlType 确定前半部分
    NSString *loginUrlStr = @"http://mapi1.platform.kkbuluo";//分支
    if(1 == loginUrlType){
        loginUrlStr = @"http://mapi.platform.kkbuluo";//主干
    }
    //4.2 根据appType 确定后缀
    if (1 == appType){
        loginUrlStr = [loginUrlStr stringByAppendingString:@".com"];//线上
    }else{
        loginUrlStr = [loginUrlStr stringByAppendingString:@".net"];//线下
    }
    //4.3 赋值
    self.loginDomainStr = loginUrlStr;
}


/** 获取appConfig.plist中的值 */
-(NSInteger)getAppConfigValue:(NSString *)aKey {
    //1.过滤
    if (aKey==nil || aKey.length < 1) {
        return 0;
    }
    //2.获取配置
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"AppConfig.plist" ofType:nil];
    NSDictionary *configDic = [[NSDictionary alloc] initWithContentsOfFile:filePath];
    NSNumber *aValue = [configDic objectForKey:aKey];
    if (aValue) {
        return [aValue integerValue];
    }
    return 0;
}
 
#pragma mark - 通知
/** 注册loginKit的通知 */
-(void)registerLoginKitNotification {
    //1.登录成功
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notifacationSafeTransferToMainThread:) name:MLLK_NOTIFICATION_LOGIN_SUCCESS object:nil];
    
    //2.oneAuth签名
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notifacationSafeTransferToMainThread:) name:MLLK_NOTIFICATION_ONE_AUTH_SIGN object:nil];
    
    //3.需要设置rootController
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notifacationSafeTransferToMainThread:) name:MLLK_NOTIFICATION_NEED_SET_ROOT_CONTROLLER object:nil];
}

/** 移除loginKit的通知 */
-(void)removeLoginKitNotification {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:MLLK_NOTIFICATION_LOGIN_SUCCESS object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:MLLK_NOTIFICATION_ONE_AUTH_SIGN object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:MLLK_NOTIFICATION_NEED_SET_ROOT_CONTROLLER object:nil];
}


/** 将通知安全的转到主线程上 */
-(void)notifacationSafeTransferToMainThread:(NSNotification *)notification {
    NSString *name = notification.name;
    dispatch_async(dispatch_get_main_queue(), ^{
        if ([name isEqualToString:MLLK_NOTIFICATION_LOGIN_SUCCESS]) {
            [self notificationLoginKitLoginSuccess:notification];
        }else if ([name isEqualToString:MLLK_NOTIFICATION_ONE_AUTH_SIGN]) {
            [self notificationLoginKitOneAuthSign:notification];
        }else if ([name isEqualToString:MLLK_NOTIFICATION_NEED_SET_ROOT_CONTROLLER]) {
            [self notificationLoginKitNeedSetRootController:notification];
        }
    });
}

#pragma mark 具体通知方法
/**
 登录成功
 1.notification.object是一个MLLKBaseVC对象: 需要做vc跳转
 2.否则: 不做任何跳转
 */
-(void)notificationLoginKitLoginSuccess:(NSNotification *)notification {
    
    NSDictionary *responseDic = notification.userInfo;
    NSObject *obj = notification.object;
    
    MLLKBaseVC *byVC;
    if ([obj isKindOfClass:[MLLKBaseVC class]]) {
        byVC = (MLLKBaseVC *)obj;
    }
    
    BOOL needSelectRole = [responseDic[@"gotoUserList"] boolValue];
    BOOL needCreateRole = [responseDic[@"gotoUserCreate"] boolValue];
    NSDictionary *oneAuthDic = responseDic[@"oneAuthPlatformLogin"];
    NSDictionary *authDic = responseDic[@"kkUserPlatformLogin"];
    NSDictionary *userDic = responseDic[@"userPlatformLogin"];
    NSDictionary *userInfoDic = responseDic[@"loginUserInfo"];
    
    //1.有oneAuth就改oneAuth签名
    if(oneAuthDic){
        [[KKNetworkConfig shareInstance] saveOneAuthInfo:@{
                                                           kNetConfig_id : oneAuthDic[@"oneAuthId"],
                                                           kNetConfig_loginKey : oneAuthDic[@"loginKey"],
                                                           kNetConfig_signKey  : oneAuthDic[@"signKey"],
                                                           kNetConfig_cryptKey : oneAuthDic[@"cryptKey"]
                                                           }];
    }
    
    //2.有auth(oneAuth的user)签名就改auth签名
    if(authDic){
        [[KKNetworkConfig shareInstance] saveAuthInfo:@{
                                                           kNetConfig_id : authDic[@"userId"],
                                                           kNetConfig_loginKey : authDic[@"loginKey"],
                                                           kNetConfig_signKey  : authDic[@"signKey"],
                                                           kNetConfig_cryptKey : authDic[@"cryptKey"]
                                                           }];
    }
    
    //3.只进行oneAuth签名的情况
    //3.1 需要创建用户
    if (needCreateRole && byVC) {
        [KKRootContollerMgr pushToRegisterRoleCreateVC:byVC];
        return;
    }
    //3.2 需要切换用户
    if (needSelectRole && byVC) {
        [KKRootContollerMgr pushToRoleListByVC:byVC];
        return;
    }
    
    //正常登录----------------------------------------------------------
    //4.1 用户信息 platformUserId
    [KKUserInfoMgr shareInstance].platformUserId = responseDic[@"kkPlatformUserId"];
    
    //4.2 用户信息 
    if (userInfoDic) {
        [KKUserInfoMgr shareInstance].userId = userInfoDic[@"userId"];
        [KKUserInfoMgr shareInstance].userInfoModel.nickName = userInfoDic[@"loginName"];
        [KKUserInfoMgr shareInstance].userInfoModel.userLogoUrl = userInfoDic[@"userLogoUrl"];
        [CC_UserInfoMgr getInstance].userId = userInfoDic[@"userId"];
        [CC_UserInfoMgr getInstance].userName = userInfoDic[@"loginName"];
        [CC_UserInfoMgr getInstance].userLogoUrl = userInfoDic[@"userLogoUrl"];
    }
    
    //5.user签名
    if (userDic) {
        [[KKNetworkConfig shareInstance] saveUserInfo:@{
                                                        kNetConfig_id : userDic[@"userId"],
                                                        kNetConfig_loginKey : userDic[@"loginKey"],
                                                        kNetConfig_signKey  : userDic[@"signKey"],
                                                        kNetConfig_cryptKey : userDic[@"cryptKey"]
                                                        }];
    }
    
    //6.刷新用户信息
    [[KKUserInfoMgr shareInstance] requestUserInfoSuccess:nil fail:nil];
    
    //7.登录IM
    [[KKIMMgr shareInstance] login];
    
    //8.登录成功后的处理
    if ([MLLKConfig getInstance].loginNotSetRootController) {
        //不设置rootController的处理(用一次清理一次,这行代码必须有)
        [MLLKConfig getInstance].loginNotSetRootController = NO;
        
        //app自己的处理代码
        [CC_Notice showNoticeStr:@"登录成功,但不设置rootController" atView:nil delay:2.0];
        
    }else if(byVC){
        [CC_Notice showNoticeStr:@"登录成功" atView:nil delay:2.0];
        [KKRootContollerMgr loadTabAsRootVC];
    }
}


/** oneAuth签名 */
-(void)notificationLoginKitOneAuthSign:(NSNotification *)notification {
    NSDictionary *oneAuthDic = notification.userInfo;
    NSObject *obj = notification.object;
    
    UIViewController *byVC;
    if([obj isKindOfClass:[UIViewController class]]){
        byVC = (UIViewController *)obj;
    }
    
    //1.oneAuth签名
    [[KKNetworkConfig shareInstance] saveOneAuthInfo:@{
                                                       kNetConfig_id : oneAuthDic[@"oneAuthId"],
                                                       kNetConfig_loginKey : oneAuthDic[@"loginKey"],
                                                       kNetConfig_signKey  : oneAuthDic[@"signKey"],
                                                       kNetConfig_cryptKey : oneAuthDic[@"cryptKey"]
                                                       }];
    //2.跳转
    if (byVC) {
        [KKRootContollerMgr pushToRegisterRoleCreateVC:byVC];
    }
}

/** 设置rootController */
-(void)notificationLoginKitNeedSetRootController:(NSNotification *)notification {
    [KKRootContollerMgr loadTabAsRootVC];
}

@end
