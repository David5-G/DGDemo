//
//  UICollectionView+KKDropDownAmplification.m
//  kk_espw
//
//  Created by hsd on 2019/7/15.
//  Copyright © 2019 david. All rights reserved.
//

#import "UICollectionView+KKDropDownAmplification.h"
#import <objc/runtime.h>

@implementation UICollectionView (KKDropDownAmplification)

#pragma mark - Action
- (void)kkAddHeaderDropDownAmplificationView:(KKHeaderAmplificationView *)headerView {
    
    if (!headerView) {
        return;
    }
    
    if (!self.backgroundView) {
        UIView *bgView = [[UIView alloc] init];
        self.backgroundView = bgView;
    }
    
    // 设置内容偏移
    self.contentInset = UIEdgeInsetsMake(headerView.kkHeaderViewHeight - headerView.kkBottomCoverHeight, 0, 0, 0);
    self.scrollIndicatorInsets = self.contentInset;
    
    headerView.weakScrollView = self;
    [self.backgroundView addSubview:headerView];
}

@end
