//
//  KKPlayTogeListCell.m
//  kk_espw
//
//  Created by 景天 on 2019/7/18.
//  Copyright © 2019年 david. All rights reserved.
//

#import "KKPlayTogeListCell.h"
#import "KKOrderListInfo.h"
#import "KKMessage.h"
#import "KKTag.h"
#import "KKOrderTagCollectionViewCell.h"
#import "KKCalculateTextWidthOrHeight.h"
#import "JTCollectionViewLayout.h"

@interface KKPlayTogeListCell()<UICollectionViewDelegate, UICollectionViewDataSource>
@property (nonatomic, strong) UIImageView *statusImageView;
@property (nonatomic, strong) UILabel *statusL;
@property (nonatomic, strong) UILabel *nameL;
@property (nonatomic, strong) UILabel *modelL;
@property (nonatomic, strong) UILabel *areaL;
@property (nonatomic, strong) UIImageView *headerImageView;
@property (nonatomic, strong) UILabel *nickL;
@property (nonatomic, strong) UILabel *danGradingL; /// 段位
@property (nonatomic, strong) CC_Button *operationButton;
@property (nonatomic, strong) CC_Button *shareButton;
@property (nonatomic, strong) CC_Button *joinGroup;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSMutableArray *tagArray;
@property (nonatomic, strong) KKOrderListInfo *orderInfo;
@property (nonatomic, strong) UILabel *myGetEvaluateL;
@property (nonatomic, strong) UILabel *residuePayEvaluateL;
@property (nonatomic, strong) UILabel *residuePayEvaluateDescriptionL;
@property (nonatomic, weak)   id m_data;
@property (nonatomic, weak)   NSIndexPath *m_tmpIndexPath;
@property (nonatomic, copy) NSString *canEva;
@end

