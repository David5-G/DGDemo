//
//  KKCapotalDetailCell.h
//  kk_espw
//
//  Created by 景天 on 2019/7/23.
//  Copyright © 2019年 david. All rights reserved.
//

#import <UIKit/UIKit.h>
@class KKCapitalAccount;
@class KKCapitalFreeze;
NS_ASSUME_NONNULL_BEGIN

@interface KKCapotalDetailCell : UITableViewCell
@property (nonatomic, strong) KKCapitalAccount *capitalAccount;
@property (nonatomic, strong) KKCapitalFreeze *capitalFreeze;

@end

NS_ASSUME_NONNULL_END
