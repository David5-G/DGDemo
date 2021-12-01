//
//  KKCardsSelectView.h
//  kk_espw
//
//  Created by 景天 on 2019/7/11.
//  Copyright © 2019年 david. All rights reserved.
//

#import <UIKit/UIKit.h>
@class KKCardTag;
NS_ASSUME_NONNULL_BEGIN
typedef void(^didSelectTableViewCellBlock)(KKCardTag *card);
@interface KKCardsSelectView : UIView
@property (nonatomic, strong) NSMutableArray *dataList;
@property (nonatomic, copy) didSelectTableViewCellBlock didSelectTableViewCellBlock;
@property (nonatomic, strong) UIView *whiteView;
@end

NS_ASSUME_NONNULL_END