@implementation KKPlayTogeListCell
- (NSMutableArray *)tagArray {
    if (!_tagArray) {
        _tagArray = [NSMutableArray array];
    }
    return _tagArray;
}

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        
        JTCollectionViewLayout * layout = [[JTCollectionViewLayout alloc] init];
        layout.rowCount = 2;
        layout.scrollDirection = ZZCollectionViewScrollDirectionHorizontal;
        
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(RH(207), RH(35), RH(RH(125)), RH(60)) collectionViewLayout:layout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.scrollEnabled = YES;
        _collectionView.backgroundColor = [UIColor whiteColor];
        _collectionView.userInteractionEnabled = YES;
        [_collectionView registerClass:[KKOrderTagCollectionViewCell class]
            forCellWithReuseIdentifier:@"KKOrderTagCollectionViewCell"];
        _collectionView.translatesAutoresizingMaskIntoConstraints = NO;
        _collectionView.bounces = YES;
        WS(weakSelf)
        [_collectionView addTapWithTimeInterval:0.5 tapBlock:^(UIView * _Nonnull view) {
            if (weakSelf.didSelectCollectionCellBlock) {
                weakSelf.didSelectCollectionCellBlock(weakSelf.orderInfo);
            }
        }];
    }
    return _collectionView;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self registerNSNotificationCenter];

        UIView *bgV = New(UIView);
        bgV.left = RH(10);
        bgV.top = RH(5);
        bgV.size = CGSizeMake(SCREEN_WIDTH - 2 * RH(10), RH(157));
        [self.contentView addSubview:bgV];
        
        bgV.backgroundColor = RGB(250, 250, 250);
        bgV.layer.cornerRadius = 5;
        bgV.clipsToBounds = YES;
        bgV.layer.shadowColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.02].CGColor;
        bgV.layer.shadowOffset = CGSizeMake(0,3);
        bgV.layer.shadowOpacity = 1;
        bgV.layer.shadowRadius = 10;
        bgV.layer.cornerRadius = 5;
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = [UIColor clearColor];
        
        UIView *topBgView = New(UIView);
        topBgView.left = 0;
        topBgView.top = 0;
        topBgView.size = CGSizeMake(SCREEN_WIDTH - RH(20), RH(88));
        topBgView.backgroundColor = RGB(254, 254, 254);
        [bgV addSubview:topBgView];
        
        UIImageView *shadowV = [UIImageView new];
        shadowV.left = 0;
        shadowV.top = topBgView.bottom -  2;
        shadowV.size = CGSizeMake(topBgView.width, RH(15));
        shadowV.image = Img(@"order_center_lineView");
        [bgV addSubview:shadowV];
        
        /// 1. 比赛中
        _statusImageView = New(UIImageView);
        _statusImageView.left = 0;
        _statusImageView.top = 0;
        _statusImageView.size = CGSizeMake(RH(44), RH(44));
        [topBgView addSubview:_statusImageView];
        /// 2. 状态文字
        _statusL = New(UILabel);
        _statusL.left = -2;
        _statusL.right = -2;
        _statusL.size = CGSizeMake(RH(26), RH(26));
        _statusL.textAlignment = NSTextAlignmentCenter;
        _statusL.transform = CGAffineTransformMakeRotation(-M_PI / 4);
        _statusL.text = @"比赛中";
        _statusL.textColor = [UIColor whiteColor];
        _statusL.adjustsFontSizeToFitWidth = YES;
        [_statusImageView addSubview:_statusL];
        /// 3. 荣耀王者SOLO赛
        _nameL = New(UILabel);
        _nameL.left = RH(30);
        _nameL.top = RH(30);
        _nameL.size = CGSizeMake(RH(180), RH(16));
        [topBgView addSubview:_nameL];
        _nameL.text = @"荣耀王者SOLO赛";
        _nameL.textColor = KKES_COLOR_BLACK_TEXT;
        _nameL.font = [KKFont pingfangFontStyle:PFFontStyleSemibold size:RH(16)];
        /// 4. 分享
        _shareButton = [CC_Button buttonWithType:UIButtonTypeCustom];
        _shareButton.frame = CGRectMake(RH(230), RH(42), RH(40), RH(40));
        _shareButton.backgroundColor = [UIColor whiteColor];
        [_shareButton setImage:Img(@"order_share") forState:UIControlStateNormal];
        _shareButton.layer.cornerRadius = 5;
        _shareButton.layer.borderColor = KKES_COLOR_BLACK_TEXT.CGColor;
        _shareButton.layer.borderWidth = 1;
        [topBgView addSubview:_shareButton];
        _shareButton.hidden = YES;
        WS(weakSelf)
        [_shareButton addTapWithTimeInterval:0.2 tapBlock:^(UIView * _Nonnull view) {
            weakSelf.tapShareButtonBlock(weakSelf.orderInfo);
        }];
        /// 4.1 进群
        _joinGroup = [CC_Button buttonWithType:UIButtonTypeCustom];
        _joinGroup.frame = CGRectMake(_shareButton.right + RH(15), RH(42), RH(40), RH(40));
        _joinGroup.backgroundColor = [UIColor whiteColor];
        [_joinGroup setImage:Img(@"join_group") forState:UIControlStateNormal];
        _joinGroup.layer.cornerRadius = 5;
        _joinGroup.layer.borderColor = KKES_COLOR_BLACK_TEXT.CGColor;
        _joinGroup.layer.borderWidth = 1;
        [topBgView addSubview:_joinGroup];
        
        [_joinGroup addTapWithTimeInterval:0.2 tapBlock:^(UIView * _Nonnull view) {
            weakSelf.tapJoinGroupButtonBlock(weakSelf.orderInfo);
        }];
        
        /// 5. 五人模式
        _modelL = New(UILabel);
        _modelL.left = _nameL.left;
        _modelL.top = _nameL.bottom + RH(12);
        _modelL.size = CGSizeMake(RH(46), RH(17));
        [topBgView addSubview:_modelL];
        _modelL.text = @"五人模式";
        _modelL.textColor = KKES_COLOR_GRAY_TEXT;
        _modelL.font = [KKFont pingfangFontStyle:PFFontStyleMedium size:RH(9)];
        _modelL.layer.borderWidth = 1;
        _modelL.layer.cornerRadius = 3;
        _modelL.layer.borderColor = [UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1.0].CGColor;
        _modelL.textAlignment = NSTextAlignmentCenter;
        /// 6. 微信大区
        _areaL = New(UILabel);
        _areaL.left = _modelL.right + RH(6);
        _areaL.top = _modelL.top;
        _areaL.size = CGSizeMake(RH(46), RH(17));
        [topBgView addSubview:_areaL];
        _areaL.text = @"微信大区";
        _areaL.layer.cornerRadius = 3;
        _areaL.textColor = KKES_COLOR_GRAY_TEXT;
        _areaL.font = [KKFont pingfangFontStyle:PFFontStyleMedium size:RH(9)];
        _areaL.layer.borderWidth = 1;
        _areaL.layer.borderColor = [UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1.0].CGColor;
        _areaL.textAlignment = NSTextAlignmentCenter;
        /// 7. 下半部分白色V
        UIView *bottomBgView = New(UIView);
        bottomBgView.left = 0;
        bottomBgView.top = topBgView.bottom + RH(12);
        bottomBgView.size = CGSizeMake(SCREEN_WIDTH - RH(20), RH(57));
        [bgV addSubview:bottomBgView];
        bottomBgView.backgroundColor = [UIColor whiteColor];
        /// 8. 头像
        _headerImageView = New(UIImageView);
        _headerImageView.left = RH(30);
        _headerImageView.top = RH(14);
        _headerImageView.size = CGSizeMake(RH(30), RH(30));
        _headerImageView.layer.cornerRadius = RH(15);
        _headerImageView.clipsToBounds = YES;
        [bottomBgView addSubview:_headerImageView];
        
        UIImageView *host = New(UIImageView);
        host.left = RH(15);
        host.top = RH(15);
        host.size = CGSizeMake(RH(15), RH(15));
        host.image = Img(@"icon_order_host");
        [_headerImageView addSubview:host];
        
        /// 9. 昵称
        _nickL = New(UILabel);
        _nickL.left = _headerImageView.right + RH(8);
        _nickL.top = RH(17);
        _nickL.size = CGSizeMake(RH(120), RH(12));
        [bottomBgView addSubview:_nickL];
        _nickL.text = @"张楚岚";
        _nickL.textColor = RGB(102, 102, 102);
        _nickL.font = [KKFont pingfangFontStyle:PFFontStyleMedium size:RH(12)];
        /// 10. 段位
        _danGradingL = New(UILabel);
        _danGradingL.left = _nickL.left;
        _danGradingL.top = _nickL.bottom + RH(4);
        _danGradingL.size = CGSizeMake(RH(60), RH(9));
        [bottomBgView addSubview:_danGradingL];
        _danGradingL.text = @"荣耀王者";
        _danGradingL.textColor = RGB(170, 170, 170);
        _danGradingL.font = [KKFont pingfangFontStyle:PFFontStyleMedium size:RH(9)];
        /// 11. 结束并评价
        _operationButton = [CC_Button buttonWithType:UIButtonTypeCustom];
        _operationButton.left = RH(225);
        _operationButton.top = RH(16);
        _operationButton.size = CGSizeMake(RH(100), RH(27));
        _operationButton.titleLabel.font = [KKFont pingfangFontStyle:PFFontStyleMedium size:RH(12)];
        [self yellowBorderYellowText];
        [_operationButton addTapWithTimeInterval:0.2 tapBlock:^(UIView * _Nonnull view) {
            weakSelf.tapOperationButtonBlock(weakSelf.operationButton, weakSelf.orderInfo, weakSelf.canEva);
        }];
        [bottomBgView addSubview:_operationButton];
        
        /// 12. 评价"我收到的评价"
        _myGetEvaluateL = New(UILabel);
        _myGetEvaluateL.left = RH(207);
        _myGetEvaluateL.top = 0;
        _myGetEvaluateL.text = @"我收到的评价";
        _myGetEvaluateL.textColor = KKES_COLOR_GRAY_TEXT;
        _myGetEvaluateL.size = CGSizeMake(topBgView.width - RH(207), 35);
        _myGetEvaluateL.textAlignment = NSTextAlignmentCenter;
        _myGetEvaluateL.font = [KKFont pingfangFontStyle:PFFontStyleMedium size:10];
        [topBgView addSubview:_myGetEvaluateL];
        [topBgView addSubview:self.collectionView];
        
        /// 13. 剩余支付评价时间描述
        _residuePayEvaluateDescriptionL = New(UILabel);
        _residuePayEvaluateDescriptionL.left = RH(246);
        _residuePayEvaluateDescriptionL.top = 33;
        _residuePayEvaluateDescriptionL.textColor = KKES_COLOR_GRAY_TEXT;
        _residuePayEvaluateDescriptionL.size = CGSizeMake(80, RH(13));
        _residuePayEvaluateDescriptionL.textAlignment = NSTextAlignmentCenter;
        _residuePayEvaluateDescriptionL.font = [KKFont pingfangFontStyle:PFFontStyleMedium size:RH(10)];
        [topBgView addSubview:_residuePayEvaluateDescriptionL];
        
        /// 14. 剩余支付评价时间
        _residuePayEvaluateL = New(UILabel);
        _residuePayEvaluateL.left = RH(246);
        _residuePayEvaluateL.top = _residuePayEvaluateDescriptionL.bottom + RH(5);
        _residuePayEvaluateL.textColor = KKES_COLOR_BLACK_TEXT;
        _residuePayEvaluateL.size = CGSizeMake(80, RH(20));
        _residuePayEvaluateL.textAlignment = NSTextAlignmentCenter;
        _residuePayEvaluateL.font = [KKFont pingfangFontStyle:PFFontStyleSemibold size:RH(16)];
        [topBgView addSubview:_residuePayEvaluateL];
        
        _residuePayEvaluateDescriptionL.text = @"剩余支付时间";
        _residuePayEvaluateL.text = @"05:11";
        
    }
    return self;
}

