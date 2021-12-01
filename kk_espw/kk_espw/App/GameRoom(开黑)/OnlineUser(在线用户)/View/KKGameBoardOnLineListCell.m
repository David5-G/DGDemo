//
//  KKGameBoardOnLineListCell.m
//  kk_espw
//
//  Created by jingtian9 on 2019/10/22.
//  Copyright © 2019 david. All rights reserved.
//

#import "KKGameBoardOnLineListCell.h"
#import "KKChatRoomUserSimpleModel.h"
#import "KKChatRoomMetalSimpleModel.h"

@interface KKGameBoardOnLineListCell ()
//1. 头像
@property (nonatomic, strong) UIImageView *portraitImageView;
//2. 名字
@property (nonatomic, strong) UILabel *nameLabel;
//3. 大神
@property (nonatomic, strong) UIImageView *tagImg;
//4. 禁言状态
@property (nonatomic, strong) UIButton *forbiddenButton;
//5. 当前model
@property (nonatomic, strong) KKChatRoomUserSimpleModel *currentModel;

@end

@implementation KKGameBoardOnLineListCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        _portraitImageView = New(UIImageView);
        _portraitImageView.left = RH(19);
        _portraitImageView.top = RH(22);
        _portraitImageView.size = CGSizeMake(RH(50), RH(50));
        _portraitImageView.layer.cornerRadius = RH(25);
        _portraitImageView.clipsToBounds = YES;
        [self.contentView addSubview:_portraitImageView];
        
        
        _nameLabel = New(UILabel);
        _nameLabel.left = RH(10) + _portraitImageView.right;
        _nameLabel.top = RH(29);
        _nameLabel.size = CGSizeMake(RH(80), RH(18));
        _nameLabel.font = [KKFont pingfangFontStyle:PFFontStyleMedium size:RH(16)];
        _nameLabel.textColor = KKES_COLOR_BLACK_TEXT;
        [self.contentView addSubview:_nameLabel];
        
        _tagImg = New(UIImageView);
        _tagImg.left = _nameLabel.left;
        _tagImg.top = RH(10) + _nameLabel.bottom;
        _tagImg.size = CGSizeMake(RH(42), RH(14));
        [self.contentView addSubview:_tagImg];
        
        _forbiddenButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _forbiddenButton.left = RH(266);
        _forbiddenButton.top = RH(36);
        _forbiddenButton.backgroundColor = KKES_COLOR_MAIN_YELLOW;
        _forbiddenButton.size = CGSizeMake(RH(70), RH(24));
        _forbiddenButton.titleLabel.font = [KKFont pingfangFontStyle:PFFontStyleRegular size:RH(12)];
        _forbiddenButton.layer.cornerRadius = RH(5);
        [self.contentView addSubview:_forbiddenButton];
        
        [_forbiddenButton addTarget:self action:@selector(forbiddenButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}

- (void)setModel:(KKChatRoomUserSimpleModel *)model {
    _currentModel = model;
    [_portraitImageView sd_setImageWithURL:Url(model.userLogoUrl)];
    _nameLabel.text = model.loginName;
    if (model.userMedalDetails.count > 0) {
        KKChatRoomMetalSimpleModel *simpleModel = model.userMedalDetails.firstObject;
        _tagImg.image = Img([KKDataDealTool returnImageStr:simpleModel.currentMedalLevelConfigCode]);
        _tagImg.hidden = NO;
    }else {
        _tagImg.hidden = YES;
    }
    
    if (model.forbidChat == YES) {
        if (self.isForbiddenList == YES) {
            [_forbiddenButton setTitle:@"解禁" forState:UIControlStateNormal];
        }else {
            [_forbiddenButton setTitle:@"禁言中" forState:UIControlStateNormal];
        }
        [_forbiddenButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    }else {
        [_forbiddenButton setTitle:@"禁言" forState:UIControlStateNormal];
        [_forbiddenButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    }
    /// 是不是房主
    if ([model.ownerId isEqualToString:model.userId]) {
        _forbiddenButton.hidden = NO;
    }else {
        _forbiddenButton.hidden = YES;
    }
    /// 登录用户是不是房主
    if ([model.ownerId isEqualToString:[KKUserInfoMgr shareInstance].userId]) {
        _forbiddenButton.hidden = NO;
    }else {
        _forbiddenButton.hidden = YES;
    }
}

- (void)forbiddenButtonAction:(UIButton *)obj {
    if (self.forbiddenBlock) {
        self.forbiddenBlock(_currentModel, obj);
    }
}
@end
