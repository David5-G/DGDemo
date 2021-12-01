//
//  UITableView+KKDropDownAmplification.m
//  kk_espw
//
//  Created by hsd on 2019/7/12.
//  Copyright © 2019 david. All rights reserved.
//

#import "UITableView+KKDropDownAmplification.h"
#import <objc/runtime.h>

@implementation UITableView (KKDropDownAmplification)

#pragma mark - dynamic set get
@dynamic originContentInset;

static const char *kkGameOriginContentInsetsKey = "kkGameOriginContentInsetsKey";
- (void)setOriginContentInset:(UIEdgeInsets)originContentInset {
    NSString *insetString = [NSString stringWithFormat:@"%.2lf:%.2lf:%.2lf:%.2lf",
                             originContentInset.top,
                             originContentInset.left,
                             originContentInset.bottom,
                             originContentInset.right];
    objc_setAssociatedObject(self, kkGameOriginContentInsetsKey, insetString, OBJC_ASSOCIATION_COPY);
}

- (UIEdgeInsets)originContentInset {
    NSString *insetString = objc_getAssociatedObject(self, kkGameOriginContentInsetsKey);
    UIEdgeInsets inset = UIEdgeInsetsZero;
    if (insetString) {
        NSArray *insetArr = [insetString componentsSeparatedByString:@":"];
        if (insetArr.count == 4) {
            inset.top = [insetArr[0] doubleValue];
            inset.left = [insetArr[1] doubleValue];
            inset.bottom = [insetArr[2] doubleValue];
            inset.right = [insetArr[3] doubleValue];
        }
    }
    return inset;
}

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
    self.originContentInset = self.contentInset;
    self.scrollIndicatorInsets = self.contentInset;
    
    headerView.weakScrollView = self;
    [self.backgroundView addSubview:headerView];
}

@end
