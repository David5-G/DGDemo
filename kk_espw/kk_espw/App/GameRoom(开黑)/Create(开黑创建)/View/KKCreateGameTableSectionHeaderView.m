//
//  KKCreateGameTableHeaderView.m
//  kk_espw
//
//  Created by hsd on 2019/7/17.
//  Copyright © 2019 david. All rights reserved.
//

#import "KKCreateGameTableSectionHeaderView.h"

@interface KKCreateGameTableSectionHeaderView ()

@property (nonatomic, strong, nonnull) UILabel *titleLabel;

@end

@implementation KKCreateGameTableSectionHeaderView


/**
 设置标题文本

 @param allStr 显示的全部文字
 @param attriStr 需要特殊处理的文字(如果为nil, 则正常显示标题文本)
 */
- (void)setTitle:(NSString *_Nonnull)allStr attriStr:(NSString *_Nullable)attriStr {
    
    NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithString:allStr];
    
    if (attriStr) {
        NSDictionary *attriDic = @{
                                   NSFontAttributeName: [KKFont pingfangFontStyle:PFFontStyleRegular size:12],
                                   };
        [text addAttributes:attriDic range:[allStr rangeOfString:attriStr]];
    }
    
    self.titleLabel.attributedText = text;
    
}

#pragma mark - init
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self initTitleLabel];
    }
    return self;
}

- (void)initTitleLabel {
    self.titleLabel = [[UILabel alloc] init];
    self.titleLabel.font = [KKFont pingfangFontStyle:PFFontStyleMedium size:16];
    self.titleLabel.textColor = KKES_COLOR_HEX(0x333333);
    self.titleLabel.textAlignment = NSTextAlignmentLeft;
    [self addSubview:self.titleLabel];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self).mas_offset(15);
        make.top.mas_equalTo(self).mas_offset(13);
        make.bottom.mas_equalTo(self).mas_offset(-13);
        make.right.mas_equalTo(self);
    }];
}



@end
