//
//  KKGamePrepareToolView.m
//  kk_espw
//
//  Created by hsd on 2019/7/22.
//  Copyright © 2019 david. All rights reserved.
//

#import "KKGamePrepareToolView.h"

@interface KKGamePrepareToolView ()

@property (strong, nonatomic) IBOutlet KKGamePrepareToolView *bgView;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *subTitleLabel;
@property (weak, nonatomic) IBOutlet CC_Button *rightBtn2;
@property (weak, nonatomic) IBOutlet CC_Button *rightBtn1;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *titleToSubTitle;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *subTitleHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *titleToTop;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *subTitleToBottom;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *rightBtn1Width;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *rightBtn2Width;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *rightBtn2ToRightBtn1;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *rightBtn1ToTrail;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *titleLabelToRightBtn2;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *subTitleToRightBtn2;


@end

@implementation KKGamePrepareToolView
#pragma mark - set
- (void)setTitle:(NSString *)title forState:(UIControlState)state forButtonType:(KKGamePrepareToolViewBtnType)btnType {
    if (btnType == KKGamePrepareToolViewBtnTypeNoBorder) {
        [self.rightBtn1 setTitle:title forState:state];
        
    } else if (btnType == KKGamePrepareToolViewBtnTypeBorder) {
        [self.rightBtn2 setTitle:title forState:state];
    }
}

- (void)setButtonEnable:(BOOL)enable forButtonType:(KKGamePrepareToolViewBtnType)btnType {
    if (btnType == KKGamePrepareToolViewBtnTypeNoBorder) {
        [self.rightBtn1 setEnabled:enable];
        if (enable) {
            self.rightBtn1.backgroundColor = KKES_COLOR_HEX(0x999999);
        } else {
            self.rightBtn1.backgroundColor = KKES_COLOR_HEX(0xECC165);
        }
        
    } else if (btnType == KKGamePrepareToolViewBtnTypeBorder) {
        [self.rightBtn2 setEnabled:enable];
        if (enable) {
            self.rightBtn2.layer.borderColor = KKES_COLOR_HEX(0xECC165).CGColor;
            [self.rightBtn2 setTitleColor:KKES_COLOR_HEX(0xECC165) forState:UIControlStateNormal];
        } else {
            self.rightBtn2.layer.borderColor = RGB(211, 211, 211).CGColor;
            [self.rightBtn2 setTitleColor:RGB(211, 211, 211) forState:UIControlStateNormal];
        }
    }
}

- (void)setTitleString:(NSString *)titleString {
    _titleString = titleString;
    self.titleLabel.text = titleString;
}

- (void)setSubTitleString:(NSString * _Nullable)subTitleString attriStr:(NSString * _Nullable)attriStr {
    if (!attriStr) {
        self.subTitleLabel.text = subTitleString;
        
    } else {
        NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithString:subTitleString];
        NSDictionary *attriDic = @{
                                   NSFontAttributeName: [KKFont pingfangFontStyle:PFFontStyleRegular size:12],
                                   NSForegroundColorAttributeName: KKES_COLOR_HEX(0xE3A729),
                                   };
        
        [text addAttributes:attriDic range:[subTitleString rangeOfString:attriStr]];
        self.subTitleLabel.attributedText = text;
    }
    
    if (![subTitleString isKindOfClass:[NSString class]] || subTitleString.length == 0) {
        self.subTitleHeight.constant = 0;
        self.titleToSubTitle.constant = 0;
        self.titleToTop.constant = 11;
        self.subTitleToBottom.constant = 10;
        self.subTitleLabel.hidden = YES;
    } else {
        self.subTitleHeight.constant = 14;
        self.titleToSubTitle.constant = 10;
        self.titleToTop.constant = 13;
        self.subTitleToBottom.constant = 11;
        self.subTitleLabel.hidden = NO;
    }
}

- (void)setShowBtnType:(KKGamePrepareToolViewBtnType)showBtnType {
    _showBtnType = showBtnType;
    
    if (showBtnType == KKGamePrepareToolViewBtnTypeAll) {
        self.rightBtn1Width.constant = 75;
        self.rightBtn2Width.constant = 75;
        self.rightBtn2ToRightBtn1.constant = 9;
        self.rightBtn1ToTrail.constant = 6;
        self.titleLabelToRightBtn2.constant = 10;
        self.subTitleToRightBtn2.constant = 10;
        
        self.rightBtn1.hidden = NO;
        self.rightBtn2.hidden = NO;
        
    } else if (showBtnType == KKGamePrepareToolViewBtnTypeBorder) {
        self.rightBtn1Width.constant = 0;
        self.rightBtn2Width.constant = 75;
        self.rightBtn2ToRightBtn1.constant = 0;
        self.rightBtn1ToTrail.constant = 6;
        self.titleLabelToRightBtn2.constant = 10;
        self.subTitleToRightBtn2.constant = 10;
        
        self.rightBtn1.hidden = YES;
        self.rightBtn2.hidden = NO;
        
    } else if (showBtnType == KKGamePrepareToolViewBtnTypeNoBorder) {
        self.rightBtn1Width.constant = 75;
        self.rightBtn2Width.constant = 0;
        self.rightBtn2ToRightBtn1.constant = 0;
        self.rightBtn1ToTrail.constant = 6;
        self.titleLabelToRightBtn2.constant = 10;
        self.subTitleToRightBtn2.constant = 10;
        
        self.rightBtn1.hidden = NO;
        self.rightBtn2.hidden = YES;
        
    } else if (showBtnType == KKGamePrepareToolViewBtnTypeNone) {
        self.rightBtn1Width.constant = 0;
        self.rightBtn2Width.constant = 0;
        self.rightBtn2ToRightBtn1.constant = 0;
        self.rightBtn1ToTrail.constant = 6;
        self.titleLabelToRightBtn2.constant = 8;
        self.subTitleToRightBtn2.constant = 8;
        
        self.rightBtn1.hidden = YES;
        self.rightBtn2.hidden = YES;
    }
}

#pragma mark - init
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self loadXib];
        [self resetUI];
    }
    return self;
}

- (void)loadXib {
    UIView *bgView = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:self options:nil] lastObject];
    [self addSubview:bgView];
    [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.mas_equalTo(self);
    }];
}

- (void)resetUI {
    
    self.rightBtn1.layer.cornerRadius = 5;
    self.rightBtn1.layer.masksToBounds = YES;
    
    self.rightBtn2.layer.cornerRadius = 5;
    self.rightBtn2.layer.masksToBounds = YES;
    self.rightBtn2.layer.borderWidth = 1;
    self.rightBtn2.layer.borderColor = KKES_COLOR_HEX(0xECC165).CGColor;
    
    WS(weakSelf)
    [self.rightBtn1 addTappedOnceDelay:0.5 withBlock:^(UIButton *button) {
        if (weakSelf.tapBlockNoBorder) {
            weakSelf.tapBlockNoBorder((CC_Button *)button);
        }
    }];
    [self.rightBtn2 addTappedOnceDelay:0.5 withBlock:^(UIButton *button) {
        if (weakSelf.tapBlockBorder) {
            weakSelf.tapBlockBorder((CC_Button *)button);
        }
    }];
}

@end
