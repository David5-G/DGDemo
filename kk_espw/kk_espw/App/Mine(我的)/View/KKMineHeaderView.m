//
//  KKMineHeaderView.m
//  kk_espw
//
//  Created by 景天 on 2019/7/12.
//  Copyright © 2019年 david. All rights reserved.
//

#import "KKMineHeaderView.h"
#import "KKCalculateTextWidthOrHeight.h"
#import "KKMessage.h"
#import "KKUserMedelInfo.h"

@interface KKMineHeaderView ()
@property (nonatomic, strong) UIButton *setupButton;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UIButton *editButton;
@property (nonatomic, strong) UIButton *headerButton;
@property (nonatomic, strong) UIImageView *tagImageView;
@property (nonatomic, strong) UIImageView *sexImageView;
@property (nonatomic, strong) UIButton *walletButton;
@property (nonatomic, strong) UIButton *myCardButton;
@property (nonatomic, strong) UIButton *weekWorkButton;
@property (nonatomic, strong) UILabel *ageLabel;
@end

@implementation KKMineHeaderView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        
        UIImageView *bg = [[UIImageView alloc] initWithFrame:CGRectMake([ccui getRH:161], -[ccui getRH:30], [ccui getRH:214], [ccui getRH:232])];
        bg.image = Img(@"mine_bg");
        [self addSubview:bg];
        
        /// 1. 设置
        _setupButton = [CC_Button buttonWithType:UIButtonTypeCustom];
        _setupButton.frame = CGRectMake([ccui getRH:331], STATUS_BAR_HEIGHT + RH(11), [ccui getRH:17], [ccui getRH:19]);
        [_setupButton setImage:Img(@"mine_setup") forState:UIControlStateNormal];
        [_setupButton addTarget:self action:@selector(setupButtonAction) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_setupButton];
        
        /// 2. 名字
        _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake([ccui getRH:29], [ccui getRH:71], [ccui getRH:139], [ccui getRH:30])];
        _nameLabel.textColor = KKES_COLOR_BLACK_TEXT;
        _nameLabel.font = [KKFont pingfangFontStyle:PFFontStyleSemibold size:23];
        _nameLabel.backgroundColor = KKES_COLOR_BG;
        [self addSubview:_nameLabel];
        
        /// 3. 编辑
        _editButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _editButton.frame = CGRectMake(_nameLabel.right + [ccui getRH:6], [ccui getRH:79], [ccui getRH:14], [ccui getRH:14]);
        [_editButton setImage:Img(@"mine_edit") forState:UIControlStateNormal];
        WS(weakSelf)
        [_editButton addTapWithTimeInterval:0.1 tapBlock:^(UIView * _Nonnull view) {
            if ([weakSelf.delegate respondsToSelector:@selector(didSelectedEditButton)]) {
                [weakSelf.delegate didSelectedEditButton];
            }
        }];
        [self addSubview:_editButton];
        
        _tagImageView = [[UIImageView alloc] initWithFrame:CGRectMake([ccui getRH:30], [ccui getRH:12] + _nameLabel.bottom, [ccui getRH:42], [ccui getRH:14])];
        [self addSubview:_tagImageView];
        
        _sexImageView = [[UIImageView alloc] initWithFrame:CGRectMake([ccui getRH:5] + _tagImageView.right, _tagImageView.top, [ccui getRH:34], [ccui getRH:14])];
        _sexImageView.image = Img(@"mine_male");
        [self addSubview:_sexImageView];
        
        _ageLabel = [[UILabel alloc] initWithFrame:CGRectMake([ccui getRH:17]
                                                                      , 0, [ccui getRH:14], [ccui getRH:14])];
        _ageLabel.font = [ccui getRFS:9];
        _ageLabel.adjustsFontSizeToFitWidth = YES;
        _ageLabel.textColor = [UIColor whiteColor];
        [_sexImageView addSubview:_ageLabel];
        
        _walletButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _walletButton.frame = CGRectMake([ccui getRH:30], [ccui getRH:176], (SCREEN_WIDTH - [ccui getRH:60]) / 3, [ccui getRH:60]);
        [_walletButton setImage:Img(@"mine_wallet") forState:UIControlStateNormal];
        [_walletButton setTitle:@"我的钱包" forState:UIControlStateNormal];
        [_walletButton setTitleColor:RGB(68, 68, 68) forState:UIControlStateNormal];
        _walletButton.titleLabel.font = [ccui getRFS:13];
        [_walletButton addTapWithTimeInterval:0.1 tapBlock:^(UIView * _Nonnull view) {
            if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(didSelectedWalletButton)]) {
                [weakSelf.delegate didSelectedWalletButton];
            }
        }];
        [self addSubview:_walletButton];
        [self adjustTextLocationWithObj:_walletButton];
        
        _myCardButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _myCardButton.frame = CGRectMake(_walletButton.right, [ccui getRH:176], (SCREEN_WIDTH - [ccui getRH:60]) / 3, [ccui getRH:60]);
        [_myCardButton setImage:Img(@"mine_mycard") forState:UIControlStateNormal];
        [_myCardButton setTitle:@"我的名片" forState:UIControlStateNormal];
        [_myCardButton setTitleColor:RGB(68, 68, 68) forState:UIControlStateNormal];
        _myCardButton.titleLabel.font = [ccui getRFS:13];
        [_myCardButton addTapWithTimeInterval:0.1 tapBlock:^(UIView * _Nonnull view) {
            if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(didSelectedCardsButton)]) {
                [weakSelf.delegate didSelectedCardsButton];
            }
        }];
        [self addSubview:_myCardButton];
        [self adjustTextLocationWithObj:_myCardButton];

        
        _weekWorkButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _weekWorkButton.frame = CGRectMake(_myCardButton.right, [ccui getRH:176], (SCREEN_WIDTH - [ccui getRH:60]) / 3, [ccui getRH:60]);
        [_weekWorkButton setImage:Img(@"mine_weekswork") forState:UIControlStateNormal];
        [_weekWorkButton setTitle:@"积分任务" forState:UIControlStateNormal];
        [_weekWorkButton setTitleColor:RGB(68, 68, 68) forState:UIControlStateNormal];
        _weekWorkButton.titleLabel.font = [ccui getRFS:13];
        [_weekWorkButton addTapWithTimeInterval:0.1 tapBlock:^(UIView * _Nonnull view) {
            if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(didSelectedWeeksWorkButton)]) {
                [weakSelf.delegate didSelectedWeeksWorkButton];
            }
        }];
        [self addSubview:_weekWorkButton];
        [self adjustTextLocationWithObj:_weekWorkButton];

        
        self.headerButton = [UIButton buttonWithType:UIButtonTypeCustom];
        self.headerButton.frame = CGRectMake([ccui getRH:280], _setupButton.bottom + RH(10), [ccui getRH:79], [ccui getRH:79]);
        self.headerButton.layer.cornerRadius = RH(39.5);
        self.headerButton.clipsToBounds = YES;
        self.headerButton.backgroundColor = KKES_COLOR_BG;
        [self.headerButton addTapWithTimeInterval:0.1 tapBlock:^(UIView * _Nonnull view) {
            if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(didSelectedHeaderButton)]) {
                [weakSelf.delegate didSelectedHeaderButton];
            }
        }];
        [self addSubview:self.headerButton];
    }
    return self;
}

