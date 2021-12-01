//
//  KKPlayerGameCardView.m
//  kk_espw
//
//  Created by hsd on 2019/7/23.
//  Copyright © 2019 david. All rights reserved.
//

#import "KKPlayerGameCardView.h"

@interface KKPlayerGameCardView ()<UIGestureRecognizerDelegate>

@property (nonatomic, strong, nonnull) UIView *contentView;             ///< 白底视图

@property (weak, nonatomic) IBOutlet CC_Button *leftUpBtn;              ///< 左上角按钮
@property (weak, nonatomic) IBOutlet CC_Button *closeBtn;               ///< 右上角按钮
@property (weak, nonatomic) IBOutlet UIImageView *playerIconImageView;  ///< 头像
@property (weak, nonatomic) IBOutlet UILabel *playerNickLabel;          ///< 昵称
@property (weak, nonatomic) IBOutlet UILabel *gameNameLabel;            ///< 玩的游戏名称
@property (weak, nonatomic) IBOutlet UILabel *gameNumbersLabel;         ///< 游戏局数
@property (weak, nonatomic) IBOutlet UILabel *gameTogetherLabel;        ///< 组队
@property (weak, nonatomic) IBOutlet UILabel *gameTogetherNumbersLabel; ///< 组队次数
@property (weak, nonatomic) IBOutlet UILabel *feelGoodNumbersLabel;     ///< 好评次数

@property (weak, nonatomic) IBOutlet UIView *playerLabelSuperView;      ///< 玩家标签父视图

@property (weak, nonatomic) IBOutlet CC_Button *addFriendBtn;           ///< 加好友
@property (weak, nonatomic) IBOutlet CC_Button *removeGameRoomBtn;      ///< 移除开黑房

@property (weak, nonatomic) IBOutlet UIView *verticalLineView;
@property (weak, nonatomic) IBOutlet UIView *horizontalLineView1;
@property (weak, nonatomic) IBOutlet UIView *horizontalLineView2;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *addFriendBtnHeight;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *removeGameRoomBtnHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *removeGameRoomBtnToBottom;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *addFriendToRemoveGameRoomBtn;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *playerLabelSuperViewWidth;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *playerLabelSuperViewHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *playerLabelSuperViewToPlayerNicker;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *highEvaluateLabelheight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *highEvaluateLabelToGameNumbersLabel;


@property (nonatomic, assign) BOOL isNeedTeamTitle;                         ///< 是否需要组队文字
@property (nonatomic, assign) KKPlayerGameCardViewBtnType   btnType;       ///< 按钮类型
@property (nonatomic, copy, nullable) NSArray<KKPlayerLabelView *> *labelViewArray; ///< 玩家标签列表

@end

@implementation KKPlayerGameCardView

#pragma mark - set
- (void)setGameNumbersColor:(UIColor *)gameNumbersColor {
    _gameNumbersColor = gameNumbersColor;
}

- (void)setNickTitle:(NSString *)title {
    self.playerNickLabel.text = title;
}

- (void)setLeftUpBtnTitle:(NSString *)title forState:(UIControlState)state {
    [self.leftUpBtn setTitle:title forState:state];
}

- (void)setLeftUpBtnTitleColor:(UIColor *)titleColor forState:(UIControlState)state {
    [self.leftUpBtn setTitleColor:titleColor forState:state];
}

- (void)setLeftUpBtnHidden:(BOOL)hidden {
    self.leftUpBtn.hidden = hidden;
}

- (void)setGameNameTitle:(NSString *)title {
    self.gameNameLabel.text = title;
}

- (void)setGameNumbersTitle:(NSString *)numbersStr unitTitle:(NSString *)unitStr {
    
    if (!unitStr) {
        unitStr = @"局";
    }
    
    unitStr = [@" " stringByAppendingString:unitStr];
    NSString *allStr = [numbersStr stringByAppendingString:unitStr];
    
    NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithString:allStr];
    UIColor *attriColor = self.gameNumbersColor;
    if (!attriColor) {
        attriColor = KKES_COLOR_HEX(0xECC165);
    }
    
    NSDictionary *attriDic = @{
                            NSFontAttributeName: [KKFont pingfangFontStyle:PFFontStyleSemibold size:15],
                            NSForegroundColorAttributeName: attriColor,
                            };
    
    [text addAttributes:attriDic range:[allStr rangeOfString:numbersStr]];
    
    self.gameNumbersLabel.attributedText = text;
}

- (void)setGameTogetherTitle:(NSString *)title {
    self.gameTogetherLabel.text = title;
}

- (void)setGameTogetherNumbersTitle:(NSString *)title {
    self.gameTogetherNumbersLabel.text = title;
}

