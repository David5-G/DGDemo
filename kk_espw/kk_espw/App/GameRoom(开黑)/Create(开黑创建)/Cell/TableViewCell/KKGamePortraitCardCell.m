//
//  KKGamePortraitCardCell.m
//  kk_espw
//
//  Created by hsd on 2019/7/17.
//  Copyright © 2019 david. All rights reserved.
//

#import "KKGamePortraitCardCell.h"
#import "KKCollectionViewCustomLayout.h"
#import "KKGamePortraitCardCollectionCell.h"

@interface KKGamePortraitCardCell ()<UICollectionViewDelegate, UICollectionViewDataSource, KKCollectionViewCustomLayoutDelegate>

@property (nonatomic, strong, nonnull) UICollectionView *collectionView;

@property (nonatomic, strong, nonnull) NSIndexPath *selectIndexPath;    ///< 选中item

@end

@implementation KKGamePortraitCardCell
#pragma mark - set
- (void)setDataSourceArray:(NSArray<KKCardTag *> *)dataSourceArray {
    _dataSourceArray = dataSourceArray;
    
    for (NSInteger index = 0; index < dataSourceArray.count; index ++) {
        KKCardTag *tag = dataSourceArray[index];
        if ([self.defaultSelectProfileId isEqualToString:tag.ID]) {
            self.selectIndexPath = [NSIndexPath indexPathForItem:index inSection:0];
            break;
        }
    }
    
    [self.collectionView reloadData];
    if (dataSourceArray.count > 0) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.collectionView scrollToItemAtIndexPath:self.selectIndexPath atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
        });
    }
}

#pragma mark - init
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectIndexPath = [NSIndexPath indexPathForItem:0 inSection:0];
        [self initCollectionView];
    }
    return self;
}

- (void)initCollectionView {
    
    KKCollectionViewCustomLayout *layout = [[KKCollectionViewCustomLayout alloc] init];
    layout.sectionInsets = UIEdgeInsetsMake(0, 18, 13, 18);
    layout.itemSpace = 16;
    layout.layoutDelegate = self;
    
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    self.collectionView.showsVerticalScrollIndicator = NO;
    self.collectionView.showsHorizontalScrollIndicator = NO;
    self.collectionView.backgroundColor = [UIColor whiteColor];
    
    //注册 cell
    [self.collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([KKGamePortraitCardCollectionCell class]) bundle:nil] forCellWithReuseIdentifier:NSStringFromClass([KKGamePortraitCardCollectionCell class])];
    
    [self.contentView addSubview:self.collectionView];
    
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.mas_equalTo(self.contentView);
    }];
}

#pragma mark - Action
- (void)showSelectUI:(NSIndexPath *)indexPath select:(BOOL)isSelect needReload:(BOOL)needReload {
    KKGamePortraitCardCollectionCell *cell = (KKGamePortraitCardCollectionCell *)[self.collectionView cellForItemAtIndexPath:indexPath];
    if ([cell isKindOfClass:[KKGamePortraitCardCollectionCell class]]) {
        [cell resetViewBorder:isSelect];
    }
    
    //需要刷新
    if (needReload) {
        for (KKGamePortraitCardCollectionCell *theCell in self.collectionView.visibleCells) {
            if ([theCell isKindOfClass:[KKGamePortraitCardCollectionCell class]]) {
                [theCell resetViewBorder:(theCell == cell)];
            }
        }
    }
}

#pragma mark - KKCollectionViewCustomLayoutDelegate
/// 返回 indexPath 位置的 cell Size
- (CGSize)layout:(KKCollectionViewCustomLayout *_Nonnull)layout itemSizeForIndexPath:(NSIndexPath *_Nonnull)indexPath {
    return CGSizeMake(137, 58);
}

#pragma mark - UICollectionViewDataSource
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataSourceArray.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    KKGamePortraitCardCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([KKGamePortraitCardCollectionCell class]) forIndexPath:indexPath];
    
    KKCardTag *cardTag = self.dataSourceArray[indexPath.item];
    BOOL isMan = [cardTag.sex.name isEqualToString:@"M"];
    BOOL isSelect = (indexPath.item == self.selectIndexPath.item && indexPath.section == self.selectIndexPath.section);
    
    cell.sexImage = Img(isMan ? @"game_card_sex_man" : @"game_card_sex_woman");
    cell.nickNameString = cardTag.nickName;
    cell.accountSourceString = cardTag.platformType.message;
    cell.levelString = cardTag.rank.message;
    [cell resetViewBorder:isSelect];
    
    WS(weakSelf)
    cell.editBlock = ^{
        if (weakSelf.editBlock) {
            weakSelf.editBlock(cardTag, YES);
        }
    };
    
    if (isSelect && self.selectBlock) {
        self.selectBlock(cardTag, NO);
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
        self.selectBlock(self.dataSourceArray[indexPath.item], YES);
    }
    [collectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
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
