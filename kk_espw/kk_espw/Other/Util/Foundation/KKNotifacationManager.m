//
//  KKNotifacationManager.m
//  kk_espw
//
//  Created by 罗礼豪 on 2019/8/7.
//  Copyright © 2019 david. All rights reserved.
//

#import "KKNotifacationManager.h"
#import "KKConversationController.h"
#import <IMUIKit/KKConversation.h>

@implementation KKNotifacationManager

+ (void)registerNotification {
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0) {
        [[UIApplication sharedApplication] registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:(UIUserNotificationTypeSound | UIUserNotificationTypeAlert | UIUserNotificationTypeBadge) categories:nil]];
        [[UIApplication sharedApplication] registerForRemoteNotifications];
    } else {
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes: (UIUserNotificationTypeBadge | UIUserNotificationTypeSound | UIUserNotificationTypeAlert)];
    }
}

/**
 * 推送处理2
 */
//注册用户通知设置
- (void)application:(UIApplication *)application didRegisterUserNotificationSettings: (UIUserNotificationSettings *)notificationSettings {
    // register to receive notifications
    [application registerForRemoteNotifications];
}

/**
 * 推送处理3
 */
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

// 获取DeviceToken失败
- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error{
    NSLog(@"[DeviceToken Error]:%@\n",error.description);
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult result))completionHandler {
    
    NSDictionary *remoteNotificationUserInfo = userInfo;
    NSDictionary *rc = [remoteNotificationUserInfo objectForKey:@"rc"];
    NSString *tId = [rc objectForKey:@"tId"];
    KKConversationController *conversationController = [[KKConversationController alloc] init];
    KKConversation *conversation = [[KKConversation alloc] init];
    conversation.targetId = tId;
    [self showViewController:conversationController];
    completionHandler(UIBackgroundFetchResultNewData);
}

//页在跳转
- (void)showViewController:(UIViewController *)viewController {
    UIViewController *rootVC = [UIApplication sharedApplication].delegate.window.rootViewController;
    if (rootVC && [rootVC isKindOfClass:[UINavigationController class]]) {
        //主页面加载之前，直接用NavigationController push
        UINavigationController *navigationVC = (UINavigationController *)rootVC;
        [navigationVC pushViewController:viewController animated:YES];
    } else if (rootVC && [rootVC isKindOfClass:[UITabBarController class]]) {
        //主页面加载之后，找到当前选中的NavigationController push
        UITabBarController *tabBarVC = (UITabBarController *)rootVC;
        if (tabBarVC.selectedViewController && [tabBarVC.selectedViewController isKindOfClass:[UINavigationController class]]) {
            UINavigationController *navigationVC = (UINavigationController *)tabBarVC.selectedViewController;
            [navigationVC pushViewController:viewController animated:YES];
        }
    }
}


@end
