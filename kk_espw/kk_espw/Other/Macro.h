//
//  Macro.h
//  Rainbow
//
//  Created by david on 2019/1/3.
//  Copyright © 2019 gwh. All rights reserved.
//

#ifndef Macro_h
#define Macro_h

//---------------------------------------------------
#pragma mark - app
//#define JSHARE_APPKEY @"2ce219a73c8f5524e51f5971"
//---------------------------------------------------
#pragma mark - 尺寸
#define NAV_BAR_HEIGHT (44.f)
#define STATUS_AND_NAV_BAR_HEIGHT (STATUS_BAR_HEIGHT + NAV_BAR_HEIGHT)
#define STATUS_BAR_HEIGHT (CGRectGetHeight([UIApplication sharedApplication].statusBarFrame))

#define SCREEN_WIDTH ([UIScreen mainScreen].bounds.size.width)
#define SCREEN_HEIGHT ([UIScreen mainScreen].bounds.size.height)

#define HOME_INDICATOR_HEIGHT (iPhoneX ? 34.f : 0.f)
#define STATUSBAR_ADD_NAVIGATIONBARHEIGHT (iPhoneX ? 88.f : 64.f)
// tabBar高度
#define TAB_BAR_HEIGHT (iPhoneX ? (49.f+34.f) : 49.f)

/// 通讯录索引高度
#define KKSECTION_INDEX_HEIGHT 40.f

//---------------------------------------------------
#pragma mark - scale
#define SCREEN_WIDTH_SCALE_5      (MIN(SCREEN_WIDTH,SCREEN_HEIGHT)/320.0*0.8+0.2)
#define SCREEN_WIDTH_SCALE_6      (MIN(SCREEN_WIDTH,SCREEN_HEIGHT)/375.0)
#define SCREEN_WIDTH_SCALE_6P     (MIN(SCREEN_WIDTH,SCREEN_HEIGHT)/414.0*0.8+0.2)
#define SCREEN_HEIGHT_SCALE_6P    (MAX(SCREEN_WIDTH,SCREEN_HEIGHT)/736.0*0.8+0.2)
#define ScreenWidthFullScale      (MIN(SCREEN_WIDTH,SCREEN_HEIGHT)/414)
#define ScreenWidthScaleWith(a)   (a/414.0*0.8+0.2)

//---------------------------------------------------
#pragma mark - color
//RGB颜色
#define RGBA(r,g,b,a) [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:a]
#define rgba(r,g,b,a) RGBA(r,g,b,a)
#define RGB(r,g,b) RGBA(r,g,b,1.0f)


/** 常用颜色*/
#define KKES_COLOR_NAVI_BG           RGB(255, 255, 255)//导航背景色
#define KKES_COLOR_BG                RGB(242, 242, 242)//背景色
#define KKES_COLOR_YELLOW            RGB(236, 193, 101)//黄色
#define KKES_COLOR_MAIN_YELLOW       RGB(236, 193, 101)
#define KKES_COLOR_LIGHT_BLUE        RGBA(204, 217, 252, 1)//浅蓝色
#define KKES_COLOR_GRAY_LINE         RGB(238, 238, 238)//灰色分割线
#define KKES_COLOR_HEADER_BG         RGB(244, 244, 244)//

#define KKES_COLOR_BLACK_TEXT        RGB(51, 51, 51)
#define KKES_COLOR_DARK_GRAY_TEXT    RGB(102, 102, 102)
#define KKES_COLOR_GRAY_TEXT         RGB(153, 153, 153)
//随机色
#define KKES_COLOR_RANDOM            RGB(arc4random_uniform(256), arc4random_uniform(256), arc4random_uniform(256))
//二进制颜色
#define KKES_COLOR_HEX(hex) [UIColor colorWithRed:((float)((hex & 0x00FF0000) >> 16)) / 255.0     \
green:((float)((hex & 0x0000FF00) >>  8)) / 255.0     \
blue:((float)((hex & 0x000000FF) >>  0)) / 255.0     \
alpha:1.0]


//---------------------------------------------------
#pragma mark - 设备/版本
//系统版本
#define IOS_VERSION [[[UIDevice currentDevice] systemVersion] floatValue]
#define CurrentSystemVersion [[UIDevice currentDevice] systemVersion]
#define CurrentAppVersion [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]
#define CurrentAppBundleId [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleIdentifier"]

