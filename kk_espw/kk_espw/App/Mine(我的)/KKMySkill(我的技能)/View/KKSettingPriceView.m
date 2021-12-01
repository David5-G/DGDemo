//
//  KKSettingPriceView.m
//  kk_espw
//
//  Created by 景天 on 2019/7/17.
//  Copyright © 2019年 david. All rights reserved.
//

#import "KKSettingPriceView.h"
#import "KKGamePrice.h"

@interface KKSettingPriceView ()
@property (nonatomic, strong) UILabel *showPriceLabel;
@property (nonatomic, strong) UIView *whiteView;
@property (nonatomic, assign) NSInteger kCoin;
@property (nonatomic, strong) KKGamePrice *price;
@property (nonatomic, strong) UILabel *priceLabel;


@end

@implementation KKSettingPriceView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        WS(weakSelf)
//        [self addTapWithTimeInterval:1 tapBlock:^(UIView * _Nonnull view) {
//            [weakSelf removeFromSuperview];
//        }];
        
        _kCoin = 13;
        self.backgroundColor = rgba(0, 0, 0, 0.4);
        _whiteView = [[UIView alloc] initWithFrame:CGRectMake(10, SCREEN_HEIGHT - RH(290 + HOME_INDICATOR_HEIGHT + 5), SCREEN_WIDTH - RH(20), RH(290))];
        [_whiteView addTapWithTimeInterval:1 tapBlock:^(UIView * _Nonnull view) {
            
        }];
        _whiteView.backgroundColor = [UIColor whiteColor];
        _whiteView.layer.cornerRadius = 10;
        [self addSubview:_whiteView];
        
        UILabel *des = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, _whiteView.width, 60)];
        des.textColor = KKES_COLOR_BLACK_TEXT;
        des.text = @"设置价格";
        des.textAlignment = NSTextAlignmentCenter;
        des.font = RF(18);
        [_whiteView addSubview:des];
        
        UILabel *currentPriceLabel = [[UILabel alloc] initWithFrame:CGRectMake(RH(26), RH(84), RH(67), RH(16))];
        currentPriceLabel.textColor = RGB(68, 68, 68);
        currentPriceLabel.text = @"当前价格";
        currentPriceLabel.textAlignment = NSTextAlignmentCenter;
        currentPriceLabel.font = [KKFont pingfangFontStyle:PFFontStyleMedium size:15];
        [_whiteView addSubview:currentPriceLabel];
        
        _priceLabel = [[UILabel alloc] initWithFrame:CGRectMake(RH(269), RH(84), RH(67), RH(16))];
        _priceLabel.textColor = RGB(68, 68, 68);
        _priceLabel.text = @"10k/局";
        _priceLabel.layer.cornerRadius = RH(15);
        _priceLabel.textAlignment = NSTextAlignmentCenter;
        _priceLabel.font = RF(16);
        [_whiteView addSubview:_priceLabel];
        
        UILabel *priceSettingLabel = [[UILabel alloc] initWithFrame:CGRectMake(RH(26), RH(44) + currentPriceLabel.bottom, RH(67), RH(16))];
        priceSettingLabel.textColor = RGB(68, 68, 68);
        priceSettingLabel.text = @"价格设置";
        priceSettingLabel.textAlignment = NSTextAlignmentCenter;
        priceSettingLabel.font = [KKFont pingfangFontStyle:PFFontStyleMedium size:15];
        [_whiteView addSubview:priceSettingLabel];
        
        UIButton *subtractButton = [UIButton buttonWithType:UIButtonTypeCustom];
        subtractButton.frame = CGRectMake(RH(167), RH(140), RH(25), RH(25));
        [_whiteView addSubview:subtractButton];
        [subtractButton setTitle:@"-" forState:UIControlStateNormal];
        [subtractButton setTitleColor:RGB(68, 68, 68) forState:UIControlStateNormal];
        subtractButton.layer.cornerRadius = RH(12.5);
        subtractButton.layer.borderWidth = RH(1.5);
        subtractButton.layer.borderColor = RGB(68, 68, 68).CGColor;
        [subtractButton addTapWithTimeInterval:0.1 tapBlock:^(UIView * _Nonnull view) {
            weakSelf.kCoin --;
            if (weakSelf.kCoin < weakSelf.price.minPrice.integerValue) {
                [CC_Notice show:[NSString stringWithFormat:@"价格不能小于%@", weakSelf.price.minPrice]];
                weakSelf.kCoin = weakSelf.price.minPrice.integerValue;
                return ;
            }
            weakSelf.showPriceLabel.text = [NSString stringWithFormat:@"%lu%@", weakSelf.kCoin, @"K"];
        }];
        
        _showPriceLabel = [[UILabel alloc] initWithFrame:CGRectMake(subtractButton.right + RH(10), RH(137), RH(97), RH(30))];
        _showPriceLabel.backgroundColor = RGB(242, 242, 242);
        _showPriceLabel.textColor = RGB(68, 68, 68);
        _showPriceLabel.text = [NSString stringWithFormat:@"%lu%@", _kCoin, @"K"];
        _showPriceLabel.textAlignment = NSTextAlignmentCenter;
        _showPriceLabel.font = RF(15);
        [_whiteView addSubview:_showPriceLabel];
        
        UIButton *addButton = [UIButton buttonWithType:UIButtonTypeCustom];
        addButton.frame = CGRectMake(_showPriceLabel.right + RH(10), RH(140), RH(25), RH(25));
        [_whiteView addSubview:addButton];
        [addButton setTitle:@"+" forState:UIControlStateNormal];
        [addButton setTitleColor:RGB(68, 68, 68) forState:UIControlStateNormal];
        addButton.layer.cornerRadius = RH(12.5);
        addButton.layer.borderWidth = RH(1.5);
        addButton.layer.borderColor = RGB(68, 68, 68).CGColor;
        [addButton addTapWithTimeInterval:0.1 tapBlock:^(UIView * _Nonnull view) {
            weakSelf.kCoin ++;
            if (weakSelf.kCoin > weakSelf.price.maxPrice.integerValue) {
                [CC_Notice show:@"已经到达最大价格"];
                weakSelf.kCoin = weakSelf.price.maxPrice.integerValue;
                return ;
            }
            weakSelf.showPriceLabel.text = [NSString stringWithFormat:@"%lu%@", weakSelf.kCoin, @"K"];
        }];
        
        CC_Button *quitButton = [CC_Button buttonWithType:UIButtonTypeCustom];
        quitButton.top = RH(220);
        quitButton.left = RH(21);
        quitButton.size = CGSizeMake(_whiteView.width - RH(42), RH(45));
        [quitButton setTitle:@"确定" forState:UIControlStateNormal];
        quitButton.backgroundColor = KKES_COLOR_MAIN_YELLOW;
        quitButton.layer.cornerRadius = RH(4);
        [quitButton addTapWithTimeInterval:0.2 tapBlock:^(UIView * _Nonnull view) {
            if (weakSelf.tapComfirmButtonBlock) {
                weakSelf.tapComfirmButtonBlock(self.price.userGameBoardPriceConfigId, [NSString stringWithFormat:@"%lu", weakSelf.kCoin]);
            }
        }];
        [_whiteView addSubview:quitButton];
    }
    return self;
}

