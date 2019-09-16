//
//  MvcTableViewCell.h
//  DGNotJustMVC
//
//  Created by David.G on 2019/7/9.
//  Copyright © 2019 David.G. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DGModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface MvcTableViewCell : UITableViewCell

@property (nonatomic,strong) DGModel *model;

@end

NS_ASSUME_NONNULL_END