- (void)setModel:(KKOrderListInfo *)model {
    _residuePayEvaluateDescriptionL.hidden = YES;
    _residuePayEvaluateL.hidden = YES;
    _myGetEvaluateL.hidden = YES;
    _shareButton.hidden = YES;
    _operationButton.hidden = YES;
    _collectionView.hidden = YES;
    _joinGroup.hidden = YES;
    _orderInfo = model;
    [self.tagArray removeAllObjects];
    [_headerImageView sd_setImageWithURL:Url(model.ownerUserHeaderImgUrl)];
    /// 标题
    _nameL.text = model.title;
    /// 模式
    _modelL.text = model.patternType.message;
    /// 微信区
    _areaL.text = [NSString stringWithFormat:@"%@大区", model.platFormType.message];
    /// 用户名字
    _nickL.text = model.ownerUserName;
    /// 段位
    _danGradingL.text = model.gameRank.message;
    /// 招募中
    _statusImageView.image = Img([KKDataDealTool returnChineseStrWithEnglisgStr:model.proceedStatus.name]);
    /// 边框
    if ([model.proceedStatus.name isEqualToString:@"INIT"]) {
        _operationButton.hidden = NO;
        [_operationButton setTitle:@"立即支付" forState:UIControlStateNormal];
        [_operationButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _operationButton.backgroundColor = [UIColor colorWithRed:210/255.0 green:165/255.0 blue:77/255.0 alpha:1.0];
        _statusImageView.image = Img(@"willpay");
        _statusL.text = @"待支付";
        _residuePayEvaluateDescriptionL.text = @"剩余支付时间";
        _residuePayEvaluateDescriptionL.hidden = NO;
        _residuePayEvaluateL.hidden = NO;
    }else if ([model.proceedStatus.name isEqualToString:@"RECRUIT"]){
        /// 拥有者和登录人一样 才能解散对局
        if ([model.ownerUserId isEqualToString:[KKUserInfoMgr shareInstance].userId]) {
            _operationButton.hidden = NO;
            [_operationButton setTitle:@"解散对局" forState:UIControlStateNormal];
            [self yellowBorderYellowText];
        }else {
            _operationButton.hidden = YES;
        }
        _statusImageView.image = Img(@"zhaomuzhong");
        _statusL.text = @"招募中";
        _shareButton.hidden = NO;
        _joinGroup.hidden = NO;

    }else if ([model.proceedStatus.name isEqualToString:@"PROCESSING"]){
        _operationButton.hidden = NO;
        _joinGroup.hidden = NO;
        [_operationButton setTitle:@"结束并评价" forState:UIControlStateNormal];
        _statusImageView.image = Img(@"bisaizhong");
        _statusL.text = @"比赛中";
        
        _operationButton.layer.borderWidth = 1;
        _operationButton.layer.borderColor = KKES_COLOR_GRAY_TEXT.CGColor;
        [_operationButton setTitleColor:KKES_COLOR_GRAY_TEXT forState:UIControlStateNormal];
        _operationButton.layer.cornerRadius = 3;

    }else if ([model.proceedStatus.name isEqualToString:@"EVALUATE"]){
        _operationButton.hidden = NO;
        _joinGroup.hidden = YES;
        [_operationButton setTitle:@"立即评价" forState:UIControlStateNormal];
        [self yellowBorderYellowText];
        _statusImageView.image = Img(@"close_gray");
        _statusL.text = @"待评价";
        /// 结束时间
        _residuePayEvaluateDescriptionL.text = @"剩余评价时间";
        _residuePayEvaluateDescriptionL.hidden = NO;
        _residuePayEvaluateL.hidden = NO;
    }else if ([model.proceedStatus.name isEqualToString:@"FINISH"]){
        _statusImageView.image = Img(@"close_gray");
        _statusL.text = @"已结束";

        if (model.userGameTagCountList.count != 0) {
            _myGetEvaluateL.hidden = NO;
            _collectionView.hidden = NO;
            [self.tagArray addObjectsFromArray:model.userGameTagCountList];
            [self.collectionView reloadData];
        }

    }else if ([model.proceedStatus.name isEqualToString:@"CANCEL"]){
        _statusImageView.image = Img(@"close_gray");
        _statusL.text = @"已关闭";

    }else if ([model.proceedStatus.name isEqualToString:@"FAIL_SOLD"]){
        _statusImageView.image = Img(@"close_gray");
        _statusL.text = @"已关闭";
    }
}

- (void)yellowBorderYellowText {
    _operationButton.layer.borderWidth = 1;
    _operationButton.layer.borderColor = [UIColor colorWithRed:210/255.0 green:165/255.0 blue:77/255.0 alpha:1.0].CGColor;
    [_operationButton setTitleColor:[UIColor colorWithRed:210/255.0 green:165/255.0 blue:77/255.0 alpha:1.0] forState:UIControlStateNormal];
    _operationButton.layer.cornerRadius = 3;
}


- (void)setConfig:(NSString *)config systemDate:(NSString *)systemDate {
    if ([self.orderInfo.proceedStatus.name isEqualToString:@"PROCESSING"]) {
        NSTimeInterval time = [self pleaseInsertStarTime:self.orderInfo.gmtBoardStart andInsertEndTime:systemDate];
        if (time > config.integerValue * 60) {
            _canEva = @"can";
            [_operationButton setTitle:@"结束并评价" forState:UIControlStateNormal];
            _operationButton.layer.borderWidth = 1;
            _operationButton.layer.borderColor = [UIColor colorWithRed:210/255.0 green:165/255.0 blue:77/255.0 alpha:1.0].CGColor;
            [_operationButton setTitleColor:[UIColor colorWithRed:210/255.0 green:165/255.0 blue:77/255.0 alpha:1.0] forState:UIControlStateNormal];
            _operationButton.layer.cornerRadius = 3;
        }
    }
}

- (NSTimeInterval)pleaseInsertStarTime:(NSString *)starTime andInsertEndTime:(NSString *)endTime{
    NSDateFormatter *formater = [[NSDateFormatter alloc] init];
    [formater setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *startDate = [formater dateFromString:starTime];
    NSDate *endDate = [formater dateFromString:endTime];
    NSTimeInterval time = [endDate timeIntervalSinceDate:startDate];
    return time;
}

#pragma mark - <UICollectionViewDelegate, UICollectionViewDataSource>
- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout *)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    KKTag *tag = self.tagArray[indexPath.item];
    CGFloat tagW = [self getTagW:tag];
    CGFloat tagTextW = [self getTagTextW:tag];
    return CGSizeMake(tagW + tagTextW + RH(4), RH(15));
}

