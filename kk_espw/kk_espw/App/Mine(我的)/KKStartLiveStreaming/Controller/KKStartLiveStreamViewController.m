//
//  KKStartLiveStreamViewController.m
//  kk_espw
//
//  Created by 景天 on 2019/7/17.
//  Copyright © 2019年 david. All rights reserved.
//

#import "KKStartLiveStreamViewController.h"

@implementation KKStartLiveStreamViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setNavUI];
    [self setUI];
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
    UILabel *rightMainTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake([ccui getRH:15], [ccui getRH:18], [ccui getRH:140], [ccui getRH:16])];
    rightMainTitleLabel.font = [UIFont fontWithName:@"PingFang-SC-Bold" size:16];
    rightMainTitleLabel.text = @"王者荣耀招募厅";
    rightMainTitleLabel.textColor = [UIColor whiteColor];
    [topImageView addSubview:rightMainTitleLabel];
    
    /// 副标题
    UILabel *rightDetailLabel = [[UILabel alloc] init];
    rightDetailLabel.frame = CGRectMake(rightMainTitleLabel.left, rightMainTitleLabel.bottom + 8, [ccui getRH:60], [ccui getRH:12]);
    rightDetailLabel.numberOfLines = 0;
    [topImageView addSubview:rightDetailLabel];
    NSMutableAttributedString *rightDetailLabelString = [[NSMutableAttributedString alloc] initWithString:@"2102人在线" attributes:@{NSFontAttributeName: [UIFont fontWithName:@"PingFang-SC-Medium" size: 12],NSForegroundColorAttributeName: RGB(248, 215, 87)}];
    rightDetailLabel.attributedText = rightDetailLabelString;
    rightDetailLabel.alpha = 0.9;
    
    /// 副标题
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
    agreementDes.frame = CGRectMake(RH(62), RH(12) + startButton.bottom, SCREEN_WIDTH - RH(124), [ccui getRH:12]);
    agreementDes.font = RF(12);
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
@end