// 判断iPhone
#define iPhone4 (MAX(SCREEN_WIDTH, SCREEN_HEIGHT) == 480)
#define iPhone5 (MAX(SCREEN_WIDTH, SCREEN_HEIGHT) == 568)
#define iPhoneX (MAX(SCREEN_WIDTH, SCREEN_HEIGHT) >= 812)

//---------------------------------------------------
#pragma mark - 简写

#define New(T)     ([[T alloc] init])
#define Img(T)     ([UIImage imageNamed:T])
#define Url(T)     ([NSURL URLWithString:T])
#define Font(T)    ([UIFont systemFontOfSize:T])
#define FontB(T)    ([UIFont boldSystemFontOfSize:T])
#define RH(f) [ccui getRH:f]
#define RF(f) [ccui getRFS:f]

#define WS(weakSelf)  __weak __typeof(&*self)weakSelf = self;
#define SS(strongSelf)  __strong __typeof(&*weakSelf)strongSelf = weakSelf;
//---------------------------------------------------
#pragma mark - 通知
#pragma mark 登录
#define NOTIFICATION_PRESENT_LOGINVC @"notificationPresentLoginVC"///<通知弹出登录页
#define NOTIFICATION_PRESENT_LOGINVC_SIGN_REQUIRED @"notificationSignRequired"///通知需要签名
#define NOTIFICATION_PRESENT_LOGINVC_LOGIN_ELSE @"notificationLoginElse"///在其他地方登录
#define NOTIFICATION_PRESENT_LOGINVC_USER_NOT_LOGIN @"notificationUserNotLogin"///用户未登录(如封号)
#define NOTIFICATION_PRESENT_LOGINVC_ACCOUNT_ABNORMAL @"notificationAccountAbnormal"///账号异常
#define NOTIFICATION_LOGIN_SUCCESS @"notificationLoginSuccess"///<登录成功通知
#define NOTIFICATION_LOGOUT_SUCCESS @"notificationLogoutSuccess"///<退出登录通知

#pragma mark 开黑房
#define NOTIFICATION_PUSH_CREATEGAME_VC @"NOTIFICATION_PUSH_CREATEGAME_VC"
#define NOTIFICATION_EXIT_GAMEROOM_VC @"NOTIFICATION_EXIT_GAMEROOM_VC"
#define NOTIFICATION_TIME_CELL @"NOTIFICATION_TIME_CELL"
#define NOTIFICATION_TIME_CELL_GAMEEND_EVA @"NOTIFICATION_TIME_CELL_GAMEEND_EVA"
#define NOTIFICATION_GAME_ROOM_DISSOLVE  @"NOTIFICATION_GAME_ROOM_DISSOLVE"

#pragma mark 招募厅
#define NOTIFICATION_LIVE_STUDIO_EXIT_VC @"NOTIFICATION_LIVE_STUDIO_EXIT_VC"

#pragma mark 语音房
#define NOTIFICATION_VOICE_ROOM_HOST_LEAVE  @"notificationVoiceRoomHostLeave"

#pragma mark UI
#define NOTIFICATION_DEVICE_ORIENTATION_CHANGED @"notificationDeviceOrientationChanged"///<横竖屏切换通知
#define NOTIFICATION_UPDATETAB @"notificationUpdateTab"///更新TAB图标

#pragma mark other
#define NOTIFICATION_PASTE_BOARD_STR_PASTE @"notificationPasteboardStrPaste"///剪切板粘贴通知

//---------------------------------------------------
#pragma mark - keys
#define KEY_PASTE_BOARD_STR_PASTE @"keyPasteboardStrPaste"///剪切板粘贴

#define RELOAD_GROUP_MEMBER @"RELOAD_GROUP_MEMBER" /// 刷新群成员
#define RELOAD_GROUP_NOTICE @"RELOAD_GROUP_NOTICE" /// 刷新群公告
#define RELOAD_CONTACT_DATA @"RELOAD_CONTACT_DATA" /// 刷新通讯录

/// 存储信息, 招募厅
#define STUDIOID @"studioId"
#define HOSTNAME @"hostName"
#define TITLE @"title"
#define HOSTLOGOURL @"hostLogoUrl"
/// 开黑房
#define GAMEROOMID @"gameRoomId"
#define GAMEPROFILE @"gameProfilesIdStr"
#define GAMEBOARD @"gameBoardIdStr"
#define GROUPID @"groupIdStr"
//---------------------------------------------------
#pragma mark - log
#ifdef DEBUG
#   define BBLOG(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);
#else
#   define BBLOG(...)
#endif

#endif /* Macro_h */
