//
//  KKSuspenViewManager.m
//  kk_espw
//
//  Created by 景天 on 2019/8/9.
//  Copyright © 2019年 david. All rights reserved.
//

#import "KKSuspenViewManager.h"
#import "KKHomeRoomListInfo.h"
@interface KKSuspenViewManager ()<CatDefaultPopDelegate>
@property (nonatomic, strong) CatDefaultPop *pop;
@property (nonatomic, strong) CatDefaultPop *pop2;

@end


@implementation KKSuspenViewManager
static KKSuspenViewManager *manager = nil;
+ (instancetype)shareInstance{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[KKSuspenViewManager alloc] init];
    });
    return manager;
}

+ (BOOL)isJoinGameBoard {
    if ([KKFloatGameRoomView shareInstance].gameRoomIdStr || [KKFloatGameRoomView shareInstance].gameProfilesIdStr || [KKFloatGameRoomView shareInstance].gameBoardIdStr || [KKFloatGameRoomView shareInstance].groupIdStr) {
        return YES;
    }else {
        return NO;
    }
}

+ (BOOL)isJoinedGameBoard:(KKHomeRoomListInfo *)info {
    if ([KKSuspenViewManager isJoinGameBoard]) {
        if (info.gameRoomId == [KKFloatGameRoomView shareInstance].gameRoomIdStr) {
            return YES;
        }else {
            /// 进入不同的开黑房
            return NO;
        }
    }else {
        return YES;
    }
}

/// show 招募厅
+ (void)showRecruitViewComplete:(void(^)(void))complete closeBlock:(void(^)(void))closeBlock{
    [[KKFloatLiveStudioView shareInstance] showkSuspendedView];
    [[KKFloatLiveStudioView shareInstance] addTapWithTimeInterval:0.2 tapBlock:^(UIView * _Nonnull view) {
        complete();
    }];
    [[KKFloatLiveStudioView shareInstance].closeButton addTapWithTimeInterval:0.2 tapBlock:^(UIView * _Nonnull view) {
        closeBlock();
    }];
}

+ (void)showGameBoardViewComplete:(void(^)(void))complete{
    [[KKFloatGameRoomView shareInstance] showKhSuspendedView];
    [[KKFloatGameRoomView shareInstance] addTapWithTimeInterval:0.2 tapBlock:^(UIView * _Nonnull view) {
            complete();
    }];
}

+ (void)hideKHGameBoardView {
    [[KKFloatGameRoomView shareInstance] hideKhSuspendedView];
}

+ (void)hideRecruitView {
    [[KKFloatLiveStudioView shareInstance] hidekSuspendedView];
}

/// 赋值
+ (void)setRecruitName:(NSString *)recruitName compereName:(NSString *)compereName compereHeadUrl:(NSString *)compereHeadUrl {
    [[KKFloatLiveStudioView shareInstance].headerImage sd_setImageWithURL:Url(compereHeadUrl)];
    [KKFloatLiveStudioView shareInstance].titleL.text = recruitName;
    if (compereName.length == 0) {
        [KKFloatLiveStudioView shareInstance].compereL.text = [NSString stringWithFormat:@"主持人:%@", @"暂无"];
    }else {
        [KKFloatLiveStudioView shareInstance].compereL.text = [NSString stringWithFormat:@"主持人:%@", compereName];
    }
}

#pragma mark - Alert
- (void)showAlert1 {
    self.pop = [[CatDefaultPop alloc] initWithTitle:@"是否进入?" content:@"进入招募厅后, 将退出开黑房?" cancelTitle:@"取消" confirmTitle:@"确定"];
    self.pop.delegate = self;
    [self.pop popUpCatDefaultPopView];
    [self.pop updateCancelColor:KKES_COLOR_GRAY_TEXT confirmColor:KKES_COLOR_MAIN_YELLOW];
}

- (void)showAlert2 {
    self.pop2 = [[CatDefaultPop alloc] initWithTitle:@"是否进入?" content:@"进入开黑房后, 将退出招募厅?" cancelTitle:@"取消" confirmTitle:@"确定"];
    self.pop2.delegate = self;
    [self.pop2 popUpCatDefaultPopView];
    [self.pop2 updateCancelColor:KKES_COLOR_GRAY_TEXT confirmColor:KKES_COLOR_MAIN_YELLOW];
}

- (void)catDefaultPopConfirm:(CatDefaultPop *)defaultPop {
    /// 退出游戏局
    if (defaultPop == self.pop) {
        self.tapedExitGameBoardBlock();
        [[KKFloatGameRoomView shareInstance] hideKhSuspendedView];
        return;
    }
    
    /// 这里退出招募厅
    if (defaultPop == self.pop2) {
        self.tapedExitRecruitBlock();
        [[KKFloatGameRoomView shareInstance] hideKhSuspendedView];
        return;
    }
}
@end
