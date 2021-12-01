//
//  KKGameOverEvaluateCell.m
//  kk_espw
//
//  Created by hsd on 2019/7/26.
//  Copyright © 2019 david. All rights reserved.
//

#import "KKGameOverEvaluateCell.h"
#import "KKGameRoomContrastModel.h"

static NSString *kk_game_tag_compressiveKing  = @"KAN_YA_WANG";
static NSString *kk_game_tag_wildKing         = @"YE_WANG";
static NSString *kk_game_tag_pitKing          = @"KENG_HUO";
static NSString *kk_game_tag_assitKing        = @"QUAN_NENG_FU_ZHU";
static NSString *kk_game_tag_dharmaKing       = @"FA_WANG";
static NSInteger kk_game_tag_default          = -1;

@interface KKGameOverEvaluateCell ()

@property (nonatomic, strong, nonnull) UIView *bgContentView;
@property (nonatomic, strong, nonnull) UIImageView *leftRoadImageView;
@property (nonatomic, strong, nonnull) UIImageView *roomOwnerImageView;
@property (nonatomic, strong, nonnull) UIImageView *playerIconImageView;
@property (nonatomic, strong, nonnull) UIImageView *sexImageView;
@property (nonatomic, strong, nonnull) UIView *lineView;
@property (nonatomic, strong, nonnull) UILabel *roadLabel;
@property (nonatomic, strong, nonnull) UILabel *nickLabel;

@property (nonatomic, strong, nonnull) CC_Button *compressiveKingBtn;   ///< 抗压王
@property (nonatomic, strong, nonnull) CC_Button *wildKingBtn;          ///< 野王
@property (nonatomic, strong, nonnull) CC_Button *pitKingBtn;           ///< 坑货
@property (nonatomic, strong, nonnull) CC_Button *assitKingBtn;         ///< 全能辅助
@property (nonatomic, strong, nonnull) CC_Button *dharmaKingBtn;        ///< 法王

@property (nonatomic, strong, nullable) CAGradientLayer *gradientLayer;

@end

@implementation KKGameOverEvaluateCell

#pragma mark - set
- (void)setUserModel:(KKGameEvaluateUserSimpleModel *)userModel {
    _userModel = userModel;
    
    if (userModel.positionType.name) {
        self.roadLabel.text = [KKGameRoomContrastModel shareInstance].positionMapDic[userModel.positionType.name].title;
    }
    
    self.roomOwnerImageView.hidden = !userModel.isRoomOwner;
    
    NSString *userLogoUrl = userModel.userLogoUrl;
    if (userModel.userId && ![userLogoUrl containsString:userModel.userId]) {
        userLogoUrl = [NSString stringWithFormat:@"%@%@", userLogoUrl, userModel.userId];
    }
    [self.playerIconImageView sd_setImageWithURL:[NSURL URLWithString:userLogoUrl]];
    
    if (userModel.sex.name) {
        self.sexImageView.image = [KKGameRoomContrastModel shareInstance].sexMapDic[userModel.sex.name];
    }
    
    self.nickLabel.text = userModel.nickName;
}

- (void)setTagArray:(NSArray<KKGameEvaluateTagSimpleModel *> *)tagArray {
    _tagArray = tagArray;
    
    // 恢复默认
    self.compressiveKingBtn.tag = kk_game_tag_default;
    self.wildKingBtn.tag = kk_game_tag_default;
    self.pitKingBtn.tag = kk_game_tag_default;
    self.assitKingBtn.tag = kk_game_tag_default;
    self.dharmaKingBtn.tag = kk_game_tag_default;
    
    // 重新赋值数据
    for (KKGameEvaluateTagSimpleModel *tagModel in tagArray) {
        if ([tagModel.tagCode isEqualToString:kk_game_tag_compressiveKing]) {
            self.compressiveKingBtn.tag = tagModel.ID;
            [self.compressiveKingBtn setTitle:tagModel.tagName forState:UIControlStateNormal];
            
        } else if ([tagModel.tagCode isEqualToString:kk_game_tag_wildKing]) {
            self.wildKingBtn.tag = tagModel.ID;
            [self.wildKingBtn setTitle:tagModel.tagName forState:UIControlStateNormal];
            
        } else if ([tagModel.tagCode isEqualToString:kk_game_tag_pitKing]) {
            self.pitKingBtn.tag = tagModel.ID;
            [self.pitKingBtn setTitle:tagModel.tagName forState:UIControlStateNormal];
            
        } else if ([tagModel.tagCode isEqualToString:kk_game_tag_assitKing]) {
            self.assitKingBtn.tag = tagModel.ID;
            [self.assitKingBtn setTitle:tagModel.tagName forState:UIControlStateNormal];
            
        } else if ([tagModel.tagCode isEqualToString:kk_game_tag_dharmaKing]) {
            self.dharmaKingBtn.tag = tagModel.ID;
            [self.dharmaKingBtn setTitle:tagModel.tagName forState:UIControlStateNormal];
        }
    }
    
    // 是否可交互
    self.compressiveKingBtn.enabled = (self.compressiveKingBtn.tag != kk_game_tag_default);
    self.wildKingBtn.enabled = (self.wildKingBtn.tag != kk_game_tag_default);
    self.pitKingBtn.enabled = (self.pitKingBtn.tag != kk_game_tag_default);
    self.assitKingBtn.enabled = (self.assitKingBtn.tag != kk_game_tag_default);
    self.dharmaKingBtn.enabled = (self.dharmaKingBtn.tag != kk_game_tag_default);
}

