//
//  KKGameOverFootView.m
//  kk_espw
//
//  Created by hsd on 2019/8/12.
//  Copyright © 2019 david. All rights reserved.
//

#import "KKGameOrderDetailFootView.h"
#import "KKGameRoomContrastModel.h"

@interface KKGameOrderDetailFootView ()

@property (nonatomic, strong, nonnull) UILabel *evaluateLabel;      ///< '被评为'
@property (nonatomic, strong, nonnull) UILabel *chargeLabel;        ///< '支付给'
@property (nonatomic, strong, nonnull) UILabel *orderNoLabel;       ///< '订单编号'
@property (nonatomic, strong, nonnull) UILabel *endTimeLabel;       ///< '结束时间'
@property (nonatomic, strong, nonnull) NSMutableArray<UILabel *> *evaluateTagArr; ///< 标签数组

@property (nonatomic, strong, nonnull) UILabel *titleLabel;
@property (nonatomic, strong, nonnull) UILabel *subTitleLabel;
@property (nonatomic, strong, nonnull) CC_Button *endBtn;
@property (nonatomic, strong, nonnull) CC_Button *groupBtn;

@property (nonatomic, assign) CGFloat bottomSafeDistance;

@end

@implementation KKGameOrderDetailFootView
#pragma mark - set

- (void)setHiddenTopView:(BOOL)hiddenTopView {
    _hiddenTopView = hiddenTopView;
    self.evaluateLabel.hidden = hiddenTopView;
    self.chargeLabel.hidden = hiddenTopView;
    self.orderNoLabel.hidden = hiddenTopView;
    self.endTimeLabel.hidden = hiddenTopView;
    
    for (UILabel *label in self.evaluateTagArr) {
        label.hidden = hiddenTopView;
    }
}

- (void)setHiddenBottomView:(BOOL)hiddenBottomView {
    _hiddenBottomView = hiddenBottomView;
    self.titleLabel.hidden = hiddenBottomView;
    self.subTitleLabel.hidden = hiddenBottomView;
    self.endBtn.hidden = hiddenBottomView;
    self.groupBtn.hidden = hiddenBottomView;
}

- (void)setEvaluateTitleString:(NSString *)evaluateTitleString {
    _evaluateTitleString = evaluateTitleString;
    self.evaluateLabel.text = evaluateTitleString;
}

- (void)setChargeTitleString:(NSString *)chargeTitleString {
    _chargeTitleString = chargeTitleString;
    self.chargeLabel.text = chargeTitleString;
    
    if (chargeTitleString == nil) {
        [self.chargeLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(0);
            make.top.mas_equalTo(self.evaluateLabel.mas_bottom).mas_offset(0);
        }];
    } else {
        [self.chargeLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(12);
            make.top.mas_equalTo(self.evaluateLabel.mas_bottom).mas_offset(9);
        }];
    }
}

- (void)setOrderNoString:(NSString *)orderNoString {
    _orderNoString = orderNoString;
    self.orderNoLabel.text = orderNoString;
    
    if (orderNoString == nil) {
        [self.orderNoLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(0);
            make.top.mas_equalTo(self.chargeLabel.mas_bottom).mas_offset(0);
        }];
    } else {
        [self.orderNoLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(12);
            make.top.mas_equalTo(self.chargeLabel.mas_bottom).mas_offset(9);
        }];
    }
}

- (void)setGameEndString:(NSString *)gameEndString {
    _gameEndString = gameEndString;
    self.endTimeLabel.text = gameEndString;
}

- (void)setTitleString:(NSString *)titleString {
    _titleString = titleString;
    self.titleLabel.text = titleString;
}

- (void)setSubTitleString:(NSString *)subTitleString {
    _subTitleString = subTitleString;
    self.subTitleLabel.text = subTitleString;
}

- (void)setTitle:(NSString *)title forState:(UIControlState)state forButtonType:(KKGameOrderDetailButtonType)btnType {
    if (btnType == KKGameOrderDetailButtonTypeNoBorder) {
        [self.groupBtn setTitle:title forState:state];
    } else if (btnType == KKGameOrderDetailButtonTypeBorder) {
        [self.endBtn setTitle:title forState:state];
    }
}

