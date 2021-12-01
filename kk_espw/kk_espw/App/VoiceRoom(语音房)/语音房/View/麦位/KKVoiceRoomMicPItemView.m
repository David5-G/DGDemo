//
//  KKVoiceRoomMicPItemView.m
//  kk_espw
//
//  Created by david on 2019/10/16.
//  Copyright © 2019 david. All rights reserved.
//

#import "KKVoiceRoomMicPItemView.h"

@interface KKVoiceRoomMicPItemView ()
@property (nonatomic, strong) UIView *headerView;
@property (nonatomic, strong) UIImageView *portraitImageView;
@property (nonatomic, strong) UIImageView *hostTagImageView;
@property (nonatomic, strong) UIImageView *sexImageView;
@property (nonatomic, strong) UIImageView *gifImageView;
@property (nonatomic, strong) UILabel *nameLabel;
@end

@implementation KKVoiceRoomMicPItemView

#pragma mark - life circle
-(instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
    }
    return self;
}

-(void)dealloc {
}


#pragma mark - UI
-(void)setupUI {
    WS(weakSelf)
    CGFloat headerW = [ccui getRH:80];
    CGFloat portraitW = [ccui getRH:53];
    CGFloat hostTagW = [ccui getRH:15];
    CGFloat sexW = [ccui getRH:14];
    CGFloat sexHostOffset = [ccui getRH:2.6];
    
    //1.头像
    UIView *headerV = [[UIView alloc]init];
    self.headerView = headerV;
    [self addSubview:headerV];
    [headerV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.centerX.mas_equalTo(0);
        make.width.height.mas_equalTo(headerW);
    }];
    [headerV addTapWithTimeInterval:0.5 tapBlock:^(UIView * _Nonnull view) {
        SS(strongSelf)
        if (strongSelf.tapPortraitBlock) {
            strongSelf.tapPortraitBlock(strongSelf);
        }
    }];
    
    //2.gif
    UIImageView *gifImgV = [self createGifImageView];
    self.gifImageView = gifImgV;
    [headerV addSubview:gifImgV];
    [gifImgV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.right.mas_equalTo(0);
    }];
    
    //3.portrait
    UIImageView *portraitImgV = [[UIImageView alloc]initWithImage: [UIImage imageNamed:@"voice_micP_absent"]];
    portraitImgV.layer.cornerRadius = portraitW/2.0;
    portraitImgV.layer.masksToBounds = YES;
    portraitImgV.layer.borderColor = UIColor.whiteColor.CGColor;
    portraitImgV.layer.borderWidth = 0;
    self.portraitImageView = portraitImgV;
    [headerV addSubview:portraitImgV];
    [portraitImgV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(0);
        make.width.height.mas_equalTo(portraitW);
    }];
    
    //4.hostTag
    UIImageView *hostTagImgV =  [[UIImageView alloc]initWithImage: [UIImage imageNamed:@"voice_micP_host"]];
    hostTagImgV.hidden = YES;
    self.hostTagImageView = hostTagImgV;
    [headerV addSubview:hostTagImgV];
    [hostTagImgV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(portraitImgV.mas_left).mas_offset(sexHostOffset);
        make.top.mas_equalTo(portraitImgV.mas_top).mas_offset(sexHostOffset);
        make.width.height.mas_equalTo(hostTagW);
    }];
    
    //5.sex
    UIImageView *sexImgV =  [[UIImageView alloc]initWithImage: [UIImage imageNamed:@"voice_micP_male"]];
    sexImgV.hidden = YES;
    self.sexImageView = sexImgV;
    [headerV addSubview:sexImgV];
    [sexImgV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(portraitImgV.mas_right).mas_offset(-sexHostOffset);
        make.bottom.mas_equalTo(portraitImgV.mas_bottom).mas_offset(-sexHostOffset);
        make.width.height.mas_equalTo(sexW);
    }];
    
    //6.name
    DGLabel *nameL = [DGLabel labelWithText:@"等待入座" fontSize:[ccui getRH:13] color:rgba(135, 126, 113, 1)];
    nameL.textAlignment = NSTextAlignmentCenter;
    self.nameLabel = nameL;
    [self addSubview:nameL];
    [nameL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(headerV.mas_bottom).mas_offset(-[ccui getRH:1]);
        make.left.right.mas_equalTo(0);
    }];
}


