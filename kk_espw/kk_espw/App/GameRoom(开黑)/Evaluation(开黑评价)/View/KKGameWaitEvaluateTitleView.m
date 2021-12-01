//
//  KKGameOverEvaluateTitleView.m
//  kk_espw
//
//  Created by hsd on 2019/7/26.
//  Copyright © 2019 david. All rights reserved.
//

#import "KKGameWaitEvaluateTitleView.h"

@interface KKGameWaitEvaluateTitleView ()

@property (nonatomic, strong, nonnull) UILabel *evaluateTitleLabel;     ///< '评价倒计时:'
@property (nonatomic, strong, nonnull) UILabel *countdownLabel;         ///< 倒计时
@property (nonatomic, strong, nonnull) UILabel *describeLabel;          ///< 描述

@end

@implementation KKGameWaitEvaluateTitleView
#pragma mark - set
- (void)setEvaluateTitleStr:(NSString *)evaluateTitleStr {
    _evaluateTitleStr = evaluateTitleStr;
    self.evaluateTitleLabel.text = evaluateTitleStr;
}

- (void)setCountdownStr:(NSString *)countdownStr {
    _countdownStr = countdownStr;
    self.countdownLabel.text = countdownStr;
}

- (void)setDescripeStr:(NSString *)descripeStr {
    _descripeStr = descripeStr;
    self.describeLabel.text = descripeStr;
}

#pragma mark - init
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self initSubViews];
    }
    return self;
}

- (void)initSubViews {
    
    self.evaluateTitleLabel = [[UILabel alloc] init];
    self.evaluateTitleLabel.textColor = KKES_COLOR_HEX(0xFFFFFF);
    self.evaluateTitleLabel.font = [KKFont pingfangFontStyle:PFFontStyleRegular size:14];
    self.evaluateTitleLabel.textAlignment = NSTextAlignmentLeft;
    self.evaluateTitleLabel.text = @"评价倒计时：";
    [self addSubview:self.evaluateTitleLabel];
    [self.evaluateTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self).mas_offset(8);
        make.top.mas_equalTo(self).mas_offset(7);
        make.height.mas_equalTo(15);
    }];
    
    self.countdownLabel = [[UILabel alloc] init];
    self.countdownLabel.textColor = KKES_COLOR_HEX(0xD2A54D);
    self.countdownLabel.font = [KKFont pingfangFontStyle:PFFontStyleRegular size:16];
    self.countdownLabel.textAlignment = NSTextAlignmentLeft;
    self.countdownLabel.text = @"";
    [self addSubview:self.countdownLabel];
    [self.countdownLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.evaluateTitleLabel.mas_right);
        make.centerY.mas_equalTo(self.evaluateTitleLabel);
        make.height.mas_equalTo(18);
    }];
    
    self.describeLabel = [[UILabel alloc] init];
    self.describeLabel.textColor = KKES_COLOR_HEX(0xA0A0A0);
    self.describeLabel.font = [KKFont pingfangFontStyle:PFFontStyleRegular size:9];
    self.describeLabel.textAlignment = NSTextAlignmentLeft;
    self.describeLabel.text = @"每个队友最多可选择一项评价";
    [self addSubview:self.describeLabel];
    [self.describeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.evaluateTitleLabel.mas_left);
        make.right.mas_equalTo(self);
        make.height.mas_equalTo(10);
        make.bottom.mas_equalTo(self).mas_offset(-10);
    }];
}

@end
