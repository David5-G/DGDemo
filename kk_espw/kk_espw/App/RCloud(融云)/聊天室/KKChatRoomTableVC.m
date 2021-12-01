//
//  KKChatRoomConversationViewController.m
//  kk_espw
//
//  Created by 阿杜 on 2019/8/8.
//  Copyright © 2019 david. All rights reserved.
//

#import "KKChatRoomTableVC.h"
#import "KKChatRoomMessage.h"
//自定义消息
#import "KKChatRoomCustomMsg.h"
#import "KKChatRoomMemberChangeMsg.h"
#import "KKChatRoomMicPositionMsg.h"
#import "KKUserMedelInfo.h"
#import "KKChatRoomTableViewCell.h"

@interface KKChatRoomTableVC ()
/** UI样式 */
@property (nonatomic, assign) KKChatRoomTableVCThemeStyle themeStyle;
/** 是否需要滚动到底部 */
@property(nonatomic, assign) BOOL isNeedScrollToButtom;

/** 滚动条不在底部的时候，接收到消息不滚动到底部，记录未读消息数 */
@property (nonatomic, assign) NSInteger unreadNewMsgCount;
@property (nonatomic, strong) NSMutableArray <KKChatRoomMessage *>*msgs;

@end

@implementation KKChatRoomTableVC
#pragma mark - lazy load
-(NSMutableArray<KKChatRoomMessage *> *)msgs {
    if (!_msgs) {
        _msgs = [NSMutableArray array];
    }
    return _msgs;
}

-(void)setTargetId:(NSString *)targetId {
    //过滤无效
    //空
    if (targetId.length < 1) {
        return;
    }
    //相同
    if ([_targetId isEqualToString:targetId]) {
        return;
    }
    
    //1.属性没值, 加入房间
    if(_targetId.length < 1){
        _targetId = [targetId copy];
        [self joinRoom];
        return;
    }
    
    //2.属性有值, 退出原来的房间,加入新房间
    if (_targetId.length > 0) {
        WS(weakSelf);
        [self quitChatRoomSuccess:^{
            self->_targetId = targetId;
            [weakSelf joinRoom];
        } error:nil];
    }
}



#pragma mark - life circle
-(instancetype)init {
    return [self initWithThemeStyle:KKChatRoomTableVCThemeStyleDefault];
}

-(instancetype)initWithThemeStyle:(KKChatRoomTableVCThemeStyle)themeStyle {
    self = [super initWithStyle:UITableViewStylePlain];
    if (self) {
        self.themeStyle = themeStyle;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.separatorColor = [UIColor clearColor];
    
    [self addObserver];
}

-(void)dealloc {
    [self quitChatRoomSuccess:nil error:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    CCLOG(@"%s", __func__);
}


#pragma mark - notification
-(void)addObserver {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onNewMessage:) name:IMKitNotification_IMMessageListener object:nil];
}

