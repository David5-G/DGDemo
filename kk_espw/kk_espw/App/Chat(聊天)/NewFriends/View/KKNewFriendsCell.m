//
//  KKNewFriendsCell.m
//  kk_espw
//
//  Created by 罗礼豪 on 2019/7/11.
//  Copyright © 2019 david. All rights reserved.
//

#import "KKNewFriendsCell.h"

@interface KKNewFriendsCell()

@property (nonatomic, strong) UIImageView *iconImageView;
@property (nonatomic, strong) UILabel *userNameLabel;
@property (nonatomic, strong) UIButton *acceptStatusButton;

@end

@implementation KKNewFriendsCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setupViews];
    }
    return self;
}

- (void)setupViews {
    _iconImageView = [[UIImageView alloc] init];
    _iconImageView.layer.cornerRadius = 20;
    _iconImageView.layer.masksToBounds = YES;
    _iconImageView.backgroundColor = [UIColor blackColor];
    [self.contentView addSubview:_iconImageView];
    [_iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView);
        make.size.mas_equalTo(CGSizeMake(40, 40));
        make.left.equalTo(self.contentView).mas_offset(12);
    }];
    
    _userNameLabel = [[UILabel alloc] init];
    _userNameLabel.text = @"董监高";
    _userNameLabel.font = [UIFont systemFontOfSize:15];
    _userNameLabel.textColor = rgba(51, 51, 51, 1);
    [self.contentView addSubview:_userNameLabel];
    [_userNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView);
        make.left.equalTo(self.iconImageView.mas_right).mas_offset(12);
    }];
    
    _acceptStatusButton = [[UIButton alloc] init];
    [_acceptStatusButton addTarget:self action:@selector(acceptStatusButtonDidTipped:) forControlEvents:UIControlEventTouchUpInside];
    [_acceptStatusButton setTitle:@"接受" forState:UIControlStateNormal];
    [_acceptStatusButton setTitle:@"已接受" forState:UIControlStateSelected];
    _acceptStatusButton.layer.cornerRadius = 5;
    _acceptStatusButton.backgroundColor = rgba(236, 193, 101, 1);
    [_acceptStatusButton setTitleColor:rgba(255, 255, 255, 1) forState:UIControlStateNormal];
    [_acceptStatusButton setTitleColor:rgba(186, 188, 198, 1) forState:UIControlStateSelected];
    _acceptStatusButton.titleLabel.font = [UIFont systemFontOfSize:13];
    _acceptStatusButton.layer.masksToBounds = YES;
    [self.contentView addSubview:_acceptStatusButton];
    [_acceptStatusButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView);
        make.right.equalTo(self.contentView).mas_offset(-16);
        make.size.mas_equalTo(CGSizeMake(63, 29));
    }];
}

- (void)acceptStatusButtonDidTipped:(UIButton *)sender {
    if (_delegate && [_delegate respondsToSelector:@selector(acceptNewFriendsDidTipped:)]) {
        [_delegate acceptNewFriendsDidTipped:sender];
    }
}

@end
