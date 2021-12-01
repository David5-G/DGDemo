//
//  KKCapitalDetailHeadView.h
//  kk_espw
//
//  Created by 景天 on 2019/7/23.
//  Copyright © 2019年 david. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@protocol KKCapitalDetailHeadViewDelegate <NSObject>

@optional
- (void)tapedIncomeButton;
- (void)tapedFreezeButton;
- (void)tapedStartDateButton;
- (void)tapedEndDateButton;
- (void)tapedSearchButton;
@end


@interface KKCapitalDetailHeadView : UIView
@property (nonatomic, weak) id<KKCapitalDetailHeadViewDelegate> delegate;
@property (nonatomic, strong) CC_Button *incomeAndExpensesButton;
@property (nonatomic, strong) CC_Button *freezeButton;
@property (nonatomic, strong) UIButton *calendarLeftButton;
@property (nonatomic, strong) UIButton *calendarRightButton;
@end

NS_ASSUME_NONNULL_END