#pragma mark tool
-(UIImageView *)createGifImageView {
    //1.准备图片
    NSMutableArray *imgArr = [NSMutableArray arrayWithCapacity:4];
    for (NSInteger i=1; i<5; i++) {
        NSString *imgStr = [NSString stringWithFormat:@"voice_gif_voice_%02ld",(long)i];
        [imgArr addObject:Img(imgStr)];
    }
    
    //2.创建imgV
    UIImageView *imgV = [[UIImageView alloc]initWithImage:imgArr.firstObject];
    imgV.animationImages = imgArr;
    imgV.animationDuration = 0.2*imgArr.count;
    imgV.animationRepeatCount = 0;
    imgV.hidden = YES;
    //3.
    return imgV;
}

-(void)setDefaultName:(NSString *)name {
    self.nameLabel.text = name;
    self.nameLabel.font = [KKFont pingfangFontStyle:PFFontStyleRegular size:[ccui getRH:13]];
    self.nameLabel.textColor = rgba(255, 255, 255, 0.7);
}

#pragma mark - setter
-(void)setName:(NSString *)name {
    _name = [name copy];
    
    self.nameLabel.text = name;
    self.nameLabel.font = [KKFont pingfangFontStyle:PFFontStyleSemibold size:[ccui getRH:13]];
    self.nameLabel.textColor = UIColor.whiteColor;
}

-(void)setPortraitUrlStr:(NSString *)portraitUrlStr {
     //1.过滤
    if (self.status == KKVoiceRoomMicPStatusClose) {
        return;
    }
    
    //2.赋值
    _portraitUrlStr = [portraitUrlStr copy];
    
    //3.改变状态
    if (portraitUrlStr.length > 0) {
        [self.portraitImageView sd_setImageWithURL:[NSURL URLWithString:portraitUrlStr]];
    }
    
    //4.描边情况
    self.portraitImageView.layer.borderWidth = portraitUrlStr.length > 0 ? 1.0 : 0;
}


-(void)setStatus:(KKVoiceRoomMicPStatus)status {
    _status = status;
    
    switch (status) {
        case KKVoiceRoomMicPStatusPresent:
            self.portraitImageView.image = nil;
            self.name = @"";
            break;
        case KKVoiceRoomMicPStatusAbsent:
            self.portraitImageView.image = [UIImage imageNamed:@"voice_micP_absent"];
            [self setDefaultName:@"等待入座"];
            break;
        case KKVoiceRoomMicPStatusClose:
            self.portraitImageView.image = [UIImage imageNamed:@"voice_micP_close"];
            [self setDefaultName:@""];
            break;
        default:
            break;
    }
    //2.只要改变status, 就清空状态
    self.userId = @"";
    self.portraitUrlStr = @"";
    self.isSpeaking = NO;
    self.isHost = NO;
    self.sexType = KKVoiceRoomMicPSexTypeUnknown;
}


-(void)setSexType:(KKVoiceRoomMicPSexType)sexType {
    _sexType = sexType;
    
    //先显示
    self.sexImageView.hidden = NO;
    
    //根据枚举显示
    switch (sexType) {
        case KKVoiceRoomMicPSexTypeUnknown:
            self.sexImageView.hidden = YES;//未知性别隐藏图标
            break;
        case KKVoiceRoomMicPSexTypeMale:
            self.sexImageView.image = [UIImage imageNamed:@"voice_micP_male"];
            break;
        case KKVoiceRoomMicPSexTypeFemale:
            self.sexImageView.image = [UIImage imageNamed:@"voice_micP_female"];
            break;
        default:
            break;
    }
}

-(void)setIsSpeaking:(BOOL)isSpeaking {
    _isSpeaking = isSpeaking;
    
    if (isSpeaking) {
        [self.gifImageView startAnimating];
        self.gifImageView.hidden = NO;
        self.portraitImageView.layer.borderWidth = 0;//动效没描边
    }else {
        [self.gifImageView stopAnimating];
        self.gifImageView.hidden = YES;
        self.portraitImageView.layer.borderWidth = self.portraitUrlStr.length>0 ? 1.0 : 0;
    }
}

-(void)setIsHost:(BOOL)isHost {
    _isHost = isHost;
    self.hostTagImageView.hidden = !isHost;
}

@end
