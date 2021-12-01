//
//  KKStartLiveStreamViewController.m
//  kk_espw
//
//  Created by 景天 on 2019/7/17.
//  Copyright © 2019年 david. All rights reserved.
//

#import "KKStartLiveStreamViewController.h"
#import "KKLiveStreamService.h"
#import "KKLiveStatusView.h"
#import "KKCalculateTextWidthOrHeight.h"
#import "KKHomeRoomStatus.h"
@interface KKStartLiveStreamViewController ()
@property (nonatomic, strong) UILabel *rightMainTitleLabel;
@property (nonatomic, strong) UILabel *rightDetailLabel;
@property (nonatomic, strong) UIImageView *offical;
@property (nonatomic, strong) KKLiveStatusView *liveView;
@end

@implementation KKStartLiveStreamViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setNavUI];
    [self setUI];
    
    [self requestAnchorPresidChannelData];
}

#pragma mark - UI
- (void)setUI {
    /// 1. 顶部视图
    UIImageView *topImageView = [[UIImageView alloc] initWithFrame:CGRectMake(RH(15), RH(21) + STATUSBAR_ADD_NAVIGATIONBARHEIGHT, (SCREEN_WIDTH - [ccui getRH:30]), [ccui getRH:90])];
    [self.view addSubview:topImageView];
    topImageView.clipsToBounds = YES;
    topImageView.layer.cornerRadius = 6;
    topImageView.image = Img(@"home_right_image_bg");
    [topImageView addTapWithTimeInterval:0.1 tapBlock:^(UIView * _Nonnull view) {
        
    }];
    
    /// 文字表述
    _rightMainTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake([ccui getRH:15], [ccui getRH:18], [ccui getRH:140], [ccui getRH:16])];
    _rightMainTitleLabel.font = [UIFont fontWithName:@"PingFang-SC-Bold" size:16];
    _rightMainTitleLabel.text = @"王者荣耀招募厅";
    _rightMainTitleLabel.textColor = [UIColor whiteColor];
    [topImageView addSubview:_rightMainTitleLabel];
    
    /// 官方
    _offical = New(UIImageView);
    _offical.image = Img(@"home_official");
    _offical.left = _rightMainTitleLabel.right + RH(5);
    _offical.top = RH(21);
    _offical.size = CGSizeMake(RH(22), RH(11));
    [topImageView addSubview:_offical];
    
    /// 副标题
    _rightDetailLabel = [[UILabel alloc] init];
    _rightDetailLabel.frame = CGRectMake(_rightMainTitleLabel.left, _rightMainTitleLabel.bottom + 8, [ccui getRH:60], [ccui getRH:12]);
    _rightDetailLabel.numberOfLines = 0;
    [topImageView addSubview:_rightDetailLabel];
    _rightDetailLabel.font = [KKFont pingfangFontStyle:PFFontStyleRegular size:12];
    _rightDetailLabel.textColor = KKES_COLOR_MAIN_YELLOW;
    
    /// 红色六边形
    _liveView = [[KKLiveStatusView alloc] initWithFrame:CGRectMake(_rightDetailLabel.right + RH(5), _rightDetailLabel.top, RH(16), RH(16))];
    [topImageView addSubview:_liveView];
    
    /// 描述
    UILabel *desLabel = [[UILabel alloc] init];
    desLabel.frame = CGRectMake(0, topImageView.bottom + 10, SCREEN_WIDTH, [ccui getRH:12]);
    desLabel.textAlignment = NSTextAlignmentCenter;
    desLabel.textColor = KKES_COLOR_DARK_GRAY_TEXT;
    desLabel.font = RF(12);
    desLabel.text = @"主持人进入王者荣耀招募厅，可以自由选择直播的时间段";
    [self.view addSubview:desLabel];
    
    CC_Button *startButton = [CC_Button buttonWithType:UIButtonTypeCustom];
    startButton.top = RH(74) + desLabel.bottom;
    startButton.left = RH(21);
    startButton.size = CGSizeMake(SCREEN_WIDTH - RH(42), RH(45));
    [startButton setTitle:@"语音直播" forState:UIControlStateNormal];
    startButton.backgroundColor = KKES_COLOR_MAIN_YELLOW;
    startButton.layer.cornerRadius = RH(4);
    [startButton addTapWithTimeInterval:0.2 tapBlock:^(UIView * _Nonnull view) {
        
    }];
    [self.view addSubview:startButton];
    
    UILabel *agreementDes = [[UILabel alloc] init];
    agreementDes.frame = CGRectMake(0, RH(12) + startButton.bottom, SCREEN_WIDTH, [ccui getRH:12]);
    agreementDes.font = RF(12);
    agreementDes.textAlignment = NSTextAlignmentCenter;
    agreementDes.textColor = KKES_COLOR_DARK_GRAY_TEXT;
    [self.view addSubview:agreementDes];

    NSString *sumStr = @"开播默认同意遵守《KK电竞语音直播管理条例》";
    NSString *lineStr = @"《KK电竞语音直播管理条例》";
    NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc] initWithString:sumStr];
    [attStr addAttribute:NSForegroundColorAttributeName value:KKES_COLOR_DARK_GRAY_TEXT range:[sumStr rangeOfString:lineStr]];
    [attStr addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:[sumStr rangeOfString:lineStr]];
    agreementDes.attributedText = attStr;
}

- (void)setNavUI {
    [self setNaviBarWithType:DGNavigationBarTypeWhite];
    [self setNaviBarTitle:@"主持主播"];
}

#pragma mark - Net
- (void)requestAnchorPresidChannelData {
    WS(weakSelf)
    [KKLiveStreamService requestAnchorPresidChannelDataSuccess:^(NSMutableArray * _Nonnull dataList) {
        [weakSelf setDataWithLiveView:dataList.firstObject];
    } Fail:^{
        
    }];
}

#pragma mark - 数据赋值
- (void)setDataWithLiveView:(KKHomeRoomStatus *)status {
    /// 调整位置 直播间标题宽度
    _rightMainTitleLabel.width = [KKCalculateTextWidthOrHeight getWidthWithAttributedText:status.channelName font:[KKFont pingfangFontStyle:PFFontStyleSemibold size:17] height:RH(16)];
    /// x
    _offical.left = _rightMainTitleLabel.right + RH(5);
    /// 赋值
    _rightMainTitleLabel.text = status.channelName;
    _rightDetailLabel.text = [NSString stringWithFormat:@"%@人在线", status.inChannelUserCount];
    /// 调整在线人数L宽度
    _rightDetailLabel.width = [KKCalculateTextWidthOrHeight getWidthWithAttributedText:_rightDetailLabel.text font:[KKFont pingfangFontStyle:PFFontStyleRegular size:12] height:RH(12)];
    /// x
    _liveView.left = _rightDetailLabel.right + RH(5);
    if ([status.channelStatus isEqualToString:@"BREAK"]) {
        [_liveView startAnimate];
    }else {
        [_liveView startAnimate];
    }
}

- (void)dealloc {
    [KKLiveStreamService destroyInstance];
}
@end
