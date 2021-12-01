//
//  KKPlayerGameCardTool.m
//  kk_espw
//
//  Created by david on 2019/8/9.
//  Copyright © 2019 david. All rights reserved.
//

#import "KKPlayerGameCardTool.h"
//controller
#import "KKConversationController.h"
#import "KKGameReportController.h"
//view
#import "KKPlayerGameCardView.h"
//model
#import "KKGamePlayerCardInfoModel.h"
#import "KKGameRoomContrastModel.h"


@interface KKPlayerGameCardTool ()
@property (nonatomic, weak) id<KKPlayerGameCardToolDelagate> delegate;
@property (nonatomic, strong) KKGamePlayerCardInfoModel *playerCardInfoModel;
/** 用户的id */
@property (nonatomic, copy, readwrite) NSString *userId;
/** 房间id */
@property (nonatomic, copy, readwrite) NSString *roomId;

@end

@implementation KKPlayerGameCardTool

#pragma mark - singleTon
static KKPlayerGameCardTool *_playGameCardTool = nil;
static dispatch_once_t onceToken;

+(instancetype)shareInstance{
    dispatch_once(&onceToken, ^{
        _playGameCardTool = [[KKPlayerGameCardTool alloc] init];
    });
    return _playGameCardTool;
}


#pragma mark - public
 
/** 展示用户卡片信息 */
-(void)showUserInfo:(NSString *)userId
             roomId:(NSString *)roomId
           needKick:(BOOL)needKick
        isHostCheck:(BOOL)isHostCheck
            isOnMic:(BOOL)isOnMic
           delegate:(id<KKPlayerGameCardToolDelagate>)delegate {
    
    [self showUserInfo:userId roomId:roomId needKick:needKick isHostCheck:isHostCheck isForGame:NO isOn:isOnMic delegate:delegate];
}

 
-(void)showUserInfo:(NSString *)userId
             roomId:(NSString *)roomId
           needKick:(BOOL)needKick
        isHostCheck:(BOOL)isHostCheck
          isForGame:(BOOL)isForGame
               isOn:(BOOL)isOn
           delegate:(id<KKPlayerGameCardToolDelagate>)delegate {
    
    self.delegate = delegate;
    self.userId = userId;
    self.roomId = roomId;
    
    WS(weakSelf);
    [self requestUserInfo:userId roomId:roomId block:^{
        [weakSelf showHorizontalTypePlayerCardView:needKick isHostCheck:isHostCheck isForGame:isForGame isOn:isOn];
    }];
}


