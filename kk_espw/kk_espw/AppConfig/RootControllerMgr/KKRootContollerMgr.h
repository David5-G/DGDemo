//
//  KKRootContollerMgr.h
//  kk_buluo
//
//  Created by yaya on 2019/3/8.
//  Copyright © 2019 yaya. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface KKRootContollerMgr : NSObject
/** 加载rootVC, 如果user未登录调loadLoginAsRootVC, 已登录调loadLTabAsRootVC */
+ (void)loadRootVC:(nullable NSDictionary *)launchOptions;
/** 加载LoginVC作为rootVC */
+ (void)loadLoginAsRootVC;
/** 加载Tab作为rootVC */
+ (void)loadTabAsRootVC;

#pragma mark - loginKit
/** push跳转 角色列表VC */
+(void)pushToRoleListByVC:(UIViewController *)byVC;
/** push跳转 注册时创建角色VC */
+(void)pushToRegisterRoleCreateVC:(UIViewController *)byVC;
/** push跳转 实名认证VC */
+(void)pushToRealNameByVC:(UIViewController *)byVC;
/** push跳转 密码管理VC */
+(void)pushToPwdMgrByVC:(UIViewController *)byVC;


#pragma mark - tool
+ (UINavigationController *)getRootNav;
+ (UIViewController *)getCurrentVC;
+ (UIViewController *)topViewController;
+ (UIWindow *)getCurrentWindow;
@end

NS_ASSUME_NONNULL_END
