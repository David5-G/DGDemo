//
//  KKLiveStudioUserMgrPopVC.h
//  kk_espw
//
//  Created by david on 2019/8/7.
//  Copyright © 2019 david. All rights reserved.
//

#import "KKLiveStudioBasePopVC.h"


#define KKLiveStudioUserMgrTitleOnline      @"在线用户"
#define KKLiveStudioUserMgrTitleMicRank     @"排麦用户"
#define KKLiveStudioUserMgrTitleForbidWord  @"禁言用户"

NS_ASSUME_NONNULL_BEGIN

@interface KKLiveStudioUserMgrPopVC : KKLiveStudioBasePopVC

/** 数组的元素是上边的宏定义 KKLiveStudioUserMgrTitleXXX*/
-(instancetype)initWithTitleArray:(NSArray <NSString *>*)titleArray;
/** 默认选中的index */
@property (nonatomic, assign) NSInteger defaultItemIndex;

@end

NS_ASSUME_NONNULL_END
