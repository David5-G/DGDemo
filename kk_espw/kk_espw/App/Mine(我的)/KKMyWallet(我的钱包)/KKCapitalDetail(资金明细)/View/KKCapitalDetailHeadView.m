//
//  KKCapitalDetailHeadView.m
//  kk_espw
//
//  Created by 景天 on 2019/7/23.
//  Copyright © 2019年 david. All rights reserved.
//

#import "KKCapitalDetailHeadView.h"

@interface KKCapitalDetailHeadView ()

@end

@implementation KKCapitalDetailHeadView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        WS(weakSelf)
        _incomeAndExpensesButton = [CC_Button buttonWithType:UIButtonTypeCustom];
        _incomeAndExpensesButton.left = RH(0);
        _incomeAndExpensesButton.top = RH(23);
        _incomeAndExpensesButton.size = CGSizeMake(SCREEN_WIDTH / 2, RH(16));
        _incomeAndExpensesButton.titleLabel.adjustsFontSizeToFitWidth = YES;
        [_incomeAndExpensesButton setTitle:@"收支明细" forState:UIControlStateNormal];
        [_incomeAndExpensesButton setTitleColor:KKES_COLOR_MAIN_YELLOW forState:UIControlStateNormal];
        _incomeAndExpensesButton.titleLabel.font = [KKFont pingfangFontStyle:PFFontStyleSemibold size:16];
        [_incomeAndExpensesButton addTapWithTimeInterval:0.2 tapBlock:^(UIView * _Nonnull view) {
            
            if (weakSelf.delegate && [self.delegate respondsToSelector:@selector(tapedIncomeButton)]) {
                [weakSelf.delegate tapedIncomeButton];
            }
            [weakSelf.incomeAndExpensesButton setTitleColor:KKES_COLOR_MAIN_YELLOW forState:UIControlStateNormal];
            [weakSelf.freezeButton setTitleColor:KKES_COLOR_GRAY_TEXT forState:UIControlStateNormal];

        }];
        [self addSubview:_incomeAndExpensesButton];
        
        _freezeButton = [CC_Button buttonWithType:UIButtonTypeCustom];
        _freezeButton.left = _incomeAndExpensesButton.right;
        _freezeButton.top = RH(23);
        _freezeButton.size = CGSizeMake(SCREEN_WIDTH / 2, RH(16));
        _freezeButton.titleLabel.adjustsFontSizeToFitWidth = YES;
        [_freezeButton setTitle:@"冻结明细" forState:UIControlStateNormal];
        [_freezeButton setTitleColor:KKES_COLOR_GRAY_TEXT forState:UIControlStateNormal];
        _freezeButton.titleLabel.font = [KKFont pingfangFontStyle:PFFontStyleSemibold size:16];
        [_freezeButton addTapWithTimeInterval:0.2 tapBlock:^(UIView * _Nonnull view) {
            if (weakSelf.delegate && [self.delegate respondsToSelector:@selector(tapedFreezeButton)]) {
                [weakSelf.delegate tapedFreezeButton];
            }
            
            [weakSelf.incomeAndExpensesButton setTitleColor:KKES_COLOR_GRAY_TEXT forState:UIControlStateNormal];
            [weakSelf.freezeButton setTitleColor:KKES_COLOR_MAIN_YELLOW forState:UIControlStateNormal];
        }];
        [self addSubview:_freezeButton];
    
        /// 线
        UIView *line = New(UIView);
        line.left = 0;
        line.top = _incomeAndExpensesButton.bottom + RH(10);
        line.size = CGSizeMake(SCREEN_WIDTH, 1);
        line.backgroundColor = RGB(243, 243, 243);
        [self addSubview:line];
        
        /// 日历图片
        UIImageView *cal = New(UIImageView);
        cal.left = RH(14);
        cal.top = line.bottom + RH(17);
        cal.size = CGSizeMake(RH(16), RH(16));
        cal.image = Img(@"capital_calendar");
        [self addSubview:cal];
        
        /// 左侧日期选择
        _calendarLeftButton = [CC_Button buttonWithType:UIButtonTypeCustom];
        _calendarLeftButton.left = RH(45);
        _calendarLeftButton.top = RH(19) + line.bottom;
        _calendarLeftButton.size = CGSizeMake(RH(90), RH(11));
        
        /// 当前时间
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"yyyy-MM-dd"];
        NSDate *lastWeekDate = [[NSDate date] dateByAddingTimeInterval:-(7 * 24 * 60 * 60)];
        NSString *lastWeekStr = [formatter stringFromDate:lastWeekDate];
        
        [_calendarLeftButton setTitle:lastWeekStr forState:UIControlStateNormal];
        [_calendarLeftButton setTitleColor:RGB(102, 102, 102) forState:UIControlStateNormal];
        _calendarLeftButton.titleLabel.font = [KKFont pingfangFontStyle:PFFontStyleRegular size:14];
        [_calendarLeftButton addTapWithTimeInterval:0.2 tapBlock:^(UIView * _Nonnull view) {
            
            if (weakSelf.delegate && [self.delegate respondsToSelector:@selector(tapedStartDateButton)]) {
                [weakSelf.delegate tapedStartDateButton];
            }
        }];
        [self addSubview:_calendarLeftButton];
        
        UIImageView *arrow = New(UIImageView);
        arrow.left = RH(150);
        arrow.top = RH(19) + line.bottom;
        arrow.size = CGSizeMake(RH(6), RH(12));
        arrow.image = Img(@"wallat_detail_right");
        [self addSubview:arrow];
        
        /// 右侧日期选择
        _calendarRightButton = [CC_Button buttonWithType:UIButtonTypeCustom];
        _calendarRightButton.left = _calendarLeftButton.right + RH(35);
        _calendarRightButton.top = _calendarLeftButton.top;
        _calendarRightButton.size = CGSizeMake(RH(90), RH(11));
        
        /// 当前时间
        NSString *nowStr = [formatter stringFromDate:[NSDate date]];
        [_calendarRightButton setTitle:nowStr forState:UIControlStateNormal];
        [_calendarRightButton setTitleColor:RGB(102, 102, 102) forState:UIControlStateNormal];
        _calendarRightButton.titleLabel.font = [KKFont pingfangFontStyle:PFFontStyleRegular size:14];
        [_calendarRightButton addTapWithTimeInterval:0.2 tapBlock:^(UIView * _Nonnull view) {
            
            if (weakSelf.delegate && [self.delegate respondsToSelector:@selector(tapedEndDateButton)]) {
                [weakSelf.delegate tapedEndDateButton];
            }
        }];
        [self addSubview:_calendarRightButton];
        
        /// 搜索
        CC_Button *searchButton = [CC_Button buttonWithType:UIButtonTypeCustom];
        searchButton.left = SCREEN_WIDTH - RH(12) - RH(60);
        searchButton.top = line.bottom + RH(10);
        searchButton.size = CGSizeMake(RH(60), RH(29));
        [searchButton setTitle:@"搜索" forState:UIControlStateNormal];
        [searchButton setTitleColor:KKES_COLOR_MAIN_YELLOW forState:UIControlStateNormal];
        searchButton.titleLabel.font = [KKFont pingfangFontStyle:PFFontStyleRegular size:15];
        searchButton.backgroundColor = [UIColor whiteColor];
        searchButton.layer.cornerRadius = RH(5);
        searchButton.layer.borderColor = KKES_COLOR_MAIN_YELLOW.CGColor;
        searchButton.layer.borderWidth = 1;
        [searchButton addTapWithTimeInterval:0.2 tapBlock:^(UIView * _Nonnull view) {
            
            if (weakSelf.delegate && [self.delegate respondsToSelector:@selector(tapedSearchButton)]) {
                [weakSelf.delegate tapedSearchButton];
            }
        }];
        [self addSubview:searchButton];
        
    }
    return self;
}

@end
