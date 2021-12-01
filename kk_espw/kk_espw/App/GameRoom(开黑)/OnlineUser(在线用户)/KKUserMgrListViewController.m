//
//  KKUserMgrListViewController.m
//  kk_espw
//
//  Created by jingtian9 on 2019/10/22.
//  Copyright © 2019 david. All rights reserved.
//

#import "KKUserMgrListViewController.h"
#import "DGItemView.h"
#import "KKPaginator.h"
#import "KKGameBoardOnLineListCell.h"
#import "KKGameRoomViewModel.h"
#import "KKPlayerGameCardView.h"
#import "NoContentReminderView.h"
#import "KKChatRoomUserSimpleModel.h"
#import "KKChatRoomMetalSimpleModel.h"
@interface KKUserMgrListViewController ()
<UIScrollViewDelegate,
DGItemViewDelegate,
UITableViewDelegate,
UITableViewDataSource>
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) DGItemView *itemView;
@property (nonatomic, strong) NSArray <NSString *>*titleArray;
//在线列表
@property (nonatomic, strong) UITableView *onlineListView;
//禁言列表
@property (nonatomic, strong) UITableView *forbidWordListView;
@property (nonatomic, strong) KKPaginator *paginator;
@property (nonatomic, strong) KKPaginator *paginatorForbidden;
//在线数组
@property (nonatomic, strong) NSMutableArray *onLineDataArray;
//禁言数组
@property (nonatomic, strong) NSMutableArray *forbiddenDataArray;
@property (nonatomic, strong) NoContentReminderView *notDateView;

@end

@implementation KKUserMgrListViewController

#pragma mark - init
- (NSMutableArray *)onLineDataArray {
    if (!_onLineDataArray) {
        _onLineDataArray = [NSMutableArray array];
    }
    return _onLineDataArray;
}

- (NSMutableArray *)forbiddenDataArray {
    if (!_forbiddenDataArray) {
        _forbiddenDataArray = [NSMutableArray array];
    }
    return _forbiddenDataArray;
}

- (instancetype)init {
    return [self initWithTitleArray:@[KKLiveStudioUserMgrTitleMicRank, KKLiveStudioUserMgrTitleOnline, KKLiveStudioUserMgrTitleForbidWord]];
}

- (instancetype)initWithTitleArray:(NSArray<NSString *> *)titleArray {
    self = [super init];
    if (self) {
        // 1.设置titleArr
        NSMutableArray *titleArr = [NSMutableArray array];
        for (NSString *str in titleArray) {
            if ([str isEqualToString:KKLiveStudioUserMgrTitleMicRank]) {
                [titleArr addObject:KKLiveStudioUserMgrTitleMicRank];
                
            }else if ([str isEqualToString:KKLiveStudioUserMgrTitleOnline]){
                [titleArr addObject:KKLiveStudioUserMgrTitleOnline];
                
            }else if ([str isEqualToString:KKLiveStudioUserMgrTitleForbidWord]){
                [titleArr addObject:KKLiveStudioUserMgrTitleForbidWord];
            }
        }
        self.titleArray = titleArr.count > 0 ? titleArr : @[KKLiveStudioUserMgrTitleMicRank, KKLiveStudioUserMgrTitleOnline, KKLiveStudioUserMgrTitleForbidWord];
    }
    return self;
}

#pragma mark - UI
- (NoContentReminderView *)notDateView{
    if (!_notDateView) {
        NSMutableAttributedString *attribute = [[NSMutableAttributedString alloc] init];
        attribute = [CC_AttributedStr getOrigAttStr:attribute appendStr:@"暂时没有数据哦~" withColor:[UIColor grayColor]];
        _notDateView = [[NoContentReminderView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH-2*[ccui getRH:10], [ccui getRH:450]) imageTopY:[ccui getRH:80] image:Img(@"data_is_null") remindWords:attribute];
    }
    return _notDateView;
}