- (CGFloat)collectionView:(UICollectionView *)collectionView
                   layout:(UICollectionViewLayout *)collectionViewLayout
minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 2;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView
                        layout:(UICollectionViewLayout *)collectionViewLayout
        insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(1, 1, 1, 1);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 2;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.tagArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                  cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    KKOrderTagCollectionViewCell *cell =
    [collectionView dequeueReusableCellWithReuseIdentifier:@"KKOrderTagCollectionViewCell"
                                              forIndexPath:indexPath];
    KKTag *tag = self.tagArray[indexPath.item];
    cell.tagModel = tag;
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (self.didSelectCollectionCellBlock) {
        self.didSelectCollectionCellBlock(_orderInfo);
    }
}

/// 获取Kangyawang
- (CGFloat)getTagW:(KKTag *)tag {
    /// 计算标签的宽度
    CGFloat w = 0;
    if ([tag.tagCode isEqualToString:@"YE_WANG"] || [tag.tagCode isEqualToString:@"KENG_HUO"] || [tag.tagCode isEqualToString:@"FA_WANG"]) {
        w = RH(25);
    }else if ([tag.tagCode isEqualToString:@"QUAN_NENG_FU_ZHU"]){
        w = RH(40);
    }else {
        w = RH(35);
    }
    return w;
}