/// 设置按钮可否交互
- (void)setButtonEnable:(BOOL)enable forButtonType:(KKGameOrderDetailButtonType)btnType {
    if (btnType == KKGameOrderDetailButtonTypeNoBorder) {
        [self.groupBtn setEnabled:enable];
        if (enable) {
            self.groupBtn.backgroundColor = KKES_COLOR_HEX(0x999999);
        } else {
            self.groupBtn.backgroundColor = KKES_COLOR_HEX(0xECC165);
        }
        
    } else if (btnType == KKGameOrderDetailButtonTypeBorder) {
        [self.endBtn setEnabled:enable];
        if (enable) {
            self.endBtn.layer.borderColor = KKES_COLOR_HEX(0xECC165).CGColor;
            [self.endBtn setTitleColor:KKES_COLOR_HEX(0xECC165) forState:UIControlStateNormal];
        } else {
            self.endBtn.layer.borderColor = KKES_COLOR_HEX(0x999999).CGColor;
            [self.endBtn setTitleColor:KKES_COLOR_HEX(0x999999) forState:UIControlStateNormal];
        }
    }
}

- (void)setUserGameTagArr:(NSArray<KKGameUserGameTagModel *> *)userGameTagArr {
    _userGameTagArr = userGameTagArr;
    
    // 移除之前添加的
    if (self.evaluateTagArr.count > 0) {
        for (UILabel *evaLabel in self.evaluateTagArr) {
            [evaLabel removeFromSuperview];
        }
        [self.evaluateTagArr removeAllObjects];
    }
    
    // 数据判空
    if (!userGameTagArr) {
        return;
    }
    
    // 重新添加
    for (KKGameUserGameTagModel *tagModel in userGameTagArr) {
        
        if (!tagModel.tagCode) {
            continue;
        }
        
        NSString *tagName = [KKGameRoomContrastModel shareInstance].evaluateMapDic[tagModel.tagCode];
        if (!tagName) {
            continue;
        }
        
        UIFont *font = [KKFont kkFontStyle:KKFontStyleREEJIHonghuangLiMedium size:10];
        CGFloat height = 15;
        CGFloat width = [tagName widthForHeight:height font:font] + 6; // 文字左右各空出3pt
        
        // 描述
        UILabel *nameLabel = [[UILabel alloc] init];
        nameLabel.backgroundColor = KKES_COLOR_HEX(0xEF7334);
        nameLabel.layer.cornerRadius = 2;
        nameLabel.layer.masksToBounds = YES;
        nameLabel.font = font;
        nameLabel.textColor = KKES_COLOR_HEX(0xFFFFFF);
        nameLabel.textAlignment = NSTextAlignmentCenter;
        nameLabel.text = tagName;
        [self addSubview:nameLabel];
        
        // 次数
        UILabel *numLabel = [[UILabel alloc] init];
        numLabel.font = font;
        numLabel.textColor = KKES_COLOR_HEX(0xEF7334);
        numLabel.textAlignment = NSTextAlignmentCenter;
        numLabel.text = [NSString stringWithFormat:@"x%ld", tagModel.gameTagCount];
        [self addSubview:numLabel];
        
        // 最后添加的label
        CGFloat toLeft = 6;
        UILabel *lastLabel = [self.evaluateTagArr lastObject];
        
        // 取最左侧label
        if (!lastLabel) {
            toLeft = 11;
            lastLabel = self.evaluateLabel;
        }
        
        /// 约束
        [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(lastLabel.mas_right).mas_offset(toLeft);
            make.height.mas_equalTo(height);
            make.width.mas_equalTo(width);
            make.centerY.mas_equalTo(self.evaluateLabel);
        }];
        [numLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(nameLabel.mas_right).mas_equalTo(3);
            make.height.mas_equalTo(height);
            make.centerY.mas_equalTo(self.evaluateLabel);
        }];
        
        nameLabel.hidden = _hiddenTopView;
        numLabel.hidden = _hiddenTopView;
        
        // 加入到数组
        [self.evaluateTagArr addObject:nameLabel];
        [self.evaluateTagArr addObject:numLabel];
    }
}

#pragma mark - get
- (NSMutableArray<UILabel *> *)evaluateTagArr {
    if (!_evaluateTagArr) {
        _evaluateTagArr = [NSMutableArray array];
    }
    return _evaluateTagArr;
}