-(void)onNewMessage:(NSNotification *)notification {
    RCMessage *rcMessage = notification.object;
    NSDictionary *userInfoDic = notification.userInfo;
    
    //过滤不匹配
    if (![rcMessage.targetId isEqualToString:self.targetId]) {
        return;
    }
    
    //1.text消息
    if ([rcMessage.content isKindOfClass:[RCTextMessage class]]) {
        [self handleDisplayMsg:rcMessage userInfo:userInfoDic];
        return;
    }
    
    //2.KKChatRoomCustomMsg
    if ([rcMessage.content isKindOfClass:[KKChatRoomCustomMsg class]]) {
        KKChatRoomCustomMsg *content = (KKChatRoomCustomMsg *)rcMessage.content;
        
        //2.1 开黑房广播找人
        if ([content.msgType isEqualToString:@"ESPW_SPECIAL_MSG_TYPE"]) {
            [self handleDisplayMsg:rcMessage userInfo:userInfoDic];
            return;
        }
        
        //2.2 开黑房状态改变，刷新
        if ([content.msgType isEqualToString:@"ESPW_ROOM_REFRESH_TYPE"]) {
            [[NSNotificationCenter defaultCenter] postNotificationName:REFRESH_GAME_BOARD_ROOM_NOTIFICATION object:nil userInfo:@{@"content":content.extra ?: @""}];
            return;
            
        }
        
        //2.3 主播麦克风变化
        if ([content.msgType isEqualToString:@"ANCHOR_MIC_CLOSE"] ||
            [content.msgType isEqualToString:@"ANCHOR_MIC_OPEN"] ) {
            
            BOOL isClose = [content.msgType isEqualToString:@"ANCHOR_MIC_CLOSE"];
            NSDictionary *userInfo = @{@"hostMicClose" : @(isClose),
                                       @"extra" : content.extra, };
            [[NSNotificationCenter defaultCenter] postNotificationName:LIVE_STUDIO_HOST_MIC_CHANGE_NOTIFICATION object:self userInfo:userInfo];
            return;
        }
    }
    
    //3.KKChatRoomMemberChangeMsg
    if ([rcMessage.content isKindOfClass:[KKChatRoomMemberChangeMsg class]]) {//开黑房状态改变
        KKChatRoomMemberChangeMsg *content = (KKChatRoomMemberChangeMsg *)rcMessage.content;
        NSDictionary *userInfo = @{@"targetId" : rcMessage.targetId,
                                   @"changeType" : content.changeType,
                                   @"changeUserId" : content.changeUserId,
        };
        [[NSNotificationCenter defaultCenter] postNotificationName:CHAT_ROOM_MEMBER_CHANGE_NOTIFICATION object:self userInfo:userInfo];
        return;
    }
    
    //4.KKChatRoomMicPositionMsg
    if ([rcMessage.content isKindOfClass:[KKChatRoomMicPositionMsg class]]) {//开黑房状态改变
        KKChatRoomMicPositionMsg *content = (KKChatRoomMicPositionMsg *)rcMessage.content;
        NSDictionary *userInfo = @{@"targetId" : rcMessage.targetId,
                                   @"micChangeType" : content.micChangeType,
                                   @"fromChangeUserId" : content.fromChangeUserId,
                                   @"toChangeUserId" : content.toChangeUserId,
                                   @"extra" : content.extra, };
        [[NSNotificationCenter defaultCenter] postNotificationName:LIVE_STUDIO_MIC_POSITION_CHANGE_NOTIFICATION object:self userInfo:userInfo];
        return;
    }
 
}

-(void)handleDisplayMsg:(RCMessage *)rcMsg userInfo:(NSDictionary *)userInfoDic {
    
    //过滤空
    if (!rcMsg) { return; }
    
    //1.主线程处理
    dispatch_async(dispatch_get_main_queue(), ^{
        
        if (userInfoDic && [userInfoDic[@"left"] isEqual:@(0)]) {
            self.isNeedScrollToButtom = YES;
        }
        
        [self appendAndDisplayMessage:rcMsg];
        UIMenuController *menu = [UIMenuController sharedMenuController];
        menu.menuVisible=NO;
        
        //如果消息不在最底部，收到消息之后不滚动到底部，加到列表中只记录未读数
        if (![self isAtTheBottomOfTableView]) {
            self.unreadNewMsgCount ++ ;
            [self updateUnreadMsgCountLabel];
        }
    });
}

#pragma mark - delegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.msgs.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *chatRoomCellId = @"chatRoomCellId";
    KKChatRoomTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:chatRoomCellId];
    if (!cell) {
        cell = [[KKChatRoomTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:chatRoomCellId];
    }
    
    KKChatRoomMessage *msg = self.msgs[indexPath.row];
    [cell loadMsg:msg];
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    KKChatRoomMessage *msg = self.msgs[indexPath.row];
    if(msg.isDark){
        return msg.contentSize.height + [ccui getRH:16];
    }
    return msg.contentSize.height + [ccui getRH:5];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (self.delegate && [self.delegate respondsToSelector:@selector(chatRoom:didSelectMsg:)]) {
        [self.delegate chatRoom:self didSelectMsg:self.msgs[indexPath.row]];
    }
}

#pragma mark - scrollViewDelegate

