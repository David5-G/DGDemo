//
//  KKHomeHeaderView.m
//  kk_espw
//
//  Created by 景天 on 2019/7/10.
//  Copyright © 2019年 david. All rights reserved.
//

#import "KKHomeHeaderView.h"
#import "SDCycleScrollView.h"
#import "KKHomeRoomStatus.h"
#import "KKCalculateTextWidthOrHeight.h"
#import "KKLiveStatusView.h"

@interface KKHomeHeaderView ()<SDCycleScrollViewDelegate>
@property (nonatomic, strong) UILabel *rightMainTitleLabel;
@property (nonatomic, strong) UILabel *rightDetailLabel;
@property (nonatomic, strong) UIImageView *offical;
@property (nonatomic, strong) KKLiveStatusView *liveView;
@property (nonatomic, strong) SDCycleScrollView *cycleScrollView;
@end

@implementation KKHomeHeaderView
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setUI];
    }
    return self;
}

- (void)setUI {
    self.backgroundColor = [UIColor clearColor];
    /// KK电竞
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(RH(18), RH(36), RH(100), RH(23))];
    titleLabel.text = @"KK电竞";
    titleLabel.font = [KKFont pingfangFontStyle:PFFontStyleSemibold size:RH(24)];
    titleLabel.textColor = [UIColor whiteColor];
    [self addSubview:titleLabel];
    
    /// 搜索
    CC_Button *searchButton = [CC_Button buttonWithType:UIButtonTypeCustom];
    [searchButton setImage:Img(@"home_search") forState:UIControlStateNormal];
    [searchButton addTarget:self action:@selector(searchButtonAction) forControlEvents:UIControlEventTouchUpInside];
    searchButton.frame = CGRectMake([ccui getRH:337], [ccui getRH:39], [ccui getRH:19], [ccui getRH:17]);
    [self addSubview:searchButton];
    
    /// banner
    _cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake([ccui getRH:15], [ccui getRH:74], SCREEN_WIDTH - [ccui getRH:30], [ccui getRH:142]) delegate:self placeholderImage:nil];
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
    WS(weakSelf)
    [leftImageView addTapWithTimeInterval:0.1 tapBlock:^(UIView * _Nonnull view) {
        if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(didSelectedLeftView)]) {
            [weakSelf.delegate didSelectedLeftView];
        }
    }];
    /// 文字表述
    UILabel *mainTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake([ccui getRH:15], [ccui getRH:18], [ccui getRH:100], [ccui getRH:16])];
    mainTitleLabel.font = [KKFont pingfangFontStyle:PFFontStyleSemibold size:RH(16)];
    mainTitleLabel.text = @"开黑排行榜";
    mainTitleLabel.textAlignment = NSTextAlignmentLeft;
    mainTitleLabel.textColor = [UIColor whiteColor];
    [leftImageView addSubview:mainTitleLabel];
    
    /// 副标题
    UILabel *detailLabel = [[UILabel alloc] init];
    detailLabel.frame = CGRectMake(mainTitleLabel.left, mainTitleLabel.bottom + 8, [ccui getRH:100], [ccui getRH:12]);
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
    /// 文字表述
    _rightMainTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake([ccui getRH:15], [ccui getRH:18], [ccui getRH:104], [ccui getRH:16])];
    _rightMainTitleLabel.font = [KKFont pingfangFontStyle:PFFontStyleSemibold size:RH(15)];
    _rightMainTitleLabel.textColor = [UIColor whiteColor];
    [rightImageView addSubview:_rightMainTitleLabel];
    /// 官方
    _offical = New(UIImageView);
    _offical.image = Img(@"home_official");
    _offical.left = _rightMainTitleLabel.right + RH(5);
    _offical.top = RH(21);
    _offical.size = CGSizeMake(RH(22), RH(11));
    [rightImageView addSubview:_offical];
    /// 副标题
    _rightDetailLabel = [[UILabel alloc] init];
    _rightDetailLabel.frame = CGRectMake(_rightMainTitleLabel.left, _rightMainTitleLabel.bottom + 8, [ccui getRH:60], [ccui getRH:12]);
    _rightDetailLabel.numberOfLines = 0;
    _rightDetailLabel.font = [KKFont pingfangFontStyle:PFFontStyleRegular size:RH(12)];
    _rightDetailLabel.textColor = KKES_COLOR_MAIN_YELLOW;
    [rightImageView addSubview:_rightDetailLabel];
    /// 红色六边形
    _liveView = [[KKLiveStatusView alloc] initWithFrame:CGRectMake(_rightDetailLabel.right + RH(5), RH(39), RH(16), RH(16))];
    [rightImageView addSubview:_liveView];
    /// 线
    UIView *bottomLine = [[UIView alloc] initWithFrame:CGRectMake(0, rightImageView.bottom + [ccui getRH:12], SCREEN_WIDTH, [ccui getRH:12])];
    bottomLine.backgroundColor = RGB(246, 247, 248);
    [self addSubview:bottomLine];
}

- (void)setImagesURLStrings:(NSMutableArray *)imagesURLStrings {
    _cycleScrollView.imageURLStringsGroup = imagesURLStrings;
}

- (void)scanButtonAction {
    if (self.delegate && [self.delegate respondsToSelector:@selector(didSelectedScanButton)]) {
        [self.delegate didSelectedScanButton];
    }
}

- (void)searchButtonAction {
    if (self.delegate && [self.delegate respondsToSelector:@selector(didSelectedSearchButton)]) {
        [self.delegate didSelectedSearchButton];
    }
}

#pragma mark - SDCycleScrollViewDelegate
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index{
    if (self.delegate && [self.delegate respondsToSelector:@selector(didSelectedSDCycleScrollViewIndex:)]) {
        [self.delegate didSelectedSDCycleScrollViewIndex:index];
    }
}

- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didScrollToIndex:(NSInteger)index {
    
}

- (void)setStatus:(KKHomeRoomStatus *)status {
    /// 调整位置 直播间标题宽度
    _rightMainTitleLabel.width = [KKCalculateTextWidthOrHeight getWidthWithAttributedText:status.channelName font:[KKFont pingfangFontStyle:PFFontStyleSemibold size:15] height:RH(16)];
    /// x
    _offical.left = _rightMainTitleLabel.right + RH(5);
    /// 赋值
    _rightMainTitleLabel.text = status.channelName;
    if (status.inChannelUserCount.doubleValue > 10000000) {
        _rightDetailLabel.text = [NSString stringWithFormat:@"%@人在线", @"99999999"];
    }else {
        _rightDetailLabel.text = [NSString stringWithFormat:@"%@人在线", status.inChannelUserCount];
    }
    /// 调整在线人数L宽度
    _rightDetailLabel.width = [KKCalculateTextWidthOrHeight getWidthWithAttributedText:_rightDetailLabel.text font:[KKFont pingfangFontStyle:PFFontStyleRegular size:RH(12)] height:RH(12)];
    /// x
    _liveView.left = _rightDetailLabel.right + RH(5);
    if ([status.channelStatus isEqualToString:@"BREAK"]) {
        [_liveView stopAnimate];
    }else {
        [_liveView startAnimate];
    }
}
@end
