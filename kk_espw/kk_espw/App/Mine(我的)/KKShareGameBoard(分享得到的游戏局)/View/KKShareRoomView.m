//
//  KKShareRoomView.m
//  kk_espw
//
//  Created by 景天 on 2019/8/2.
//  Copyright © 2019年 david. All rights reserved.
//

#import "KKShareRoomView.h"
#import "KKHomeRoomListInfo.h"
#import "KKMessage.h"
#import "KKShareGameInfo.h"
#import "KKCalculateTextWidthOrHeight.h"
@interface KKShareRoomView ()
@property (nonatomic, strong) UIImageView *headerIconImageView;
@property (nonatomic, strong) UILabel *roomStatusLabel;
@property (nonatomic, strong) UIView *cycleView;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UIImageView *sexImageView;
@property (nonatomic, strong) UILabel *areaLabel; /// 区
@property (nonatomic, strong) UILabel *danGradingLabel; /// 段位
@property (nonatomic, strong) UILabel *duijuCountLabel;
@property (nonatomic, strong) UILabel *creditLabel; /// 靠谱
@property (nonatomic, strong) UIImageView *tagImageView; /// 标签
@property (nonatomic, strong) UILabel *roomIDLabel;
@property (nonatomic, strong) UILabel *descripitionLabel;
@property (nonatomic, strong) UIImageView *maleImageView;
@property (nonatomic, strong) UIImageView *femaleImageView;
@property (nonatomic, strong) UILabel *maleCountLabel;
@property (nonatomic, strong) UILabel *femaleCountLabel;
@property (nonatomic, strong) UILabel *scaleLabel;
@property (nonatomic, strong) UIImageView *roomStatusImg;
@property (nonatomic, strong) UIView *duijuV;
@property (nonatomic, strong) UIView *creditV; /// 靠谱
@property (nonatomic, strong) UIView *line0;
@property (nonatomic, strong) UILabel *isNeedPayL;
@property (nonatomic, strong) UIView *lineView;
@end

