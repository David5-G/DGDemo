//
//  KKGameChargeToolView.m
//  kk_espw
//
//  Created by hsd on 2019/7/24.
//  Copyright © 2019 david. All rights reserved.
//

#import "KKGameChargeToolView.h"

@interface KKGameChargeToolView ()<UIGestureRecognizerDelegate>

@property (nonatomic, strong, nonnull) UIView *contentView;         ///< 白底视图

@property (weak, nonatomic) IBOutlet UIView *horizontalLineView1;
@property (weak, nonatomic) IBOutlet UIView *horizontalLineView2;
@property (weak, nonatomic) IBOutlet UIView *verticalLineView;

@property (weak, nonatomic) IBOutlet CC_Button *cancelBtn;
@property (weak, nonatomic) IBOutlet UILabel *chargeToLabel;
@property (weak, nonatomic) IBOutlet UIImageView *playerIconImageView;
@property (weak, nonatomic) IBOutlet UILabel *playerNickerLabel;

@property (weak, nonatomic) IBOutlet UIImageView *balanceImageView;
@property (weak, nonatomic) IBOutlet UILabel *balanceLabel;
@property (weak, nonatomic) IBOutlet CC_Button *chargeBtn;
@property (weak, nonatomic) IBOutlet CC_Button *certainBtn;
@property (weak, nonatomic) IBOutlet UIView *certainBtnSuperView;

@property (weak, nonatomic) IBOutlet UIView *payAmountSuperView;
@property (weak, nonatomic) IBOutlet UIImageView *payAmountImageView;
@property (weak, nonatomic) IBOutlet UILabel *payAmountLabel;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *horizontalLineView2ToBottom;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *certainBtnSuperViewWidth;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *certainBtnSuperViewHeight;

@property (nonatomic, copy, nullable) NSString *depositStr; ///< 支付金额
@property (nonatomic, copy, nullable) NSString *balanceStr; ///< 余额

@property (nonatomic, assign) CGFloat safeBottomDistance;   ///< 底部安全距离
@property (nonatomic, assign) CGFloat contentViewHeight;    ///< 默认白底视图高度

@end

@implementation KKGameChargeToolView

#pragma mark - get
- (CGFloat)contentViewHeight {
    return 256;
}

#pragma mark - set
- (void)setNickNameString:(NSString * _Nullable)nick {
    self.playerNickerLabel.text = nick;
}

- (void)setBalanceCoinString:(NSString * _Nullable)balance unit:(NSString * _Nullable)unitString {
    if (!unitString) {
        unitString = @"K币";
    }
    if (!balance) {
        balance = @"0";
    }
    self.balanceStr = balance;
    self.balanceLabel.text = [balance stringByAppendingString:unitString];
}

- (void)setChargeToGameRoomOwner:(NSString * _Nonnull)chargeCoin unit:(NSString * _Nullable)unitString {
    
    if (!unitString) {
        unitString = @"K币";
    }
    unitString = [@" " stringByAppendingString:unitString];
    
    NSString *allStr = [chargeCoin stringByAppendingString:unitString];
    
    NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithString:allStr];
    UIColor *attriColor = KKES_COLOR_HEX(0x2A2B34);
    NSDictionary *attriDic = @{
                               NSFontAttributeName: [KKFont pingfangFontStyle:PFFontStyleMedium size:42],
                               NSForegroundColorAttributeName: attriColor,
                               };
    
    [text addAttributes:attriDic range:[allStr rangeOfString:chargeCoin]];
    
    self.depositStr = chargeCoin;
    self.payAmountLabel.attributedText = text;
}

#pragma mark - init
- (instancetype)initWithSafeBottom:(CGFloat)safeBottom {
    if (self = [super init]) {
        self.backgroundColor = rgba(0, 0, 0, 0);
        self.safeBottomDistance = safeBottom;
        [self loadXib];
        [self addTapGes];
        [self resetSubViews];
        [self addGradientLayerToBtn];
    }
    return self;
}

#pragma mark - setup
- (void)loadXib {
    self.contentView = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:self options:nil] lastObject];
    
    // 这里先给个frame, 默认放于屏幕外, 不然调用showIn:方法时, 感觉是从上面下来的,而不是从底部弹上来的
    self.contentView.frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, self.contentViewHeight);
    
    [self addSubview:self.contentView];
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(self);
        make.top.mas_equalTo(self.mas_bottom).mas_offset(0);
        make.height.mas_equalTo(self.contentViewHeight + self.safeBottomDistance);
    }];
}

