//
//  KKHeaderAmplificationView.m
//  kk_espw
//
//  Created by hsd on 2019/7/15.
//  Copyright © 2019 david. All rights reserved.
//

#import "KKHeaderAmplificationView.h"

@interface KKHeaderAmplificationView ()

@end

@implementation KKHeaderAmplificationView

#pragma mark - init
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.userInteractionEnabled = YES;
        self.kkOriginFrame = frame;
        self.kkHeaderViewHeight = frame.size.height;
        self.kkBottomCoverHeight = 10;
    }
    return self;
}

#pragma mark - Action
/// 添加监听
- (void)addObserverForScroll {
    [self.weakScrollView addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew context:nil];
}

/// 移除监听
- (void)removeObserverForScroll {
    [self.weakScrollView removeObserver:self forKeyPath:@"contentOffset"];
}

#pragma mark - KVO
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    if ([keyPath isEqualToString:@"contentOffset"]) {
        CGPoint newOffset = [change[NSKeyValueChangeNewKey] CGPointValue];
        [self updateFrameWithOffset:newOffset];
    }
}

- (void)updateFrameWithOffset:(CGPoint)newOffset {
    
    CGFloat defaultContentOffset = self.kkHeaderViewHeight - self.kkBottomCoverHeight;
    CGFloat navHeight = [UIApplication sharedApplication].statusBarFrame.size.height + 44;
    
    if (newOffset.y <= -defaultContentOffset) { // 向下拖动
        
        CGFloat scale = fabs(newOffset.y + defaultContentOffset);
        CGFloat height = self.kkHeaderViewHeight + scale;
        CGFloat width = self.kkOriginFrame.size.width * (1 + scale / defaultContentOffset);
        
        CGRect frame = self.frame;
        frame.origin.x = (self.kkOriginFrame.size.width - width) / 2;
        frame.size.height = height;
        frame.size.width = width;
        
        self.frame = frame;
        
    } else if (newOffset.y > -defaultContentOffset && newOffset.y <= -navHeight) { //(未触及导航栏前)悬停
        self.frame = self.kkOriginFrame;
        
    } else if (newOffset.y > -navHeight && newOffset.y <= 0) {
        CGRect frame = self.kkOriginFrame;
        frame.origin.y = -(navHeight + newOffset.y);
        self.frame = frame;
        
    } else { //移除屏幕
        CGRect frame = self.kkOriginFrame;
        frame.origin.y = -self.kkHeaderViewHeight;
        self.frame = frame;
    }
}

@end
