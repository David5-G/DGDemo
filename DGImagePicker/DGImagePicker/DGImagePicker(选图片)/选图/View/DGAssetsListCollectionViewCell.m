//
//  DGAssetsListCollectionViewCell.m
//  DGImagePicker
//
//  Created by david on 2018/12/18.
//  Copyright © 2018 david. All rights reserved.
//

#import "DGAssetsListCollectionViewCell.h"

@implementation DGAssetsListCollectionViewCell

-(instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self.contentView addSubview:self.selectView];
    }
    return self;
}


#pragma mark setter
-(void)setAsset:(ALAsset *)asset {
    _asset = asset;
    self.selectView.asset = asset;
}

#pragma mark - lazy load
-(DGSelectImgView *)selectView {
    if (_selectView == nil) {
        _selectView = [[DGSelectImgView alloc] initWithFrame:self.bounds];
    }
    return _selectView;
}


@end
