//
//  KKWangZhePlayHeaderView.m
//  kk_espw
//
//  Created by 景天 on 2019/7/11.
//  Copyright © 2019年 david. All rights reserved.
//

#import "KKSelectHeaderView.h"

@implementation KKSelectHeaderView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        
        UIImageView *icon = [[UIImageView alloc] initWithFrame:CGRectMake([ccui getRH:15], [ccui getRH:16], [ccui getRH:14], [ccui getRH:16])];
        icon.image = Img(@"icon_red");
        [self addSubview:icon];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(icon.right + 7, [ccui getRH:18], [ccui getRH:100], [ccui getRH:13])];
        label.numberOfLines = 0;
        [self addSubview:label];
        
        NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:@"王者开黑" attributes:@{NSFontAttributeName: [UIFont fontWithName:@"PingFang-SC-Medium" size: 14],NSForegroundColorAttributeName: RGB(51, 51, 51)}];
        label.attributedText = string;
        
        WS(weakSelf)
        UIView *selectView = New(UIView);
        selectView.frame = CGRectMake(SCREEN_WIDTH - RH(80) - RH(19), [ccui getRH:0], [ccui getRH:80], [ccui getRH:50]);
        [self addSubview:selectView];
        [selectView addTapWithTimeInterval:1 tapBlock:^(UIView * _Nonnull view) {
            [weakSelf tapSelectViewAction];
        }];
        
        _selectTitleL = New(UILabel);
        _selectTitleL.left = 0;
        _selectTitleL.top = 0;
        _selectTitleL.size = CGSizeMake(RH(60), RH(50));
        _selectTitleL.font = [KKFont pingfangFontStyle:PFFontStyleRegular size:RH(10)];
        _selectTitleL.textAlignment = NSTextAlignmentRight;
        _selectTitleL.textColor = KKES_COLOR_GRAY_TEXT;
        [selectView addSubview:_selectTitleL];
        
        UIImageView *dir = New(UIImageView);
        dir.left = _selectTitleL.right + RH(2);
        dir.top = RH(21.5);
        dir.size = CGSizeMake(RH(11), RH(10));
        dir.image = Img(@"home_dir_down1");
        [selectView addSubview:dir];
        
    }
    return self;
}

- (void)setSelectViewTitle:(NSString *)selectViewTitle {
    _selectTitleL.text = selectViewTitle;
}

- (void)tapSelectViewAction {
    if (self.didTapSelectButtonBlock) {
        self.didTapSelectButtonBlock();
    }
}

@end
