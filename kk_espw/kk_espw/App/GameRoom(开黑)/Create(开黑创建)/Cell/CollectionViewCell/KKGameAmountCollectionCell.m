//
//  KKGameAmountCollectionCell.m
//  kk_espw
//
//  Created by hsd on 2019/7/17.
//  Copyright © 2019 david. All rights reserved.
//

#import "KKGameAmountCollectionCell.h"

@interface KKGameAmountCollectionCell ()

@property (weak, nonatomic) IBOutlet UILabel *amountLabel;

@end

@implementation KKGameAmountCollectionCell

- (void)setTitleString:(NSString *)titleString {
    _titleString = titleString;
    self.amountLabel.text = titleString;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.contentView.layer.cornerRadius = 3;
    self.contentView.layer.masksToBounds = YES;
    
}

- (void)resetViewBorder:(BOOL)isSelect {
    
    if (isSelect) {
        self.contentView.layer.borderWidth = 1;
        self.contentView.layer.borderColor = KKES_COLOR_HEX(0xECBA50).CGColor;
        self.contentView.backgroundColor = KKES_COLOR_HEX(0xFFFFFF);
    } else {
        self.contentView.layer.borderWidth = 0;
        self.contentView.layer.borderColor = nil;
        self.contentView.backgroundColor = RGB(245, 245, 245);
    }
}

@end
