//
//  KKKCoinCollectionViewCell.m
//  kk_espw
//
//  Created by 景天 on 2019/7/18.
//  Copyright © 2019年 david. All rights reserved.
//

#import "KKKCoinCollectionViewCell.h"
#import "UIView+LSCore.h"
#import "KKRechargeRate.h"

@interface KKKCoinCollectionViewCell()
@property (nonatomic, strong) UILabel *kLabel; /// K币
@property (nonatomic, strong) UILabel *yLabel; /// 元

@end

@implementation KKKCoinCollectionViewCell
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.layer.cornerRadius = RH(5);
        self.layer.borderWidth = 1;
        
        _yLabel = New(UILabel);
        _yLabel.left = RH(0);
        _yLabel.top = RH(41);
        _yLabel.size = CGSizeMake(RH(95), RH(29));
        _yLabel.text = @"4.6K";
        _yLabel.backgroundColor = KKES_COLOR_MAIN_YELLOW;
        _yLabel.textAlignment = NSTextAlignmentCenter;
        [_yLabel addRoundedCorners:UIRectCornerBottomLeft | UIRectCornerBottomRight withRadii:CGSizeMake(RH(5), RH(5))];
        _yLabel.font = RF(15);
        _yLabel.textColor = KKES_COLOR_GRAY_TEXT;
        [self.contentView addSubview:_yLabel];
        
        _kLabel = New(UILabel);
        _kLabel.left = RH(0);
        _kLabel.top = RH(0);
        _kLabel.size = CGSizeMake(RH(95), RH(41));
        _kLabel.text = @"4.6K";
        _kLabel.textAlignment = NSTextAlignmentCenter;
        _kLabel.font = RF(15);
        _kLabel.textColor = KKES_COLOR_GRAY_TEXT;
        [self.contentView addSubview:_kLabel];
        
        _kLabel.textColor = RGB(118, 118, 118);
        _yLabel.textColor = RGB(118, 118, 118);
        _yLabel.backgroundColor = RGB(237, 237, 237);
        self.layer.borderColor = RGB(237, 237, 237).CGColor;
    }
    return self;
}

- (void)setSelected:(BOOL)selected {
    if (selected) {
        _kLabel.textColor = KKES_COLOR_MAIN_YELLOW;
        _yLabel.textColor = [UIColor whiteColor];
        _yLabel.backgroundColor = KKES_COLOR_MAIN_YELLOW;
        self.layer.borderColor = KKES_COLOR_MAIN_YELLOW.CGColor;
    }else {
        _kLabel.textColor = RGB(118, 118, 118);
        _yLabel.textColor = RGB(118, 118, 118);
        _yLabel.backgroundColor = RGB(237, 237, 237);
        self.layer.borderColor = RGB(237, 237, 237).CGColor;
    }
}

- (void)setRate:(KKRechargeRate *)rate {
    _kLabel.text = rate.kCoin;
    _yLabel.text = [NSString stringWithFormat:@"¥%@", rate.rmb];
}
@end