- (void)setupSubViewsForDisplayView:(UIView *)displayView {
    
    CGFloat titleViewH = [ccui getRH:54];
    CGFloat itemW = [ccui getRH:85];
    CGFloat itemH = [ccui getRH:40];
    CGFloat itemLeftSpace = (displayView.width - itemW*self.titleArray.count)/2.0;
    CGFloat itemTopSpace = [ccui getRH:8];
    
    //1.itemV
    self.itemView = [[DGItemView alloc] initWithFrame: CGRectMake(itemLeftSpace, itemTopSpace, displayView.width - 2 * itemLeftSpace, itemH)];
    [self setupItemView];
    [displayView addSubview:self.itemView];
    
    //2.grayLine
    UIView *grayLine = [[UIView alloc]init];
    grayLine.backgroundColor = rgba(245, 245, 245, 1);
    [displayView addSubview:grayLine];
    [grayLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(titleViewH-1);
        make.left.right.mas_equalTo(0);
        make.height.mas_equalTo(1);
    }];
    
    //3.scrollView
    UIScrollView *scrollV = [[UIScrollView alloc]initWithFrame:CGRectMake(0, titleViewH, displayView.width, displayView.height-titleViewH)];
    scrollV.contentSize = CGSizeMake(displayView.width*self.titleArray.count, displayView.height-titleViewH);
    scrollV.pagingEnabled = YES;
    scrollV.showsHorizontalScrollIndicator = NO;
    scrollV.delegate = self;
    [displayView addSubview:scrollV];
    self.scrollView = scrollV;
    [self setupScollViewSubviews];
    
}

-(void)setupItemView {
    DGItemView *itemV = self.itemView;
    if (!itemV) { return ; }
    
    itemV.backgroundColor = [UIColor whiteColor];
    itemV.normalFont = Font([ccui getRH:13]);
    itemV.selectedFont = FontB([ccui getRH:17]);
    itemV.normalColor = KKES_COLOR_DARK_GRAY_TEXT;
    itemV.selectedColor = KKES_COLOR_BLACK_TEXT;
    itemV.indicatorScale = 0.4;
    //itemV.indicatorImage = Img(@"item_scrollLine");
    itemV.indicatorColor = rgba(255, 223, 71, 1);
    itemV.lineIndicatorHeight = [ccui getRH:4];
    itemV.lineIndicatorBottomSpace = [ccui getRH:0];
    itemV.lineIndicatorCornerRadius = [ccui getRH:2];
    itemV.delegate = self;
    itemV.titleArr = self.titleArray;
}


-(void)setupScollViewSubviews {
    CGFloat w = self.scrollView.width;
    CGFloat h = self.scrollView.height;
    
    //1.subviews
    for (NSInteger i=0; i<self.titleArray.count; i++) {
        CGRect frame = CGRectMake(w*i, 0, w, h);
        NSString *title = self.titleArray[i];
        if ([title isEqualToString:KKLiveStudioUserMgrTitleMicRank]) {
            
            
        }else if ([title isEqualToString:KKLiveStudioUserMgrTitleOnline]) {
            [self scrollViewAddOnlineUserListView:frame];
            
        }else if ([title isEqualToString:KKLiveStudioUserMgrTitleForbidWord]) {
            [self scrollViewAddForbidWordListView:frame];
        }
    }
}

-(void)scrollViewAddOnlineUserListView:(CGRect)frame {
     WS(weakSelf);
    //1.在线用户UI
    UITableView *oListV = [[UITableView alloc] initWithFrame:frame style:UITableViewStylePlain];
    [oListV registerClass:[KKGameBoardOnLineListCell class] forCellReuseIdentifier:@"KKGameBoardOnLineListCell"];
    oListV.delegate = self;
    oListV.dataSource = self;
    oListV.tableFooterView = [[UIView alloc] init];
    self.onlineListView = oListV;
    [self.scrollView addSubview:oListV];
    //2.header refresh
    [oListV addSimpleHeaderRefresh:^{
        //请求
        [weakSelf requestOnlineUsers];
    }];
    
    //3.footer refresh
    [oListV addAutoFooterRefreshWithPercent:0 block:^{
        //请求
        SS(strongSelf)
        if (strongSelf->_paginator.page < strongSelf->_paginator.pages) {
            strongSelf->_paginator.page++;
            [strongSelf requestGameBoardUserForbiddenListData] ;
        }else{
            [strongSelf.forbidWordListView.mj_footer endRefreshingWithNoMoreData];
        }
    }];
}