- (void)setHighPraiseTitle:(NSString *)title {
    self.feelGoodNumbersLabel.text = title;
}

- (void)setPlayerLabels:(NSArray<KKPlayerLabelViewModel *> *)labelsArr {
    [self resetPlayerLabelsWith:labelsArr];
}

- (void)setBackgroundColor:(UIColor * _Nullable)backgroundColor forButtonType:(KKPlayerGameCardViewBtnType)btnType {
    if (btnType == KKPlayerGameCardViewBtnTypeAll) {
//        [self.addFriendBtn setBackgroundColor:backgroundColor];
//        [self.removeGameRoomBtn setBackgroundColor:backgroundColor];
        
    } else if (btnType == KKPlayerGameCardViewBtnTypeNoBorder) {
//        [self.addFriendBtn setBackgroundColor:backgroundColor];
        
    } else if (btnType == KKPlayerGameCardViewBtnTypeBorder) {
//        [self.removeGameRoomBtn setBackgroundColor:backgroundColor];
    }
}

- (void)setTitle:(NSString * _Nullable)title forState:(UIControlState)state forButtonType:(KKPlayerGameCardViewBtnType)btnType {
    if (btnType == KKPlayerGameCardViewBtnTypeAll) {
        [self.addFriendBtn setTitle:title forState:state];
        [self.removeGameRoomBtn setTitle:title forState:state];
        
    } else if (btnType == KKPlayerGameCardViewBtnTypeNoBorder) {
        [self.addFriendBtn setTitle:title forState:state];
        
    } else if (btnType == KKPlayerGameCardViewBtnTypeBorder) {
        [self.removeGameRoomBtn setTitle:title forState:state];
    }
}

#pragma mark - init
- (instancetype)initWithButtonType:(KKPlayerGameCardViewBtnType)btnType needTeamTitle:(BOOL)needTeam {
    if (self = [super init]) {
        
        self.isNeedTeamTitle = needTeam;
        self.btnType = btnType;
        
        [self resetBgColor];
        [self addTapGes];
        [self loadXib];
        [self resetSubviews];
        [self resetButtons];
    }
    return self;
}

- (void)resetBgColor {
    self.backgroundColor = RGBA(0, 0, 0, 0.5);
}

- (void)addTapGes {
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickBackgroundView)];
    tap.delegate = self;
    [self addGestureRecognizer:tap];
}

- (void)loadXib {
    self.contentView = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:self options:nil] lastObject];
    [self addSubview:self.contentView];
    CGFloat height = 366; // 基础
    
    if (!self.isNeedTeamTitle) {
        height -= 42;
    }
    
    if (self.btnType == KKPlayerGameCardViewBtnTypeNoBorder ||
        self.btnType == KKPlayerGameCardViewBtnTypeBorder || self.btnType == KKPlayerGameCardViewBtnTypeHorizontal) {
        height -= 63; /// 一个按钮, 可以减83
    } else if (self.btnType == KKPlayerGameCardViewBtnTypeNone) {
        height -= 142; /// 0个按钮
    }
    
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(300);
        make.height.mas_equalTo(height);
        make.centerX.mas_equalTo(self);
        make.centerY.mas_equalTo(self).mas_offset(-23);
    }];
}