@implementation KKShareRoomView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        self.layer.shadowColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.07].CGColor;
        self.layer.shadowOffset = CGSizeMake(0,3);
        self.layer.shadowOpacity = 1;
        self.layer.shadowRadius = 15;
        self.layer.borderWidth = 0.5;
        self.layer.borderColor = [UIColor colorWithRed:242/255.0 green:242/255.0 blue:242/255.0 alpha:1.0].CGColor;
        self.layer.cornerRadius = 6;
        UIView *whiteBgV = New(UIView);
        whiteBgV.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
        whiteBgV.backgroundColor = [UIColor whiteColor];
        whiteBgV.layer.cornerRadius = RH(6);
        [self addSubview:whiteBgV];
        /// 头像
        _headerIconImageView = [[UIImageView alloc] initWithFrame:CGRectMake(RH(20), RH(18), RH(44), RH(44))];
        [_headerIconImageView addRoundedCorners:UIRectCornerTopLeft | UIRectCornerTopRight | UIRectCornerBottomLeft | UIRectCornerBottomRight withRadii:CGSizeMake(RH(22), RH(22))];
        [whiteBgV addSubview:_headerIconImageView];
        /// 组队中 home_cell_left_up_bg
        _roomStatusImg = [[UIImageView alloc] initWithFrame:CGRectMake([ccui getRH:21], [ccui getRH:18], [ccui getRH:42], [ccui getRH:18])];
        _roomStatusImg.image = Img(@"home_cell_left_up_bg");
        [whiteBgV addSubview:_roomStatusImg];
        /// 组队中
        _roomStatusLabel = [[UILabel alloc] initWithFrame:CGRectMake([ccui getRH:0], [ccui getRH:0], [ccui getRH:42], [ccui getRH:18])];
        _roomStatusLabel.font = [KKFont pingfangFontStyle:PFFontStyleMedium size:RH(9)];
        _roomStatusLabel.textAlignment = NSTextAlignmentCenter;
        [_roomStatusImg addSubview:_roomStatusLabel];
        /// 绿色的点点
        _cycleView = New(UIView);
        _cycleView.left = RH(3);
        _cycleView.top = RH(7);
        _cycleView.size = CGSizeMake(RH(4), RH(4));
        _cycleView.layer.cornerRadius = RH(2);
        [_roomStatusImg addSubview:_cycleView];
        /// 名字
        _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(_headerIconImageView.right + RH(12), [ccui getRH:18], [ccui getRH:71], [ccui getRH:21])];
        [whiteBgV addSubview:_nameLabel];
        _nameLabel.textColor = KKES_COLOR_BLACK_TEXT;
        _nameLabel.font = [KKFont pingfangFontStyle:PFFontStyleRegular size:RH(15)];
        /// 性别
        _sexImageView = New(UIImageView);
        _sexImageView.frame = CGRectMake(0, RH(24), RH(10), RH(10));
        [whiteBgV addSubview:_sexImageView];
        /// 大神
        _tagImageView = [[UIImageView alloc] initWithFrame:CGRectMake(_headerIconImageView.right + [ccui getRH:12], _nameLabel.bottom + [ccui getRH:8], [ccui getRH:42], [ccui getRH:14])];
        _tagImageView.layer.cornerRadius = 2;
        [whiteBgV addSubview:_tagImageView];
        /// 局数
        _duijuV = New(UIView);
        _duijuV.frame = CGRectMake(_tagImageView.right + RH(7), _tagImageView.top, [ccui getRH:39], [ccui getRH:14]);
        _duijuV.backgroundColor = [UIColor colorWithRed:255/255.0 green:197/255.0 blue:59/255.0 alpha:1.0];
        _duijuV.layer.cornerRadius = 2;
        _duijuV.clipsToBounds = YES;
        [whiteBgV addSubview:_duijuV];
        ///
        _duijuCountLabel = [[UILabel alloc] initWithFrame:CGRectMake(_tagImageView.right + RH(7), _tagImageView.top + RH(3), [ccui getRH:39], [ccui getRH:10])];
        _duijuCountLabel.textAlignment = NSTextAlignmentCenter;
        _duijuCountLabel.font = [KKFont kkFontStyle:KKFontStyleREEJIHonghuangLiMedium size:RH(9)];
        _duijuCountLabel.textColor = [UIColor whiteColor];
        [whiteBgV addSubview:_duijuCountLabel];
        /// 靠谱
        _creditV = New(UIView);
        _creditV.frame = CGRectMake(_duijuV.right + RH(7), _duijuV.top, [ccui getRH:39], [ccui getRH:14]);
        _creditV.backgroundColor = [UIColor colorWithRed:255/255.0 green:96/255.0 blue:96/255.0 alpha:1.0];
        _creditV.layer.cornerRadius = 2;
        _creditV.clipsToBounds = YES;
        [whiteBgV addSubview:_creditV];
        ///
        _creditLabel = [[UILabel alloc] initWithFrame:CGRectMake(_duijuV.right + [ccui getRH:7],_duijuV.top + RH(3), [ccui getRH:39], [ccui getRH:10])];
        _creditLabel.textAlignment = NSTextAlignmentCenter;
        _creditLabel.font = [KKFont kkFontStyle:KKFontStyleREEJIHonghuangLiMedium size:RH(9)];
        _creditLabel.textColor = [UIColor whiteColor];
        [whiteBgV addSubview:_creditLabel];
        /// 灰色横线
        UIView *lineV = New(UIView);
        lineV.top = _creditV.bottom + RH(17);
        lineV.left = RH(20);
        lineV.width = whiteBgV.width - RH(40);
        lineV.height = 0.5;
        lineV.backgroundColor = RGB(222, 222, 222);
        [whiteBgV addSubview:lineV];
        /// 描述
        _descripitionLabel = [[UILabel alloc] initWithFrame:CGRectMake(RH(20), [ccui getRH:13] + lineV.bottom, whiteBgV.width - RH(40), [ccui getRH:20])];
        _descripitionLabel.font = [KKFont pingfangFontStyle:PFFontStyleRegular size:RH(14)];
        _descripitionLabel.textColor = KKES_COLOR_BLACK_TEXT;
        _descripitionLabel.textAlignment = NSTextAlignmentLeft;
        [whiteBgV addSubview:_descripitionLabel];
        /// 是否支持付费
        _isNeedPayL = New(UILabel);
        _isNeedPayL.left = RH(20);
        _isNeedPayL.top = RH(6) + _descripitionLabel.bottom;
        _isNeedPayL.size = CGSizeMake(RH(23), 14);
        _isNeedPayL.font = [KKFont pingfangFontStyle:PFFontStyleRegular size:RH(10)];
        _isNeedPayL.textColor = rgba(255, 48, 88, 1);
        [whiteBgV addSubview:_isNeedPayL];
        /// 线
        _line0 = New(UIView);
        _line0.left = RH(8) + _isNeedPayL.right;
        _line0.top = RH(3);
        _line0.size = CGSizeMake(0.5, RH(8));
        _line0.backgroundColor = RGB(217, 217, 217);
        [whiteBgV addSubview:_line0];
        /// 底部LineView
        _lineView = New(UIView);
        _lineView.left = _line0.right + RH(8);
        _lineView.top = _isNeedPayL.top;
        _lineView.size = CGSizeMake(whiteBgV.width - _isNeedPayL.right, 14);
        [whiteBgV addSubview:_lineView];
        /// 房间Id
        _roomIDLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, [ccui getRH:35], [ccui getRH:14])];
        _roomIDLabel.font = [KKFont pingfangFontStyle:PFFontStyleRegular size:RH(10)];
        _roomIDLabel.textColor = KKES_COLOR_GRAY_TEXT;
        [_lineView addSubview:_roomIDLabel];
        /// 线1
        UIView *line1 = New(UIView);
        line1.left = _roomIDLabel.right;
        line1.top = RH(3);
        line1.size = CGSizeMake(0.5, RH(8));
        line1.backgroundColor = RGB(217, 217, 217);
        [_lineView addSubview:line1];
        /// 大区
        _areaLabel = New(UILabel);
        _areaLabel.left = line1.right + RH(8);
        _areaLabel.top = 0;
        _areaLabel.size = CGSizeMake(RH(23), RH(14));
        _areaLabel.font = [KKFont pingfangFontStyle:PFFontStyleRegular size:RH(10)];
        _areaLabel.textAlignment = NSTextAlignmentCenter;
        _areaLabel.textColor = KKES_COLOR_GRAY_TEXT;
        [_lineView addSubview:_areaLabel];
        ///
        UIView *line2 = New(UIView);
        line2.left = _areaLabel.right + RH(8);
        line2.top = RH(3);
        line2.size = CGSizeMake(0.5, RH(8));
        line2.backgroundColor = RGB(217, 217, 217);
        [_lineView addSubview:line2];
        /// 段位
        _danGradingLabel = New(UILabel);
        _danGradingLabel.left = RH(8) + line2.right;
        _danGradingLabel.top = 0;
        _danGradingLabel.size = CGSizeMake(RH(23), RH(14));
        _danGradingLabel.font = [KKFont pingfangFontStyle:PFFontStyleRegular size:RH(10)];
        _danGradingLabel.textColor = KKES_COLOR_GRAY_TEXT;
        _danGradingLabel.textAlignment = NSTextAlignmentCenter;
        [_lineView addSubview:_danGradingLabel];
        /// line3
        UIView *line3 = New(UIView);
        line3.left = _danGradingLabel.right + RH(8);
        line3.top = RH(3);
        line3.size = CGSizeMake(0.5, RH(8));
        line3.backgroundColor = RGB(217, 217, 217);
        [_lineView addSubview:line3];
        /// male
        _maleImageView = [[UIImageView alloc] initWithFrame:CGRectMake(line3.right + RH(6), RH(4), [ccui getRH:7], [ccui getRH:7])];
        [_lineView addSubview:_maleImageView];
        /// maleCount
        _maleCountLabel = [[UILabel alloc] initWithFrame:CGRectMake(_maleImageView.right, RH(3), [ccui getRH:7], [ccui getRH:9])];
        _maleCountLabel.font = [KKFont pingfangFontStyle:PFFontStyleRegular size:RH(10)];
        _maleCountLabel.textColor = KKES_COLOR_GRAY_TEXT;
        [_lineView addSubview:_maleCountLabel];
        /// female
        _femaleImageView = [[UIImageView alloc] initWithFrame:CGRectMake(_maleCountLabel.right + RH(8), RH(4), [ccui getRH:7], [ccui getRH:7])];
        [_lineView addSubview:_femaleImageView];
        /// femaleCount
        _femaleCountLabel = [[UILabel alloc] initWithFrame:CGRectMake(_femaleImageView.right, RH(3), [ccui getRH:7], [ccui getRH:9])];
        _femaleCountLabel.font = [KKFont pingfangFontStyle:PFFontStyleRegular size:RH(10)];
        _femaleCountLabel.textColor = KKES_COLOR_GRAY_TEXT;
        [_lineView addSubview:_femaleCountLabel];
        /// scale
        _scaleLabel = [[UILabel alloc] initWithFrame:CGRectMake(_femaleCountLabel.right + RH(6), RH(3), [ccui getRH:18], [ccui getRH:9])];
        _scaleLabel.font = [KKFont pingfangFontStyle:PFFontStyleRegular size:RH(10)];
        _scaleLabel.textColor = KKES_COLOR_GRAY_TEXT;
        [_lineView addSubview:_scaleLabel];
        _femaleImageView.image = Img(@"home_female");
        _maleImageView.image = Img(@"home_male");
    }
    return self;
}