- (void)scrollViewAddForbidWordListView:(CGRect)frame {
    
    WS(weakSelf);
    //1.禁言用户UI
    UITableView *fListV = [[UITableView alloc] initWithFrame:frame style:UITableViewStylePlain];
    [fListV registerClass:[KKGameBoardOnLineListCell class] forCellReuseIdentifier:@"KKGameBoardOnLineListCell1"];
    fListV.delegate = self;
    fListV.dataSource = self;
    fListV.separatorColor = [UIColor clearColor];
    self.forbidWordListView = fListV;
    [self.scrollView addSubview:fListV];
    
    //1.header refresh
    [fListV addSimpleHeaderRefresh:^{
        //请求
        [self requestGameBoardUserForbiddenListData];
    }];
    
    //3.footer refresh
    [fListV addAutoFooterRefreshWithPercent:0 block:^{
        
        SS(strongSelf)
        if (strongSelf->_paginatorForbidden.page < strongSelf->_paginatorForbidden.pages) {
            strongSelf->_paginatorForbidden.page++;
            [strongSelf.forbidWordListView.mj_footer endRefreshingWithNoMoreData];
        }else{
            [strongSelf.forbidWordListView.mj_footer endRefreshingWithNoMoreData];
        }
        
    }];
}

#pragma mark  DGItemViewDelegate
- (BOOL)itemView:(DGItemView *)itemView didSelectedAtIndex:(NSUInteger)index {
    self.scrollView.contentOffset = CGPointMake(index*self.scrollView.width, 0);
    if (index == 0) {
        [self.onlineListView.mj_header beginRefreshing];
    }else {
        [self.forbidWordListView.mj_header beginRefreshing];
    }
    return YES;
}

#pragma mark  UIScrollViewDelegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if (![scrollView isKindOfClass:[UITableView class]]) {
        NSInteger index = scrollView.contentOffset.x / scrollView.width;
        self.itemView.selectedIndex = index;
        if (index == 0) {
            [self.onlineListView.mj_header beginRefreshing];
        }else {
            [self.forbidWordListView.mj_header beginRefreshing];
        }
    }
}

#pragma mark - numberOfSectionsInTableView
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.onlineListView == tableView) {
        return self.onLineDataArray.count;
    }else {
        return self.forbiddenDataArray.count;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return RH(90);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    WS(weakSelf)
    if (tableView == self.onlineListView) {
        KKGameBoardOnLineListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"KKGameBoardOnLineListCell"];
        KKChatRoomUserSimpleModel *model = self.onLineDataArray[indexPath.row];
        cell.isForbiddenList = NO;
        model.ownerId = self.viewModel.infoModel.gameBoardClientSimple.ownerUserId;
        cell.model = model;
        cell.forbiddenBlock = ^(KKChatRoomUserSimpleModel * _Nonnull model, UIButton * _Nonnull currnetButton) {
            if ([currnetButton.currentTitle isEqualToString:@"禁言"]) {
                [weakSelf.viewModel requestGameBoardUserForbiddenWithUserId:model.userId gameBoardRoomId:self.viewModel.gameRoomId Success:^{
                    [weakSelf.onlineListView beginHeaderRefresh];
                }];
            }
        };
        return cell;
    }else {
        KKGameBoardOnLineListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"KKGameBoardOnLineListCell1"];
        cell.isForbiddenList = YES;
        KKChatRoomUserSimpleModel *model = self.forbiddenDataArray[indexPath.row];
        cell.model = model;
        cell.forbiddenBlock = ^(KKChatRoomUserSimpleModel * _Nonnull model, UIButton * _Nonnull currnetButton) {
            if ([currnetButton.currentTitle isEqualToString:@"解禁"]) {
                [weakSelf.viewModel requestGameBoardUserNoForbiddenWithUserId:model.userId gameBoardRoomId:self.viewModel.gameRoomId Success:^{
                    [weakSelf.forbidWordListView beginHeaderRefresh];
                }];
            }
        };
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    WS(weakSelf)
    if (tableView == self.onlineListView) {
        KKChatRoomUserSimpleModel *model = self.onLineDataArray[indexPath.row];
        [self requestUserDataWithModel:model succsee:^(NSDictionary *dic) {
            KKGamePlayerCardInfoModel *cardInfoModel = [KKGamePlayerCardInfoModel mj_objectWithKeyValues:dic];
            [weakSelf showPlayerCardWithModel:cardInfoModel user:model];
        }];
    }else if (tableView == self.forbidWordListView) {
        KKChatRoomUserSimpleModel *model = self.forbiddenDataArray[indexPath.row];
        [self requestUserDataWithModel:model succsee:^(NSDictionary *dic) {
            KKGamePlayerCardInfoModel *cardInfoModel = [KKGamePlayerCardInfoModel mj_objectWithKeyValues:dic];
            [weakSelf showPlayerCardWithModel:cardInfoModel user:model];
        }];
    }
}