- (void)setButtonItems:(NSArray<UIButton *> *)buttonItems {
    if (self.btnType == KKPlayerGameCardViewBtnTypeHorizontal) {
        //1.底部contentV
        UIView *botttomV = [[UIView alloc] init];
        [self.contentView addSubview:botttomV];
        [botttomV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(300);
            make.height.mas_equalTo(67);
            make.centerX.mas_equalTo(self);
            make.bottom.mas_equalTo(self.contentView).mas_offset(-10);
        }];
        //2.布局子视图
        if (buttonItems.count == 1) {
            UIButton *item = buttonItems.firstObject;
            item.frame = CGRectMake(0, 21, 300, RH(25));
            [botttomV addSubview:item];
            
            item.titleLabel.font = [KKFont pingfangFontStyle:PFFontStyleMedium size:16];
            
        }else if (buttonItems.count == 2) {
            UIButton *item0 = buttonItems.firstObject;
            UIButton *item1 = buttonItems.lastObject;
            //1.item0
            item0.frame = CGRectMake(0, RH(21), 150, RH(25));
            [botttomV addSubview:item0];
            //3.item1
            item1.frame = CGRectMake(150, RH(21), 150, RH(25));
            [botttomV addSubview:item1];
            //2.竖线
            UIView *line = [[UIView alloc] initWithFrame:CGRectMake(150, 23, 0.5, 21)];
            line.backgroundColor = RGB(245, 245, 245);
            [botttomV addSubview:line];
            
            item0.titleLabel.font = [KKFont pingfangFontStyle:PFFontStyleMedium size:16];
            item1.titleLabel.font = [KKFont pingfangFontStyle:PFFontStyleMedium size:16];
            
        }else if (buttonItems.count == 3) {
            UIButton *item0 = buttonItems[0];
            UIButton *item1 = buttonItems[1];
            UIButton *item2 = buttonItems[2];
            //1.item0
            item0.frame = CGRectMake(0, RH(21), 100, RH(25));
            [botttomV addSubview:item0];
            //2.item1
            item1.frame = CGRectMake(100, RH(21), 100, RH(25));
            [botttomV addSubview:item1];
            //3.item2
            item2.frame = CGRectMake(200, RH(21), 100, RH(25));
            [botttomV addSubview:item2];
            //4.竖线
            UIView *line = [[UIView alloc] initWithFrame:CGRectMake(100, 23, 0.5, 21)];
            line.backgroundColor = RGB(245, 245, 245);
            [botttomV addSubview:line];
            //5.第二条竖线
            UIView *line1 = [[UIView alloc] initWithFrame:CGRectMake(200, 23, 0.5, 21)];
            line1.backgroundColor = RGB(245, 245, 245);
            [botttomV addSubview:line1];
            
            item0.titleLabel.font = [KKFont pingfangFontStyle:PFFontStyleMedium size:RH(15)];
            item1.titleLabel.font = [KKFont pingfangFontStyle:PFFontStyleMedium size:RH(15)];
            item2.titleLabel.font = [KKFont pingfangFontStyle:PFFontStyleMedium size:RH(15)];
            
        }else if (buttonItems.count == 4) {
            UIButton *item0 = buttonItems[0];
            UIButton *item1 = buttonItems[1];
            UIButton *item2 = buttonItems[2];
            UIButton *item3 = buttonItems[3];
            //1.item0
            item0.frame = CGRectMake(0, RH(21), 75, RH(25));
            [botttomV addSubview:item0];
            //2.item1
            item1.frame = CGRectMake(75, RH(21), 75, RH(25));
            [botttomV addSubview:item1];
            //3.item2
            item2.frame = CGRectMake(150, RH(21), 75, RH(25));
            [botttomV addSubview:item2];
            //4.item3
            item3.frame = CGRectMake(225, RH(21), 75, RH(25));
            [botttomV addSubview:item3];
            //4.竖线
            UIView *line = [[UIView alloc] initWithFrame:CGRectMake(75, 23, 0.5, 21)];
            line.backgroundColor = RGB(245, 245, 245);
            [botttomV addSubview:line];
            //5.第二条竖线
            UIView *line1 = [[UIView alloc] initWithFrame:CGRectMake(150, 23, 0.5, 21)];
            line1.backgroundColor = RGB(245, 245, 245);
            [botttomV addSubview:line1];
            //6.第二条竖线
            UIView *line2 = [[UIView alloc] initWithFrame:CGRectMake(225, 23, 0.5, 21)];
            line2.backgroundColor = RGB(245, 245, 245);
            [botttomV addSubview:line2];
            
            item0.titleLabel.font = [KKFont pingfangFontStyle:PFFontStyleMedium size:RH(14)];
            item1.titleLabel.font = [KKFont pingfangFontStyle:PFFontStyleMedium size:RH(14)];
            item2.titleLabel.font = [KKFont pingfangFontStyle:PFFontStyleMedium size:RH(14)];
            item3.titleLabel.font = [KKFont pingfangFontStyle:PFFontStyleMedium size:RH(14)];
        }
    }
}



