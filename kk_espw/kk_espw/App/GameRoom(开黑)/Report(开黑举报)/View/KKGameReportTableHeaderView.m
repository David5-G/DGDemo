//
//  KKGameReportTableHeaderView.m
//  kk_espw
//
//  Created by hsd on 2019/7/25.
//  Copyright © 2019 david. All rights reserved.
//

#import "KKGameReportTableHeaderView.h"

@interface KKGameReportTableHeaderView ()

@property (nonatomic, strong, nonnull) UILabel *titleLabel;

@end

@implementation KKGameReportTableHeaderView

- (void)setTitleString:(NSString *)titleString {
    _titleString = titleString;
    self.titleLabel.text = titleString;
}

- (void)setTitleFont:(UIFont *)titleFont {
    _titleFont = titleFont;
    self.titleLabel.font = titleFont;
}

- (void)setTopInset:(CGFloat)topInset {
    _topInset = topInset;
    [self.titleLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self).mas_offset(topInset);
    }];
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setupSubViews];
    }
    return self;
}

- (void)setupSubViews {
    self.titleLabel = [[UILabel alloc] init];
    self.titleLabel.numberOfLines = 0;
    self.titleLabel.textColor = KKES_COLOR_HEX(0x999999);
    self.titleLabel.font = [KKFont pingfangFontStyle:PFFontStyleMedium size:14];
    self.titleLabel.textAlignment = NSTextAlignmentLeft;
    self.titleLabel.text = @"请选择举报类型";
    [self addSubview:self.titleLabel];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self).mas_offset(25);
        make.right.mas_lessThanOrEqualTo(self).mas_offset(-25);
        make.top.mas_equalTo(self).mas_offset(15);
        make.bottom.mas_equalTo(self).mas_offset(-12);
    }];
}


@end
