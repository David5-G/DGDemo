//
//  KKGameOrderDetailBottomView.m
//  kk_espw
//
//  Created by hsd on 2019/8/15.
//  Copyright © 2019 david. All rights reserved.
//

#import "KKGameOrderDetailBottomView.h"

@interface KKGameOrderDetailBottomView ()

@property (nonatomic, strong, nonnull) UILabel *titleLabel;
@property (nonatomic, strong, nonnull) UILabel *subTitleLabel;
@property (nonatomic, strong, nonnull) CC_Button *endBtn;
@property (nonatomic, strong, nonnull) CC_Button *groupBtn;

@property (nonatomic, assign) CGFloat bottomSafeDistance;

@end

@implementation KKGameOrderDetailBottomView

#pragma mark - init
- (instancetype)initWithFrame:(CGRect)frame bottomDistance:(CGFloat)distance {
    if (self = [super initWithFrame:frame]) {
        [self initSubViews];
    }
    return self;
}

- (void)initSubViews {
    
    WS(weakSelf)
    
    self.endBtn = [[CC_Button alloc] init];
    self.endBtn.layer.cornerRadius = 5;
    self.endBtn.layer.masksToBounds = YES;
    self.endBtn.layer.borderWidth = 1;
    self.endBtn.layer.borderColor = KKES_COLOR_HEX(0xECC165).CGColor;
    self.endBtn.titleLabel.font = [KKFont pingfangFontStyle:PFFontStyleRegular size:15];
    [self.endBtn setTitleColor:KKES_COLOR_HEX(0xECC165) forState:UIControlStateNormal];
    [self.endBtn setTitleColor:KKES_COLOR_HEX(0x999999) forState:UIControlStateHighlighted];
    [self.endBtn setTitle:@"结束" forState:UIControlStateNormal];
    [self.endBtn addTappedOnceDelay:0.2 withBlock:^(UIButton *button) {
        [weakSelf clickEndGame];
    }];
    [self addSubview:self.endBtn];
    [self.endBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self).mas_offset(25);
        make.bottom.mas_equalTo(self).mas_equalTo(-39 - self.bottomSafeDistance);
        make.width.mas_equalTo(75);
        make.height.mas_equalTo(34);
    }];
    
    
    self.groupBtn = [[CC_Button alloc] init];
    self.groupBtn.layer.cornerRadius = 5;
    self.groupBtn.layer.masksToBounds = YES;
    self.groupBtn.titleLabel.font = [KKFont pingfangFontStyle:PFFontStyleRegular size:15];
    [self.groupBtn setTitleColor:KKES_COLOR_HEX(0xFFFFFF) forState:UIControlStateNormal];
    [self.groupBtn setTitleColor:KKES_COLOR_HEX(0x999999) forState:UIControlStateHighlighted];
    [self.groupBtn setBackgroundColor:KKES_COLOR_HEX(0xECC165)];
    [self.groupBtn setTitle:@"进群" forState:UIControlStateNormal];
    [self.groupBtn addTappedOnceDelay:0.2 withBlock:^(UIButton *button) {
        [weakSelf clickGotoGroup];
    }];
    [self addSubview:self.groupBtn];
    [self.groupBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.endBtn.mas_right).mas_offset(20);
        make.right.mas_equalTo(self).mas_offset(-20);
        make.height.bottom.mas_equalTo(self.endBtn);
    }];
    
    
    self.subTitleLabel = [[UILabel alloc] init];
    self.subTitleLabel.font = [KKFont pingfangFontStyle:PFFontStyleRegular size:12];
    self.subTitleLabel.textColor = KKES_COLOR_HEX(0xFFFFFF);
    self.subTitleLabel.text = @"点击进群,畅玩游戏";
    [self addSubview:self.subTitleLabel];
    [self.subTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self).mas_offset(26);
        make.height.mas_equalTo(14);
        make.right.mas_lessThanOrEqualTo(self);
        make.bottom.mas_equalTo(self.endBtn.mas_top).mas_offset(-28);
    }];
    
    
    self.titleLabel = [[UILabel alloc] init];
    self.titleLabel.font = [KKFont pingfangFontStyle:PFFontStyleSemibold size:13];
    self.titleLabel.textColor = KKES_COLOR_HEX(0xFFFFFF);
    self.titleLabel.text = @"开始游戏啦";
    [self addSubview:self.titleLabel];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.subTitleLabel);
        make.height.mas_equalTo(15);
        make.right.mas_lessThanOrEqualTo(self);
        make.bottom.mas_equalTo(self.subTitleLabel.mas_top).mas_equalTo(-7);
    }];
}

#pragma mark - Action
- (void)clickEndGame {
    
}

- (void)clickGotoGroup {
    
}

@end
