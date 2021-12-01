//
//  KKGamePortraitCardCollectionCell.m
//  kk_espw
//
//  Created by hsd on 2019/7/17.
//  Copyright © 2019 david. All rights reserved.
//

#import "KKGamePortraitCardCollectionCell.h"

@interface KKGamePortraitCardCollectionCell ()

@property (weak, nonatomic) IBOutlet UIImageView *sexImageView;         ///< 性别
@property (weak, nonatomic) IBOutlet UILabel *nickNameLabel;            ///< 昵称
@property (weak, nonatomic) IBOutlet UIImageView *indicationImageView;  ///< 指示图标
@property (weak, nonatomic) IBOutlet UILabel *accountSourceLabel;       ///< 账号来源
@property (weak, nonatomic) IBOutlet UILabel *levelLabel;               ///< 等级
@property (weak, nonatomic) IBOutlet CC_Button *editBtn;                ///< 编辑按钮

@property (weak, nonatomic) IBOutlet UIView *lineView;                  ///< 分割线

@end

@implementation KKGamePortraitCardCollectionCell

#pragma mark - set
- (void)setSexImage:(UIImage *)sexImage {
    _sexImage = sexImage;
    self.sexImageView.image = sexImage;
}

- (void)setNickNameString:(NSString *)nickNameString {
    _nickNameString = nickNameString;
    self.nickNameLabel.text = nickNameString;
}

- (void)setAccountSourceString:(NSString *)accountSourceString {
    _accountSourceString = accountSourceString;
    self.accountSourceLabel.text = accountSourceString;
}

- (void)setLevelString:(NSString *)levelString {
    _levelString = levelString;
    self.levelLabel.text = levelString;
}

#pragma mark - system
- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.contentView.layer.cornerRadius = 3;
    self.contentView.layer.masksToBounds = YES;
    self.contentView.backgroundColor = RGB(245, 245, 245);
    
    WS(weakSelf)
    [self.editBtn addTappedOnceDelay:0.2 withBlock:^(UIButton *button) {
        if (weakSelf.editBlock) {
            weakSelf.editBlock();
        }
    }];
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
    
    self.editBtn.hidden = !isSelect;
}

@end
