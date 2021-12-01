//
//  KKSexSelectView.m
//  kk_espw
//
//  Created by 景天 on 2019/7/16.
//  Copyright © 2019年 david. All rights reserved.
//

#import "KKSexSelectView.h"

@interface KKSexSelectView ()
@property (nonatomic, strong) UIButton *maleButton;
@property (nonatomic, strong) UIButton *feMaleButton;

@end

@implementation KKSexSelectView
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(15, RH(17), RH(45), RH(14))];
        title.textColor = KKES_COLOR_BLACK_TEXT;
        title.text = @"*性别";
        title.textAlignment = NSTextAlignmentLeft;
        title.font = RF(15);
        [self addSubview:title];
        /// 男神
        _maleButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _maleButton.frame = CGRectMake(15, RH(44), RH(82), RH(38));
        [self addSubview:_maleButton];
        _maleButton.backgroundColor = [UIColor whiteColor];
        [_maleButton setTitle:@"男生" forState:UIControlStateNormal];
        [self adjustTextLocationWithObj:_maleButton];
        _maleButton.layer.cornerRadius = 4;
        _maleButton.layer.borderColor = KKES_COLOR_MAIN_YELLOW.CGColor;
        _maleButton.layer.borderWidth = 1;
        _maleButton.titleLabel.font = [KKFont pingfangFontStyle:PFFontStyleMedium size:13];
        [_maleButton setTitleColor:KKES_COLOR_DARK_GRAY_TEXT forState:UIControlStateNormal];
        [_maleButton setImage:Img(@"home_male_blue") forState:UIControlStateNormal];
        WS(weakSelf)
        [_maleButton addTapWithTimeInterval:0.2 tapBlock:^(UIView * _Nonnull view) {
            weakSelf.maleButton.layer.borderColor = KKES_COLOR_MAIN_YELLOW.CGColor;
            weakSelf.feMaleButton.layer.borderColor = RGB(234, 234, 234).CGColor;
            if (weakSelf.didSelectViewWithMaleBlock) {
                weakSelf.didSelectViewWithMaleBlock();
            }
        }];
        /// 女神
        _feMaleButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _feMaleButton.frame = CGRectMake(_maleButton.right +  RH(15), RH(44), RH(82), RH(38));
        [self addSubview:_feMaleButton];
        [_feMaleButton setTitle:@"女生" forState:UIControlStateNormal];
        [self adjustTextLocationWithObj:_feMaleButton];
        _feMaleButton.layer.cornerRadius = 4;
        _feMaleButton.layer.borderColor = RGB(234, 234, 234).CGColor;
        _feMaleButton.layer.borderWidth = 1;
        _feMaleButton.titleLabel.font = [KKFont pingfangFontStyle:PFFontStyleMedium size:13];
        [_feMaleButton setTitleColor:KKES_COLOR_DARK_GRAY_TEXT forState:UIControlStateNormal];
        [_feMaleButton setImage:Img(@"home_female_pink") forState:UIControlStateNormal];

        [_feMaleButton addTapWithTimeInterval:0.2 tapBlock:^(UIView * _Nonnull view) {
            weakSelf.feMaleButton.layer.borderColor = KKES_COLOR_MAIN_YELLOW.CGColor;
            weakSelf.maleButton.layer.borderColor = RGB(234, 234, 234).CGColor;
            if (weakSelf.didSelectViewWithFeMaleBlock) {
                weakSelf.didSelectViewWithFeMaleBlock();
            }
        }];
    }
    return self;
}

- (void)setSex:(NSString *)sex {
    if ([sex isEqualToString:@"M"]) {
        self.maleButton.layer.borderColor = KKES_COLOR_MAIN_YELLOW.CGColor;
        self.feMaleButton.layer.borderColor = RGB(234, 234, 234).CGColor;
    }else {
        self.feMaleButton.layer.borderColor = KKES_COLOR_MAIN_YELLOW.CGColor;
        self.maleButton.layer.borderColor = RGB(234, 234, 234).CGColor;
    }
}

- (void)adjustTextLocationWithObj:(UIButton *)obj {
    CGFloat offset = 10.0f;
    obj.titleEdgeInsets = UIEdgeInsetsMake(0, offset, 0, 0);
    obj.imageEdgeInsets = UIEdgeInsetsMake(0, -offset, 0, 0);

}
@end