- (void)addTapGes {
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickBackgroundView)];
    tap.delegate = self;
    [self addGestureRecognizer:tap];
}

- (void)resetSubViews {
    
    self.horizontalLineView2ToBottom.constant = 70 + self.safeBottomDistance;
    
    self.playerIconImageView.layer.cornerRadius = 11;
    self.playerIconImageView.layer.masksToBounds = YES;
    _iconImgView = self.playerIconImageView;
    
    [self.cancelBtn setImageEdgeInsets:UIEdgeInsetsMake(5, 5, 5, 5)];
    
    [self.chargeBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 14)];
    [self.chargeBtn setImageEdgeInsets:UIEdgeInsetsMake(7, 34, 7, 0)];
    
    // 无法支付, 隐藏掉
    self.chargeBtn.hidden = YES;
    self.verticalLineView.hidden = YES;
    
    WS(weakSelf)
    [self.cancelBtn addTappedOnceDelay:0.2 withBlock:^(UIButton *button) {
        [weakSelf dismiss];
        if (weakSelf.tapBlock) {
            weakSelf.tapBlock(KKGameChargeToolViewTapTypeCancel);
        }
    }];
    [self.chargeBtn addTappedOnceDelay:0.2 withBlock:^(UIButton *button) {
        [weakSelf dismiss];
        if (weakSelf.tapBlock) {
            weakSelf.tapBlock(KKGameChargeToolViewTapTypeCharge);
        }
    }];
    [self.certainBtn addTappedOnceDelay:0.2 withBlock:^(UIButton *button) {
        [weakSelf dismiss];
        if (weakSelf.tapBlock) {
            weakSelf.tapBlock(KKGameChargeToolViewTapTypeCertain);
        }
    }];
}

- (void)addGradientLayerToBtn {
    
    self.certainBtnSuperView.backgroundColor = KKES_COLOR_HEX(0xFFFFFF);
    
    CAGradientLayer *gLayer = [CAGradientLayer layer];
    gLayer.frame = CGRectMake(0, 0, self.certainBtnSuperViewWidth.constant, self.certainBtnSuperViewHeight.constant);
    gLayer.startPoint = CGPointMake(0, 0);
    gLayer.endPoint = CGPointMake(1, 1);
    gLayer.colors = @[(__bridge id)KKES_COLOR_HEX(0xF0C765).CGColor, (__bridge id)KKES_COLOR_HEX(0xE5B04A).CGColor];
    gLayer.locations = @[@(0.0), @(1.0)];
    
    [self.certainBtnSuperView.layer addSublayer:gLayer];
    
    [self.certainBtnSuperView bringSubviewToFront:self.certainBtn];
    
    self.certainBtnSuperView.layer.cornerRadius = 5;
    self.certainBtnSuperView.layer.masksToBounds = YES;
}

- (void)clickBackgroundView {
    [self dismiss];
    if (self.tapBlock) {
        self.tapBlock(KKGameChargeToolViewTapTypeBackground);
    }
}

#pragma mark - Action
- (void)showIn:(UIView * _Nullable)inView {
    
    if ([self.depositStr doubleValue] > [self.balanceStr doubleValue]) {
        self.certainBtn.enabled = NO;
        self.certainBtn.backgroundColor = RGB(211, 211, 211);
    } else {
        self.certainBtn.enabled = YES;
        self.certainBtn.backgroundColor = nil;
    }
    
    if (!inView) {
        inView = [UIApplication sharedApplication].keyWindow;
    }
    self.frame = inView.bounds;
    [inView addSubview:self];
    [inView bringSubviewToFront:self];
    
    [UIView animateWithDuration:0.3 animations:^{
        self.backgroundColor = RGBA(0, 0, 0, 0.5);
        [self.contentView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.mas_bottom).mas_offset(-self.contentViewHeight - self.safeBottomDistance);
        }];
        [self layoutIfNeeded];
    }];
}

- (void)dismiss {
    
    [UIView animateWithDuration:0.3 animations:^{
        
        self.backgroundColor = RGBA(0, 0, 0, 0);
        [self.contentView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.mas_bottom).mas_offset(0);
        }];
        [self layoutIfNeeded];
        
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

#pragma mark - UIGestureRecognizerDelegate
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return YES;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    
    if ([touch.view isDescendantOfView:self.contentView]) {
        return NO;
    }
    return YES;
}

@end
