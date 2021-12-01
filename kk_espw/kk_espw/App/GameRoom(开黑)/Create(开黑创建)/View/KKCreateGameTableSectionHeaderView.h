//
//  KKCreateGameTableHeaderView.h
//  kk_espw
//
//  Created by hsd on 2019/7/17.
//  Copyright © 2019 david. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/// 创建开黑房列表头视图
@interface KKCreateGameTableSectionHeaderView : UIView

/**
 设置标题文本
 
 @param allStr 显示的全部文字
 @param attriStr 需要特殊处理的文字(如果为nil, 则正常显示标题文本)
 */
- (void)setTitle:(NSString *_Nonnull)allStr attriStr:(NSString *_Nullable)attriStr;

@end

NS_ASSUME_NONNULL_END
