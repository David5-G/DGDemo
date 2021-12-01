//
//  KKConversationSettingOtherCell.m
//  kk_espw
//
//  Created by 罗礼豪 on 2019/7/30.
//  Copyright © 2019 david. All rights reserved.
//

#import "KKConversationSettingOtherCell.h"

@interface KKConversationSettingOtherCell()

@property (nonatomic, strong) UILabel *detailLabel;
@property (nonatomic, strong) UIView *lineView;
@property (nonatomic, strong) UISwitch *swithButton;
@property (nonatomic, strong) UIImageView *arrowImageView;

@end

@implementation KKConversationSettingOtherCell

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
    
    
    _lineView = [[UIView alloc] init];
    _lineView.backgroundColor = rgba(246, 247, 249, 1);
    [self.contentView addSubview:_lineView];
    [_lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).mas_offset(18);
        make.right.equalTo(self.contentView).mas_offset(-18);
        make.bottom.equalTo(self.contentView);
        make.height.mas_equalTo(1);
    }];
    
    _swithButton = [[UISwitch alloc] init];
    [_swithButton addTarget:self action:@selector(swithButtonDidTipped:) forControlEvents:UIControlEventValueChanged];
    [self.contentView addSubview:_swithButton];
    [_swithButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView);
        make.right.equalTo(self.contentView).mas_offset(-16);
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

- (void)swithButtonDidTipped:(UISwitch *)swithButton {
    if (swithButton.tag == 0) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(conversationIsNoTrouble:)]) {
            [self.delegate conversationIsNoTrouble:swithButton.isOn];
        }
    } else if (swithButton.tag == 1) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(conversationIsTop:)]) {
            [self.delegate conversationIsTop:swithButton.isOn];
        }
    }
}

- (void)setupUI:(NSString *)info withIndex:(NSIndexPath *)indexPath andConversation:(KKConversation *)conversation {
    _detailLabel.text = info;
    if (indexPath.row == 2) {
        _lineView.hidden = YES;
        _swithButton.hidden = YES;
        _arrowImageView.hidden = NO;
    } else if (indexPath.row == 0) {
        _swithButton.tag = indexPath.row;
        _swithButton.hidden = NO;
        _lineView.hidden = NO;
        _arrowImageView.hidden = YES;
        [_swithButton setOn:conversation.isNoTrouble];
    } else if (indexPath.row == 1) {
        _swithButton.tag = indexPath.row;
        _swithButton.hidden = NO;
        _lineView.hidden = NO;
        _arrowImageView.hidden = YES;
        [_swithButton setOn:conversation.isTop];
    }
}

@end