#pragma mark - init
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self initSubViews];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    if (!self.gradientLayer) {
        [self addGredientLayer];
    }
}

- (void)addGredientLayer {
    CAGradientLayer *gLayer = [CAGradientLayer layer];
    gLayer.frame = CGRectMake(0, 0, self.contentView.bounds.size.width - 19, self.contentView.bounds.size.height);
    gLayer.startPoint = CGPointMake(0.4, 0.5);
    gLayer.endPoint = CGPointMake(1, 0.5);
    gLayer.colors = @[(__bridge id)RGB(42, 43, 60).CGColor, (__bridge id)KKES_COLOR_HEX(0x100D15).CGColor];
    gLayer.locations = @[@(0.0), @(1.0)];
    self.gradientLayer = gLayer;
    [self.bgContentView.layer addSublayer:gLayer];
}

- (void)initSubViews {
    
    self.leftRoadImageView = [[UIImageView alloc] init];
    self.leftRoadImageView.image = Img(@"game_over_evaluate_left_logo");
    [self.contentView addSubview:self.leftRoadImageView];
    [self.leftRoadImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.bottom.mas_equalTo(self.contentView);
        make.width.mas_equalTo(26);
    }];
    
    self.bgContentView = [[UIView alloc] init];
    self.bgContentView.backgroundColor = KKES_COLOR_HEX(0x2A2B3C);
    [self.contentView addSubview:self.bgContentView];
    [self.bgContentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.leftRoadImageView.mas_right).mas_offset(-7);
        make.top.bottom.right.mas_equalTo(self.contentView);
    }];
    
    self.roadLabel = [[UILabel alloc] init];
    self.roadLabel.textColor = KKES_COLOR_HEX(0x1D1E29);
    self.roadLabel.font = [KKFont pingfangFontStyle:PFFontStyleRegular size:10];
    self.roadLabel.textAlignment = NSTextAlignmentLeft;
    [self.leftRoadImageView addSubview:self.roadLabel];
    [self.roadLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.leftRoadImageView).mas_offset(3);
        make.centerY.mas_equalTo(self.leftRoadImageView).mas_offset(-1);
        make.height.mas_equalTo(11);
    }];
    
    self.roomOwnerImageView = [[UIImageView alloc] init];
    self.roomOwnerImageView.image = Img(@"game_room_owner");
    [self.contentView addSubview:self.roomOwnerImageView];
    [self.roomOwnerImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(10);
        make.left.mas_equalTo(self.contentView).mas_offset(24);
        make.top.mas_equalTo(self.contentView).mas_offset(6);
    }];
    
    self.playerIconImageView = [[UIImageView alloc] init];
    self.playerIconImageView.layer.cornerRadius = 20;
    self.playerIconImageView.layer.masksToBounds = YES;
    [self.contentView addSubview:self.playerIconImageView];
    [self.playerIconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(40);
        make.left.mas_equalTo(self.leftRoadImageView.mas_right).mas_offset(13);
        make.top.mas_equalTo(self.contentView).mas_offset(4);
    }];
    
    self.sexImageView = [[UIImageView alloc] init];
    [self.contentView addSubview:self.sexImageView];
    [self.sexImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(10);
        make.right.mas_equalTo(self.playerIconImageView.mas_right).mas_offset(2);
        make.bottom.mas_equalTo(self.playerIconImageView.mas_bottom).mas_offset(1);
    }];
    
    self.lineView = [[UIView alloc] init];
    self.lineView.backgroundColor = KKES_COLOR_HEX(0x212230);
    [self.contentView addSubview:self.lineView];
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.playerIconImageView.mas_right).mas_offset(18);
        make.top.mas_equalTo(self.contentView).mas_offset(7);
        make.bottom.mas_equalTo(self.contentView).mas_offset(-7);
        make.width.mas_equalTo(1);
    }];
    
    self.nickLabel = [[UILabel alloc] init];
    self.nickLabel.textColor = KKES_COLOR_HEX(0xFFFFFF);
    self.nickLabel.font = [KKFont pingfangFontStyle:PFFontStyleRegular size:9];
    self.nickLabel.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:self.nickLabel];
    [self.nickLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.leftRoadImageView.mas_right);
        make.right.mas_equalTo(self.lineView.mas_left);
        make.height.mas_equalTo(10);
        make.top.mas_equalTo(self.playerIconImageView.mas_bottom).mas_offset(7);
    }];
    
    
    CGFloat width = (SCREEN_WIDTH - 130 - 10) / 3;
    CGFloat height = 24;
    
    self.compressiveKingBtn = [self createButtonModel:nil];
    [self.contentView addSubview:self.compressiveKingBtn];
    [self.compressiveKingBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.lineView.mas_right).mas_offset(17);
        make.top.mas_equalTo(self.contentView).mas_offset(6);
        make.width.mas_equalTo(width);
        make.height.mas_equalTo(height);
    }];
    
    self.wildKingBtn = [self createButtonModel:nil];
    [self.contentView addSubview:self.wildKingBtn];
    [self.wildKingBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.compressiveKingBtn.mas_right).mas_offset(5);
        make.centerY.mas_equalTo(self.compressiveKingBtn);
        make.width.mas_equalTo(width);
        make.height.mas_equalTo(height);
    }];
    
    self.pitKingBtn = [self createButtonModel:nil];
    [self.contentView addSubview:self.pitKingBtn];
    [self.pitKingBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.wildKingBtn.mas_right).mas_offset(5);
        make.centerY.mas_equalTo(self.wildKingBtn);
        make.width.mas_equalTo(width);
        make.height.mas_equalTo(height);
    }];
    
    self.assitKingBtn = [self createButtonModel:nil];
    [self.contentView addSubview:self.assitKingBtn];
    [self.assitKingBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(self.compressiveKingBtn);
        make.top.mas_equalTo(self.compressiveKingBtn.mas_bottom).mas_offset(4);
        make.height.mas_equalTo(height);
    }];
    
    self.dharmaKingBtn = [self createButtonModel:nil];
    [self.contentView addSubview:self.dharmaKingBtn];
    [self.dharmaKingBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(self.wildKingBtn);
        make.top.mas_equalTo(self.assitKingBtn);
        make.height.mas_equalTo(height);
    }];
    
    [self.contentView sendSubviewToBack:self.bgContentView];
}

