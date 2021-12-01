//
//  KKUserMgrListViewController.h
//  kk_espw
//
//  Created by jingtian9 on 2019/10/22.
//  Copyright © 2019 david. All rights reserved.
//

//#import "KKLiveStudioBasePopVC.h"
#import "KKBottomPopVC.h"
#define KKLiveStudioUserMgrTitleOnline      @"在线用户"
#define KKLiveStudioUserMgrTitleMicRank     @"排麦用户"
#define KKLiveStudioUserMgrTitleForbidWord  @"禁言用户"
@class KKLiveStudioUserSimpleModel;
@class KKGameRoomViewModel;
@class KKGamePlayerCardInfoModel;
NS_ASSUME_NONNULL_BEGIN
typedef void(^toPushConversationVCBlock)(KKGamePlayerCardInfoModel *model);
@interface KKUserMgrListViewController : KKBottomPopVC

//1. 数组的元素是上边的宏定义 KKLiveStudioUserMgrTitleXXX
-(instancetype)initWithTitleArray:(NSArray <NSString *>*)titleArray;
//2. 默认选中的index
@property (nonatomic, assign) NSInteger defaultItemIndex;
//3. groupId
@property (nonatomic, copy) NSString *groupIdStr;
//4. 跳转私聊
@property (nonatomic, copy) toPushConversationVCBlock toPushConversationVCBlock;
//5. viewModel
@property (nonatomic, strong) KKGameRoomViewModel *viewModel;
//6. 开始刷新
- (void)beginLoadData;

@end

NS_ASSUME_NONNULL_END
