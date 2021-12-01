//
//  KKJTHeaderView.m
//  kk_espw
//
//  Created by jingtian9 on 2019/10/11.
//  Copyright © 2019 david. All rights reserved.
//

#import "KKJTHeaderView.h"
#import <CatPager.h>
#import "SDCycleScrollView.h"
#import "KKLiveStatusView.h"
#import "KKCalculateTextWidthOrHeight.h"

@interface KKJTHeaderView ()<CatPagerDelegate, SDCycleScrollViewDelegate>
@property (nonatomic, strong) CatPager *catPager;
@property (nonatomic, strong) SDCycleScrollView *cycleScrollView;
@property (nonatomic, strong) UILabel *rightMainTitleLabel;
@property (nonatomic, strong) UILabel *rightDetailLabel;
@property (nonatomic, strong) KKLiveStatusView *liveView;
@property (nonatomic, strong) UILabel *selectTitleL;
@property (nonatomic, strong) UIView *selectView;
@end

@implementation KKJTHeaderView
/// 初始化
- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self setupUI];
    }
    return self;
}
/// 滑动时调整指示器的位置
- (void)setSelectIndex:(NSInteger)selectIndex{
    _selectIndex = selectIndex;
    [self.catPager selectItemAtIndex:selectIndex animated:YES];
    /// 滑动的时候
    if (selectIndex == 1) {
        _selectView.hidden = YES;
    }else {
        _selectView.hidden = NO;
    }
    if (self.delegate && [self.delegate respondsToSelector:@selector(headerViewIndex:)]) {
        [self.delegate headerViewIndex:selectIndex];
    }
}
/// UI创建
- (void)setupUI{
    /// 分页器的容器
    UIView *contentV = [[UIView alloc] init];
    contentV.left = 0;
    contentV.width = SCREEN_WIDTH;
    contentV.top = self.height - 60;
    contentV.height = 54;
    [self addSubview:contentV];
    /// 分页器
    self.catPager = [[CatPager alloc] initOn:contentV theme:CatPagerThemeLineZoom itemArr:@[@"王者开黑", @"连麦语音"] selectedIndex:0];
    self.catPager.delegate = self;
    [self.catPager updateSelectedTextColor:KKES_COLOR_BLACK_TEXT selectedBackColor:[UIColor whiteColor] textColor:KKES_COLOR_BLACK_TEXT backColor:[UIColor whiteColor] bottomLineColor:KKES_COLOR_MAIN_YELLOW];
    [self.catPager updateCatPagerThemeLineSize:CGSizeMake(31, 4)];
    [self.catPager updateCatPagerThemeLineZoom:[KKFont pingfangFontStyle:PFFontStyleSemibold size:RH(17)]];
    /// 筛选视图的容器
    WS(weakSelf)
    _selectView = New(UIView);
    _selectView.frame = CGRectMake(SCREEN_WIDTH - RH(80) - RH(19), [ccui getRH:0], [ccui getRH:80], [ccui getRH:50]);
    [contentV addSubview:_selectView];
    [_selectView addTapWithTimeInterval:1 tapBlock:^(UIView * _Nonnull view) {
        [weakSelf tapSelectViewAction];
    }];
    /// 筛选Label
    _selectTitleL = New(UILabel);
    _selectTitleL.left = 0;
    _selectTitleL.top = 0;
    _selectTitleL.size = CGSizeMake(RH(60), RH(54));
    _selectTitleL.font = [KKFont pingfangFontStyle:PFFontStyleRegular size:RH(11)];
    _selectTitleL.textAlignment = NSTextAlignmentRight;
    _selectTitleL.textColor = KKES_COLOR_BLACK_TEXT;
    [_selectView addSubview:_selectTitleL];
    /// 向下的箭头
    UIImageView *dir = New(UIImageView);
    dir.left = _selectTitleL.right + RH(4);
    dir.top = RH(24.5);
    dir.size = CGSizeMake(RH(12), RH(7));
    dir.image = Img(@"home_dir_down1");
    [_selectView addSubview:dir];
    /// banner
    _cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake([ccui getRH:15], [ccui getRH:15], SCREEN_WIDTH - [ccui getRH:30], [ccui getRH:142]) delegate:self placeholderImage:nil];
    _cycleScrollView.backgroundColor = [UIColor whiteColor];
    _cycleScrollView.currentPageDotImage = [UIImage imageNamed:@"long_white_line"];
    _cycleScrollView.pageDotImage = [UIImage imageNamed:@"short_gray_line"];
    _cycleScrollView.clipsToBounds = YES;
    _cycleScrollView.autoScrollTimeInterval = 4;
    _cycleScrollView.layer.cornerRadius = 6;
    _cycleScrollView.pageControlRightOffset = [ccui getRH:-(_cycleScrollView.width / 2 - 60)];
    [self addSubview:_cycleScrollView];

    /// 左侧视图
    UIImageView *leftImageView = [[UIImageView alloc] initWithFrame:CGRectMake(_cycleScrollView.left, _cycleScrollView.bottom + [ccui getRH:12], (SCREEN_WIDTH - [ccui getRH:40]) / 2, [ccui getRH:70])];
    [self addSubview:leftImageView];
    leftImageView.clipsToBounds = YES;
    leftImageView.layer.cornerRadius = 6;
    leftImageView.image = Img(@"home_left_image_bg");
    [leftImageView addTapWithTimeInterval:0.1 tapBlock:^(UIView * _Nonnull view) {
        if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(didSelectedLeftView)]) {
            [weakSelf.delegate didSelectedLeftView];
        }
    }];
    /// 加一点阴影
