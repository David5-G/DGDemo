//
//  KKVoiceRoomListCell.m
//  kk_espw
//
//  Created by jingtian9 on 2019/10/15.
//  Copyright © 2019 david. All rights reserved.
//

#import "KKVoiceRoomListCell.h"
#import "KKHomeVoiceRoomModel.h"
#import "KKMessage.h"
@interface KKVoiceRoomListCell ()
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

@implementation KKVoiceRoomListCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.contentView.backgroundColor = [UIColor clearColor];
        self.backgroundColor = [UIColor clearColor];
        UIView *whiteBgV = New(UIView);
        whiteBgV.frame = CGRectMake(RH(10), RH(10), SCREEN_WIDTH - RH(10) * 2, RH(118));
        whiteBgV.backgroundColor = [UIColor whiteColor];
        whiteBgV.layer.cornerRadius = RH(6);
        [self.contentView addSubview:whiteBgV];
        /// 是否是搜索
        _isSearch = NO;
        /// 点击没有阴影效果
        self.selectionStyle = UITableViewCellSelectionStyleNone;
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
        /// 2.1
        UIView *line1 = New(UIView);
        line1.left = _roomIDLabel.right;
        line1.top = RH(10) + _titleL.bottom;
        line1.size = CGSizeMake(0.5, RH(8));
        line1.backgroundColor = RGB(217, 217, 217);
        [whiteBgV addSubview:line1];
        //3.男
        _maleImageView = [[UIImageView alloc] initWithFrame:CGRectMake(_roomIDLabel.right + RH(15), _titleL.bottom + RH(11), [ccui getRH:8], [ccui getRH:8])];
        [whiteBgV addSubview:_maleImageView];
        //4.男生人数
        _maleCountLabel = [[UILabel alloc] initWithFrame:CGRectMake(_maleImageView.right + RH(3), _titleL.bottom + RH(8), [ccui getRH:7], [ccui getRH:14])];
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
        _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(_headerIconImageView.right + RH(7),RH(12) + lineV.bottom, [ccui getRH:71], [ccui getRH:25])];
        [whiteBgV addSubview:_nameLabel];
        _nameLabel.textColor = KKES_COLOR_GRAY_TEXT;
        _nameLabel.font = [KKFont pingfangFontStyle:PFFontStyleRegular size:RH(11)];
        //10.性别
        _sexImageView = New(UIImageView);
        _sexImageView.frame = CGRectMake(_nameLabel.right, RH(19.5) + lineV.bottom, RH(10), RH(10));
        [whiteBgV addSubview:_sexImageView];
        //11.大神
        _tagImageView = [[UIImageView alloc] initWithFrame:CGRectMake(_sexImageView.right + [ccui getRH:5], lineV.bottom + [ccui getRH:17], [ccui getRH:44], [ccui getRH:14])];
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
    _roomIDLabel.text = [NSString stringWithFormat:@"ID:%@", model.ID];
    _maleCountLabel.text = model.male;
    _femaleCountLabel.text = model.female;
    _scaleLabel.text = [NSString stringWithFormat:@"%@/%@", model.total, @"6"];
    [_headerIconImageView sd_setImageWithURL:Url(model.ownerUserLogoUrl)];
    _nameLabel.text = model.nickName;
    //3.性别视图
    if ([model.ownerUserSex.name isEqualToString:@"F"]) {
        _sexImageView.image = Img(@"home_female_pink");
        _sexImageView.size = CGSizeMake(RH(10), RH(10));
    }else {
        _sexImageView.image = Img(@"home_male_blue");
        _sexImageView.size = CGSizeMake(RH(10), RH(10));
    }
    //4.大神
    KKUserMedelInfo *userMedalDetail = model.medalDetailList.firstObject;
    _tagImageView.image = Img([KKDataDealTool returnImageStr:userMedalDetail.currentMedalLevelConfigCode]);
}
@end
