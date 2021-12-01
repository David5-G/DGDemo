//
//  KKContactsCell.m
//  kk_espw
//
//  Created by 罗礼豪 on 2019/7/11.
//  Copyright © 2019 david. All rights reserved.
//

#import "KKContactsCell.h"
@interface KKContactsCell()
{
    UIImageView *_iconImageView;
    UILabel *_userNameLabel;
}
@end

@implementation KKContactsCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        _iconImageView = [[UIImageView alloc] init];
        _iconImageView.layer.cornerRadius = [ccui getRH:20];
        _iconImageView.layer.masksToBounds = YES;
        _iconImageView.backgroundColor = [UIColor blackColor];
        [self.contentView addSubview:_iconImageView];
        [_iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.contentView);
            make.size.mas_equalTo(CGSizeMake([ccui getRH:40], [ccui getRH:40]));
            make.left.equalTo(self.contentView).mas_offset([ccui getRH:12]);
        }];
        
        _userNameLabel = [[UILabel alloc] init];
        _userNameLabel.text = @"董监高";
//        _userNameLabel.font = [UIFont pingFangSCWithWeight:<#(PFFontWeightStyle)#> size:<#(CGFloat)#>];
        _userNameLabel.textColor = rgba(51, 51, 51, 1);
        [self.contentView addSubview:_userNameLabel];
        [_userNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.contentView);
            make.left.equalTo(self->_iconImageView.mas_right).mas_offset(12);
        }];
    }
    return self;
}

-(void)loadModel:(KKContactModel *)model
{
    [_iconImageView sd_setImageWithURL:[NSURL URLWithString:model.logo]];
    _userNameLabel.text = model.name;
}
@end
