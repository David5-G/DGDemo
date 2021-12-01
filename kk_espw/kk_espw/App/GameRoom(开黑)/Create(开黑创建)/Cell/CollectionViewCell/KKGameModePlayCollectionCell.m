//
//  KKGameModePlayCollectionCell.m
//  kk_espw
//
//  Created by hsd on 2019/7/17.
//  Copyright © 2019 david. All rights reserved.
//

#import "KKGameModePlayCollectionCell.h"

@interface KKGameModePlayCollectionCell ()

@property (weak, nonatomic) IBOutlet UIImageView *logoImageView;
@property (weak, nonatomic) IBOutlet UILabel *describeLabel;


@end

@implementation KKGameModePlayCollectionCell

- (void)setMainImage:(UIImage *)mainImage {
    _mainImage = mainImage;
    self.logoImageView.image = mainImage;
}

- (void)setTitleString:(NSString *)titleString {
    _titleString = titleString;
    self.describeLabel.text = titleString;
}

#pragma mark - system
- (void)awakeFromNib {
    [super awakeFromNib];
    [self resetLayer];
}

- (void)resetLayer {
    self.contentView.layer.cornerRadius = 3;
    self.contentView.layer.masksToBounds = YES;
    self.contentView.layer.shadowColor = RGBA(0, 0, 0, 0.07).CGColor;
    self.contentView.layer.shadowOffset = CGSizeMake(0, 0);
    self.contentView.layer.shadowOpacity = 1;
    self.contentView.layer.shadowRadius = 5;
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
