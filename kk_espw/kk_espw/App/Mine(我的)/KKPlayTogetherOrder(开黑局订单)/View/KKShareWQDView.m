//
//  KKShareWQDView.m
//  kk_espw
//
//  Created by 景天 on 2019/8/11.
//  Copyright © 2019年 david. All rights reserved.
//

#import "KKShareWQDView.h"

@implementation KKShareWQDView

- (void)setupSubViewsForDisplayView:(UIView *)displayView {
    /// 标题
    UILabel *titleL = New(UILabel);
    titleL.left = 0;
    titleL.top = RH(13);
    titleL.size = CGSizeMake(displayView.width, RH(16));
    titleL.font = [KKFont pingfangFontStyle:PFFontStyleMedium size:16];
    titleL.textColor = KKES_COLOR_BLACK_TEXT;
    titleL.text = @"邀请玩伴";
    titleL.textAlignment = NSTextAlignmentCenter;
    [displayView addSubview:titleL];
    /// KK
    WS(weakSelf)
    CC_Button *kButton = [CC_Button buttonWithType:UIButtonTypeCustom];
    kButton.frame = CGRectMake(RH(51), RH(59), RH(45), RH(41));
    [kButton setTitle:@"KK好友" forState:UIControlStateNormal];
    kButton.titleLabel.font = [KKFont pingfangFontStyle:PFFontStyleMedium size:10];
    [kButton setImage:Img(@"share_kk") forState:UIControlStateNormal];
    [kButton setTitleColor:COLOR_BLACK forState:UIControlStateNormal];
    [displayView addSubview:kButton];
    [kButton addTapWithTimeInterval:0.2 tapBlock:^(UIView * _Nonnull view) {
        [weakSelf hidePopView];
        weakSelf.tapShareKKBlock();
    }];
    /// 微信
    CC_Button *wButton = [CC_Button buttonWithType:UIButtonTypeCustom];
    wButton.frame = CGRectMake(kButton.right + (displayView.width - (3 * RH(45) + 2 * RH(51))) / 2, RH(59), RH(45), RH(41));
    [wButton setTitle:@"微信好友" forState:UIControlStateNormal];
    [wButton setImage:Img(@"share_wx") forState:UIControlStateNormal];
    [wButton setTitleColor:COLOR_BLACK forState:UIControlStateNormal];
    [displayView addSubview:wButton];
    wButton.titleLabel.font = [KKFont pingfangFontStyle:PFFontStyleMedium size:10];
    [wButton addTapWithTimeInterval:0.2 tapBlock:^(UIView * _Nonnull view) {
        [weakSelf hidePopView];
        weakSelf.tapShareWXBlock();
    }];
    /// QQ
    CC_Button *qButton = [CC_Button buttonWithType:UIButtonTypeCustom];
    qButton.frame = CGRectMake(wButton.right + (displayView.width - (3 * RH(45) + 2 * RH(51))) / 2, RH(59), RH(45), RH(41));
    [qButton setTitle:@"QQ好友" forState:UIControlStateNormal];
    [qButton setImage:Img(@"share_qq") forState:UIControlStateNormal];
    [qButton setTitleColor:COLOR_BLACK forState:UIControlStateNormal];
    [displayView addSubview:qButton];
    qButton.titleLabel.font = [KKFont pingfangFontStyle:PFFontStyleMedium size:10];
    [qButton addTapWithTimeInterval:0.2 tapBlock:^(UIView * _Nonnull view) {
        [weakSelf hidePopView];
        weakSelf.tapShareQQBlock();
    }];
    /// 调整按钮文字位置
    [self adjustTextLocationWithObj:qButton];
    [self adjustTextLocationWithObj:wButton];
    [self adjustTextLocationWithObj:kButton];
    /// 横线
    UIView *view = [[UIView alloc] init];
    view.frame = CGRectMake(0, qButton.bottom + RH(25), SCREEN_WIDTH,0.5);
    view.backgroundColor = [UIColor colorWithRed:242/255.0 green:242/255.0 blue:242/255.0 alpha:1.0];
    [displayView addSubview:view];
    /// 取消
    CC_Button *cancelButton = [CC_Button buttonWithType:UIButtonTypeCustom];
    cancelButton.frame = CGRectMake(0, view.bottom, displayView.width, RH(38));
    [cancelButton setTitle:@"取消" forState:UIControlStateNormal];
    [cancelButton setTitleColor:KKES_COLOR_DARK_GRAY_TEXT forState:UIControlStateNormal];
    [displayView addSubview:cancelButton];
    cancelButton.titleLabel.font = [KKFont pingfangFontStyle:PFFontStyleMedium size:13];
    [cancelButton addTapWithTimeInterval:0.2 tapBlock:^(UIView * _Nonnull view) {
        [weakSelf hidePopView];
    }];
}

- (void)adjustTextLocationWithObj:(UIButton *)obj {
    CGFloat offset = 20.0f;
    obj.titleEdgeInsets = UIEdgeInsetsMake(0, -obj.imageView.frame.size.width, -obj.imageView.frame.size.height - offset / 2, 0);
    obj.imageEdgeInsets = UIEdgeInsetsMake(-obj.titleLabel.intrinsicContentSize.height - offset / 2, 0, 0, -obj.titleLabel.intrinsicContentSize.width);
}
@end
