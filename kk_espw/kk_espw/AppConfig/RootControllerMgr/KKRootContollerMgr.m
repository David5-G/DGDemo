//
//  KKRootContollerMgr.m
//  kk_buluo
//
//  Created by yaya on 2019/3/8.
//  Copyright © 2019 yaya. All rights reserved.
//

#import "KKRootContollerMgr.h"
#import "KKTabBarController.h"
#import "BaseNavigationController.h"
//tool
#import "DGImagePickerManager.h"
//loginKit
#import "MLLKLoginVC.h"
#import "MLLKRoleListVC.h"
#import "MLLKRegisterRoleCreateVC.h"
#import "MLLKPwdMgrVC.h"
#import "MLLKRealNameVC.h"
#import "KKCustomTabViewController.h"
//三方
#import "WXApi.h"



@implementation KKRootContollerMgr

#pragma mark - life circle
+ (instancetype)sharedInstance {
    static dispatch_once_t onceToken;
    static KKRootContollerMgr *sharedInstance;
    
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}


#pragma mark - load rootVC
+ (void)loadRootVC:(nullable NSDictionary *)launchOptions {
    [self loadTabAsRootVC];
    return;
    
    if([KKUserInfoMgr isLogin]){
        [self loadTabAsRootVC];
    }else {
        [self loadLoginAsRootVC];
    }
}

+ (void)loadLoginAsRootVC {
    //LoginKitConfig
    [KKRootContollerMgr setLoginKitConfig];
    
    //登录
    MLLKLoginVC *loginVC = [[MLLKLoginVC alloc] init];
    loginVC.skipLoginHidden = YES;
    loginVC.isSingleRole = YES;
    loginVC.isSingleRole =  YES;
    
    //1.手机号快速登录
    loginVC.quickCellLoginShow = YES;
    
    //2.微信授权登录
    //少了这句就会引起循环引用
    __weak typeof(loginVC) weakLoginVC = loginVC;
    loginVC.quickWechatBlock = ^{
        SendAuthReq *req = [[SendAuthReq alloc] init];
        req.scope = @"snsapi_userinfo";
        req.state = @"kk_espw";
        NSLog(@"WXopenID: %@",req.openID);
        
        //2.1 安装了微信
        if ([WXApi isWXAppInstalled]) {
            [WXApi sendReq:req];
            
        }else {
            //2.2 没有安装微信
            //[CC_Notice show:@"“您未安装微信”"];
            //唤起微信网页登录
            __strong typeof(weakLoginVC)strongLoginVC = weakLoginVC;
            [WXApi sendAuthReq:req viewController:strongLoginVC delegate:[UIApplication sharedApplication].delegate];
        }
    };
    
    //3.setRootVC
    BaseNavigationController *loginNavi = [[BaseNavigationController alloc] initWithRootViewController:loginVC];
    [self setRootViewController:loginNavi];
}


+ (void)loadTabAsRootVC {
    //1.LoginKitConfig
    [KKRootContollerMgr setLoginKitConfig];
    
    //2.rootVC
    KKCustomTabViewController *tabBarController = [[KKCustomTabViewController alloc] init];
    [self setRootViewController:tabBarController];
}


#pragma mark  tool
+ (void)setRootViewController:(UIViewController *)viewController {
    //1.获取当前rootVC
    UIViewController *rootVC = [self rootViewController];
    
    //2.获取presentedVC层级
    NSMutableArray<UIViewController*> *tmpArray;
    while (rootVC.presentedViewController != nil) {
        UIViewController *topVC = rootVC.presentedViewController;
        rootVC = topVC;
        [tmpArray insertObject:rootVC atIndex:0];
    }
    //3.将presentedVC层级中的vc移除
    for (int i=0; i<tmpArray.count; i++) {
        UIViewController *vc = tmpArray[i];
        [vc dismissViewControllerAnimated:NO completion:nil];
    }
    
    //4.将rootVC的view移除
    [rootVC.view removeFromSuperview];

    //5.设置新的rootVC
    UIWindow *window = [[UIApplication sharedApplication] delegate].window;
    window.rootViewController = viewController;
}

+ (UIViewController *)rootViewController {
    UIWindow *window = [[UIApplication sharedApplication] delegate].window;
    if (window) {
        UIViewController *rootVC = [window rootViewController];
        return rootVC;
    }
    return nil;
}

/** loginKit的其他配置 */
+(void)setLoginKitConfig {
    //1.UI
    [MLLKConfig getInstance].checkMarkSelectedImage = Img(@"loginKit_checkmark_yellowBg");
    [MLLKConfig getInstance].buttonSelectedBgColor = rgba(236, 193, 101, 1);
    //2.功能
    [MLLKConfig getInstance].accountRegisterHidden = YES;
}


