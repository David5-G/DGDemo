//
//  MyLayout.m
//  UIConlectionView
//
//  Created by jaki on 15/10/27.
//  Copyright © 2015年 jaki. All rights reserved.
//

#import "MyLayout.h"

@implementation MyLayout

-(void)prepareLayout{
    [super prepareLayout];
    
}


-(CGSize)collectionViewContentSize{
    return CGSizeMake(self.collectionView.frame.size.width, self.collectionView.frame.size.height*([self.collectionView numberOfItemsInSection:0]+2));
}


-(BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds{
    return YES;
}

-(UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath{
    UICollectionViewLayoutAttributes * atti = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
    //获取item的个数
    int itemCounts = (int)[self.collectionView numberOfItemsInSection:0];
    atti.center = CGPointMake(self.collectionView.frame.size.width/2, self.collectionView.frame.size.height/2+self.collectionView.contentOffset.y);
    atti.size = CGSizeMake(260, 100);
    
    CATransform3D trans3D = CATransform3DIdentity;
    trans3D.m34 = -1/900.0;
    
    CGFloat radius = 50/tanf(M_PI*2/itemCounts/2);
    //根据偏移量 改变角度
    float offset = self.collectionView.contentOffset.y;
    float angleOffset = offset/self.collectionView.frame.size.height;
    CGFloat angle = (float)(indexPath.row+angleOffset-1)/itemCounts*M_PI*2;
    trans3D = CATransform3DRotate(trans3D, angle, 1.0, 0, 0);
    trans3D = CATransform3DTranslate(trans3D, 0, 0, radius);
    atti.transform3D = trans3D;
    return atti;
}


-(NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect{
    NSMutableArray * attributes = [[NSMutableArray alloc]init];
    //遍历设置每个item的布局属性
    for (int i=0; i<[self.collectionView numberOfItemsInSection:0]; i++) {
        [attributes addObject:[self layoutAttributesForItemAtIndexPath:[NSIndexPath indexPathForItem:i inSection:0]]];
    }
    return attributes;
}


@end