- (void)adjustTextLocationWithObj:(UIButton *)obj {
    CGFloat offset = 20.0f;
    obj.titleEdgeInsets = UIEdgeInsetsMake(0, -obj.imageView.frame.size.width, -obj.imageView.frame.size.height - offset / 2, 0);
    obj.imageEdgeInsets = UIEdgeInsetsMake(-obj.titleLabel.intrinsicContentSize.height - offset / 2, 0, 0, -obj.titleLabel.intrinsicContentSize.width);
}

- (void)setupButtonAction {
    if (self.delegate && [self.delegate respondsToSelector:@selector(didSelectedSetupButton)]) {
        [self.delegate didSelectedSetupButton];
    }
}

- (void)setMineInfo:(KKUserInfoModel *)mineInfo {
    NSString *nameStr;
    if (mineInfo.nickName.length > 8) {
        nameStr = [NSString stringWithFormat:@"%@%@", [mineInfo.nickName substringToIndex:8], @"..."];
        /// 调整宽度
        _nameLabel.width = [KKCalculateTextWidthOrHeight getWidthWithAttributedText:nameStr font:[KKFont pingfangFontStyle:PFFontStyleSemibold size:23] height:RH(30)];
        _nameLabel.text = nameStr;
    }else {
        _nameLabel.width = [KKCalculateTextWidthOrHeight getWidthWithAttributedText:mineInfo.nickName font:[KKFont pingfangFontStyle:PFFontStyleSemibold size:23] height:RH(30)];
        _nameLabel.text = mineInfo.nickName;
    }
    
    _nameLabel.backgroundColor = [UIColor clearColor];
    /// 调整编辑按钮的X
    _editButton.left = _nameLabel.right + [ccui getRH:6];
    /// 头像
    NSString *url = [NSString stringWithFormat:@"%@", mineInfo.userLogoUrl];
    [self.headerButton sd_setImageWithURL:Url(url) forState:UIControlStateNormal];
    /// 性别标签
    /// 年纪
    _ageLabel.text = mineInfo.age;
    if ([mineInfo.age isEqualToString:@"-1"]) {
        _ageLabel.hidden = YES;
        _sexImageView.width = RH(14);
        if ([mineInfo.sex.name isEqualToString:@"M"]) {
            _sexImageView.image = Img(@"male_noage");
        }else {
            _sexImageView.image = Img(@"female_noage");
        }
    }else {
        _sexImageView.width = RH(34);
        if ([mineInfo.sex.name isEqualToString:@"M"]) {
            _sexImageView.image = Img(@"mine_male");
        }else {
            _sexImageView.image = Img(@"mine_female");
        }
        _ageLabel.hidden = NO;
    }
    
    /// 大神标签
    if (mineInfo.userMedalDetailList.count <= 0) {
        _tagImageView.hidden = YES;
        _sexImageView.left = RH(30);

    }else {
        KKUserMedelInfo *userMedalDetail = mineInfo.userMedalDetailList.firstObject;
        _tagImageView.image = Img([KKDataDealTool returnImageStr:userMedalDetail.currentMedalLevelConfigCode]);
        _tagImageView.hidden = NO;
        _sexImageView.left = [ccui getRH:5] + _tagImageView.right;
    }
}
@end
