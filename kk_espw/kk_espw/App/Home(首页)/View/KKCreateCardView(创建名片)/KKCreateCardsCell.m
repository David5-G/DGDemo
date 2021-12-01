//
//  KKCreateCardsCell.m
//  kk_espw
//
//  Created by 景天 on 2019/7/11.
//  Copyright © 2019年 david. All rights reserved.
//

#import "KKCreateCardsCell.h"

@interface KKCreateCardsCell ()
@end

@implementation KKCreateCardsCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _title = [[UILabel alloc] initWithFrame:self.bounds];
        _title.font = [ccui getRFS:12];
        _title.textColor = KKES_COLOR_GRAY_TEXT;
        _title.textAlignment = NSTextAlignmentCenter;
        _title.backgroundColor = RGB(238, 238, 238);
        _title.layer.cornerRadius = self.frame.size.height / 2;
        _title.clipsToBounds = YES;
        [self.contentView addSubview:_title];
    }
    return self;
}

- (void)setSelected:(BOOL)selected {
    if (selected) {
        _title.backgroundColor = KKES_COLOR_MAIN_YELLOW;
        _title.textColor = [UIColor whiteColor];
    }else {
        _title.backgroundColor = RGB(238, 238, 238);
        _title.textColor = KKES_COLOR_GRAY_TEXT;
    }
}
@end