#pragma mark - private
-(void)showHorizontalTypePlayerCardView:(BOOL)needKick isHostCheck:(BOOL)isHostCheck isForGame:(BOOL)isForGame isOn:(BOOL)isOn {
    
    WS(weakSelf)
    KKGamePlayerCardInfoModel *cardModel = self.playerCardInfoModel;
    NSString *targetUserId = cardModel.targetUserId;
    BOOL isForbiden = cardModel.forbidden;
    BOOL isFriend = cardModel.isFriend;
    BOOL isSelf = [[KKUserInfoMgr shareInstance].userId isEqualToString:targetUserId];
    
    //1.参数
    //1.1 举报
    NSString *reportTitle = !isSelf ? @"举报" : @"" ;
    BOOL needReport = !isSelf;//举报
    BOOL needTeamTitle = !isSelf;//组队信息
    
    //1.2 是自己
    NSArray <DGButton *>*btnArr;
    if (isSelf) {
        //1.2.1 是语音的麦位 && 在麦上
        if (!isForGame && isOn) {
            NSString *title = @"下麦";
            //主播有自定义下麦title
            if (isHostCheck && self.hostMicQuitTitle.length > 0) {
                title = self.hostMicQuitTitle;
            }
            
            DGButton *micBtn = [DGButton btnWithFontSize:[ccui getRH:14] title:title titleColor:KKES_COLOR_BLACK_TEXT];
             btnArr = @[micBtn];
        }
        
    }else{//1.3 不是自己
        
        //1.3.1 是主播
        if (isHostCheck) {
            //加好友
            NSString *chatTitle = isFriend ? @"聊一聊" : @"加好友";
            DGButton *chatBtn = [DGButton btnWithFontSize:[ccui getRH:14] title:chatTitle titleColor:KKES_COLOR_MAIN_YELLOW];
            //抱麦
            NSString *micTitle = isOn ? @"抱下麦" : @"抱上麦";
            DGButton *micBtn = [DGButton btnWithFontSize:[ccui getRH:14] title:micTitle titleColor:KKES_COLOR_BLACK_TEXT];
            //请离队
            DGButton *kickTeamBtn = [DGButton btnWithFontSize:[ccui getRH:14] title:@"请离队" titleColor:KKES_COLOR_BLACK_TEXT];
            //移出房间
            DGButton *kickRoomBtn = [DGButton btnWithFontSize:[ccui getRH:14] title:@"移出房间" titleColor:KKES_COLOR_BLACK_TEXT];
            //禁言
            NSString *forbidenTitle = isForbiden ? @"解禁" : @"禁言";
            DGButton *forbidenBtn = [DGButton btnWithFontSize:[ccui getRH:14] title:forbidenTitle titleColor:KKES_COLOR_BLACK_TEXT];
            
            NSMutableArray *mBtnArr = [NSMutableArray array];
            [mBtnArr addObject:chatBtn];
            if(isForGame){
                if (isOn) {
                    [mBtnArr addObject:kickTeamBtn];
                }
            }else{
                if (!isForbiden) {//没被禁言,有micBtn
                    [mBtnArr addObject:micBtn];
                }
            }
            
            if (needKick) {//需要踢出房间
                [mBtnArr addObject:kickRoomBtn];
            }
            if (!isOn) {//需要禁言
                [mBtnArr addObject:forbidenBtn];
            }
            
            if(isForGame){
                if (isOn) {
                    [mBtnArr addObject:forbidenBtn];
                }
            }
            
            btnArr = mBtnArr;
            
        }else {//1.3.2 不是主播
            NSString *title = isFriend ? @"聊一聊" : @"加好友";
            DGButton *chatBtn = [DGButton btnWithFontSize:[ccui getRH:14] title:title titleColor:KKES_COLOR_MAIN_YELLOW];
            btnArr = @[chatBtn];
        }
    }
    
    //2.cardView设置
    KKPlayerGameCardViewBtnType btnType = btnArr.count>0 ? KKPlayerGameCardViewBtnTypeHorizontal : KKPlayerGameCardViewBtnTypeNone;
    KKPlayerGameCardView *cardView = [[KKPlayerGameCardView alloc] initWithButtonType:btnType needTeamTitle:needTeamTitle];
    
    //2.0 btns
    __weak __typeof(cardView) weakCardView = cardView;
    cardView.buttonItems = btnArr;
    for (DGButton *btn in btnArr) {
        [btn addClickWithTimeInterval:0.5 block:^(DGButton *btn) {
            SS(strongSelf)
            [weakCardView dismissWithAnimated:YES];
            [strongSelf handleMsg: [btn titleForState:UIControlStateNormal] targetUserId:targetUserId];
        }];
    }
    
    //2.1 举报
    [cardView setLeftUpBtnHidden:!needReport];
    [cardView setLeftUpBtnTitle:reportTitle forState:UIControlStateNormal];
    UIColor *leftUpBtnColor = isHostCheck ?KKES_COLOR_HEX(0xECC165) : KKES_COLOR_HEX(0x999999);
    [cardView setLeftUpBtnTitleColor:leftUpBtnColor forState:UIControlStateNormal];
    
    //2.2 头像/昵称
    [cardView.iconImgView sd_setImageWithURL:[NSURL URLWithString:cardModel.userLogoUrl] placeholderImage:Img(@"game_absent")];
    [cardView setNickTitle:cardModel.nickName];
    
    //2.3 玩家标签
    NSMutableArray<KKPlayerLabelViewModel *> *labelModels = [NSMutableArray array];
    // 勋章
    for (KKPlayerMedalDetailModel *medalModel in cardModel.userMedalDetailList) {
        NSString *imgName = [[KKGameRoomContrastModel shareInstance].medalMapDic objectForKey:medalModel.currentMedalLevelConfigCode];
        if (imgName) {
            KKPlayerLabelViewModel *labelModel = [KKPlayerLabelViewModel createWithType:KKPlayerLabelViewModelTypeBigImage bgColors:nil img:Img(imgName) labelStr:nil];
            [labelModels addObject:labelModel];
        }
    }
    // 性别年龄
    NSArray *bgColors = @[KKES_COLOR_HEX(0x17B5FF), KKES_COLOR_HEX(0x21C3EC)];
    if ([cardModel.sex.name isEqualToString:@"F"]) {
        bgColors = @[KKES_COLOR_HEX(0xFF64AA)];
    }
    UIImage *sexImg = [KKGameRoomContrastModel shareInstance].cardSexMapDic[cardModel.sex.name ?: @""];
    NSString *ageStr = nil;
    if (cardModel.age && [cardModel.age integerValue] >= 0) {
        ageStr = [NSString stringWithFormat:@"%@", cardModel.age];
    }
    
    //标签model
    KKPlayerLabelViewModel *labelModel = [KKPlayerLabelViewModel createWithType:KKPlayerLabelViewModelTypeIconImage bgColors:bgColors img:sexImg labelStr:ageStr];
    [labelModels addObject:labelModel];
    // 设置标签
    [cardView setPlayerLabels:[labelModels copy]];
    
    // 最大显示局数和次数有限制
    NSString *gameNumberStr = [NSString stringWithFormat:@"%@", cardModel.gameBoardCount ?: @"0"];
    if ([cardModel.gameBoardCount integerValue] > kk_player_max_game_count) {
        gameNumberStr = [NSString stringWithFormat:@"%ld+", (long)kk_player_max_game_count];
    }
    
    NSString *gameTogetherNumberStr = [NSString stringWithFormat:@"%@", (cardModel.countWithTargetUser ?: @"0")];
    if ([cardModel.countWithTargetUser integerValue] > kk_player_max_game_time) {
        gameTogetherNumberStr = [NSString stringWithFormat:@"%ld+", (long)kk_player_max_game_time];
    }
    
    NSString *highPriseStr = [NSString stringWithFormat:@"%@", (cardModel.evaluationCountWithTargetUser ?: @"0")];
    if ([cardModel.evaluationCountWithTargetUser integerValue] > kk_player_max_game_time) {
        highPriseStr = [NSString stringWithFormat:@"%ld+", (long)kk_player_max_game_time];
    }
    
    //2.4 游戏记录
    [cardView setGameNameTitle:@"王者荣耀开黑"];
    [cardView setGameNumbersColor:KKES_COLOR_HEX(0xECC165)];
    [cardView setGameNumbersTitle:gameNumberStr unitTitle:@"局"];
    
    //2.5 组队记录
    [cardView setGameTogetherTitle:@"我和他组队"];
    [cardView setGameTogetherNumbersTitle:[NSString stringWithFormat:@"%@次", gameTogetherNumberStr]];
    [cardView setHighPraiseTitle:[NSString stringWithFormat:@"%@次好评", highPriseStr]];
    
    //2.6 show
    [cardView showIn:nil animated:YES];
    
    //3. 点击回调
    cardView.tapBlock = ^(KKPlayerGameCardViewTapType tapType) {
        SS(strongSelf);
        
        //3.1 点击背景
        if (tapType == KKPlayerGameCardViewTapTypeBackground) {
            //不禁止点击背景dissmiss
            if(!strongSelf.forbidTapBgDismiss){
                [weakCardView dismissWithAnimated:YES];
            }
            return ;
        }
        
        //3.3 撤销
        if (tapType == KKPlayerGameCardViewTapTypeRightUp ) {
            [weakCardView dismissWithAnimated:YES];
            return ;
        }
        //3.4 举报
        if (tapType == KKPlayerGameCardViewTapTypeLeftUp) {
            [weakCardView dismissWithAnimated:YES];
            [strongSelf handleMsg:reportTitle targetUserId:targetUserId];
            return ;
            
        }
    };
}

