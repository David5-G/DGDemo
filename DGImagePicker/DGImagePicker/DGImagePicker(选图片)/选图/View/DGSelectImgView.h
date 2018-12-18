//
//  DGSelectImgView.h
//  DGImagePicker
//
//  Created by david on 2018/12/18.
//  Copyright © 2018 david. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <AssetsLibrary/AssetsLibrary.h>


@interface DGMarkView : UIView

/** 是否被选中 */
@property (nonatomic,assign) BOOL isSelected;

@end

#pragma mark -
//带有选择图片的覆盖层
@interface DGCoverView : UIView

/** 对号图标 */
@property (nonatomic,strong) DGMarkView *checkmarkView;

@end


#pragma mark -
@interface DGSelectImgView : UIView

@property (nonatomic,strong) ALAsset *asset;

/** 标记选中状态的View */
@property (nonatomic,strong,readonly) DGCoverView *coverView;

/** 是否被选中 */
@property (nonatomic,assign) BOOL isSelected;

@end

