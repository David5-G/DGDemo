//
//  KKGameModePlayCell.m
//  kk_espw
//
//  Created by hsd on 2019/7/17.
//  Copyright © 2019 david. All rights reserved.
//

#import "KKGameModePlayCell.h"
#import "KKCollectionViewCustomLayout.h"
#import "KKGameModePlayCollectionCell.h"
#import "KKCreateGameRoomExternKey.h"

@interface KKGameModePlayCell ()<UICollectionViewDelegate, UICollectionViewDataSource, KKCollectionViewCustomLayoutDelegate>

@property (nonatomic, strong, nonnull) UICollectionView *collectionView;

@property (nonatomic, strong, nonnull) NSIndexPath *selectIndexPath;    ///< 选中item

@end

@implementation KKGameModePlayCell

#pragma mark - set
- (void)setSectionInsets:(UIEdgeInsets)sectionInsets {
    _sectionInsets = sectionInsets;
    
    KKCollectionViewCustomLayout *layout = (KKCollectionViewCustomLayout *)self.collectionView.collectionViewLayout;
    if ([layout isKindOfClass:[KKCollectionViewCustomLayout class]]) {
        layout.sectionInsets = sectionInsets;
    }
}

- (void)setDataSourceArray:(NSArray<NSDictionary *> *)dataSourceArray {
    _dataSourceArray = dataSourceArray;
    
    for (NSInteger index = 0; index < dataSourceArray.count; index ++) {
        NSDictionary *dic = dataSourceArray[index];
        if ([self.defaultSelectTypeString isEqualToString:dic[kkCreateGameRoom_param_data]]) {
            self.selectIndexPath = [NSIndexPath indexPathForItem:index inSection:0];
            break;
        }
    }
    
    [self.collectionView reloadData];
}

#pragma mark - init
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.maxShowOneLine = 0;
        self.selectIndexPath = [NSIndexPath indexPathForItem:0 inSection:0];
        [self initCollectionView];
    }
    return self;
}

- (void)initCollectionView {
    KKCollectionViewCustomLayout *layout = [[KKCollectionViewCustomLayout alloc] init];
    layout.sectionInsets = UIEdgeInsetsMake(0, 18, 13, 18);
    layout.lineSpace = 15;
    layout.itemSpace = 16;
    layout.layoutDelegate = self;
    
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    self.collectionView.showsVerticalScrollIndicator = NO;
    self.collectionView.showsHorizontalScrollIndicator = NO;
    self.collectionView.backgroundColor = [UIColor whiteColor];
    
    //注册 cell
    [self.collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([KKGameModePlayCollectionCell class]) bundle:nil] forCellWithReuseIdentifier:NSStringFromClass([KKGameModePlayCollectionCell class])];
    
    [self.contentView addSubview:self.collectionView];
    
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.mas_equalTo(self.contentView);
    }];
}

#pragma mark - Action
- (void)showSelectUI:(NSIndexPath *)indexPath select:(BOOL)isSelect needReload:(BOOL)needReload {
    KKGameModePlayCollectionCell *cell = (KKGameModePlayCollectionCell *)[self.collectionView cellForItemAtIndexPath:indexPath];
    if ([cell isKindOfClass:[KKGameModePlayCollectionCell class]]) {
        [self setCellState:cell indexPath:indexPath isSelect:isSelect];
    }
    
    //需要刷新
    if (needReload) {
        for (KKGameModePlayCollectionCell *theCell in self.collectionView.visibleCells) {
            if ([theCell isKindOfClass:[KKGameModePlayCollectionCell class]]) {
                NSIndexPath *theIndexPath = [self.collectionView indexPathForCell:theCell];
                [self setCellState:theCell indexPath:theIndexPath isSelect:(theCell == cell)];
            }
        }
    }
}

- (void)setCellState:(KKGameModePlayCollectionCell *)cell indexPath:(NSIndexPath *)indexPath isSelect:(BOOL)isSelect {
    if (isSelect) {
        cell.mainImage = Img([self.dataSourceArray[indexPath.item] objectForKey:kkCreateGameRoom_select_image]);
        [cell resetViewBorder:YES];
    } else {
        cell.mainImage = Img([self.dataSourceArray[indexPath.item] objectForKey:kkCreateGameRoom_normal_image]);
        [cell resetViewBorder:NO];
    }
}

#pragma mark - KKCollectionViewCustomLayoutDelegate
/// 返回 indexPath 位置的 cell Size
- (CGSize)layout:(KKCollectionViewCustomLayout *_Nonnull)layout itemSizeForIndexPath:(NSIndexPath *_Nonnull)indexPath {
    return CGSizeMake(61, 60);
}

- (NSInteger)layout:(KKCollectionViewCustomLayout *)layout oneLineMaxItemsShowInSection:(NSUInteger)section {
    return self.maxShowOneLine;
}

#pragma mark - UICollectionViewDataSource
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataSourceArray.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    KKGameModePlayCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([KKGameModePlayCollectionCell class]) forIndexPath:indexPath];
    
    BOOL isSelect = (indexPath.item == self.selectIndexPath.item && indexPath.section == self.selectIndexPath.section);
    NSDictionary *dataDic = self.dataSourceArray[indexPath.item];
    
    cell.titleString = dataDic[kkCreateGameRoom_title];
    [self setCellState:cell indexPath:indexPath isSelect:isSelect];
    
    if (isSelect && self.selectBlock) {
        self.selectBlock(dataDic[kkCreateGameRoom_param_data], NO);
    }
    
    return cell;
}

#pragma mark - UICollectionViewDelegate
- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)collectionView:(UICollectionView *)collectionView didHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
    [self showSelectUI:indexPath select:YES needReload:NO];
}

- (void)collectionView:(UICollectionView *)collectionView didUnhighlightItemAtIndexPath:(NSIndexPath *)indexPath {
    [self showSelectUI:indexPath select:NO needReload:NO];
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    self.selectIndexPath = indexPath;
    [self showSelectUI:indexPath select:YES needReload:YES];
    if (self.selectBlock) {
        self.selectBlock([self.dataSourceArray[indexPath.item] objectForKey:kkCreateGameRoom_param_data], YES);
    }
}

- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath {
    [self showSelectUI:indexPath select:NO needReload:YES];
}

#pragma mark - system
- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