//竖排的操作btn样式, 已弃用
-(void)showPlayerCardView:(BOOL)needReport isHostCheck:(BOOL)isHostCheck isOnMic:(BOOL)isOnMic {
    
    KKGamePlayerCardInfoModel *cardModel = self.playerCardInfoModel;
    NSString *targetUserId = cardModel.targetUserId;
    BOOL isFriend = cardModel.isFriend;
    BOOL isSelf = [[KKUserInfoMgr shareInstance].userId isEqualToString:targetUserId];
    
    //1.默认参数
    NSString *reportTitle = @"";
    NSString *bgBtnTitle = @"";
    NSString *borderBtnTitle = @"";
    BOOL needTeamTitle = NO;
    KKPlayerGameCardViewBtnType btnType = KKPlayerGameCardViewBtnTypeNone;
    
    //1.1处理举报
    //1.1.1 自己不能举报或管理自己
    if (isSelf) {
        needReport = NO;
    }
    //1.1.2 能举报,按钮title设置
    if (needReport) {
        if (isHostCheck) {
            reportTitle = @"管理";
        }else{
            reportTitle = @"举报";
        }
    }
    
    //1.2 是自己
    if (isSelf) {
        needTeamTitle = NO;
        needReport = NO;
        //1.2.1 不是主播
        if (!isHostCheck) {
            btnType = isOnMic ? KKPlayerGameCardViewBtnTypeNoBorder : KKPlayerGameCardViewBtnTypeNone;
            bgBtnTitle = isOnMic ? @"下麦" : @"";
        }
        
    }else{//1.3 不是自己
        
        needTeamTitle = YES;
        //1.3.1 是主播
        if (isHostCheck) {
            btnType = isOnMic ? KKPlayerGameCardViewBtnTypeAll : KKPlayerGameCardViewBtnTypeNoBorder;
            bgBtnTitle = isFriend ? @"聊一聊" : @"加好友";
            borderBtnTitle = isOnMic ? @"抱下麦" : @"";
            
        }else {//1.3.2 不是主播
            btnType = KKPlayerGameCardViewBtnTypeNoBorder;
            bgBtnTitle = isFriend ? @"聊一聊" : @"加好友";
        }
    }
    
    //2.cardView设置
    KKPlayerGameCardView *cardView = [[KKPlayerGameCardView alloc] initWithButtonType:btnType needTeamTitle:needTeamTitle];
    
    //2.1 举报
    [cardView setLeftUpBtnHidden:!needReport];
    [cardView setLeftUpBtnTitle:reportTitle forState:UIControlStateNormal];
    UIColor *leftUpBtnColor = isHostCheck ?KKES_COLOR_HEX(0xECC165) : KKES_COLOR_HEX(0x999999);
    [cardView setLeftUpBtnTitleColor:leftUpBtnColor forState:UIControlStateNormal];
    
    //2.2 头像/昵称
    [cardView.iconImgView sd_setImageWithURL:[NSURL URLWithString:cardModel.userLogoUrl] placeholderImage:Img(@"game_absent")];
    [cardView setNickTitle:cardModel.nickName];
    
    //2.3 玩家标签
    NSMutableArray<KKPlayerLabelViewModel *> *labelModels = [NSMutableArray array];
    // 勋章
    for (KKPlayerMedalDetailModel *medalModel in cardModel.userMedalDetailList) {
        NSString *imgName = [[KKGameRoomContrastModel shareInstance].medalMapDic objectForKey:medalModel.currentMedalLevelConfigCode];
        if (imgName) {
            KKPlayerLabelViewModel *labelModel = [KKPlayerLabelViewModel createWithType:KKPlayerLabelViewModelTypeBigImage bgColors:nil img:Img(imgName) labelStr:nil];
            [labelModels addObject:labelModel];
        }
    }
    // 性别年龄
    NSArray *bgColors = @[KKES_COLOR_HEX(0x17B5FF), KKES_COLOR_HEX(0x21C3EC)];
    if ([cardModel.sex.name isEqualToString:@"F"]) {
        bgColors = @[KKES_COLOR_HEX(0xFF64AA)];
    }
    UIImage *sexImg = [KKGameRoomContrastModel shareInstance].cardSexMapDic[cardModel.sex.name ?: @""];
    NSString *ageStr = nil;
    if (cardModel.age && [cardModel.age integerValue] >= 0) {
        ageStr = [NSString stringWithFormat:@"%@", cardModel.age];
    }
    
    KKPlayerLabelViewModel *labelModel = [KKPlayerLabelViewModel createWithType:KKPlayerLabelViewModelTypeIconImage bgColors:bgColors img:sexImg labelStr:ageStr];
    [labelModels addObject:labelModel];
    // 设置标签
    [cardView setPlayerLabels:[labelModels copy]];
    
    // 最大显示局数和次数有限制
    NSString *gameNumberStr = [NSString stringWithFormat:@"%@", cardModel.gameBoardCount ?: @"0"];
    if ([cardModel.gameBoardCount integerValue] > kk_player_max_game_count) {
        gameNumberStr = [NSString stringWithFormat:@"%ld+", (long)kk_player_max_game_count];
    }
    
    NSString *gameTogetherNumberStr = [NSString stringWithFormat:@"%@", (cardModel.countWithTargetUser ?: @"0")];
    if ([cardModel.countWithTargetUser integerValue] > kk_player_max_game_time) {
        gameTogetherNumberStr = [NSString stringWithFormat:@"%ld+", (long)kk_player_max_game_time];
    }
    
    NSString *highPriseStr = [NSString stringWithFormat:@"%@", (cardModel.evaluationCountWithTargetUser ?: @"0")];
    if ([cardModel.evaluationCountWithTargetUser integerValue] > kk_player_max_game_time) {
        highPriseStr = [NSString stringWithFormat:@"%ld+", (long)kk_player_max_game_time];
    }
    
    //2.4 游戏记录
    [cardView setGameNameTitle:@"王者荣耀开黑"];
    [cardView setGameNumbersColor:KKES_COLOR_HEX(0xECC165)];
    [cardView setGameNumbersTitle:gameNumberStr unitTitle:@"局"];
    
    //2.5 组队记录
    [cardView setGameTogetherTitle:@"我和他组队"];
    [cardView setGameTogetherNumbersTitle:[NSString stringWithFormat:@"%@次", gameTogetherNumberStr]];
    [cardView setHighPraiseTitle:[NSString stringWithFormat:@"%@次好评", highPriseStr]];
    
    //2.5 bgBtn
    [cardView setTitle:bgBtnTitle forState:UIControlStateNormal forButtonType:KKPlayerGameCardViewBtnTypeNoBorder];
    
    //2.6 borderBtn
    [cardView setTitle:borderBtnTitle forState:UIControlStateNormal forButtonType:KKPlayerGameCardViewBtnTypeBorder];
    
    //2.7 show
    [cardView showIn:nil animated:YES];
    
    //3. 点击回调
    __weak __typeof(cardView) weakCardView = cardView;
    WS(weakSelf)
    cardView.tapBlock = ^(KKPlayerGameCardViewTapType tapType) {
        SS(strongSelf);
        
        //3.1 点击背景
        if (tapType == KKPlayerGameCardViewTapTypeBackground) {
            //不禁止点击背景dissmiss
            if(!strongSelf.forbidTapBgDismiss){
                [weakCardView dismissWithAnimated:YES];
            }
            return ;
        }
        
        //3.3 撤销
        if (tapType == KKPlayerGameCardViewTapTypeRightUp ) {
            [weakCardView dismissWithAnimated:YES];
            return ;
        }
        //3.4 举报
        if (tapType == KKPlayerGameCardViewTapTypeLeftUp) {
            [weakCardView dismissWithAnimated:YES];
            [strongSelf handleMsg:reportTitle targetUserId:targetUserId];
            return ;
            
        }
        //3.5 第一个按钮
        if (tapType == KKPlayerGameCardViewTapTypeNoBorder) {
            [weakCardView dismissWithAnimated:YES];
            [strongSelf handleMsg:bgBtnTitle targetUserId:targetUserId];
            return ;
            
        }
        //3.6 第二个按钮
        if (tapType == KKPlayerGameCardViewTapTypeBorder) {
            [weakCardView dismissWithAnimated:YES];
            [strongSelf handleMsg:borderBtnTitle targetUserId:targetUserId];
            return ;
        }
    };
}

