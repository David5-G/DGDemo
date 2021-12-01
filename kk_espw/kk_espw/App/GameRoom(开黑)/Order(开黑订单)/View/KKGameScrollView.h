//
//  KKGameScrollView.h
//  kk_espw
//
//  Created by hsd on 2019/8/29.
//  Copyright © 2019 david. All rights reserved.
//

#import <UIKit/UIKit.h>

@class KKGameScrollView;

@protocol KKGameScrollViewDelegate <UIScrollViewDelegate>

@optional
/// 点击了子view
- (void)scrollView:(KKGameScrollView *_Nonnull)scrollView didTouchOtherView:(UIView *_Nonnull)view;

@end

NS_ASSUME_NONNULL_BEGIN

@interface KKGameScrollView : UIScrollView

@property (nonatomic, weak, nullable) id<KKGameScrollViewDelegate> touchDelegate;

@end

NS_ASSUME_NONNULL_END