//    leftImageView.layer.shadowColor = [UIColor lightGrayColor].CGColor;
//    leftImageView.layer.shadowOffset = CGSizeMake(0,2);
//    leftImageView.layer.shadowOpacity = 1;
//    leftImageView.layer.shadowRadius = 5;
//    leftImageView.clipsToBounds = NO;
    /// 文字表述
    UILabel *mainTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake([ccui getRH:15], [ccui getRH:11], [ccui getRH:100], [ccui getRH:22.5])];
    mainTitleLabel.font = [KKFont pingfangFontStyle:PFFontStyleSemibold size:RH(16)];
    mainTitleLabel.text = @"开黑排行榜";
    mainTitleLabel.textAlignment = NSTextAlignmentLeft;
    mainTitleLabel.textColor = [UIColor whiteColor];
    [leftImageView addSubview:mainTitleLabel];

    /// 副标题
    UILabel *detailLabel = [[UILabel alloc] init];
    detailLabel.frame = CGRectMake(mainTitleLabel.left, mainTitleLabel.bottom + RH(7), [ccui getRH:100], [ccui getRH:16.5]);
    detailLabel.numberOfLines = 0;
    [leftImageView addSubview:detailLabel];
    /// 文字
    NSMutableAttributedString *detailLabelString = [[NSMutableAttributedString alloc] initWithString:@"谁才是榜首" attributes:@{NSFontAttributeName: [UIFont fontWithName:@"PingFang-SC-Medium" size:12],NSForegroundColorAttributeName: [UIColor colorWithRed:248/255.0 green:248/255.0 blue:248/255.0 alpha:1.0]}];
    detailLabel.attributedText = detailLabelString;
    detailLabel.alpha = 0.9;

    /// 右侧视图
    UIImageView *rightImageView = [[UIImageView alloc] initWithFrame:CGRectMake(leftImageView.right + [ccui getRH:10], _cycleScrollView.bottom + [ccui getRH:12], (SCREEN_WIDTH - [ccui getRH:40]) / 2, [ccui getRH:70])];
    [self addSubview:rightImageView];
    rightImageView.clipsToBounds = YES;
    rightImageView.layer.cornerRadius = 6;
    rightImageView.image = Img(@"home_right_image_bg");
    [rightImageView addTapWithTimeInterval:0.1 tapBlock:^(UIView * _Nonnull view) {
        if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(didSelectedRightView)]) {
            [weakSelf.delegate didSelectedRightView];
        }
    }];