#pragma mark - action
/** 处理点击msg */
-(void)handleMsg:(NSString *)msg targetUserId:(NSString *)targetUserId {
    if ([msg isEqualToString:@"加好友"]) {
        [self requestForAddFriendWith:self.userId];
        return;
    }
    
    if ([msg isEqualToString:@"聊一聊"]) {
        [self pushToConversationVC];
        return ;
    }
    
    if ([msg isEqualToString:@"举报"]) {
        [self pushToGameReportVC:self.userId];
        return;
    }
    
    if ([msg isEqualToString:@"抱上麦"] ||
        [msg isEqualToString:@"抱下麦"] ||
        [msg isEqualToString:@"下麦"] ||
        [msg isEqualToString:@"移出房间"] ||
        [msg isEqualToString:@"管理"] ||
        [msg isEqualToString:@"请离队"] ||
        [msg isEqualToString:@"禁言"] ||
        [msg isEqualToString:@"解禁"] ) {
        
        if (self.delegate && [self.delegate respondsToSelector:@selector(playerGameCardTool:handleMsg:targetUserId:)]) {
            [self.delegate playerGameCardTool:self handleMsg:msg targetUserId:targetUserId];
        }
        return;
    }
    
    //自定义的
    if (self.delegate && [self.delegate respondsToSelector:@selector(playerGameCardTool:handleMsg:targetUserId:)]) {
        [self.delegate playerGameCardTool:self handleMsg:msg targetUserId:targetUserId];
    }
}


