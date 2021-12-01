//
//  KKGameOverEvaluateFooterView.m
//  kk_espw
//
//  Created by hsd on 2019/7/29.
//  Copyright © 2019 david. All rights reserved.
//

#import "KKGameOverEvaluateFooterView.h"

@interface KKGameOverEvaluateFooterView ()

@property (nonatomic, strong, nonnull) UILabel *orderNumberLabel;

@end

@implementation KKGameOverEvaluateFooterView

- (void)setTitleString:(NSString *)titleString {
    _titleString = titleString;
    self.orderNumberLabel.text = titleString;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self initSubViews];
    }
    return self;
}

- (void)initSubViews {
    self.orderNumberLabel = [[UILabel alloc] init];
    self.orderNumberLabel.textColor = KKES_COLOR_HEX(0x999999);
    self.orderNumberLabel.font = [KKFont pingfangFontStyle:PFFontStyleRegular size:10];
    [self addSubview:self.orderNumberLabel];
    [self.orderNumberLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(self);
        make.top.mas_equalTo(self).mas_offset(15);
        make.height.mas_equalTo(12);
    }];
}

@end