//    rightImageView.layer.shadowColor = [UIColor lightGrayColor].CGColor;
//    rightImageView.layer.shadowOffset = CGSizeMake(0,2);
//    rightImageView.layer.shadowOpacity = 1;
//    rightImageView.layer.shadowRadius = 5;
//    rightImageView.clipsToBounds = NO;
    /// 红色六边形
    _liveView = [[KKLiveStatusView alloc] initWithFrame:CGRectMake(RH(15), RH(39), RH(14), RH(15))];
    [rightImageView addSubview:_liveView];
    /// 文字表述
    _rightMainTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake([ccui getRH:15], [ccui getRH:11], [ccui getRH:104], [ccui getRH:22.5])];
    _rightMainTitleLabel.font = [KKFont pingfangFontStyle:PFFontStyleSemibold size:RH(15)];
    _rightMainTitleLabel.textColor = [UIColor whiteColor];
    [rightImageView addSubview:_rightMainTitleLabel];
    /// 副标题
    _rightDetailLabel = [[UILabel alloc] init];
    _rightDetailLabel.frame = CGRectMake(_liveView.right + RH(4), _rightMainTitleLabel.bottom + RH(7), [ccui getRH:60], [ccui getRH:16.5]);
    _rightDetailLabel.numberOfLines = 0;
    _rightDetailLabel.font = [KKFont pingfangFontStyle:PFFontStyleRegular size:RH(12)];
    _rightDetailLabel.textColor = [UIColor whiteColor];
    [rightImageView addSubview:_rightDetailLabel];
    
}

/// CatPagerDelegate
- (void)catPager:(CatPager*)catPager didSelectRowAtIndex:(NSInteger)index {
    /// 点击了语音连麦
    if (index == 0) {
        _selectView.hidden = NO;
    }else {
        _selectView.hidden = YES;
    }
    if (self.delegate && [self.delegate respondsToSelector:@selector(headerView:SelectionIndex:)]) {
        [self.delegate headerView:self SelectionIndex:index];
    }
}

- (void)setBanners:(NSMutableArray *)banners {
    _cycleScrollView.imageURLStringsGroup = banners;
}

#pragma mark - SDCycleScrollViewDelegate
/// 轮播图点击事件的回调
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index{
    if (self.delegate && [self.delegate respondsToSelector:@selector(didSelectedSDCycleScrollViewIndex:)]) {
        [self.delegate didSelectedSDCycleScrollViewIndex:index];
    }
}

- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didScrollToIndex:(NSInteger)index {
    
}

- (void)setStatus:(KKHomeRoomStatus *)status {
    /// 调整位置 直播间标题宽度
    _rightMainTitleLabel.width = [KKCalculateTextWidthOrHeight getWidthWithAttributedText:status.channelName font:[KKFont pingfangFontStyle:PFFontStyleSemibold size:RH(15)] height:RH(16)];
    /// 赋值
    _rightMainTitleLabel.text = status.channelName;
    if (status.inChannelUserCount.doubleValue > 10000000) {
        _rightDetailLabel.text = [NSString stringWithFormat:@"%@人在线", @"99999999"];
    }else {
        _rightDetailLabel.text = [NSString stringWithFormat:@"%@人在线", status.inChannelUserCount];
    }
    /// 调整在线人数L宽度
    _rightDetailLabel.width = [KKCalculateTextWidthOrHeight getWidthWithAttributedText:_rightDetailLabel.text font:[KKFont pingfangFontStyle:PFFontStyleRegular size:RH(12)] height:RH(12)];
    /// 休息或者活跃
    if ([status.channelStatus isEqualToString:@"BREAK"]) {
        [_liveView stopAnimate];
    }else {
        [_liveView startAnimate];
    }
}

- (void)setSelectViewTitle:(NSString *)selectViewTitle {
    _selectTitleL.text = selectViewTitle;
}

#pragma mark - Action
- (void)tapSelectViewAction {
    if (self.didTapSelectViewBlock) {
        self.didTapSelectViewBlock();
    }
}

@end
