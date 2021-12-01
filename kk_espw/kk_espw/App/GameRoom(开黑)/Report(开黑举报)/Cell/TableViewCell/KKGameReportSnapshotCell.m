//
//  KKGameReportScreenshotCell.m
//  kk_espw
//
//  Created by hsd on 2019/7/25.
//  Copyright © 2019 david. All rights reserved.
//

#import "KKGameReportSnapshotCell.h"
#import "KKGameReportSnapshotCollectionCell.h"
#import "KKCollectionViewCustomLayout.h"
#import "KKChangeImageColorModel.h"
#import "DGImagePickerManager.h"

#define  reportMaxSelectedCount 3

@interface KKGameReportSnapshotCell ()<UICollectionViewDelegate, UICollectionViewDataSource, KKCollectionViewCustomLayoutDelegate>
{
    NSArray *_selectedArr;
}
@property (nonatomic, strong, nonnull) UICollectionView *collectionView;
@property (nonatomic, strong, nonnull) UILabel *titleLabel;
@property (nonatomic, strong, nonnull) DGImagePickerManager *imagePickerMgr;

@end

@implementation KKGameReportSnapshotCell

#pragma mark - init
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self initTitleLabel];
        [self initCollectionView];
    }
    return self;
}

- (void)initTitleLabel {
    self.titleLabel = [[UILabel alloc] init];
    self.titleLabel.numberOfLines = 1;
    self.titleLabel.textColor = KKES_COLOR_HEX(0x999999);
    self.titleLabel.font = [KKFont pingfangFontStyle:PFFontStyleMedium size:12];
    self.titleLabel.textAlignment = NSTextAlignmentLeft;
    self.titleLabel.text = @"最多上传3张图片，单张图最大3M";
    [self.contentView addSubview:self.titleLabel];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.contentView).mas_offset(25);
        make.right.mas_lessThanOrEqualTo(self.contentView);
        make.bottom.mas_equalTo(self.contentView).mas_offset(-14);
        make.height.mas_equalTo(13);
    }];
}

- (void)initCollectionView {
    
    KKCollectionViewCustomLayout *layout = [[KKCollectionViewCustomLayout alloc] init];
    layout.sectionInsets = UIEdgeInsetsMake(14, 25, 10, 25);
    layout.itemSpace = 10;
    layout.layoutDelegate = self;
    
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    self.collectionView.showsVerticalScrollIndicator = NO;
    self.collectionView.showsHorizontalScrollIndicator = NO;
    self.collectionView.backgroundColor = [UIColor whiteColor];
    
    //注册 cell
    [self.collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([KKGameReportSnapshotCollectionCell class]) bundle:nil] forCellWithReuseIdentifier:NSStringFromClass([KKGameReportSnapshotCollectionCell class])];
    
    [self.contentView addSubview:self.collectionView];
    
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(self.contentView);
        make.bottom.mas_equalTo(self.titleLabel.mas_top).mas_offset(-10);
        make.top.mas_equalTo(self.contentView);
    }];
}

#pragma mark - KKCollectionViewCustomLayoutDelegate
/// 返回 indexPath 位置的 cell Size
- (CGSize)layout:(KKCollectionViewCustomLayout *_Nonnull)layout itemSizeForIndexPath:(NSIndexPath *_Nonnull)indexPath {
    return CGSizeMake(90, 90);
}

#pragma mark - UICollectionViewDataSource
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _selectedArr.count+1;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    KKGameReportSnapshotCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([KKGameReportSnapshotCollectionCell class]) forIndexPath:indexPath];
    
    if (indexPath.row == _selectedArr.count) {
        cell.cellType = KKGameReportSnapshotCollectionCellTypeAdd;
        [cell setMainImage:nil];
    }else {
        cell.cellType = KKGameReportSnapshotCollectionCellTypeSnapshot;
        [cell setMainImage:_selectedArr[indexPath.row]];
    }

    WS(weakSelf)
    __block NSInteger row = indexPath.row;
    cell.deleteBlock = ^{
        SS(strongSelf)
        
        NSMutableArray *tempMutArr = strongSelf->_selectedArr.mutableCopy;
        [tempMutArr removeObjectAtIndex:row];
        strongSelf->_selectedArr = tempMutArr.mutableCopy;
        [strongSelf.collectionView reloadData];
        
        if (strongSelf.imageSelect) {
            strongSelf.imageSelect(strongSelf->_selectedArr);
        }
    };
    
    return cell;
}

#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == _selectedArr.count) {
        if (_selectedArr.count > reportMaxSelectedCount) {
            [CC_Notice show:@"最多选择3张"];
            return;
        }
        WS(weakSelf)
        self.imagePickerMgr.maxImageCount = reportMaxSelectedCount-_selectedArr.count;
        [self.imagePickerMgr presentImagePickerByVC:self.viewController];
        self.imagePickerMgr.finishBlock = ^(NSArray<UIImage *> *seletedImages) {
            SS(strongSelf)
            NSMutableArray *allArr = [NSMutableArray new];
            [allArr addObjectsFromArray:strongSelf->_selectedArr];
            [allArr addObjectsFromArray:seletedImages];
            strongSelf->_selectedArr = [allArr mutableCopy];
            [strongSelf.collectionView reloadData];
            
            if (strongSelf.imageSelect) {
                strongSelf.imageSelect(strongSelf->_selectedArr);
            }
        };
    }
}

#pragma mark - system
- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

-(DGImagePickerManager *)imagePickerMgr {
    if (!_imagePickerMgr) {
        _imagePickerMgr = [[DGImagePickerManager alloc] initWithMaxImageCount:reportMaxSelectedCount];
    }
    return _imagePickerMgr;
}
@end
