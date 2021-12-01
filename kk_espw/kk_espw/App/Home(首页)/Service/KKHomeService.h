//
//  KKHomeService.h
//  kk_espw
//
//  Created by 景天 on 2019/7/19.
//  Copyright © 2019年 david. All rights reserved.
//

#import <Foundation/Foundation.h>

@class KKHomeRoomListInfo;
@class KKCardTag;
@class KKCheckInfo;
@class KKBanner;
@class KKMessage;
NS_ASSUME_NONNULL_BEGIN

typedef void(^requestHomeListBlockSuccess)(NSMutableArray *dataList, KKPaginator *paginator);
typedef void(^requestHomeListBlockFail)(void);
typedef void(^requestHomeRoomStatusDataBlockSuccess)(NSMutableArray *dataList);
typedef void(^requestHomeRoomStatusDataBlockFail)(void);
typedef void(^requestLastTimeGameBoardBlockSuccess)(KKCardTag *lastCard, KKMessage *message);
typedef void(^requestLastTimeGameBoardBlockFail)(void);
typedef void(^requestCheckGameBoardBlockSuccess)(KKCheckInfo *checkInfo);
typedef void(^requestCheckGameBoardBlockFail)(void);
typedef void(^requestBannerBlockSuccess)(NSMutableArray *dataList);
typedef void(^requestBannerBlockFail)(void);
@interface KKHomeService : NSObject
@property (nonatomic, copy) requestHomeListBlockFail requestHomeListBlockSuccess;
@property (nonatomic, copy) requestHomeListBlockFail requestHomeListBlockFail;
@property (nonatomic, copy) requestHomeRoomStatusDataBlockSuccess requestHomeRoomStatusDataBlockSuccess;
@property (nonatomic, copy) requestHomeRoomStatusDataBlockFail requestHomeRoomStatusDataBlockFail;
@property (nonatomic, copy) requestLastTimeGameBoardBlockSuccess requestLastTimeGameBoardBlockSuccess;
@property (nonatomic, copy) requestLastTimeGameBoardBlockFail requestLastTimeGameBoardBlockFail;
@property (nonatomic, copy) requestCheckGameBoardBlockSuccess requestCheckGameBoardBlockSuccess;
@property (nonatomic, copy) requestCheckGameBoardBlockFail requestCheckGameBoardBlockFail;
@property (nonatomic, copy) requestBannerBlockSuccess requestBannerBlockSuccess;
@property (nonatomic, copy) requestBannerBlockFail requestBannerBlockFail;
@property (nonatomic, strong) NSNumber *page;
@property (nonatomic, copy) NSString *gameRoomId;
@property (nonatomic, copy) NSString *rank; /// 段位
@property (nonatomic, copy) NSString *platFormType; /// 大区
@property (nonatomic, copy) NSString *channelCode; /// 栏目
/**
 初始化

 @return 实例
 */
+ (instancetype)shareInstance;
/**
 请求首页开黑房列表
 
 @param success success
 @param fail fail
 */
+ (void)requestHomeListSuccess:(requestHomeListBlockSuccess)success Fail:(requestHomeListBlockFail)fail;
- (void)requestHomeListSuccess:(requestHomeListBlockSuccess)success Fail:(requestHomeListBlockFail)fail;
/// 语音房列表查询
/// @param currentPage 当前页
/// @param success 成功
/// @param fail 失败
+ (void)requesHomeVoiceRoomListWithCurrentPage:(NSNumber *)currentPage
                                       success:(void(^)(NSMutableArray *dataList, KKPaginator *paginator))success
                                          fail:(void(^)(void))fail;
/**
 请求首页直播间状态

 @param success success
 @param fail fail
 */
+ (void)requestHomeRoomStatusDataSuccess:(requestHomeRoomStatusDataBlockSuccess)success Fail:(requestHomeRoomStatusDataBlockFail)fail;


/**
 请求上一次对局的名片信息

 @param success success
 @param fail fail
 */
+ (void)requestLastTimeGameBoadDataSuccess:(requestLastTimeGameBoardBlockSuccess)success Fail:(requestLastTimeGameBoardBlockFail)fail;
- (void)requestLastTimeGameBoadDataSuccess:(requestLastTimeGameBoardBlockSuccess)success Fail:(requestLastTimeGameBoardBlockFail)fail ;
/**
 游戏校验检查服务: 游戏局是否有在进行中

 @param success success
 @param fail fail
 */
+ (void)requestCheckGameBoadDataSuccess:(requestCheckGameBoardBlockSuccess)success Fail:(requestCheckGameBoardBlockFail)fail;

- (void)requestCheckGameBoadDataSuccess:(requestCheckGameBoardBlockSuccess)success Fail:(requestCheckGameBoardBlockFail)fail;
    
/**
 请求轮播图

 @param success success
 @param fail fail
 */
+ (void)requestBannerDataSuccess:(requestBannerBlockSuccess)success Fail:(requestBannerBlockFail)fail;


+ (void)requestUserOnlineLiveDataSuccess:(void(^)(NSMutableArray *dataList))success Fail:(void(^)(void))fail;

/// 检查是否符合入局条件
+ (void)request_game_board_join_consult_dataWithProfilesId:(NSString *)profilesId
                                                gameRoomId:(NSInteger)gameRoomId
                                               gameBoardId:(NSString *)gameBoardId
                                                   success:(void(^)(void))success
                                                      fail:(void(^)(NSString *errorMsg, NSString *errorName))fail;


/**
 销毁单例
 */
+ (void)destroyInstance;

+ (void)requesHomeVoiceRoomListWithRoomId:(NSString *)roomId success:(void(^)(NSMutableArray *dataList))success fail:(void(^)(void))fail;

@end

NS_ASSUME_NONNULL_END
