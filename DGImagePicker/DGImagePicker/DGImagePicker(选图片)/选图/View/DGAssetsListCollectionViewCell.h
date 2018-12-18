//
//  DGAssetsListCollectionViewCell.h
//  DGImagePicker
//
//  Created by david on 2018/12/18.
//  Copyright © 2018 david. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DGSelectImgView.h"

@interface DGAssetsListCollectionViewCell : UICollectionViewCell

/** 选择标记View */
@property (nonatomic, strong) DGSelectImgView *selectView;

@property (nonatomic, strong) ALAsset *asset;

@end
