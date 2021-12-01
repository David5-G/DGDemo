//
//  KKTabBadgeValueManager.m
//  kk_espw
//
//  Created by 罗礼豪 on 2019/8/8.
//  Copyright © 2019 david. All rights reserved.
//

#import "KKTabBadgeValueManager.h"
#import "AxcAE_TabBar.h"
#import "KKCustomTabViewController.h"

@implementation KKTabBadgeValueManager

+ (void)setBadgeValue:(int)unreadMessageCount {
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [UIApplication sharedApplication].applicationIconBadgeNumber = unreadMessageCount;
        if ([[UIApplication sharedApplication].delegate.window.rootViewController isKindOfClass:[UITabBarController class]]) {
            KKCustomTabViewController *tabBarController = (KKCustomTabViewController *)[UIApplication sharedApplication].delegate.window.rootViewController;
            for (UIView *subViews in tabBarController.tabBar.subviews) {
                if ([subViews isKindOfClass:[AxcAE_TabBar class]]) {
                    AxcAE_TabBar *tabBar = (AxcAE_TabBar *)subViews;
                    AxcAE_TabBarItem *item = tabBar.tabBarItems[3];
                    if (unreadMessageCount <= 0) {
                        item.badgeLabel.hidden = YES;
                    } else if (unreadMessageCount <= 99) {
                        item.badge = [NSString stringWithFormat:@"%d",unreadMessageCount];
                        item.badgeLabel.hidden = NO;
                    } else {
                        item.badge = @"99+";
                        item.badgeLabel.hidden = NO;
                    }
                }
            }
        }
    });
}

@end
