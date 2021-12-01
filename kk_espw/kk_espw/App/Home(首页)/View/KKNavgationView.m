//
//  KKNavgationVIew.m
//  kk_espw
//
//  Created by jingtian9 on 2019/10/12.
//  Copyright © 2019 david. All rights reserved.
//

#import "KKNavgationView.h"

@implementation KKNavgationView
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        /// KK电竞
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(RH(20), 0, RH(100), RH(23))];
        titleLabel.textAlignment = NSTextAlignmentLeft;
        titleLabel.textColor = KKES_COLOR_BLACK_TEXT;
        titleLabel.text = @"KK电竞";
        titleLabel.font = [KKFont pingfangFontStyle:PFFontStyleSemibold size:RH(21)];
        [self addSubview:titleLabel];
        /// 搜索
        CC_Button *searchButton = [CC_Button buttonWithType:UIButtonTypeCustom];
        [searchButton setImage:Img(@"home_search") forState:UIControlStateNormal];
        [searchButton addTarget:self action:@selector(searchButtonAction) forControlEvents:UIControlEventTouchUpInside];
        searchButton.frame = CGRectMake([ccui getRH:337], 0, [ccui getRH:19], [ccui getRH:17]);
        [self addSubview:searchButton];
    }
    return self;
}

- (void)searchButtonAction {
    if (self.didNavgationSearchButtonBlock) {
        self.didNavgationSearchButtonBlock();
    }
}

@end