#pragma mark - init
- (instancetype)initWithFrame:(CGRect)frame bottomDistance:(CGFloat)distance {
    if (self = [super initWithFrame:frame]) {
        [self initSubViews];
    }
    return self;
}

- (void)initSubViews {
    
    self.evaluateLabel = [self createLabelModelWith:nil];
    [self addSubview:self.evaluateLabel];
    [self.evaluateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self).mas_offset(19);
        make.top.mas_equalTo(self.mas_top).mas_offset(5);
        make.height.mas_equalTo(12);
    }];
    
    self.chargeLabel = [self createLabelModelWith:nil];
    [self addSubview:self.chargeLabel];
    [self.chargeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.evaluateLabel);
        make.right.mas_equalTo(self);
        make.height.mas_equalTo(12);
        make.top.mas_equalTo(self.evaluateLabel.mas_bottom).mas_offset(9);
    }];
    
    self.orderNoLabel = [self createLabelModelWith:nil];
    [self addSubview:self.orderNoLabel];
    [self.orderNoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(self.chargeLabel);
        make.height.mas_equalTo(12);
        make.top.mas_equalTo(self.chargeLabel.mas_bottom).mas_offset(9);
    }];
    
    self.endTimeLabel = [self createLabelModelWith:nil];
    [self addSubview:self.endTimeLabel];
    [self.endTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(self.chargeLabel);
        make.height.mas_offset(12);
        make.top.mas_equalTo(self.orderNoLabel.mas_bottom).mas_offset(9);
    }];
    
    WS(weakSelf)
    
    self.endBtn = [[CC_Button alloc] init];
    self.endBtn.layer.cornerRadius = 5;
    self.endBtn.layer.masksToBounds = YES;
    self.endBtn.layer.borderWidth = 1;
    self.endBtn.layer.borderColor = KKES_COLOR_HEX(0xECC165).CGColor;
    self.endBtn.titleLabel.font = [KKFont pingfangFontStyle:PFFontStyleRegular size:15];
    [self.endBtn setTitleColor:KKES_COLOR_HEX(0xECC165) forState:UIControlStateNormal];
    [self.endBtn setTitleColor:KKES_COLOR_HEX(0x999999) forState:UIControlStateHighlighted];
    [self.endBtn setTitle:nil forState:UIControlStateNormal];
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
    [self.groupBtn setTitle:nil forState:UIControlStateNormal];
    [self.groupBtn addTappedOnceDelay:0.2 withBlock:^(UIButton *button) {
        [weakSelf clickGotoGroup];
    }];
    [self addSubview:self.groupBtn];
    [self.groupBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.endBtn.mas_right).mas_offset(20);
        make.right.mas_equalTo(self).mas_offset(-20);
        make.height.bottom.mas_equalTo(self.endBtn);
    }];
    
    self.endBtn.hidden = YES;
    self.groupBtn.hidden = YES;
    
    self.subTitleLabel = [[UILabel alloc] init];
    self.subTitleLabel.font = [KKFont pingfangFontStyle:PFFontStyleRegular size:12];
    self.subTitleLabel.textColor = KKES_COLOR_HEX(0xFFFFFF);
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
    [self addSubview:self.titleLabel];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.subTitleLabel);
        make.height.mas_equalTo(15);
        make.right.mas_lessThanOrEqualTo(self);
        make.bottom.mas_equalTo(self.subTitleLabel.mas_top).mas_equalTo(-7);
    }];
}

- (UILabel * _Nonnull)createLabelModelWith:(NSString * _Nullable)title {
    UILabel *label = [[UILabel alloc] init];
    label.font = [KKFont pingfangFontStyle:PFFontStyleRegular size:10];
    label.textColor = KKES_COLOR_HEX(0xFFFFFF);
    label.text = title;
    return label;
}

#pragma mark - Action
- (void)clickEndGame {
    if ([self.delegate respondsToSelector:@selector(footViewDidClickBorderButton)]) {
        [self.delegate footViewDidClickBorderButton];
    }
}

- (void)clickGotoGroup {
    if ([self.delegate respondsToSelector:@selector(footViewDidClickNoBorderButton)]) {
        [self.delegate footViewDidClickNoBorderButton];
    }
}

@end