- (void)resetSubviews {
    
    self.contentView.layer.cornerRadius = 10;
    
    self.playerIconImageView.layer.cornerRadius = 37.5;
    self.playerIconImageView.layer.masksToBounds = YES;
    
    self.addFriendBtn.layer.cornerRadius = 4;
    self.addFriendBtn.layer.masksToBounds = YES;
    
    self.removeGameRoomBtn.layer.cornerRadius = 4;
    self.removeGameRoomBtn.layer.masksToBounds = YES;
    
    self.removeGameRoomBtn.layer.borderWidth = 1;
    self.removeGameRoomBtn.layer.borderColor = KKES_COLOR_HEX(0xECC165).CGColor;
    
    [self.leftUpBtn setContentEdgeInsets:UIEdgeInsetsMake(7, 7, 7, 7)];
    [self.closeBtn setContentEdgeInsets:UIEdgeInsetsMake(7, 7, 7, 7)];
    
    _iconImgView = self.playerIconImageView;
    
    WS(weakSelf)
    [self.leftUpBtn addTappedOnceDelay:0.2 withBlock:^(UIButton *button) {
        if (weakSelf.tapBlock) {
            weakSelf.tapBlock(KKPlayerGameCardViewTapTypeLeftUp);
        } else {
            [weakSelf dismissWithAnimated:NO];
        }
    }];
    [self.closeBtn addTappedOnceDelay:0.2 withBlock:^(UIButton *button) {
        if (weakSelf.tapBlock) {
            weakSelf.tapBlock(KKPlayerGameCardViewTapTypeRightUp);
        } else {
            [weakSelf dismissWithAnimated:NO];
        }
    }];
    [self.addFriendBtn addTappedOnceDelay:0.2 withBlock:^(UIButton *button) {
        if (weakSelf.tapBlock) {
            weakSelf.tapBlock(KKPlayerGameCardViewTapTypeNoBorder);
        } else {
            [weakSelf dismissWithAnimated:NO];
        }
    }];
    [self.removeGameRoomBtn addTappedOnceDelay:0.2 withBlock:^(UIButton *button) {
        if (weakSelf.tapBlock) {
            weakSelf.tapBlock(KKPlayerGameCardViewTapTypeBorder);
        } else {
            [weakSelf dismissWithAnimated:NO];
        }
    }];
}

/// 调整按钮高度,间距,以适应不同显示模式
- (void)resetButtons {
    
    if (!self.isNeedTeamTitle) {
        self.highEvaluateLabelheight.constant = 0;
        self.highEvaluateLabelToGameNumbersLabel.constant = 0;
        
        self.gameTogetherLabel.hidden = YES;
        self.gameTogetherNumbersLabel.hidden = YES;
        self.feelGoodNumbersLabel.hidden = YES;
        self.verticalLineView.hidden = YES;
    }
    
    if (self.btnType == KKPlayerGameCardViewBtnTypeNoBorder) {
        self.removeGameRoomBtnHeight.constant = 0;
        self.removeGameRoomBtnToBottom.constant = 0;
        self.removeGameRoomBtn.hidden = YES;
        
    } else if (self.btnType == KKPlayerGameCardViewBtnTypeBorder) {
        self.addFriendBtnHeight.constant = 0;
        self.addFriendToRemoveGameRoomBtn.constant = 0;
        self.addFriendBtn.hidden = YES;
        
    } else if (self.btnType == KKPlayerGameCardViewBtnTypeNone) {
        self.addFriendBtnHeight.constant = 0;
        self.addFriendToRemoveGameRoomBtn.constant = 0;
        self.addFriendBtn.hidden = YES;
        
        self.removeGameRoomBtnHeight.constant = 0;
        self.removeGameRoomBtnToBottom.constant = 0;
        self.removeGameRoomBtn.hidden = YES;
        
        self.horizontalLineView2.hidden = YES;
    }else if (self.btnType == KKPlayerGameCardViewBtnTypeHorizontal){
        self.addFriendBtn.hidden = YES;
        self.removeGameRoomBtn.hidden = YES;
    }
}

