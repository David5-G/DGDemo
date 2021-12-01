//
//  KKGamePrepareToolView.h
//  kk_espw
//
//  Created by hsd on 2019/7/22.
//  Copyright © 2019 david. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, KKGamePrepareToolViewBtnType) {
    KKGamePrepareToolViewBtnTypeNoBorder            = 1,    ///< 不带边框
    KKGamePrepareToolViewBtnTypeBorder              = 2,    ///< 带边框
    KKGamePrepareToolViewBtnTypeAll                 = 3,    ///< 所有按钮
    KKGamePrepareToolViewBtnTypeNone                = 4,    ///< 不需要按钮
};

typedef void(^KKGamePrepareToolBlock)(CC_Button * _Nonnull btn);

NS_ASSUME_NONNULL_BEGIN

@interface KKGamePrepareToolView : UIView

@property (nonatomic, copy, nullable) KKGamePrepareToolBlock tapBlockBorder; ///< 带边框按钮点击回调
@property (nonatomic, copy, nullable) KKGamePrepareToolBlock tapBlockNoBorder; ///< 不带边框按钮点击回调

@property (nonatomic, assign) KKGamePrepareToolViewBtnType showBtnType; ///< 当前展示的按钮类型

@property (nonatomic, copy, nullable) NSString *titleString;        ///< 主标题

/// 设置副标题文本
- (void)setSubTitleString:(NSString * _Nullable)subTitleString attriStr:(NSString * _Nullable)attriStr;

/// 设置按钮标题
- (void)setTitle:(NSString * _Nullable)title
        forState:(UIControlState)state
   forButtonType:(KKGamePrepareToolViewBtnType)btnType;

/// 设置按钮可否交互
- (void)setButtonEnable:(BOOL)enable forButtonType:(KKGamePrepareToolViewBtnType)btnType;

@end

NS_ASSUME_NONNULL_END
