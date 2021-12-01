//
//  KKLiveStudioUserMgrPopVC.m
//  kk_espw
//
//  Created by david on 2019/8/7.
//  Copyright © 2019 david. All rights reserved.
//

#import "KKChatRoomUserMgrPopVC.h"
//view
#import "DGItemView.h"
#import "KKChatRoomMicRankUserListView.h"
#import "KKChatRoomOnlineUserListView.h"
#import "KKChatRoomForbidWordUserListView.h"
#import "KKChatRoomMicRankCell.h"
#import "KKChatRoomOnlineUserCell.h"
#import "KKChatRoomForbidWordCell.h"

@interface KKChatRoomUserMgrPopVC ()
<UIScrollViewDelegate,
DGItemViewDelegate,
KKChatRoomUserListBaseCellDelegate>
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) DGItemView *itemView;
@property (nonatomic, strong) NSArray <NSString *>*titleArray;

//排麦
@property (nonatomic, strong) KKChatRoomMicRankUserListView *micListView;
//在线
@property (nonatomic, strong) KKChatRoomOnlineUserListView *onlineListView;
//禁言
@property (nonatomic, strong) KKChatRoomForbidWordUserListView *forbidWordListView;
@end

@implementation KKChatRoomUserMgrPopVC
#pragma mark - init
-(instancetype)init {
    return [self initWithTitleArray:@[KKLiveStudioUserMgrTitleMicRank,KKLiveStudioUserMgrTitleOnline,KKLiveStudioUserMgrTitleForbidWord]];
}

-(instancetype)initWithTitleArray:(NSArray<NSString *> *)titleArray {
    self = [super init];
    if (self) {
        //1.设置titleArr
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
        
        
        self.titleArray = titleArr.count>0 ? titleArr : @[KKLiveStudioUserMgrTitleMicRank,KKLiveStudioUserMgrTitleOnline,KKLiveStudioUserMgrTitleForbidWord];
    }
    return self;
}

#pragma mark - UI
-(void)setupSubViewsForDisplayView:(UIView *)displayView {
    CGFloat leftSpace = 0;
    CGFloat titleViewH = [ccui getRH:54];
    CGFloat itemW = [ccui getRH:85];
    CGFloat itemH = [ccui getRH:40];
    CGFloat itemLeftSpace = (displayView.width - itemW*self.titleArray.count)/2.0;
    CGFloat itemTopSpace = [ccui getRH:8];
    
    //1.itemV
    self.itemView = [[DGItemView alloc] initWithFrame: CGRectMake(itemLeftSpace, itemTopSpace, displayView.width-2*itemLeftSpace, itemH)];
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
            [self scrollViewAddMicRankListView:frame];
            
        }else if ([title isEqualToString:KKLiveStudioUserMgrTitleOnline]) {
            [self scrollViewAddOnlineUserListView:frame];
            
        }else if ([title isEqualToString:KKLiveStudioUserMgrTitleForbidWord]) {
            [self scrollViewAddForbidWordListView:frame];
        }
    }
    
    //2.刷新默认index
    [self refreshListViewAtIndex:self.defaultItemIndex];
    
}

-(void)scrollViewAddMicRankListView:(CGRect)frame {
    
    WS(weakSelf);
    //1.排麦用户UI
    KKChatRoomMicRankUserListView *mListV = [[KKChatRoomMicRankUserListView alloc]initWithFrame:frame];
    mListV.isHostCheck = YES;
    [mListV setConfigBlock:^(KKChatRoomMicRankCell *cell, KKChatRoomUserSimpleModel *model, NSIndexPath *indexPath) {
        cell.nameLabel.text = model.loginName;
        [cell.portraitImageView sd_setImageWithURL:Url(model.userLogoUrl)];
        cell.rankLabel.text = [NSString stringWithFormat:@"%ld",indexPath.row+1];
        cell.isHostCheck = YES;
        cell.isForbid = model.forbidChat;
        cell.isOnMic = model.onMic;
        cell.delegate = weakSelf;
        cell.localImageName = [[KKGameRoomContrastModel shareInstance].medalMapDic objectForKey:model.userMedalDetails.firstObject.currentMedalLevelConfigCode];
        
    } selectBlock:^(KKChatRoomUserSimpleModel *model, NSIndexPath *indexPath) {
        [weakSelf showPlayerGameCard:model];
    }];
    self.micListView = mListV;
    [self.scrollView addSubview:mListV];
    
    
    //2.header refresh
    [mListV.tableView addSimpleHeaderRefresh:^{
        //请求
        [weakSelf requestMicRankUsers];
    }];
}

