//
//  KKGameReportTypeCell.m
//  kk_espw
//
//  Created by hsd on 2019/7/25.
//  Copyright © 2019 david. All rights reserved.
//

#import "KKGameReportTypeCell.h"

@interface KKGameReportTypeCell ()

@property (weak, nonatomic) IBOutlet UILabel *leftTitleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *rightImageView;

@end

@implementation KKGameReportTypeCell

#pragma mark - set
- (void)setTitleString:(NSString *)titleString {
    _titleString = titleString;
    self.leftTitleLabel.text = titleString;
}

- (void)setReportSelect:(BOOL)reportSelect {
    _reportSelect = reportSelect;
    self.rightImageView.hidden = !reportSelect;
}

#pragma mark - system
- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.leftTitleLabel.font = [KKFont pingfangFontStyle:PFFontStyleMedium size:15];
    self.leftTitleLabel.textColor = rgba(51, 51, 51, 1);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