- (void)setInfo:(KKHomeRoomListInfo *)info {
    /// 重新布局视图和样式
    _nameLabel.width = info.userNameWidth;
    _sexImageView.left = _nameLabel.right + RH(4);
    _duijuV.width = info.ownerGameBoardCountWidth;
    _duijuCountLabel.width = info.ownerGameBoardCountWidth;
    _creditV.left = _duijuCountLabel.right + RH(6);
    _creditV.width = info.reliableScoreWidth;
    _creditLabel.left = _duijuCountLabel.right + RH(6);
    _creditLabel.width = info.reliableScoreWidth;
    /* INIT => 待支付, RECRUIT => 招募中, PROCESSING => 比赛中, EVALUATE => 待评价, FINISH => 已完成, CANCEL => 关闭, FAIL_SOLD => 流局 */
    _roomStatusLabel.text = info.proceedStatus.message;
    if ([info.proceedStatus.name isEqualToString:@"RECRUIT"]) {
        _cycleView.backgroundColor = RGB(46, 255, 41);
        _roomStatusLabel.textColor = RGB(46, 255, 41);
    }else if ([info.proceedStatus.name isEqualToString:@"PROCESSING"]){
        _cycleView.backgroundColor = RGB(255, 101, 25);
        _roomStatusLabel.textColor = RGB(255, 101, 25);
    }else{
        _cycleView.backgroundColor = RGB(170, 170, 170);
        _roomStatusLabel.textColor = RGB(170, 170, 170);
    }
    
    /// 性别视图
    if ([info.sex.name isEqualToString:@"F"]) {
        _sexImageView.image = Img(@"home_female_pink");
    }else {
        _sexImageView.image = Img(@"home_male_blue");
    }
    /// 大神
    if (info.medalDetailList.count == 0) {
        /// 大神标签隐藏
        _tagImageView.hidden = YES;
        /// 调整对局, 靠谱left
        _duijuCountLabel.left = _headerIconImageView.right + [ccui getRH:12];
        _duijuV.left = _headerIconImageView.right + [ccui getRH:12];
        _creditLabel.left = _duijuCountLabel.right + RH(7);
        _creditV.left = _duijuCountLabel.right + RH(7);
    }else {
        _tagImageView.hidden = NO;
        /// 调整对局, 靠谱left
        _duijuCountLabel.left = _tagImageView.right + RH(7);
        _duijuV.left = _tagImageView.right + RH(7);
        _creditLabel.left = _duijuCountLabel.right + RH(7);
        _creditV.left = _duijuCountLabel.right + RH(7);
        KKUserMedelInfo *userMedalDetail = info.medalDetailList.firstObject;
        _tagImageView.image = Img([KKDataDealTool returnImageStr:userMedalDetail.currentMedalLevelConfigCode]);
    }
    
    /// 文字图片赋值
    _roomStatusLabel.text = [NSString stringWithFormat:@"  %@", info.proceedStatus.message];
    [_headerIconImageView sd_setImageWithURL:Url(info.userHeaderImgUrl)];
    _nameLabel.text = info.userName;
    _duijuCountLabel.text = info.ownerGameBoardCount;
    _creditLabel.text = info.reliableScore;
    _descripitionLabel.text = info.title;
    _roomIDLabel.text = [NSString stringWithFormat:@"ID%d", info.gameRoomId];
    _areaLabel.text = info.platFormType.message;
    _danGradingLabel.text = info.rank.message;
    /// 是否付费的显示
    if ([info.depositType.name isEqualToString:@"CHARGE_FOR_BOARD"]) {
        _isNeedPayL.text = @"付费 ";
        _isNeedPayL.hidden = NO;
        _line0.hidden = NO;
        _lineView.left = _isNeedPayL.right + RH(5);
    }else {
        _isNeedPayL.hidden = YES;
        _line0.hidden = YES;
        _lineView.left = RH(20);
    }
    
    _maleCountLabel.left = _maleImageView.right + RH(2);
    _femaleImageView.left = _maleCountLabel.right + RH(8);
    _femaleCountLabel.left = _femaleImageView.right + RH(2);
    _femaleCountLabel.text = info.female;
    _maleCountLabel.text = info.male;
    _scaleLabel.text = [NSString stringWithFormat:@"%@/%@", info.onlineCount, info.total];
    _scaleLabel.left = _femaleCountLabel.right + RH(8);
    
}
@end
