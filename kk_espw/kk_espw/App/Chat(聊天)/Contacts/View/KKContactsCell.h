//
//  KKContactsCell.h
//  kk_espw
//
//  Created by 罗礼豪 on 2019/7/11.
//  Copyright © 2019 david. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KKContactModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface KKContactsCell : UITableViewCell

-(void)loadModel:(KKContactModel *)model;

@end

NS_ASSUME_NONNULL_END
