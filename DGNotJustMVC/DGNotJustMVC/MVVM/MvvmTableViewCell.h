//
//  MvvmTableViewCell.h
//  DGNotJustMVC
//
//  Created by David.G on 2019/7/13.
//  Copyright © 2019 David.G. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class MvvmTableViewCell;

@protocol MvvmTableViewCellDelegate <NSObject>
@optional
- (void)didClickAddSubBtn:(MvvmTableViewCell *)cell;
@end

@interface MvvmTableViewCell : UITableViewCell
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *numLabel;
@property (nonatomic, assign) int num;
@property (nonatomic, strong) UIButton *subBtn;
@property (nonatomic, strong) UIButton *addBtn;

@property (nonatomic,strong) id<MvvmTableViewCellDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