#pragma mark - loginKit jump
+(void)pushToRoleListByVC:(UIViewController *)byVC {
    MLLKRoleListVC *vc = [[MLLKRoleListVC alloc] init];
    vc.reminderStr = @"选择后您可在\"设置\"菜单切换角色";
    [byVC.navigationController pushViewController:vc animated:YES];
}

+(void)pushToRegisterRoleCreateVC:(UIViewController *)byVC{
    __block DGImagePickerManager *imagePickerMgr = [[DGImagePickerManager alloc]initWithMaxImageCount:1];
    
    MLLKRegisterRoleCreateVC *vc = [[MLLKRegisterRoleCreateVC alloc] init];
    
    __weak __typeof(&*vc)weakVC = vc;
    vc.clickPortraitBlock = ^{
        __strong __typeof(&*weakVC)strongVC = weakVC;
        [imagePickerMgr presentImagePickerByVC:strongVC];
        imagePickerMgr.finishBlock = ^(NSArray<UIImage *> *seletedImages) {
            [strongVC setPortraitImage:seletedImages.firstObject];
        };
    };
    [byVC.navigationController pushViewController:vc animated:YES];
}

+(void)pushToRealNameByVC:(UIViewController *)byVC{
    MLLKRealNameVC *realNameVC = [[MLLKRealNameVC alloc]init];
    
    __weak __typeof(&*byVC)weakVC = byVC;
    realNameVC.successBlock = ^{
        //认证成功需要更新用户信息
        [[KKUserInfoMgr shareInstance] requestUserInfoSuccess:^{
            __strong __typeof(&*weakVC)strongVC = weakVC;
            [strongVC.navigationController popToRootViewControllerAnimated:YES];
        } fail:nil];
    };
    [byVC.navigationController pushViewController:realNameVC animated:YES];
}

+(void)pushToPwdMgrByVC:(UIViewController *)byVC{
    MLLKPwdMgrVC *vc = [[MLLKPwdMgrVC alloc]init];
    [byVC.navigationController pushViewController:vc animated:YES];
}


#pragma mark - tool
+ (UINavigationController *)getRootNav {
    // return (UINavigationController *)[UIApplication sharedApplication].keyWindow.rootViewController;
    /* keywindow会出现bug,参考:
     https://stackoverflow.com/questions/21698482/diffrence-between-uiapplication-sharedapplication-delegate-window-and-u/42996156#42996156
     http://www.jianshu.com/p/ae84cd31d8f0
     */
    
    
    UIWindow *window = [self getCurrentWindow];
    if ([window.rootViewController isKindOfClass:[UINavigationController class]]) {
        return (UINavigationController *)[UIApplication sharedApplication].delegate.window.rootViewController;
    }
    
    if ([window.rootViewController isKindOfClass:[UITabBarController class]]) {
        UIViewController *selectVc = [((UITabBarController *)window.rootViewController) selectedViewController];
        if ([selectVc isKindOfClass:[UINavigationController class]]) {
            return (UINavigationController *)selectVc;
        }
    }
    
    return nil;
}

+ (UIViewController *)getCurrentVC {
    
    UIWindow * window = [self getCurrentWindow];
    UIViewController *rootVC = window.rootViewController;
    UIViewController *presentedViewController = rootVC.presentedViewController;
    if (presentedViewController != nil) {
        if ([presentedViewController isKindOfClass:[UINavigationController class]]) {
            UINavigationController *nv = (UINavigationController *)presentedViewController;
            return [nv.viewControllers lastObject];
        }else{
            return presentedViewController;
        }
    }
    return nil;
}


+ (UIViewController *)topViewController {
    UIViewController *controller = [self topViewControllerWithRootViewController:[self getCurrentWindow].rootViewController];
    return controller;
}



+ (UIViewController *)topViewControllerWithRootViewController:(UIViewController *)viewController{
    if (viewController==nil) return nil;
    if (viewController.presentedViewController!=nil)
    {
        return [self topViewControllerWithRootViewController:viewController.presentedViewController];
    }else if([viewController isKindOfClass:[UITabBarController class]])
    {
        return [self topViewControllerWithRootViewController:[(UITabBarController *)viewController selectedViewController]];
        
    }else if ([viewController isKindOfClass:[UINavigationController class]]){
        return [self topViewControllerWithRootViewController:[(UINavigationController *)viewController topViewController]];
    }else{
        return viewController;
    }
}

+ (UIWindow *)getCurrentWindow{
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    if (window.windowLevel != UIWindowLevelNormal) {
        for (UIWindow *wid in [UIApplication sharedApplication].windows) {
            if (window.windowLevel == UIWindowLevelNormal) {
                window = wid;
                break;
            }
        }
    }
    return window;
}

@end
