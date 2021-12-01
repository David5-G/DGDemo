//
//  KKTagCollectionViewCell.m
//  kk_espw
//
//  Created by 景天 on 2019/8/11.
//  Copyright © 2019年 david. All rights reserved.
//

#import "KKTagCollectionViewCell.h"
#import "KKTag.h"
#import "KKCalculateTextWidthOrHeight.h"
@interface KKTagCollectionViewCell ()
@property (nonatomic, strong) UIImageView *tagImageView;
@property (nonatomic, strong) UILabel *tagCountLabel;

@end

@implementation KKTagCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        
        _tagImageView = [[UIImageView alloc] init];
        _tagImageView.left = 0;
        _tagImageView.top = 0;
        _tagImageView.width = 15;
        _tagImageView.height = RH(15);
        [self.contentView addSubview:_tagImageView];
        
        _tagCountLabel = [[UILabel alloc] init];
        _tagCountLabel.left = 0;
        _tagCountLabel.top = 0;
        _tagCountLabel.width = 15;
        _tagCountLabel.height = RH(15);
        _tagCountLabel.font = [KKFont pingfangFontStyle:PFFontStyleRegular size:9] ;
        _tagCountLabel.textAlignment = NSTextAlignmentCenter;
        _tagCountLabel.textColor = RGB(239, 115, 52);
        _tagCountLabel.layer.borderColor = RGB(239, 115, 52).CGColor;
        _tagCountLabel.layer.borderWidth = 0.6;
        _tagCountLabel.layer.cornerRadius = 1.5;
        [self.contentView addSubview:_tagCountLabel];
    }
    return self;
}

- (void)setTagModel:(KKTag *)tagModel {
    CGFloat w = 0;
    if ([tagModel.tagCode isEqualToString:@"YE_WANG"] || [tagModel.tagCode isEqualToString:@"KENG_HUO"] || [tagModel.tagCode isEqualToString:@"FA_WANG"]) {
        w = RH(25);
    }else if ([tagModel.tagCode isEqualToString:@"QUAN_NENG_FU_ZHU"]){
        w = RH(45);
    }else {
        w = RH(35);
    }
    self.tagImageView.width = w;
    self.tagCountLabel.left = _tagImageView.right;
    
    if (tagModel.evaluationNum.intValue > 999) {
        self.tagCountLabel.width = [KKCalculateTextWidthOrHeight getWidthWithAttributedText:@"999++" font:[KKFont pingfangFontStyle:PFFontStyleRegular size:9] height:RH(15)] + RH(4);
    }else {
        self.tagCountLabel.width = [KKCalculateTextWidthOrHeight getWidthWithAttributedText:[NSString stringWithFormat:@"%@", tagModel.evaluationNum] font:[KKFont pingfangFontStyle:PFFontStyleRegular size:9] height:RH(15)] + RH(4);
    }
    

    if ([tagModel.tagCode isEqualToString:@"YE_WANG"]) {
        _tagImageView.image = Img(@"ye_wang");
    }else if ([tagModel.tagCode isEqualToString:@"FA_WANG"]) {
        _tagImageView.image = Img(@"fa_wang");
    }else if ([tagModel.tagCode isEqualToString:@"QUAN_NENG_FU_ZHU"]) {
        _tagImageView.image = Img(@"fu_zhu");
    }else if ([tagModel.tagCode isEqualToString:@"KENG_HUO"]) {
        _tagImageView.image = Img(@"keng_huo");
    }else if ([tagModel.tagCode isEqualToString:@"KAN_YA_WANG"]) {
        _tagImageView.image = Img(@"kang_ya_wang");
    }
    if (tagModel.evaluationNum.intValue > 999) {
        
        _tagCountLabel.text = @"999+";
    }else {
        _tagCountLabel.text = [NSString stringWithFormat:@"%@", tagModel.evaluationNum];

    }
}
@end