-(void)scrollViewAddOnlineUserListView:(CGRect)frame {
    
     WS(weakSelf);
    //1.在线用户UI
    KKChatRoomOnlineUserListView *oListV = [[KKChatRoomOnlineUserListView alloc]initWithFrame:frame];
    [oListV setConfigBlock:^(KKChatRoomOnlineUserCell *cell, KKChatRoomUserSimpleModel *model, NSIndexPath *indexPath) {
        cell.nameLabel.text = model.loginName;
        [cell.portraitImageView sd_setImageWithURL:Url(model.userLogoUrl)];
        cell.isHostCheck = YES;
        cell.isOnMic = model.onMic;
        cell.isForbid = model.forbidChat;
        cell.delegate = weakSelf;
        cell.handleViewHidden = [model.userId isEqualToString:weakSelf.hostUserId];
        cell.localImageName = [[KKGameRoomContrastModel shareInstance].medalMapDic objectForKey:model.userMedalDetails.firstObject.currentMedalLevelConfigCode];
        
    } selectBlock:^(KKChatRoomUserSimpleModel *model, NSIndexPath *indexPath) {
        [weakSelf showPlayerGameCard:model];
    }];
    self.onlineListView = oListV;
    [self.scrollView addSubview:oListV];
    
    
    //2.header refresh
    [oListV.tableView addSimpleHeaderRefresh:^{
        //请求
        weakSelf.userListViewModel.onlinePaginator = nil;
        [weakSelf requestOnlineUsers];
    }];
    
    //3.footer refresh
    [oListV.tableView addAutoFooterRefreshWithPercent:0 block:^{
        //请求
        if (weakSelf.userListViewModel.onlinePaginator) {
            weakSelf.userListViewModel.onlinePaginator.page += 1;
        }
        [weakSelf requestOnlineUsers];
    }];
}

-(void)scrollViewAddForbidWordListView:(CGRect)frame {
    
    WS(weakSelf);
    //1.禁言用户UI
    KKChatRoomForbidWordUserListView *fListV = [[KKChatRoomForbidWordUserListView alloc]initWithFrame:frame];
    [fListV setConfigBlock:^(KKChatRoomForbidWordCell *cell, KKChatRoomUserSimpleModel *model, NSIndexPath *indexPath) {
        cell.nameLabel.text = model.loginName;
        [cell.portraitImageView sd_setImageWithURL:Url(model.userLogoUrl)];
        cell.isHostCheck = YES;
        cell.delegate = weakSelf;
        cell.localImageName = [[KKGameRoomContrastModel shareInstance].medalMapDic objectForKey:model.userMedalDetails.firstObject.currentMedalLevelConfigCode];
        
    } selectBlock:^(KKChatRoomUserSimpleModel * model, NSIndexPath *indexPath) {
        [weakSelf showPlayerGameCard:model];
    }];
    self.forbidWordListView = fListV;
    [self.scrollView addSubview:fListV];
    
    //1.header refresh
    [fListV.tableView addSimpleHeaderRefresh:^{
        //请求
        weakSelf.userListViewModel.forbidWordPaginator = nil;
        [weakSelf requestForbidWordUsers];
    }];
    
    //3.footer refresh
    [fListV.tableView addAutoFooterRefreshWithPercent:0 block:^{
        //请求
        if (weakSelf.userListViewModel.forbidWordPaginator) {
            weakSelf.userListViewModel.forbidWordPaginator.page += 1;
        }
        [weakSelf requestForbidWordUsers];
    }];
}

#pragma mark tool
-(void)showPlayerGameCard:(KKChatRoomUserSimpleModel *)model {

    [[KKPlayerGameCardTool shareInstance] showUserInfo:model.userId roomId:self.roomId  needKick:self.playerGameCardNeedKick isHostCheck:YES isOnMic:model.onMic delegate:self.playerGameCardDelegate];
}

-(void)refreshListViewAtIndex:(NSInteger)index {
    //1.越界处理
    if (index >= self.titleArray.count) {
        return;
    }
    
    //2.找到listView刷新
    NSString *title = self.titleArray[index];
    if([title isEqualToString:KKLiveStudioUserMgrTitleMicRank]){
        [self.micListView.tableView beginHeaderRefresh];
        
    }else if([title isEqualToString:KKLiveStudioUserMgrTitleOnline]){
        [self.onlineListView.tableView beginHeaderRefresh];
        
    }else if([title isEqualToString:KKLiveStudioUserMgrTitleForbidWord]){
        [self.forbidWordListView.tableView beginHeaderRefresh];
        
    }
}


