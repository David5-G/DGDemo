//
//  KKCardTagView.h
//  kk_espw
//
//  Created by 景天 on 2019/7/16.
//  Copyright © 2019年 david. All rights reserved.
//

#import <UIKit/UIKit.h>
@class KKTag;
NS_ASSUME_NONNULL_BEGIN

@interface KKCardTagView : UIView
- (instancetype)initWithFrame:(CGRect)frame withTag:(KKTag *)tag;
@end

NS_ASSUME_NONNULL_END
