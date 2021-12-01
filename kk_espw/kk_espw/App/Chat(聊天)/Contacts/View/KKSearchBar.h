//
//  KKSearchBar.h
//  kk_espw
//
//  Created by 罗礼豪 on 2019/7/15.
//  Copyright © 2019 david. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface KKSearchBar : UISearchBar

// searchBar的textField
@property (nonatomic, weak) UITextField *textField;

/**
 清除搜索条以外的控件
 */
- (void)cleanOtherSubViews;

@end

NS_ASSUME_NONNULL_END
