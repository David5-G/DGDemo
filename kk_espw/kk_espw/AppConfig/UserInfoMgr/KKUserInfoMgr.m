//
//  KKUserInfoMgr.m
//  kk_buluo
//
//  Created by david on 2019/3/17.
//  Copyright © 2019 yaya. All rights reserved.
//

#import "KKUserInfoMgr.h"
//bench
#import "CC_UserInfoMgr.h"
//user相关
#define kUserId         @"userId"

@interface KKUserInfoMgr()

//用于清空
@property (nonatomic,strong) NSMutableArray *keyMutArr;

@end


@implementation KKUserInfoMgr

static KKUserInfoMgr *userInfoMgr = nil;
static dispatch_once_t onceToken;


#pragma mark - setter
-(void)setUserId:(NSString *)userId {
    _userId = userId;
    [ccs saveDefaultKey:kUserId andV:userId];
}

#pragma mark - lazy load
-(NSMutableArray *)keyMutArr {
    if (!_keyMutArr) {
        _keyMutArr = [NSMutableArray array];
    }
    return _keyMutArr;
}

-(KKUserInfoModel *)userInfoModel {
    if (!_userInfoModel) {
        _userInfoModel = [[KKUserInfoModel alloc]init];
    }
    return _userInfoModel;
}

#pragma mark - life circle
+ (instancetype)shareInstance {
    dispatch_once(&onceToken, ^{
        userInfoMgr = [[KKUserInfoMgr alloc] init];
    });
    return userInfoMgr;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        [self setupInfo];
    }
    return self;
}

/** 清空 */
- (void)remove{
    //1.删除userDefault中的用户信息
    for (NSInteger i=0; i<self.keyMutArr.count; i++) {
        [ccs saveDefaultKey:self.keyMutArr[i] andV:nil];
    }
    
    //2.释放self
    userInfoMgr = nil;
    onceToken = 0;
}


#pragma mark - 用户信息
- (void)setupInfo{
    //1.user相关
    self.userId = [ccs getDefault:kUserId];
    [self.keyMutArr addObject:kUserId];
}

/** request获取用户信息 */
-(void)requestUserInfoSuccess:(void (^)(void))success fail:(void (^)(void))fail {
    //1.参数
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setObject:@"USER_HOME_INDEX" forKey:@"service"];
    
    [[CC_HttpTask getInstance] post:[KKNetworkConfig currentUrl] params:params model:nil finishCallbackBlock:^(NSString *error, ResModel *resModel) {
        
        //1.失败
        if (error) {
            [CC_Notice show:error];
            if (fail) {
                fail();
            }
            return ;
        }
        
        //2.成功
        NSDictionary *responseDic = resModel.resultDic[@"response"];
        //2.1 userInfoModel
        KKUserInfoModel *userInfoModel = [KKUserInfoModel mj_objectWithKeyValues:responseDic];
        [KKUserInfoMgr shareInstance].userInfoModel = userInfoModel;
        [KKUserInfoMgr shareInstance].userId = userInfoModel.userId;
        //2.2 bench
        [CC_UserInfoMgr getInstance].userId = userInfoModel.userId;
        [CC_UserInfoMgr getInstance].userName = userInfoModel.nickName;
        [CC_UserInfoMgr getInstance].userLogoUrl = userInfoModel.userLogoUrl;
        [ccs saveDefaultKey:@"shareUserLogo" andV:userInfoModel.userLogoUrl];
        //2.3 block
        if (success) {
            success();
        }
    }];
}


#pragma mark- login
+ (BOOL)isLogin{
    if ([KKUserInfoMgr shareInstance].userId.length > 0) {
        return YES;
    }
    return NO;
}


- (void)logoutAndSetNil:(void(^)(void))finish{
    
    //1.释放self单例
    [self remove];
    
    //2.释放网络配置
    [[KKNetworkConfig shareInstance] removeHttpTaskConfig];
    
    //3.释放融云
    [[KKIMMgr shareInstance] logout];
    
    //4.跳转登录VC
    [KKRootContollerMgr loadLoginAsRootVC];
    
    //5.执行block
    if (finish) {
        finish();
    }
    
}


@end
