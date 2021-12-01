//
//  KKAddMyCardViewController.h
//  kk_espw
//
//  Created by 景天 on 2019/7/16.
//  Copyright © 2019年 david. All rights reserved.
//

#import "BaseViewController.h"
@class KKCardTag;
NS_ASSUME_NONNULL_BEGIN
@interface KKAddMyCardViewController : BaseViewController
@property (nonatomic, assign) BOOL isEdit;
@property (nonatomic, strong) KKCardTag *cardInfo;
@end

NS_ASSUME_NONNULL_END
