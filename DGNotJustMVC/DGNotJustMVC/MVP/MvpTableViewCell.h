//
//  MvpTableViewCell.h
//  DGNotJustMVC
//
//  Created by David.G on 2019/7/10.
//  Copyright © 2019 David.G. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MvpDelegate.h"


NS_ASSUME_NONNULL_BEGIN

@interface MvpTableViewCell : UITableViewCell

@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *numLabel;
@property (nonatomic, assign) int num;
@property (nonatomic, strong) UIButton *subBtn;
@property (nonatomic, strong) UIButton *addBtn;

@property (nonatomic, strong) NSIndexPath *indexPath;
@property (nonatomic, weak) id<MvpDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