/// 获取文字宽度
- (CGFloat)getTagTextW:(KKTag *)tag {
    return [KKCalculateTextWidthOrHeight getWidthWithAttributedText:[NSString stringWithFormat:@"x%@", tag.gameTagCount] font:[KKFont pingfangFontStyle:PFFontStyleRegular size:RH(9)] height:RH(15)];
}

- (void)loadData:(id)data indexPath:(NSIndexPath *)indexPath {
    
    if ([data isMemberOfClass:[KKOrderListInfo class]]) {
        [self storeWeakValueWithData:data indexPath:indexPath];
        KKOrderListInfo *model = (KKOrderListInfo *)data;
        if ([model.proceedStatus.name isEqualToString:@"EVALUATE"]) {
            
            _residuePayEvaluateL.text  = [NSString stringWithFormat:@"%@",[model currentGameEvaluateEndTimeString]];
        }else {
            
            _residuePayEvaluateL.text  = [NSString stringWithFormat:@"%@",[model currentTimeString]];
        }

    }
    
}

- (void)storeWeakValueWithData:(id)data indexPath:(NSIndexPath *)indexPath {
    
    self.m_data         = data;
    self.m_tmpIndexPath = indexPath;
}

- (void)dealloc {
    [self removeNSNotificationCenter];
}

#pragma mark - 通知中心
- (void)registerNSNotificationCenter {
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(notificationCenterEvent:)
                                                 name:NOTIFICATION_TIME_CELL
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(notificationCenterEventEva:)
                                                 name:NOTIFICATION_TIME_CELL_GAMEEND_EVA
                                               object:nil];
}

- (void)removeNSNotificationCenter {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NOTIFICATION_TIME_CELL object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NOTIFICATION_TIME_CELL_GAMEEND_EVA object:nil];

}

- (void)notificationCenterEvent:(id)sender {
    
    if (self.m_isDisplayed) {
        [self loadData:self.m_data indexPath:self.m_tmpIndexPath];
    }
}

- (void)notificationCenterEventEva:(id)sender {
    
    if (self.m_isDisplayed) {
        [self loadData:self.m_data indexPath:self.m_tmpIndexPath];
    }
}

@end