- (void)showPlayerCardWithModel:(KKGamePlayerCardInfoModel *)cardModel user:(KKChatRoomUserSimpleModel *)simpleModel {
    WS(weakSelf)
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
    
    // 是否为好友
    BOOL isFriend = cardModel.isFriend;

    KKPlayerGameCardView *cardView = nil;
    // 自己的名片不做修改
    if ([[KKUserInfoMgr shareInstance].userId isEqualToString:simpleModel.userId]) { // 自己的名片
        cardView = [[KKPlayerGameCardView alloc] initWithButtonType:KKPlayerGameCardViewBtnTypeNone needTeamTitle:NO];
        [cardView setLeftUpBtnHidden:YES];
    } else{ // 非房主
        //1.观众点击房主
        cardView = [[KKPlayerGameCardView alloc] initWithButtonType:KKPlayerGameCardViewBtnTypeHorizontal needTeamTitle:YES];
        //2.加好友/聊一聊
        CC_Button *chatButtton = [CC_Button buttonWithType:UIButtonTypeCustom];
        [chatButtton setTitle:(isFriend ? @"聊一聊" : @"加好友") forState:UIControlStateNormal];
        [chatButtton setTitleColor:KKES_COLOR_MAIN_YELLOW forState:UIControlStateNormal];
        [chatButtton addTapWithTimeInterval:0.2 tapBlock:^(UIView * _Nonnull view) {
            if (isFriend) {
                //1.跳转私聊页面
                if (weakSelf.toPushConversationVCBlock) {
                    weakSelf.toPushConversationVCBlock(cardModel);
                }
                [cardView dismissWithAnimated:YES];

            } else {
                //2.加好友
                [weakSelf.viewModel requestForAddFriendWith:simpleModel.userId];
                [cardView dismissWithAnimated:YES];
            }
        }];
        //3.添加button数组
        cardView.buttonItems = @[chatButtton];
    }
    [cardView setLeftUpBtnTitle:@"举报" forState:UIControlStateNormal];
    [cardView setLeftUpBtnTitleColor:KKES_COLOR_HEX(0x999999) forState:UIControlStateNormal];
    [cardView setNickTitle:cardModel.nickName];
    [cardView setGameNameTitle:@"王者荣耀开黑"];
    [cardView setGameNumbersColor:KKES_COLOR_HEX(0xECC165)];
    [cardView setGameNumbersTitle:gameNumberStr unitTitle:@"局"];
    [cardView setGameTogetherTitle:@"我和他组队"];
    [cardView setGameTogetherNumbersTitle:[NSString stringWithFormat:@"%@次", gameTogetherNumberStr]];
    [cardView setHighPraiseTitle:[NSString stringWithFormat:@"%@次好评", highPriseStr]];
    [cardView.iconImgView sd_setImageWithURL:[NSURL URLWithString:cardModel.userLogoUrl] placeholderImage:Img(@"game_absent")];
    
    // 玩家标签
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
    [cardView setPlayerLabels:[labelModels copy]];
    [cardView showIn:self.view animated:YES];
}

