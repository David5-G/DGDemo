//
//  KKChatRoomUserListBaseView.h
//  kk_espw
//
//  Created by david on 2019/10/22.
//  Copyright © 2019 david. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void (^KKChatRoomUserListConfigBlock)(id cell, id model, NSIndexPath * indexPath);
typedef void (^KKChatRoomUserListSelectBlock) (id model, NSIndexPath *indexPath);

@interface KKChatRoomUserListBaseView : UIView
//tableView需要存在于本类的子类中

//tableView的数据源 (子类使用)
@property (nonatomic, copy) NSArray <id>*dataArray;

//设置tableView的配置,点击block (子类实现)
-(void)setConfigBlock:(KKChatRoomUserListConfigBlock)configBlock selectBlock:(KKChatRoomUserListSelectBlock)selectBlock;

@end

NS_ASSUME_NONNULL_END
