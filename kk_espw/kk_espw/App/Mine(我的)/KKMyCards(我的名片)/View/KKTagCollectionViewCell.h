//
//  KKTagCollectionViewCell.h
//  kk_espw
//
//  Created by 景天 on 2019/8/11.
//  Copyright © 2019年 david. All rights reserved.
//

#import <UIKit/UIKit.h>
@class KKTag;
NS_ASSUME_NONNULL_BEGIN

@interface KKTagCollectionViewCell : UICollectionViewCell
@property (nonatomic, strong) KKTag *tagModel;
@end

NS_ASSUME_NONNULL_END