-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    if (self.delegate && [self.delegate respondsToSelector:@selector(chatRoomWillBeginDragging:)]) {
        [self.delegate chatRoomWillBeginDragging:self];
    }
}

#pragma mark - IM

-(void)joinRoom {

    WS(weakSelf)
    [[RCIMClient sharedRCIMClient] joinChatRoom:self.targetId messageCount:-1 success:^{
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf.msgs removeAllObjects];
            [weakSelf.tableView reloadData];
        });
        
    } error:^(RCErrorCode status) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (status == KICKED_FROM_CHATROOM) {
                // 提示错误信息
                [CC_Notice show:@"已被踢出并禁止加入聊天室"];
            } else if(status == RC_CHANNEL_INVALID){
                [CC_Notice show:@"连接已经被释放"];
            }
        });
    }];
}


-(void)quitChatRoomSuccess:(void (^)(void))successBlock error:(void (^)(RCErrorCode))errorBlock {
    [[RCIMClient sharedRCIMClient] quitChatRoom:self.targetId
                                        success:^{
                                            if (successBlock) {
                                                successBlock();
                                            }
                                            
                                        } error:^(RCErrorCode errorCode) {
                                            if (errorBlock) {
                                                errorBlock(errorCode);
                                            }
                                        }];
}


-(void)sendTextMsg:(NSString *)text success:(void (^)(long))successBlock error:(void (^)(RCErrorCode, long))errorBlock {
    
    RCTextMessage *textContent = [RCTextMessage messageWithContent:text];
    RCUserInfo *userInfo = [[RCUserInfo alloc] init];
    userInfo.userId = [KKUserInfoMgr shareInstance].userId;
    userInfo.name = [KKUserInfoMgr shareInstance].userInfoModel.nickName;
    userInfo.portraitUri = [KKUserInfoMgr shareInstance].userInfoModel.userLogoUrl;
    
    KKUserMedelInfo *userMedalDetail = [KKUserInfoMgr shareInstance].userInfoModel.userMedalDetailList.firstObject;
    if (userMedalDetail) {
        userInfo.extra = [userMedalDetail.currentMedalLevelConfigCode stringByReplacingOccurrencesOfString:@"_" withString:@"#"];
    }
    textContent.senderUserInfo = userInfo;
    
    WS(weakSelf)
    [[RCIMClient sharedRCIMClient] sendMessage:ConversationType_CHATROOM targetId:self.targetId content:textContent pushContent:nil pushData:nil success:^(long messageId) {
        dispatch_async(dispatch_get_main_queue(), ^{
            RCMessage *message = [[RCMessage alloc] initWithType:ConversationType_CHATROOM
                                                        targetId:weakSelf.targetId
                                                       direction:MessageDirection_SEND
                                                       messageId:messageId
                                                         content:textContent];
            message.senderUserId = [KKUserInfoMgr shareInstance].userId;
            [self appendAndDisplayMessage:message];
            successBlock(messageId);
        });
    } error:^(RCErrorCode nErrorCode, long messageId) {
        if (nErrorCode == NOT_IN_CHATROOM) {
            [self joinRoom];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            errorBlock(nErrorCode,messageId);
        });
    }];
}

#pragma mark - public

-(void)cleanHistoryMessages{
    
    [self.msgs removeAllObjects];
    [self.tableView reloadData];
}

#pragma mark - private

/**
 *  将消息加入本地数组并显示
 */
- (void)appendAndDisplayMessage:(RCMessage *)rcMessage {
    if (!rcMessage) {
        return;
    }
   
    if ([self appendMessageModel:rcMessage]) {
        NSIndexPath *indexPath =
        [NSIndexPath indexPathForItem:self.msgs.count - 1
                            inSection:0];
        if ([self.tableView numberOfRowsInSection:0] !=
            self.msgs.count - 1) {
            return;
        }
        //  view刷新
        [self.tableView
         insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationBottom];
        if ([self isAtTheBottomOfTableView] || self.isNeedScrollToButtom) {
            [self scrollToBottomAnimated:YES];
            self.isNeedScrollToButtom=NO;
        }
    }
    return;
}

