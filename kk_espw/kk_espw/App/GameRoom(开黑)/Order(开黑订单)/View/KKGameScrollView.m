//
//  KKGameScrollView.m
//  kk_espw
//
//  Created by hsd on 2019/8/29.
//  Copyright © 2019 david. All rights reserved.
//

#import "KKGameScrollView.h"

@implementation KKGameScrollView

/// 是否让子视图响应触摸
/// 返回yes scroll不滚动, 返回no scroll滚动
- (BOOL)touchesShouldBegin:(NSSet<UITouch *> *)touches withEvent:(nullable UIEvent *)event inContentView:(UIView *)view {
    
    // 触摸点在聊天框内
    BOOL isTouchChat = NO;
    
    UIView *superView = view.superview;
    while (superView != nil) {
        if ([superView isKindOfClass:NSClassFromString(@"KKGameChatInputView")]) {
            isTouchChat = YES;
            break;
        } else {
            superView = superView.superview;
        }
    }
    
    if (isTouchChat ||
        [view isKindOfClass:[UITextField class]] ||
        [view isKindOfClass:[UITextView class]]) {
        CCLOG(@"%s", __func__);
    } else {
        if ([self.touchDelegate respondsToSelector:@selector(scrollView:didTouchOtherView:)]) {
            [self.touchDelegate scrollView:self didTouchOtherView:view];
        }
    }
    
    return YES;
}

@end
