//
//  DGDataSource.h
//  DGNotJustMVC
//
//  Created by David.G on 2019/7/9.
//  Copyright © 2019 David.G. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void (^DGCellConfigBlock)(id cell, id model, NSIndexPath * indexPath);
typedef void (^DGCellSelectBlock) (NSIndexPath *indexPath);

@interface DGDataSource : NSObject <UITableViewDataSource,UITableViewDelegate,UICollectionViewDataSource,UICollectionViewDelegate>

- (id)initWithIdentifier:(NSString *)identifier configBlock:(DGCellConfigBlock)configBlock selectBlock:(DGCellSelectBlock)selectBlock;

- (id)modelAtIndexPath:(NSIndexPath *)indexPath;

@property (nonatomic, strong) NSArray *modelArray;


@end

NS_ASSUME_NONNULL_END
