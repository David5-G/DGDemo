//
//  KKAddBottomViewCollectionViewCell.m
//  kk_espw
//
//  Created by 景天 on 2019/7/16.
//  Copyright © 2019年 david. All rights reserved.
//

#import "KKAddBottomViewCollectionViewCell.h"

@implementation KKAddBottomViewCollectionViewCell
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _titleButton = [[UIButton alloc] initWithFrame:self.bounds];
        _titleButton.titleLabel.font = [ccui getRFS:12];
        _titleButton.userInteractionEnabled = NO;
        [_titleButton setImage:Img(@"add_card_unselect_pos") forState:UIControlStateNormal];
        [_titleButton setTitleColor:RGB(102, 102, 102) forState:UIControlStateNormal];
        [self.contentView addSubview:_titleButton];
        _titleButton.imageEdgeInsets = UIEdgeInsetsMake(0, -10, 0, 0);
    }
    return self;
}

- (void)setSelected:(BOOL)selected {
    if (selected) {
        [_titleButton setImage:Img(@"add_card_select_pos") forState:UIControlStateNormal];
    }else {
        [_titleButton setImage:Img(@"add_card_unselect_pos") forState:UIControlStateNormal];
    }
}
@end
