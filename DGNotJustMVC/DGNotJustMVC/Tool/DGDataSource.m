//
//  DGDataSource.m
//  DGNotJustMVC
//
//  Created by David.G on 2019/7/9.
//  Copyright © 2019 David.G. All rights reserved.
//

#import "DGDataSource.h"


@interface DGDataSource ()
//sb
@property (nonatomic, copy) IBInspectable NSString *cellId;

@property (nonatomic, copy) DGCellConfigBlock configBlock;

@property (nonatomic, copy) DGCellSelectBlock selectBlock;

@end


@implementation DGDataSource


#pragma mark - public function
-(id)initWithIdentifier:(NSString *)identifier configBlock:(DGCellConfigBlock)configBlock selectBlock:(DGCellSelectBlock)selectBlock {
    self = [super init];
    if (self) {
        _cellId = identifier;
        _configBlock = configBlock;
        _selectBlock = selectBlock;
    }
    return self;
}


- (id)modelAtIndexPath:(NSIndexPath *)indexPath {
    return self.modelArray.count > indexPath.row ? self.modelArray[indexPath.row] : nil;
}

#pragma mark - tableView
#pragma mark dataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return !self.modelArray  ? 0: self.modelArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:self.cellId forIndexPath:indexPath];
    id model = [self modelAtIndexPath:indexPath];
    
    if(self.configBlock) {
        self.configBlock(cell, model,indexPath);
    }
    
    return cell;
}

#pragma mark delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    self.selectBlock(indexPath);
}


#pragma mark - collectionView
#pragma mark dataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return !self.modelArray  ? 0: self.modelArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
   
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:self.cellId forIndexPath:indexPath];
    id model = [self modelAtIndexPath:indexPath];
    
    if(self.configBlock) {
        self.configBlock(cell, model,indexPath);
    }
    
    return cell;
}


#pragma mark delegate
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    self.selectBlock(indexPath);
}


@end