- (void)setModel:(KKGamePrice *)model {
    self.price = model;
    _kCoin = model.gameBoardPrice.integerValue;
    _showPriceLabel.text = [NSString stringWithFormat:@"%lu%@", _kCoin, @"K币"];
    _priceLabel.text = [NSString stringWithFormat:@"%@K币/人", model.gameBoardPrice];
}


- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    // 1.判断当前控件能否接收事件
    if (self.userInteractionEnabled == NO || self.hidden == YES || self.alpha <= 0.01) return nil;
    // 2. 判断点在不在当前控件
    if ([self pointInside:point withEvent:event] == NO) return nil;
    // 3.从后往前遍历自己的子控件
    NSInteger count = self.subviews.count;
    for (NSInteger i = count - 1; i >= 0; i--) {
        UIView *childView = self.subviews[i];
        // 把当前控件上的坐标系转换成子控件上的坐标系
        CGPoint childP = [self convertPoint:point toView:childView];
        UIView *fitView = [childView hitTest:childP withEvent:event];
        if (fitView) { // 寻找到最合适的view
            return fitView;
        }
    }
    // 循环结束,表示没有比自己更合适的view
    return self;
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    CGPoint p = [[touches anyObject] locationInView:self];
    if (!CGRectContainsPoint(self.whiteView.frame, p)) {
        [self removeFromSuperview];
    }
}
@end
