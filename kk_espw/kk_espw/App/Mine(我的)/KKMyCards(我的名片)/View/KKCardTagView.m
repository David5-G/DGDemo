//
//  KKCardTagView.m
//  kk_espw
//
//  Created by 景天 on 2019/7/16.
//  Copyright © 2019年 david. All rights reserved.
//

#import "KKCardTagView.h"
#import "KKCalculateTextWidthOrHeight.h"
#import "KKTag.h"
@interface KKCardTagView ()
@property (nonatomic, strong) UIImageView *tagImageView;
@property (nonatomic, strong) UILabel *tagCountLabel;
@end

@implementation KKCardTagView
- (instancetype)initWithFrame:(CGRect)frame withTag:(KKTag *)tag {
    self = [super initWithFrame:frame];
    if (self) {
        [self setUIWithTag:tag.tagCode text:tag.gameTagCount];
    }
    return self;
}

- (void)setUIWithTag:(NSString *)tag text:(NSString *)text {
    /*
     KAN_YA_WANG
     QUAN_NENG_FU_ZHU
     FA_WANG
     YE_WANG
     KENG_HUO
     */
    CGFloat w = 0;
    if ([tag isEqualToString:@"YE_WANG"] || [tag isEqualToString:@"KENG_HUO"] || [tag isEqualToString:@"FA_WANG"]) {
        w = RH(25);
    }else if ([tag isEqualToString:@"QUAN_NENG_FU_ZHU"]){
        w = RH(45);
    }else {
        w = RH(35);
    }
    _tagImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, w, RH(15))];
    [self addSubview:_tagImageView];
    _tagImageView.backgroundColor = [UIColor orangeColor];
    if ([tag isEqualToString:@"YE_WANG"]) {
        _tagImageView.image = Img(@"ye_wang");
    }else if ([tag isEqualToString:@"FA_WANG"]) {
        _tagImageView.image = Img(@"fa_wang");
    }else if ([tag isEqualToString:@"QUAN_NENG_FU_ZHU"]) {
        _tagImageView.image = Img(@"fu_zhu");
    }else if ([tag isEqualToString:@"KENG_HUO"]) {
        _tagImageView.image = Img(@"keng_huo");
    }else if ([tag isEqualToString:@"KAN_YA_WANG"]) {
        _tagImageView.image = Img(@"kang_ya_wang");
    }
    [_tagImageView addRoundedCorners:UIRectCornerTopLeft | UIRectCornerBottomLeft withRadii:CGSizeMake(2, 2)];
    _tagCountLabel = [[UILabel alloc] initWithFrame:CGRectMake(_tagImageView.right, 0, [KKCalculateTextWidthOrHeight getWidthWithAttributedText:text font:[KKFont pingfangFontStyle:PFFontStyleRegular size:9] height:RH(15)] + RH(4), RH(15))];
    _tagCountLabel.text = text;
    _tagCountLabel.font = [KKFont pingfangFontStyle:PFFontStyleRegular size:9] ;
    _tagCountLabel.textAlignment = NSTextAlignmentCenter;
    _tagCountLabel.textColor = RGB(239, 115, 52);
    _tagCountLabel.layer.borderColor = RGB(239, 115, 52).CGColor;
    _tagCountLabel.layer.borderWidth = 0.6;
    [self addSubview:_tagCountLabel];
    [_tagCountLabel addRoundedCorners:UIRectCornerTopRight | UIRectCornerBottomRight withRadii:CGSizeMake(2, 2)];

}


@end
