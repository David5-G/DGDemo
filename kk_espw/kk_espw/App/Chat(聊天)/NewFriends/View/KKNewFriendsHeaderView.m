//
//  KKNewFriendsHeaderView.m
//  kk_espw
//
//  Created by 罗礼豪 on 2019/7/15.
//  Copyright © 2019 david. All rights reserved.
//

#import "KKNewFriendsHeaderView.h"

@interface KKNewFriendsHeaderView()

@property (nonatomic, strong) UILabel *contentLabel;

@end

@implementation KKNewFriendsHeaderView

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithReuseIdentifier:reuseIdentifier];
    if (self) {
        [self setupViews];
    }
    return self;
}

- (void)setupViews {
    _contentLabel = [[UILabel alloc] init];
    _contentLabel.text = @"近三天";
    _contentLabel.textColor = rgba(144, 148, 159, 1);
    _contentLabel.font = [UIFont systemFontOfSize:12];
    [self.contentView addSubview:_contentLabel];
    [_contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView);
        make.left.equalTo(self.contentView).mas_offset(13);
        make.height.mas_equalTo(12);
    }];
}

@end