#pragma mark - Net
- (void)requestUserDataWithModel:(KKChatRoomUserSimpleModel *)model succsee:(void(^)(NSDictionary *dic))success {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params safeSetObject:@"GAME_INFO_WITH_TARGET_USER_DETAIL_QUERY" forKey:@"service"];
    [params safeSetObject:model.userId forKey:@"targetUserId"];
    [params safeSetObject:@(self.viewModel.infoModel.gameBoardClientSimple.gameRoomId) forKey:@"roomId"];

    [[CC_HttpTask getInstance] post:[KKNetworkConfig currentUrl] params:params model:nil finishCallbackBlock:^(NSString *error, ResModel *resModel) {
        
        NSDictionary *responseDic = resModel.resultDic[@"response"];
        if (error) {
            [CC_Notice show:error];
        }else {
            success(responseDic);
        }
    }];
}
/// 获取开黑房在线人数
- (void)requestOnlineUsers {
    
    if (!self.groupIdStr) {
        return;
    }
    
    NSNumber *page = self.paginator?@(self.paginator.page):@(1);
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params safeSetObject:@"GAME_BOARD_CHAT_ROOM_MEMBERS_QUERY" forKey:@"service"];
    [params safeSetObject:self.groupIdStr forKey:@"groupId"];
    [params safeSetObject:page forKey:@"currentPage"];
    [params safeSetObject:@"10" forKey:@"pageSize"];
    
    WS(weakSelf)
    [[CC_HttpTask getInstance] post:[KKNetworkConfig currentUrl] params:params model:nil finishCallbackBlock:^(NSString *error, ResModel *resModel) {
        if (error) {
            [CC_Notice show:error atView:weakSelf.view];
            
        } else {
            NSDictionary *responseDic = resModel.resultDic[@"response"];
            NSMutableArray<KKLiveStudioUserSimpleModel *> *userArr = [KKChatRoomUserSimpleModel mj_objectArrayWithKeyValuesArray:responseDic[@"channelUsers"]];

            KKPaginator *paginator = [KKPaginator mj_objectWithKeyValues: responseDic[@"paginator"]];
            weakSelf.paginator = paginator;
            weakSelf.onLineDataArray = userArr;
            if (userArr.count == 0) {
                weakSelf.onlineListView.tableFooterView = weakSelf.notDateView;
            }else {
                weakSelf.onlineListView.tableFooterView = [[UIView alloc] init];
            }
            [weakSelf.onlineListView reloadData];
        }
        [weakSelf.onlineListView.mj_footer endRefreshing];
        [weakSelf.onlineListView.mj_header endRefreshing];
    }];
}

#pragma mark forbid word
- (void)requestGameBoardUserForbiddenListData {
    WS(weakSelf)
    NSNumber *page = self.paginator?@(self.paginator.page):@(1);
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params safeSetObject:@"GAME_BOARD_ROOM_FORBID_CHAT_USER_QUERY" forKey:@"service"];
    [params safeSetObject:page forKey:@"currentPage"];
    [params safeSetObject:self.groupIdStr forKey:@"groupId"];
    [[CC_HttpTask getInstance] post:[KKNetworkConfig currentUrl] params:params model:nil finishCallbackBlock:^(NSString *error, ResModel *resModel) {
        if (error) {
            [CC_Notice show:error];
            
        } else {
            NSDictionary *responseDic = resModel.resultDic[@"response"];
            NSMutableArray<KKLiveStudioUserSimpleModel *>*userArr = [KKChatRoomUserSimpleModel mj_objectArrayWithKeyValuesArray:responseDic[@"groupForbidChatUsers"]];
            KKPaginator *paginator = [KKPaginator mj_objectWithKeyValues: responseDic[@"paginator"]];
            weakSelf.paginatorForbidden = paginator;
            weakSelf.forbiddenDataArray = userArr;
            
            if (userArr.count == 0) {
                weakSelf.forbidWordListView.tableFooterView = weakSelf.notDateView;
            }else {
                weakSelf.forbidWordListView.tableFooterView = [[UIView alloc] init];
            }
            [weakSelf.forbidWordListView reloadData];
        }
        [weakSelf.forbidWordListView.mj_footer endRefreshing];
        [weakSelf.forbidWordListView.mj_header endRefreshing];
    }];
}

- (void)beginLoadData {
    [self.onlineListView beginHeaderRefresh];
}

@end
