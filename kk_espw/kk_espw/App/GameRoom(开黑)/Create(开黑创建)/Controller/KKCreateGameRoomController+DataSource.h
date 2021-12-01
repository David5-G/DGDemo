//
//  KKCreateGameRoomController+DataSource.h
//  kk_espw
//
//  Created by hsd on 2019/7/29.
//  Copyright © 2019 david. All rights reserved.
//

#import "KKCreateGameRoomController.h"

NS_ASSUME_NONNULL_BEGIN

@interface KKCreateGameRoomController (DataSource)

/// 获取默认分区头数据源
- (NSArray<NSDictionary *> * _Nonnull)defaultSectionDataSource;

/// 根据分区获取该分区数据
- (NSArray * _Nonnull)dataSourceForSection:(NSInteger)section;

@end

NS_ASSUME_NONNULL_END
