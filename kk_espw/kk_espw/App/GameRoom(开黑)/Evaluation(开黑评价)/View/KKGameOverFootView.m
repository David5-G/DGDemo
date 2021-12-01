//
//  KKGameOverFootView.m
//  kk_espw
//
//  Created by hsd on 2019/8/12.
//  Copyright © 2019 david. All rights reserved.
//

#import "KKGameOverFootView.h"
#import "KKGameRoomContrastModel.h"

@interface KKGameOverFootView ()

@property (nonatomic, strong, nonnull) UILabel *evaluateLabel;      ///< '被评为'
@property (nonatomic, strong, nonnull) UILabel *chargeLabel;        ///< '支付给'
@property (nonatomic, strong, nonnull) UILabel *orderNoLabel;       ///< '订单编号'
@property (nonatomic, strong, nonnull) UILabel *endTimeLabel;       ///< '结束时间'
@property (nonatomic, strong, nonnull) NSMutableArray<UILabel *> *evaluateTagArr; ///< 标签数组

@end

@implementation KKGameOverFootView
#pragma mark - set
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
        
        // 加入到数组
        [self.evaluateTagArr addObject:nameLabel];
        [self.evaluateTagArr addObject:numLabel];
    }
}

- (void)setEvaluateTitleString:(NSString *)evaluateTitleString {
    _evaluateTitleString = evaluateTitleString;
    self.evaluateLabel.text = evaluateTitleString;
}

- (void)setChargeTitleString:(NSString *)chargeTitleString {
    _chargeTitleString = chargeTitleString;
    self.chargeLabel.text = chargeTitleString;
}

- (void)setOrderNoString:(NSString *)orderNoString {
    _orderNoString = orderNoString;
    self.orderNoLabel.text = orderNoString;
}

- (void)setGameEndString:(NSString *)gameEndString {
    _gameEndString = gameEndString;
    self.endTimeLabel.text = gameEndString;
}

#pragma mark - get
- (NSMutableArray<UILabel *> *)evaluateTagArr {
    if (!_evaluateTagArr) {
        _evaluateTagArr = [NSMutableArray array];
    }
    return _evaluateTagArr;
}

#pragma mark - init
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self initSubViews];
    }
    return self;
}

- (void)initSubViews {
    
    self.endTimeLabel = [self createLabelModelWith:nil];
    [self addSubview:self.endTimeLabel];
    [self.endTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self).mas_offset(19);
        make.right.mas_equalTo(self);
        make.height.mas_equalTo(11);
        make.bottom.mas_equalTo(self).mas_offset(-10);
    }];
    
    self.orderNoLabel = [self createLabelModelWith:nil];
    [self addSubview:self.orderNoLabel];
    [self.orderNoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.height.mas_equalTo(self.endTimeLabel);
        make.bottom.mas_equalTo(self.endTimeLabel.mas_top).mas_offset(-9);
    }];
    
    self.chargeLabel = [self createLabelModelWith:nil];
    [self addSubview:self.chargeLabel];
    [self.chargeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.height.mas_equalTo(self.endTimeLabel);
        make.bottom.mas_equalTo(self.orderNoLabel.mas_top).mas_offset(-9);
    }];
    
    self.evaluateLabel = [self createLabelModelWith:nil];
    [self addSubview:self.evaluateLabel];
    [self.evaluateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.height.mas_equalTo(self.endTimeLabel);
        make.bottom.mas_equalTo(self.chargeLabel.mas_top).mas_offset(-9);
    }];
}

- (UILabel * _Nonnull)createLabelModelWith:(NSString * _Nullable)title {
    UILabel *label = [[UILabel alloc] init];
    label.font = [KKFont pingfangFontStyle:PFFontStyleRegular size:10];
    label.textColor = KKES_COLOR_HEX(0xFFFFFF);
    label.text = title;
    return label;
}

@end
