//
//  KKConversationSettingChatRecordCell.m
//  kk_espw
//
//  Created by 罗礼豪 on 2019/7/30.
//  Copyright © 2019 david. All rights reserved.
//

#import "KKConversationSettingChatRecordCell.h"

@interface KKConversationSettingChatRecordCell()

@property (nonatomic, strong) UILabel *detailLabel;
@property (nonatomic, strong) UIImageView *arrowImageView;

@end

@implementation KKConversationSettingChatRecordCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setupViews];
    }
    return self;
}

- (void)setupViews {
    _detailLabel = [[UILabel alloc] init];
    _detailLabel.font = [KKFont pingfangFontStyle:PFFontStyleMedium size:16];
    _detailLabel.textColor = rgba(51, 51, 51, 1);
    [self.contentView addSubview:_detailLabel];
    [_detailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView);
        make.left.equalTo(self.contentView).mas_offset(19);
        make.height.mas_equalTo(15);
    }];
    
    _arrowImageView = [[UIImageView alloc] init];
    _arrowImageView.image = [UIImage imageNamed:@"message_setting_arrow"];
    [self.contentView addSubview:_arrowImageView];
    [_arrowImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(8, 14));
        make.right.equalTo(self.contentView).mas_offset(-17);
        make.centerY.equalTo(self.contentView);
    }];
}

- (void)setInfo:(NSString *)info {
    _detailLabel.text = info;
}

@end