#pragma mark - request
/** 请求UserInfo */
-(void)requestUserInfo:(NSString *)userId roomId:(NSString *)roomId block:(void(^)(void))block{
    if (userId.length < 1) {
        [CC_Notice show:@"userId为空" atView:[CC_Code getAView]];
        return;
    }
    
    //1.参数
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setObject:@"GAME_INFO_WITH_TARGET_USER_DETAIL_QUERY" forKey:@"service"];
    [params safeSetObject:userId forKey:@"targetUserId"];
    [params safeSetObject:roomId forKey:@"roomId"];
    
    //2.请求
    WS(weakSelf);
    MaskProgressHUD *HUD = [MaskProgressHUD hudStartAnimatingAndAddToView:[CC_Code getAView]];
    [[CC_HttpTask getInstance] post:[KKNetworkConfig currentUrl] params:params model:nil finishCallbackBlock:^(NSString *error, ResModel *resModel) {
        [HUD stop];
        
        if (error) {
            [CC_Notice show:error atView:[CC_Code getAView]];
            
        }else{
            NSDictionary *responseDic = resModel.resultDic[@"response"];
            weakSelf.playerCardInfoModel = [KKGamePlayerCardInfoModel mj_objectWithKeyValues:responseDic];
            if (block) {
                block();
            }
        }
    }];
}



