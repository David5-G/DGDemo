//
//  KKWangZhePlayHeaderView.m
//  kk_espw
//
//  Created by 景天 on 2019/7/11.
//  Copyright © 2019年 david. All rights reserved.
//

#import "KKKingHeaderView.h"

@implementation KKKingHeaderView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        
        UIImageView *icon = [[UIImageView alloc] initWithFrame:CGRectMake([ccui getRH:16], [ccui getRH:16], [ccui getRH:14], [ccui getRH:16])];
        icon.image = Img(@"icon_red");
        [self addSubview:icon];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(icon.right + 7, [ccui getRH:18], [ccui getRH:100], [ccui getRH:13])];
        label.numberOfLines = 0;
        [self addSubview:label];
        
        NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:@"王者开黑" attributes:@{NSFontAttributeName: [UIFont fontWithName:@"PingFang-SC-Medium" size: 14],NSForegroundColorAttributeName: RGB(51, 51, 51)}];
        label.attributedText = string;
        
        /// 筛选
        _selectButton = [CC_Button buttonWithType:UIButtonTypeCustom];
        _selectButton.frame = CGRectMake(SCREEN_WIDTH - RH(60) - RH(35), [ccui getRH:22], [ccui getRH:60], [ccui getRH:10]);
//        [_selectButton setImage:Img(@"home_dir_down") forState:UIControlStateNormal];
//        [self adjustTextLocationWithObj:_selectButton];
        _selectButton.titleLabel.font = [ccui getRFS:9];
        [self addSubview:_selectButton];
        _selectButton.titleLabel.textAlignment = NSTextAlignmentRight;
        [_selectButton addTarget:self action:@selector(selectButtonAction) forControlEvents:UIControlEventTouchUpInside];
        [_selectButton setTitleColor:KKES_COLOR_GRAY_TEXT forState:UIControlStateNormal];
        
        UIImageView *dir = New(UIImageView);
        dir.left = _selectButton.right;
        dir.top = RH(22);
        dir.size = CGSizeMake(RH(11), RH(7));
        dir.image = Img(@"home_dir_down");
        [self addSubview:dir];
    }
    return self;
}

- (void)adjustTextLocationWithObj:(UIButton *)obj {
    obj.titleEdgeInsets = UIEdgeInsetsMake(0, -RH(45), 0, 0);
    obj.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, -obj.titleLabel.intrinsicContentSize.width);
}

- (void)selectButtonAction {
    if (self.didTapSelectButtonBlock) {
        self.didTapSelectButtonBlock();
    }
}

@end
