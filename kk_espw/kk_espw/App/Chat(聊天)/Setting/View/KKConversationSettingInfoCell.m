//
//  KKConversationSettingInfoCell.m
//  kk_espw
//
//  Created by 罗礼豪 on 2019/7/30.
//  Copyright © 2019 david. All rights reserved.
//

#import "KKConversationSettingInfoCell.h"

@interface KKConversationSettingInfoCell()

@property (nonatomic, strong) UIImageView *iconImageView;
@property (nonatomic, strong) UILabel *nickNameLabel;

@end

@implementation KKConversationSettingInfoCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setupViews];
    }
    return self;
}

- (void)setupViews {
    _iconImageView = [[UIImageView alloc] init];
    _iconImageView.layer.cornerRadius = 23;
    _iconImageView.layer.masksToBounds = YES;
    [self.contentView addSubview:_iconImageView];
    [_iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(self.contentView).mas_offset(12);
        make.size.mas_equalTo(CGSizeMake(46, 46));
    }];
    
    _nickNameLabel = [[UILabel alloc] init];
    _nickNameLabel.font = [KKFont pingfangFontStyle:PFFontStyleMedium size:19];
    _nickNameLabel.textColor = rgba(51, 51, 51, 1);
    [self.contentView addSubview:_nickNameLabel];
    [_nickNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.iconImageView);
        make.left.equalTo(self.iconImageView.mas_right).mas_offset(14);
        make.right.equalTo(self.contentView).mas_offset(-15);
        make.height.mas_equalTo(19);
    }];
}

- (void)setConversation:(KKConversation *)conversation {
    [_iconImageView sd_setImageWithURL:[NSURL URLWithString:conversation.head]];
    _nickNameLabel.text = conversation.conversationTitle;
}

@end
