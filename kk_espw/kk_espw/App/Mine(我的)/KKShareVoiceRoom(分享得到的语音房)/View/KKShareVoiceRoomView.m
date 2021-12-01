//
//  KKShareVoiceRoomView.m
//  kk_espw
//
//  Created by jingtian9 on 2019/10/17.
//  Copyright © 2019 david. All rights reserved.
//

#import "KKShareVoiceRoomView.h"
#import "KKHomeVoiceRoomModel.h"
#import "KKMessage.h"
@interface KKShareVoiceRoomView ()
@property (nonatomic, strong) UIImageView *headerIconImageView; /// 头像
@property (nonatomic, strong) UILabel *nameLabel; /// 房主
@property (nonatomic, strong) UILabel *titleL; /// 标题
@property (nonatomic, strong) UIImageView *sexImageView; /// 性别
@property (nonatomic, strong) UIImageView *tagImageView; /// 大神
@property (nonatomic, strong) UILabel *roomIDLabel; /// 房间Id
@property (nonatomic, strong) UIImageView *maleImageView;
@property (nonatomic, strong) UIImageView *femaleImageView;
@property (nonatomic, strong) UILabel *maleCountLabel;
@property (nonatomic, strong) UILabel *femaleCountLabel;
@property (nonatomic, strong) UILabel *scaleLabel;
@end

@implementation KKShareVoiceRoomView

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
        //1.标题
        _titleL = New(UILabel);
        _titleL.left = RH(20);
        _titleL.top = RH(16);
        _titleL.size = CGSizeMake(whiteBgV.width - RH(40), RH(21));
        _titleL.font = [KKFont pingfangFontStyle:PFFontStyleSemibold size:RH(15)];
        _titleL.textColor = KKES_COLOR_BLACK_TEXT;
        [whiteBgV addSubview:_titleL];
        //2.ID
        _roomIDLabel = [[UILabel alloc] initWithFrame:CGRectMake(RH(20), RH(8) + _titleL.bottom, RH(30), RH(15))];
        _roomIDLabel.font = [KKFont pingfangFontStyle:PFFontStyleSemibold size:RH(10)];
        _roomIDLabel.textColor = KKES_COLOR_GRAY_TEXT;
        [whiteBgV addSubview:_roomIDLabel];
        //3.男
        _maleImageView = [[UIImageView alloc] initWithFrame:CGRectMake(_roomIDLabel.right + RH(15), _titleL.bottom + RH(11), [ccui getRH:8], [ccui getRH:8])];
        [whiteBgV addSubview:_maleImageView];
        //4.男生人数
        _maleCountLabel = [[UILabel alloc] initWithFrame:CGRectMake(_maleImageView.right + RH(3), _titleL.bottom + RH(9), [ccui getRH:7], [ccui getRH:14])];
        _maleCountLabel.font = [KKFont pingfangFontStyle:PFFontStyleSemibold size:RH(10)];
        _maleCountLabel.textColor = KKES_COLOR_GRAY_TEXT;
        [whiteBgV addSubview:_maleCountLabel];
        //5.女
        _femaleImageView = [[UIImageView alloc] initWithFrame:CGRectMake(_maleCountLabel.right + RH(11), _maleImageView.top, [ccui getRH:8], [ccui getRH:8])];
        [whiteBgV addSubview:_femaleImageView];
        //6.女生人数
        _femaleCountLabel = [[UILabel alloc] initWithFrame:CGRectMake(_femaleImageView.right + RH(3), _maleCountLabel.top, [ccui getRH:7], [ccui getRH:14])];
        _femaleCountLabel.font = [KKFont pingfangFontStyle:PFFontStyleSemibold size:RH(10)];
        _femaleCountLabel.textColor = KKES_COLOR_GRAY_TEXT;
        [whiteBgV addSubview:_femaleCountLabel];
        //6.1 scale
        _scaleLabel = [[UILabel alloc] initWithFrame:CGRectMake(_femaleCountLabel.right + RH(11), _maleCountLabel.top, [ccui getRH:18], [ccui getRH:14])];
        _scaleLabel.font = [KKFont pingfangFontStyle:PFFontStyleSemibold size:RH(10)];
        _scaleLabel.textColor = KKES_COLOR_GRAY_TEXT;
        [whiteBgV addSubview:_scaleLabel];
        
        _femaleImageView.image = Img(@"home_female");
        _maleImageView.image = Img(@"home_male");
        //7.灰色横线
        UIView *lineV = New(UIView);
        lineV.top = _roomIDLabel.bottom + RH(12);
        lineV.left = RH(20);
        lineV.width = whiteBgV.width - RH(40);
        lineV.height = 0.5;
        lineV.backgroundColor = RGB(222, 222, 222);
        [whiteBgV addSubview:lineV];
        //8.头像
        _headerIconImageView = [[UIImageView alloc] initWithFrame:CGRectMake(RH(20), RH(12) + lineV.bottom, RH(25), RH(25))];
        [_headerIconImageView addRoundedCorners:UIRectCornerTopLeft | UIRectCornerTopRight | UIRectCornerBottomLeft | UIRectCornerBottomRight withRadii:CGSizeMake(RH(12.5), RH(12.5))];
        [whiteBgV addSubview:_headerIconImageView];
        //9.名字
        _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(_headerIconImageView.right + RH(7), [ccui getRH:17] + lineV.bottom, [ccui getRH:71], [ccui getRH:21])];
        [whiteBgV addSubview:_nameLabel];
        _nameLabel.textColor = KKES_COLOR_GRAY_TEXT;
        _nameLabel.font = [KKFont pingfangFontStyle:PFFontStyleRegular size:RH(11)];
        //10.性别
        _sexImageView = New(UIImageView);
        _sexImageView.frame = CGRectMake(_nameLabel.right, RH(23) + lineV.bottom, RH(10), RH(10));
        [whiteBgV addSubview:_sexImageView];
        //11.大神
        _tagImageView = [[UIImageView alloc] initWithFrame:CGRectMake(_sexImageView.right + [ccui getRH:12], lineV.bottom + [ccui getRH:20], [ccui getRH:44], [ccui getRH:14])];
        _tagImageView.layer.cornerRadius = 2;
        [whiteBgV addSubview:_tagImageView];
    }
    return self;
}

- (void)setModel:(KKHomeVoiceRoomModel *)model {
   //1.调整宽度
    _nameLabel.width = model.userNameWidth;
    _sexImageView.left = _nameLabel.right + RH(5);
    _tagImageView.left = _sexImageView.right + RH(5);
    //2.赋值
    _titleL.text = model.chatRoomTitle;
    _roomIDLabel.text = [NSString stringWithFormat:@"ID%@", model.ID];
    _maleCountLabel.text = model.male;
    _femaleCountLabel.text = model.female;
    _scaleLabel.text = [NSString stringWithFormat:@"%@/%@", model.total, @"6"];
    [_headerIconImageView sd_setImageWithURL:Url(model.ownerUserLogoUrl)];
    _nameLabel.text = model.nickName;
    //3.性别视图
    if ([model.ownerUserSex.name isEqualToString:@"F"]) {
        _sexImageView.image = Img(@"home_female_pink");
    }else {
        _sexImageView.image = Img(@"home_male_blue");
    }
    //4.大神
    KKUserMedelInfo *userMedalDetail = model.medalDetailList.firstObject;
    _tagImageView.image = Img([KKDataDealTool returnImageStr:userMedalDetail.currentMedalLevelConfigCode]);
}
@end
