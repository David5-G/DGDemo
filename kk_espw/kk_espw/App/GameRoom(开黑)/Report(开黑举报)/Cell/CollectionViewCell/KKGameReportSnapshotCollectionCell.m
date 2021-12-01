//
//  KKGameReportSnapshotCollectionCell.m
//  kk_espw
//
//  Created by hsd on 2019/7/25.
//  Copyright © 2019 david. All rights reserved.
//

#import "KKGameReportSnapshotCollectionCell.h"

@interface KKGameReportSnapshotCollectionCell ()

@property (weak, nonatomic) IBOutlet UIImageView *mainImageView;
@property (weak, nonatomic) IBOutlet CC_Button *deleteBtn;

@end

@implementation KKGameReportSnapshotCollectionCell

#pragma mark - set
- (void)setCellType:(KKGameReportSnapshotCollectionCellType)cellType {
    _cellType = cellType;
    self.deleteBtn.hidden = (cellType == KKGameReportSnapshotCollectionCellTypeAdd);
}

- (void)setMainImage:(UIImage *)mainImg {
    if (!mainImg) {
        self.mainImageView.image = Img(@"game_report_add_snapshot");
    } else {
        self.mainImageView.image = mainImg;
    }
}

#pragma mark - system
- (void)awakeFromNib {
    [super awakeFromNib];
    [self resetSubViews];
}

#pragma mark - init
- (void)resetSubViews {
    
    _cellType = KKGameReportSnapshotCollectionCellTypeAdd;
    
    self.mainImageView.contentMode = UIViewContentModeScaleToFill;
    self.mainImageView.layer.cornerRadius = 4;
    self.mainImageView.layer.masksToBounds = YES;
    
    WS(weakSelf)
    [self.deleteBtn addTappedOnceDelay:0.2 withBlock:^(UIButton *button) {
        if (weakSelf.deleteBlock) {
            weakSelf.deleteBlock();
        }
    }];
}

#pragma mark - hitTest
- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    UIView *view = [super hitTest:point withEvent:event];
    if (!view) {
        for (UIView *subView in self.contentView.subviews) {
            CGPoint convertPoint = [self.contentView convertPoint:point toView:subView];
            if (CGRectContainsPoint(subView.bounds, convertPoint)) {
                return subView;
            }
        }
    }
    return view;
}

@end