#pragma mark - delegate
#pragma mark  DGItemViewDelegate
- (BOOL)itemView:(DGItemView *)itemView didSelectedAtIndex:(NSUInteger)index {
    //1.设置offset
    self.scrollView.contentOffset = CGPointMake(index*self.scrollView.width, 0);
    
    //2.是否无数据
    NSString *title = self.titleArray[index];
    if ([title isEqualToString:KKLiveStudioUserMgrTitleMicRank] &&
        self.userListViewModel.micRankUsers.count < 1) {
        [self refreshListViewAtIndex:index];
        
    }else if ([title isEqualToString:KKLiveStudioUserMgrTitleOnline] &&
        self.userListViewModel.onlineUsers.count < 1) {
        [self refreshListViewAtIndex:index];
        
    }else if ([title isEqualToString:KKLiveStudioUserMgrTitleForbidWord] &&
        self.userListViewModel.forbidWordUsers.count < 1) {
        [self refreshListViewAtIndex:index];
    }
    
    //3.return
    return YES;
}

#pragma mark  UIScrollViewDelegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if (![scrollView isKindOfClass:[UITableView class]]) {
        self.itemView.selectedIndex = scrollView.contentOffset.x /scrollView.width;
    }
}

#pragma mark KKChatRoomUserListBaseCellDelegate
-(void)triggerView:(UIView *)view setMicGive:(BOOL)isGive {
    
    //1.是MicRankCell
    if ([view isMemberOfClass:[KKChatRoomMicRankCell class]]) {
        KKChatRoomMicRankCell *cell = (KKChatRoomMicRankCell *)view;
        NSIndexPath *indexPath = [self.micListView.tableView indexPathForCell:cell];
        NSInteger row = indexPath.row;
        //1.防止越界
        if (row+1 > self.userListViewModel.micRankUsers.count) {
            return;
        }
        //2.请求给麦
        __weak __typeof(&*cell)weakCell = cell;
        KKChatRoomUserSimpleModel *model = self.userListViewModel.micRankUsers[row];
        
        if (self.liveStudioGiveMicBlock) {
            self.liveStudioGiveMicBlock(isGive, model.userId, YES, ^(BOOL success) {
                if (success) {
                    weakCell.isOnMic = isGive;
                }
            });
             
        }else if (self.voiceRoomGiveMicBlock){
            self.voiceRoomGiveMicBlock(isGive, model.userId, ^(BOOL success) {
                if (success) {
                    weakCell.isOnMic = isGive;
                }
            });
        }
        return ;
    }
    
    //2.是onlineUserCell
    if ([view isMemberOfClass:[KKChatRoomOnlineUserCell class]]) {
        KKChatRoomOnlineUserCell *cell = (KKChatRoomOnlineUserCell *)view;
        NSIndexPath *indexPath = [self.onlineListView.tableView indexPathForCell:cell];
        NSInteger row = indexPath.row;
        //1.防止越界
        if (row+1 > self.userListViewModel.onlineUsers.count) {
            return;
        }
        //2.请求给麦
        __weak __typeof(&*cell)weakCell = cell;
        KKChatRoomUserSimpleModel *model = self.userListViewModel.onlineUsers[row];
        if (self.liveStudioGiveMicBlock) {
            self.liveStudioGiveMicBlock(isGive, model.userId, NO, ^(BOOL success) {
                if (success) {
                    weakCell.isOnMic = isGive;
                }
            });
             
        }else if (self.voiceRoomGiveMicBlock){
            self.voiceRoomGiveMicBlock(isGive, model.userId, ^(BOOL success) {
                if (success) {
                    weakCell.isOnMic = isGive;
                }
            });
        }
        return ;
    }
    
    
}


-(void)triggerView:(UIView *)view setForbidWord:(BOOL)isForbid {
    //1.禁言
    if ([view isMemberOfClass:[KKChatRoomOnlineUserCell class]] && isForbid) {
        [self requestForbidWord:(KKChatRoomOnlineUserCell *)view];
        return ;
    }
    
    //2.取消禁言
    if ([view isMemberOfClass:[KKChatRoomForbidWordCell class]] && !isForbid) {
        [self requestForbidWordCancel:(KKChatRoomForbidWordCell *)view];
        return ;
    }
}

