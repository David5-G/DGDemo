//
//  KKCollectionViewCustomLayout.m
//  kk_espw
//
//  Created by hsd on 2019/7/15.
//  Copyright © 2019 david. All rights reserved.
//

#import "KKCollectionViewCustomLayout.h"

@interface KKCollectionViewCustomLayout ()

@property (nonatomic, assign) CGFloat section_top; //分区头部偏移
@property (nonatomic, assign) CGFloat section_left; //分区左侧偏移
@property (nonatomic, assign) CGFloat section_bottom; //分区底部偏移
@property (nonatomic, assign) CGFloat section_right; //分区右侧偏移

@property (nonatomic, assign) CGFloat max_itemX; //记录最大X值

@property (nonatomic, assign) NSInteger itemCount; //cell数量

@property (nonatomic, strong) NSMutableArray<UICollectionViewLayoutAttributes *> *attributesArray;//所有cell布局属性

@end

@implementation KKCollectionViewCustomLayout

@synthesize layoutDelegate;

- (void)setSectionInsets:(UIEdgeInsets)sectionInsets {
    _sectionInsets = sectionInsets;
    self.section_top = self.sectionInsets.top;
    self.section_left = self.sectionInsets.left;
    self.section_bottom = self.sectionInsets.bottom;
    self.section_right = self.sectionInsets.right;
}

- (instancetype)init {
    if (self = [super init]) {
        self.attributesArray = [NSMutableArray array];
        self.sectionInsets = UIEdgeInsetsZero;
        self.section_top = 0.0;
        self.section_left = 0.0;
        self.section_bottom = 0.0;
        self.section_right = 0.0;
        self.max_itemX = 0.0;
        self.itemCount = 0;
    }
    return self;
}

#pragma mark - 获取 indexPath 位置 正确的 cell frame
- (CGRect)getCellTrueFrame:(NSIndexPath *)indexPath Size:(CGSize)size {
    
    CGFloat pointX = 0;
    CGFloat pointY = 0;
    
    CGFloat width = size.width;
    CGFloat height = size.height;
    
    // 需要多行显示
    if ([self.layoutDelegate respondsToSelector:@selector(layout:oneLineMaxItemsShowInSection:)]) {
        
        NSInteger maxShowCount = [self.layoutDelegate layout:self oneLineMaxItemsShowInSection:indexPath.section];
        
        if (maxShowCount > 0) {
            
            NSInteger indexX = indexPath.item % maxShowCount;
            NSInteger indexY = (NSInteger)floor((CGFloat)indexPath.item / (CGFloat)maxShowCount);
            
            pointX = self.section_left + indexX * (width + self.itemSpace);
            pointY = self.section_top + indexY * (height + self.lineSpace);
            
        } else { //一行显示
            pointX = self.section_left + indexPath.item * (width + self.itemSpace);
            pointY = self.section_top;
        }
        
    } else { //一行显示
        pointX = self.section_left + indexPath.item * (width + self.itemSpace);
        pointY = self.section_top;
    }
    
    // 获取 max_itemX 的值
    if (indexPath.item == self.itemCount - 1) {
        
        NSInteger maxShowCount = 0;
        if ([self.layoutDelegate respondsToSelector:@selector(layout:oneLineMaxItemsShowInSection:)]) {
            maxShowCount = [self.layoutDelegate layout:self oneLineMaxItemsShowInSection:indexPath.section];
        }
        
        // 说明一行显示
        if (maxShowCount < 1) {
            self.max_itemX = pointX + width + self.section_right;
        } else {// 多行显示
            self.max_itemX = self.collectionView.bounds.size.width;
        }
    }
    
    return CGRectMake(pointX, pointY, width, height);
}

#pragma mark - system
//必实现,  返回 collectionView 尺寸 (后于 prepareLayout 调用)
- (CGSize)collectionViewContentSize {
    return CGSizeMake(self.max_itemX, self.collectionView.bounds.size.height);
}

//重写系统为布局提供必要参数的方法
- (void)prepareLayout {
    [super prepareLayout];
    
    // 重新布局时,清空之前的数据
    [self.attributesArray removeAllObjects];
    
    self.itemCount = [self.collectionView numberOfItemsInSection:0];
    
    // 循环遍历, 获取每个 item 的 attribute
    for (int i = 0; i < self.itemCount; i ++) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:i inSection:0];
        UICollectionViewLayoutAttributes *attri = [self layoutAttributesForItemAtIndexPath:indexPath];
        [self.attributesArray addObject:attri];
    }
}

// 返回每一个 cell 对应的 attribute
- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    UICollectionViewLayoutAttributes *attribite = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
    
    CGSize itemSize = [self.layoutDelegate layout:self itemSizeForIndexPath:indexPath];
    CGRect frame = [self getCellTrueFrame:indexPath Size:itemSize];
    attribite.frame = frame;
    
    return attribite;
}

// 该方法是返回在一个rect中的Cell Attributes
- (NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect {
    
    NSMutableArray *layoutAttribute = [NSMutableArray array];
    
    [self.attributesArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        UICollectionViewLayoutAttributes *attribute = obj;
        if (CGRectIntersectsRect(attribute.frame, rect)) {
            [layoutAttribute addObject:attribute];
        }
    }];
    
    return layoutAttribute;
}

// bounds变化时是否需要重新布局
- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds {
    return YES;
}

@end