/// 创建玩家标签
- (void)resetPlayerLabelsWith:(NSArray<KKPlayerLabelViewModel *> *)labelsArr {
    // 先清空
    if (self.labelViewArray && self.labelViewArray.count > 0) {
        for (KKPlayerLabelView *label in self.labelViewArray) {
            [label removeFromSuperview];
        }
    }
    
    self.labelViewArray = nil;
    
    // 判空
    if (!labelsArr) {
        return;
    }
    
    NSMutableArray<KKPlayerLabelView *> *mutArr = [NSMutableArray array];
    CGFloat totalWidth = 0;         // 总宽度
    CGFloat labelWidth = 0;         // 标签宽度
    CGFloat minLabelWidth = 34;     // 最小标签宽度
    CGFloat maxSpaceInLabel = 4;    // 标签内icon到文字的最大距离
    CGFloat maxSpaceBetweenLabel = 4; //标签之间的距离
    
    //创建标签
    for (KKPlayerLabelViewModel *model in labelsArr) {
        KKPlayerLabelView *labelView = [[KKPlayerLabelView alloc] init];
        
        
        if (model.modelType == KKPlayerLabelViewModelTypeBigImage) {
            labelWidth = 43; // 底图模式下, 定死43宽
            
        } else {
            /*
             @notify 此非明确需求, 只是UI图上看起来这样
             * 标签最少 34pt 宽, 如果过短, 则保持 34pt 不变, 而拉伸 icon和label的间距(内间距) 以及左右边距
             * 内间距最大 4pt, 达到此间距后, 只能靠拉伸左右间距来自适应宽度
             * 优先拉伸左右间距, 其超过 4pt 后, 再拉伸 内间距
             */
            
            // 文字宽度
            CGFloat strWidth = 0;
            if (model.labelString && model.labelString.length > 0) {
                strWidth = [model.labelString widthForHeight:self.playerLabelSuperViewHeight.constant font:model.labelFont];
            } else {
                labelView.labelToTrail = 0;
            }
            
            //原则上的标签宽度
            labelWidth = strWidth + labelView.iconImageWidth + labelView.iconImageToLeft + labelView.labelToIconImage + labelView.labelToTrail;
            
            // 宽度过小
            if ((strWidth > 0) && (labelWidth < minLabelWidth)) {
                
                //内容宽
                CGFloat contentWidth = strWidth + labelView.iconImageWidth;
                
                // 左右间距
                CGFloat lrSpace = (minLabelWidth - contentWidth - labelView.labelToIconImage) / 2;
                
                if (lrSpace > maxSpaceInLabel) {
                    
                    // 开始同步拉伸内间距
                    CGFloat overflowWidth = minLabelWidth - contentWidth - labelView.labelToIconImage - 2 * maxSpaceInLabel;
                    CGFloat overflowSpace = overflowWidth / 3;
                    
                    // 超过最大内间距, 继续拉伸左右间距
                    if (labelView.labelToIconImage + overflowSpace > maxSpaceInLabel) {
                        labelView.labelToIconImage = maxSpaceInLabel;
                        lrSpace = (minLabelWidth - contentWidth - labelView.labelToIconImage) / 2;
                        
                    } else {
                        labelView.labelToIconImage += overflowSpace;
                        lrSpace = maxSpaceInLabel + overflowSpace;
                    }
                }
                
                labelView.iconImageToLeft = lrSpace;
                labelView.labelToTrail = lrSpace;
                
                // 重新计算下标签宽度
                labelWidth = strWidth + labelView.iconImageWidth + labelView.iconImageToLeft + labelView.labelToIconImage + labelView.labelToTrail;
            }
        }
        
        // 计算总宽度
        NSUInteger index = [labelsArr indexOfObject:model];
        totalWidth += (labelWidth + (index == 0 ? 0 : maxSpaceBetweenLabel));
        
        // 添加到父视图
        [self.playerLabelSuperView addSubview:labelView];
        
        // 约束
        [labelView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.playerLabelSuperView).mas_offset(totalWidth - labelWidth);
            make.top.bottom.mas_equalTo(self.playerLabelSuperView);
            make.width.mas_equalTo(labelWidth);
        }];
        
        // 界面数据赋值
        labelView.model = model;
        
        // 记录下来
        [mutArr addObject:labelView];
        
    }
    
    self.playerLabelSuperViewWidth.constant = totalWidth;
}

#pragma mark - Action
/// 显示
- (void)showIn:(UIView * _Nullable)inView animated:(BOOL)animated {
    if (!inView) {
        inView = [UIApplication sharedApplication].keyWindow;
    }
    self.frame = inView.bounds;
    [inView addSubview:self];
    [inView bringSubviewToFront:self];
    
    if (animated) {
        
        self.backgroundColor = RGBA(0, 0, 0, 0);
        
        self.contentView.alpha = 0;
        self.contentView.transform = CGAffineTransformMakeScale(1.2, 1.2);
        
        [UIView animateWithDuration:0.3 delay:0.0 options:UIViewAnimationOptionCurveEaseOut animations:^{
            
            self.backgroundColor = RGBA(0, 0, 0, 0.5);
            
            self.contentView.alpha = 1.0;
            self.contentView.transform = CGAffineTransformIdentity;
            
        } completion:^(BOOL finished) {
            
        }];
    }
}

/// 移除
- (void)dismissWithAnimated:(BOOL)animated {
    
    if (animated) {
        
        [UIView animateWithDuration:0.3 delay:0.0 options:UIViewAnimationOptionCurveEaseOut animations:^{
            
            self.backgroundColor = RGBA(0, 0, 0, 0);
            
            self.contentView.alpha = 0;
            self.contentView.transform = CGAffineTransformMakeScale(1.2, 1.2);
            
        } completion:^(BOOL finished) {
            [self removeFromSuperview];
        }];
        
    } else {
        [self removeFromSuperview];
    }
}

- (void)clickBackgroundView {
    if (self.tapBlock) {
        self.tapBlock(KKPlayerGameCardViewTapTypeBackground);
    } else {
        [self dismissWithAnimated:NO];
    }
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