#pragma mark - request

#pragma mark mic rank
/** 请求排麦列表 */
-(void)requestMicRankUsers {
    
    WS(weakSelf);
    [self.userListViewModel requestMicRankUsers:^(NSInteger code) {
        SS(strongSelf);
        
        //1.停止refresh
        [strongSelf.micListView.tableView endHeaderRefresh];
        //过滤请求失败
        if (code < 0) {
            return ;
        }
        
        //3.有数据 刷新tableView
        strongSelf.micListView.dataArray = strongSelf.userListViewModel.micRankUsers;
        [strongSelf.micListView.tableView reloadData];
    }];
}



#pragma mark online
-(void)requestOnlineUsers {
    WS(weakSelf);
    [self.userListViewModel requestOnlineUsers:^(NSInteger code) {
        SS(strongSelf);
        
        //1.停止refresh
        //1.1 请求被拦截, 没有更多数据
        if (-3 == code) {
            [strongSelf.onlineListView.tableView endFooterRefreshWithNoMoreData];
            return ;
        }
        
        [strongSelf.onlineListView.tableView endHeaderRefresh];
        [strongSelf.onlineListView.tableView endFooterRefresh];
        NSLog(@"afas");
        //1.2 请求失败, 或被拦截
        if (code < 0) {
            return;
        }
        
        //2.有数据 刷新tableView
        strongSelf.onlineListView.dataArray = strongSelf.userListViewModel.onlineUsers;
        [strongSelf.onlineListView.tableView reloadData];
    }];
}


#pragma mark forbid word
-(void)requestForbidWordUsers {
    WS(weakSelf);
    [self.userListViewModel requestForbidWordUsers:^(NSInteger code) {
        SS(strongSelf);
        
        //1.停止refresh
        //1.1 请求被拦截, 没有更多数据
        if (-3 == code) {
            [strongSelf.forbidWordListView.tableView endFooterRefreshWithNoMoreData];
            return ;
        }
        
        //1.2 停止refresh
        [strongSelf.forbidWordListView.tableView endHeaderRefresh];
        [strongSelf.forbidWordListView.tableView endFooterRefresh];
        
        //1.3 请求失败, 或被拦截
        if (code < 0) {
            return;
        }
        
        //2.有数据 刷新tableView
        strongSelf.forbidWordListView.dataArray = strongSelf.userListViewModel.forbidWordUsers;
        [strongSelf.forbidWordListView.tableView reloadData];
    }];
}


-(void)requestForbidWord:(KKChatRoomOnlineUserCell *)cell {
    
    //1.不是在线cell
    if (![cell isMemberOfClass:[KKChatRoomOnlineUserCell class]]) {
        return ;
    }
    
    //2.防止越界
    NSIndexPath *indexPath = [self.onlineListView.tableView indexPathForCell:cell];
    NSInteger row = indexPath.row;
    if (row+1 > self.userListViewModel.onlineUsers.count) {
        return;
    }
    //3.获取model
    KKChatRoomUserSimpleModel *model = self.userListViewModel.onlineUsers[row];
    //4.发请求
    [self.userListViewModel requestForbidWord:model.userId success:^(NSInteger code) {
        if (code >= 0) {
            cell.isForbid = YES;
        }
    }];
}
    
-(void)requestForbidWordCancel:(KKChatRoomForbidWordCell *)cell {
    //1.不是在线cell
    if (![cell isMemberOfClass:[KKChatRoomForbidWordCell class]]) {
        return;
    }
    
    //2.防止越界
    NSIndexPath *indexPath = [self.forbidWordListView.tableView indexPathForCell:cell];
    NSInteger row = indexPath.row;
    if (row+1 > self.userListViewModel.forbidWordUsers.count) {
        return;
    }
    
    //3.获取model
    KKChatRoomUserSimpleModel *model = self.userListViewModel.forbidWordUsers[row];
    
    //4.发请求
    WS(weakSelf);
    [self.userListViewModel requestForbidWordCancel:model.userId success:^(NSInteger code) {
        if (code < 0) {
            return ;
        }
        SS(strongSelf);
        if ([strongSelf.userListViewModel.forbidWordUsers containsObject:model]) {
            [strongSelf.userListViewModel.forbidWordUsers removeObject:model];
            strongSelf.forbidWordListView.dataArray = strongSelf.userListViewModel.forbidWordUsers;
            [strongSelf.forbidWordListView.tableView reloadData];
        }
    }];
    
}

@end