/**
 *  把消息加入本地数组
 */
- (BOOL)appendMessageModel:(RCMessage *)rcMsg {
    
    if (!rcMsg.content) {
        return NO;
    }
    //这里可以根据消息类型来决定是否显示，如果不希望显示直接return NO
    
    //数量不可能无限制的大，这里限制收到消息过多时，就对显示消息数量进行限制。
    //用户可以手动下拉更多消息，查看更多历史消息。
    if (self.msgs.count>100) {
        //                NSRange range = NSMakeRange(0, 1);
        KKChatRoomMessage *message = self.msgs[0];
        [[RCIMClient sharedRCIMClient] deleteMessages:@[@(message.rcMsg.messageId)]];
        [self.msgs removeObjectAtIndex:0];
        [self.tableView reloadData];
    }
    
    KKChatRoomMessage *uiMsg = [KKChatRoomMessage messageWithRCMgr:rcMsg dark:KKChatRoomTableVCThemeStyleDark==self.themeStyle];
    [self.msgs addObject:uiMsg];
    return YES;
}

/**
 *  判断消息是否在collectionView的底部
 *
 *  @return 是否在底部
 */
- (BOOL)isAtTheBottomOfTableView {
    if (self.tableView.contentSize.height <= self.tableView.frame.size.height) {
        return YES;
    }
    if(self.tableView.contentOffset.y +200 >= (self.tableView.contentSize.height - self.tableView.frame.size.height)) {
        return YES;
    }else{
        return NO;
    }
}

/**
 *  消息滚动到底部
 *
 *  @param animated 是否开启动画效果
 */
- (void)scrollToBottomAnimated:(BOOL)animated {
    if ([self.tableView numberOfSections] == 0) {
        return;
    }
    NSUInteger finalRow = MAX(0, [self.tableView numberOfRowsInSection:0] - 1);
    if (0 == finalRow) {
        return;
    }
    NSIndexPath *finalIndexPath = [NSIndexPath indexPathForItem:finalRow inSection:0];
    [self.tableView scrollToRowAtIndexPath:finalIndexPath atScrollPosition:UITableViewScrollPositionTop animated:animated];
}

/**
 *  更新底部新消息提示显示状态
 */
- (void)updateUnreadMsgCountLabel{
    if (self.unreadNewMsgCount == 0) {
//                self.unreadButtonView.hidden = YES;
    }
    else{
//                self.unreadButtonView.hidden = NO;
//                self.unReadNewMessageLabel.text = @"底部有新消息";
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    // 是否显示右下未读icon
    if (self.unreadNewMsgCount != 0) {
        [self checkVisiableCell];
    }
    
    //    if (scrollView.contentOffset.y < -5.0f) {
    //        [self.collectionViewHeader startAnimating];
    //    } else {
    //        [self.collectionViewHeader stopAnimating];
    //        _isLoading = NO;
    //    }
}

/**
 *  检查是否更新新消息提醒
 */
- (void) checkVisiableCell{
    NSIndexPath *lastPath = [self getLastIndexPathForVisibleItems];
    if (lastPath.row >= self.msgs.count - self.unreadNewMsgCount || lastPath == nil || [self isAtTheBottomOfTableView] ) {
        self.unreadNewMsgCount = 0;
        [self updateUnreadMsgCountLabel];
    }
}

/**
 *  获取显示的最后一条消息的indexPath
 *
 *  @return indexPath
 */
- (NSIndexPath *)getLastIndexPathForVisibleItems {
    
    NSArray *visiblePaths = [self.tableView indexPathsForVisibleRows];
    if (visiblePaths.count == 0) {
        return nil;
    }else if(visiblePaths.count == 1) {
        return (NSIndexPath *)[visiblePaths firstObject];
    }
    NSArray *sortedIndexPaths = [visiblePaths sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        NSIndexPath *path1 = (NSIndexPath *)obj1;
        NSIndexPath *path2 = (NSIndexPath *)obj2;
        return [path1 compare:path2];
    }];
    return (NSIndexPath *)[sortedIndexPaths lastObject];
}



@end
