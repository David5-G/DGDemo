//
//  NOContentReminderView.h
//  视频横幅test
//
//  Created by mac on 2017/3/17.
//  Copyright © 2017年 mac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NoContentReminderView : UIView

@property (nonatomic,strong) UIImageView *imageV;

/** ①
 *@brief :通过传递内容创建 (会调用②)
 *@param toView 将视图放在某个视图上面
 *@param imageTopY 图片与这个视图顶端的距离
 *@param image 图片
 *@param remindWords 图片下方的文字
 */
+(instancetype)showReminderViewToView:(UIView*)toView imageTopY:(CGFloat)imageTopY image:(UIImage *)image remindWords:(NSAttributedString *)remindWords;

/**②
 *@brief :init方法
 *@param frame 视图的frame
 *@param imageTopY 图片与这个视图顶端的距离
 *@param image 图片
 *@param remindWords 图片下方的文字
 */
-(instancetype)initWithFrame:(CGRect)frame imageTopY:(CGFloat)imageTopY image:(UIImage *)image remindWords:(NSAttributedString *)remindWords;

/**
 修改图片下方的文字
 @param attributeString 文字
 */
-(void)updateRemindWords:(NSAttributedString *)attributeString numberOfLines:(NSInteger)numberOfLines;

@end