- (CC_Button * _Nonnull)createButtonModel:(NSString * _Nullable)title {
    CC_Button *btn = [[CC_Button alloc] init];
    btn.tag = kk_game_tag_default;
    btn.enabled = NO;
    btn.titleLabel.font = [KKFont pingfangFontStyle:PFFontStyleRegular size:11];
    [btn setTitleColor:KKES_COLOR_HEX(0xFFFFFF) forState:UIControlStateNormal];
    [btn setTitleColor:KKES_COLOR_HEX(0x929292) forState:UIControlStateHighlighted];
    [btn setImage:Img(@"game_over_evaluate_box") forState:UIControlStateNormal];
    [btn setImage:Img(@"game_over_evaluate_select") forState:UIControlStateSelected];
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setImageEdgeInsets:UIEdgeInsetsMake(5, 0, 5, 0)];
    [btn setTitleEdgeInsets:UIEdgeInsetsMake(0, 5, 0, 0)];
    [btn setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    WS(weakSelf)
    [btn addTappedOnceDelay:0.2 withBlock:^(UIButton *button) {
        [weakSelf clickPlayerSkillBtns:(CC_Button *)button];
    }];
    return btn;
}

#pragma mark - Action
- (void)clickPlayerSkillBtns:(CC_Button *)btn {
    
    // 记录上一次的状态
    BOOL oldIsSelect = btn.isSelected;
    
    // 全部恢复默认
    self.compressiveKingBtn.selected = NO;
    self.wildKingBtn.selected = NO;
    self.pitKingBtn.selected = NO;
    self.assitKingBtn.selected = NO;
    self.dharmaKingBtn.selected = NO;
    
    // 状态变换
    btn.selected = !oldIsSelect;
    
    if (btn.isSelected) {
        NSString *positiveStr = (btn.tag == 5 ? @"false" : @"true");
        NSString *evaluateStr = [NSString stringWithFormat:@"%@-%@-%@",
                                 self.userModel.userId,
                                 @(btn.tag),
                                 positiveStr];
        if (self.boxSelectBlock) {
            self.boxSelectBlock(YES, evaluateStr);
        }
        
    } else {
        if (self.boxSelectBlock) {
            self.boxSelectBlock(NO, nil);
        }
    }
}

#pragma mark - system
- (void)awakeFromNib {
    [super awakeFromNib];
    [self addGredientLayer];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
