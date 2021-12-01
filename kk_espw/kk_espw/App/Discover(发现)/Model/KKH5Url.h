//
//  KKH5Url.h
//  kk_espw
//
//  Created by 景天 on 2019/8/5.
//  Copyright © 2019年 david. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface KKH5Url : NSObject
/*
 #排行榜
 RANK_LIST=https://kkdjmini-dev.kkbuluo.com/index.htm?gotoUrl=#/embedded/rank
 #任务
 MISSION=https://kkdjmini-dev.kkbuluo.com/index.htm?gotoUrl=#/embedded/task
 #发现
 DISCOVER=https://kkdjmini-dev.kkbuluo.com/index.htm?gotoUrl=#/news/index
 #资讯详情
 CMS_DETAIL=https://kkdjmini-dev.kkbuluo.com/index.htm?gotoUrl=#/news/detail/${id}
 #举报
 REPORT=https://kkdjmini-dev.kkbuluo.com/index.htm?gotoUrl=#/embedded/report
 */

@property (nonatomic, copy) NSString *RANK_LIST; /// 排行榜
@property (nonatomic, copy) NSString *MISSION; /// 任务
@property (nonatomic, copy) NSString *DISCOVER; /// 发现
@property (nonatomic, copy) NSString *CMS_DETAIL; /// 资讯详情
@property (nonatomic, copy) NSString *REPORT; /// 举报
@property (nonatomic, copy) NSString *LIVING_PACT; /// 协议
@property (nonatomic, copy) NSString *SHARE_DOWNLOAD; /// 分享

@end

NS_ASSUME_NONNULL_END