- (void)requestForAddFriendWith:(NSString *)targetUserId {
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params safeSetObject:@"ADD_FRIEND" forKey:@"service"];
    [params safeSetObject:[KKUserInfoMgr shareInstance].userId forKey:@"applyUserId"];
    [params safeSetObject:targetUserId forKey:@"recieveUserId"];
    [params safeSetObject:[KKUserInfoMgr shareInstance].userInfoModel.nickName forKey:@"validateMessage"];
    
    MaskProgressHUD *HUD = [MaskProgressHUD hudStartAnimatingAndAddToView:[CC_Code getAView]];
    [[CC_HttpTask getInstance] post:[KKNetworkConfig currentUrl] params:params model:nil finishCallbackBlock:^(NSString *error, ResModel *resModel) {
        [HUD stop];
        
        if (error) {
            [CC_Notice show:error atView:[CC_Code getAView]];
        }else {
            [CC_Notice show:@"好友申请已发出" atView:[CC_Code getAView]];
        }
    }];
}


#pragma mark - jump
-(void)pushToConversationVC {
    KKGamePlayerCardInfoModel *cardModel = self.playerCardInfoModel;
    //1.conversation
    KKConversation *conversation = [[KKConversation alloc] init];
    conversation.targetId = cardModel.targetUserId;
    conversation.head = cardModel.userLogoUrl;
    conversation.conversationType = KKConversationType_PRIVATE;
    conversation.conversationTitle = cardModel.nickName;
    
    //2.vc
    KKConversationController *vc = [[KKConversationController alloc] initWithConversation:conversation extra:nil];
    [[KKRootContollerMgr getRootNav] pushViewController:vc animated:YES];
}

-(void)pushToGameReportVC:(NSString *)userId {
    KKGameReportController *vc = [[KKGameReportController alloc]init];
    vc.userId = userId;
    vc.complaintObjectId = userId;
    [[KKRootContollerMgr getRootNav] pushViewController:vc animated:YES];
}

@end
