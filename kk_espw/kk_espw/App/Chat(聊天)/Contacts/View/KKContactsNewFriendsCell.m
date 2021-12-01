//
//  KKContactsHeaderView.m
//  kk_espw
//
//  Created by 罗礼豪 on 2019/7/15.
//  Copyright © 2019 david. All rights reserved.
//

#import "KKContactsNewFriendsCell.h"

@interface KKContactsNewFriendsCell()

@end

@implementation KKContactsNewFriendsCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.contentView.backgroundColor = [UIColor whiteColor];
        [self setupViews];
    }
    return self;
}

- (void)setupViews {

    UILabel *newsFriendsLabel = [[UILabel alloc] init];
    newsFriendsLabel.userInteractionEnabled = YES;
    newsFriendsLabel.text = @"新朋友";
    [self.contentView addSubview:newsFriendsLabel];
    [newsFriendsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).mas_offset(15);
        make.centerY.equalTo(self.contentView);
        make.height.mas_equalTo(15);
    }];
}

@end
