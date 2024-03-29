//
//  XTPopView.h
//  XTPopView
//
//  Created by zjwang on 16/5/23.
//  Copyright © 2016年 夏天. All rights reserved.
//

#import <UIKit/UIKit.h>
#define ScreenWidth [UIScreen mainScreen].bounds.size.width
#define ScreenHeight [UIScreen mainScreen].bounds.size.height
#define Length 8
#define Length2 15
typedef NS_ENUM(NSInteger, XTDirectionType)
{
    XTTypeOfUpLeft,     // 上左
    XTTypeOfUpCenter,   // 上中
    XTTypeOfUpRight,    // 上右
    
    XTTypeOfDownLeft,   // 下左
    XTTypeOfDownCenter, // 下中
    XTTypeOfDownRight,  // 下右
    
    XTTypeOfLeftUp,     // 左上
    XTTypeOfLeftCenter, // 左中
    XTTypeOfLeftDown,   // 左下
    
    XTTypeOfRightUp,    // 右上
    XTTypeOfRightCenter,// 右中
    XTTypeOfRightDown,  // 右下
    
    XTTypeOfTopRightRightAngle, /// 上右
    XTTypeNarmol,
    
};


@interface XTPopViewBase : UIView

// backGoundView
@property (nonatomic, strong) UIView  * _Nonnull backGoundView;

@property (nonatomic, assign) CGPoint origin;

@property (nonatomic, assign) CGFloat height;

@property (nonatomic, assign) CGFloat width;

@property (nonatomic, assign) XTDirectionType type;

@property (nonatomic, assign) CGFloat cornerRadius;


/**
 initWithOrigin

 @param origin 箭头的点位置
 @param width 视图宽
 @param height 视图高
 @param type 箭头的方向
 @param bgColor 颜色
 @param cornerRadius 圆角
 @return 对象
 */
- (instancetype _Nonnull)initWithOrigin:(CGPoint) origin
                         Width:(CGFloat) width
                        Height:(CGFloat) height
                          Type:(XTDirectionType)type
                         bgColor:( UIColor * _Nonnull )bgColor
                  cornerRadius:(CGFloat)cornerRadius;

- (void)popView;

@end
