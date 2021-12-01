//
//  KKMineVCListDoubleCell.m
//  kk_espw
//
//  Created by 景天 on 2019/7/12.
//  Copyright © 2019年 david. All rights reserved.
//

#import "KKMineVCListDoubleCell.h"

@interface KKMineVCListDoubleCell ()

@end

@implementation KKMineVCListDoubleCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.contentView.backgroundColor = [UIColor clearColor];
        ///
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        UIView *whiteView = [[UIView alloc] initWithFrame:CGRectMake([ccui getRH:10], [ccui getRH:5], SCREEN_WIDTH - [ccui getRH:20], RH(100))];
        whiteView.backgroundColor = [UIColor whiteColor];
        whiteView.layer.cornerRadius = 6;
        [self.contentView addSubview:whiteView];

        _icon = [[UIImageView alloc] init];
        _icon.backgroundColor = [UIColor whiteColor];
        _icon.left = [ccui getRH:24];
        _icon.top = [ccui getRH:17];
        _icon.contentMode = UIViewContentModeScaleAspectFit;
        _icon.size = CGSizeMake([ccui getRH:17], [ccui getRH:19]);
        [whiteView addSubview:_icon];
        
        _iconCopy = [[UIImageView alloc] init];
        _iconCopy.backgroundColor = [UIColor whiteColor];
        _iconCopy.left = [ccui getRH:24];
        _iconCopy.top = [ccui getRH:60];
        _iconCopy.contentMode = UIViewContentModeScaleAspectFit;
        _iconCopy.size = CGSizeMake([ccui getRH:17], [ccui getRH:19]);
        [whiteView addSubview:_iconCopy];
        
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.left = [ccui getRH:56];
        _titleLabel.top = [ccui getRH:19];
        _titleLabel.size = CGSizeMake(130, [ccui getRH:14]);
        _titleLabel.font = [ccui getRFS:15];
        [whiteView addSubview:_titleLabel];
        
        _titleLabelCopy = [[UILabel alloc] init];
        _titleLabelCopy.left = [ccui getRH:56];
        _titleLabelCopy.top = [ccui getRH:62];
        _titleLabelCopy.size = CGSizeMake(130, [ccui getRH:14]);
        _titleLabelCopy.font = [ccui getRFS:15];
        [whiteView addSubview:_titleLabelCopy];
        
        _directionImageView = [[UIImageView alloc] init];
        _directionImageView.backgroundColor = [UIColor whiteColor];
        _directionImageView.left = [ccui getRH:327];
        _directionImageView.top = [ccui getRH:17];
        _directionImageView.size = CGSizeMake([ccui getRH:7], [ccui getRH:13]);
        [whiteView addSubview:_directionImageView];
        
        _directionImageViewCopy = [[UIImageView alloc] init];
        _directionImageViewCopy.backgroundColor = [UIColor whiteColor];
        _directionImageViewCopy.left = [ccui getRH:327];
        _directionImageViewCopy.top = [ccui getRH:63];
        _directionImageViewCopy.size = CGSizeMake([ccui getRH:7], [ccui getRH:13]);
        [whiteView addSubview:_directionImageViewCopy];
        
        _titleLabel.font = [ccui getRFS:15];
        _titleLabelCopy.font = [ccui getRFS:15];
        
        UIView *view1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, whiteView.width, [ccui getRH:49])];
        [whiteView addSubview:view1];
        WS(weakSelf)
        [view1 addTapWithTimeInterval:0.2 tapBlock:^(UIView * _Nonnull view) {
            weakSelf.tapRowTopBlock();
        }];
        
        UIView *view2 = [[UIView alloc] initWithFrame:CGRectMake(0, view1.bottom, whiteView.width, [ccui getRH:49])];
        [whiteView addSubview:view2];
        [view2 addTapWithTimeInterval:0.2 tapBlock:^(UIView * _Nonnull view) {
            weakSelf.tapRowBottomBlock();
        }];
        
    }
    return self;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
