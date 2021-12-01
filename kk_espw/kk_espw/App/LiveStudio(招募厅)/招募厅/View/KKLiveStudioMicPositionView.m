//
//  KKLiveStudioMicPositionView.m
//  kk_espw
//
//  Created by david on 2019/7/18.
//  Copyright © 2019 david. All rights reserved.
//

#import "KKLiveStudioMicPositionView.h"

@interface KKLiveStudioMicPositionView ()
{
    UIColor *_colorYellow;
    UIColor *_colorGray;
    UIColor *_colorBlack;
}
 
@property (nonatomic, assign) CGRect preFrame;
//host
@property (nonatomic, weak) UIImageView *hostGifImageView;
@property (nonatomic, weak) UIButton *hostButton;
@property (nonatomic, weak) UILabel *hostNameLabel;
//guest
@property (nonatomic, weak) UIImageView *guestGifImageView;
@property (nonatomic, weak) UIButton *guestButton;
@property (nonatomic, weak) UILabel *guestNameLabel;
@end

@implementation KKLiveStudioMicPositionView

#pragma mark - life circle
-(instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.preFrame = frame;
        [self setDimension];
        [self setupUI];
    }
    
    return self;
}


#pragma mark - UI
-(void)setDimension {
    _colorYellow = rgba(236, 193, 101, 1);
    _colorGray = rgba(213, 213, 213, 1);
    _colorBlack = rgba(51, 51, 51, 1);
}

-(void)setupUI {
    
    WS(weakSelf);
    CGFloat btnH = [ccui getRH:47];
    CGFloat btnTopSpace = [ccui getRH:14];
    CGFloat guestBtnRightSpace = [ccui getRH:61];
    UIColor *borderC = _colorYellow;
    CGFloat gifImgVH = [ccui getRH:65];
    
    //1.上麦用户
    //1.1背景
    UIImageView *guestBgImgV = [[UIImageView alloc]initWithImage:Img(@"live_bg_guest")];
    [self addSubview:guestBgImgV];
    [guestBgImgV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.right.bottom.mas_equalTo(0);
        make.width.mas_equalTo([ccui getRH:201]);
    }];
    
    //1.2 btn
    DGButton *guestBtn = [DGButton btnWithBgImg:Img(@"live_icon_guest_absent")];
    self.guestButton = guestBtn;
    guestBtn.layer.cornerRadius = btnH/2.0;
    guestBtn.layer.masksToBounds = YES;
    guestBtn.layer.borderColor = borderC.CGColor;
    guestBtn.layer.borderWidth = 0;
    [self addSubview:guestBtn];
    [guestBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(btnTopSpace);
        make.right.mas_equalTo(-guestBtnRightSpace);
        make.width.height.mas_equalTo(btnH);
    }];
    [guestBtn addClickWithTimeInterval:0.1 block:^(DGButton *btn) {
        if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(didClickGuestButton:)]) {
            [weakSelf.delegate didClickGuestButton:weakSelf];
        }
    }];
    //不用点语法, 给_guestStatus赋值
    _guestStatus = KKLiveStudioMicPStatusAbsent;
    
    //1.3 gifImgV
    UIImageView *guestGifImgV = [self createGifImageView];
    self.guestGifImageView = guestGifImgV;
    [self addSubview:guestGifImgV];
    [self insertSubview:guestGifImgV belowSubview:guestBtn];
    [guestGifImgV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(guestBtn);
        make.width.height.mas_equalTo(gifImgVH);
    }];

    //2.4 nameL
    DGLabel *guestNameL = [DGLabel labelWithText:@"虚以待位" fontSize:[ccui getRH:12] color:borderC];
    guestNameL.textAlignment = NSTextAlignmentCenter;
    self.guestNameLabel = guestNameL;
    [self addSubview:guestNameL];
    [guestNameL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(guestBtn.mas_bottom).mas_offset([ccui getRH:8]);
        make.centerX.mas_equalTo(guestBtn);
    }];
    
    //2.主持位
    //2.1 btn
    DGButton *hostBtn = [DGButton btnWithBgImg:Img(@"live_icon_host_absent")];
    self.hostButton = hostBtn;
    hostBtn.layer.cornerRadius = btnH/2.0;
    hostBtn.layer.masksToBounds = YES;
    hostBtn.layer.borderColor = borderC.CGColor;
    hostBtn.layer.borderWidth = 0;
    [self addSubview:hostBtn];
    [hostBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(btnTopSpace);
        make.left.mas_equalTo(guestBtnRightSpace);
        make.width.height.mas_equalTo(btnH);
    }];
    [hostBtn addClickWithTimeInterval:0.1 block:^(DGButton *btn) {
        if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(didClickHostButton:)]) {
            [weakSelf.delegate didClickHostButton:weakSelf];
        }
    }];
    //不用点语法, 给_hostStatus赋值
    _hostStatus = KKLiveStudioMicPStatusAbsent;
    
    //2.2 gifImgV
    UIImageView *hostGifImgV = [self createGifImageView];
    self.hostGifImageView = hostGifImgV;
    [self addSubview:hostGifImgV];
    [self insertSubview:hostGifImgV belowSubview:hostBtn];
    [hostGifImgV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(hostBtn);
        make.width.height.mas_equalTo(gifImgVH);
    }];
    
    //2.3 tagL
    DGLabel *hostTagL = [DGLabel labelWithText:@"主持人" fontSize:[ccui getRH:9] color:UIColor.whiteColor];
    hostTagL.backgroundColor = borderC;
    hostTagL.textAlignment = NSTextAlignmentCenter;
    [self addSubview:hostTagL];
    [hostTagL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(hostBtn);
        make.top.mas_equalTo(hostBtn.mas_top).mas_offset([ccui getRH:42]);
        make.width.mas_equalTo([ccui getRH:37]);
        make.height.mas_equalTo([ccui getRH:14]);
    }];
    
    //2.4 nameL
    DGLabel *hostNameL = [DGLabel labelWithText:@"暂无主持人" fontSize:[ccui getRH:14] color:borderC];
    hostNameL.textAlignment = NSTextAlignmentCenter;
    self.hostNameLabel = hostNameL;
    [self addSubview:hostNameL];
    [hostNameL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(hostTagL.mas_bottom).mas_offset([ccui getRH:4]);
        make.centerX.mas_equalTo(hostTagL);
    }];
    
}

#pragma mark tool
-(UIImageView *)createGifImageView {
    //1.准备图片
    NSMutableArray *imgArr = [NSMutableArray arrayWithCapacity:4];
    for (NSInteger i=1; i<5; i++) {
        NSString *imgStr = [NSString stringWithFormat:@"live_gif_voice_%02ld",(long)i];
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


#pragma mark - setter
#pragma mark  host
-(void)setHostName:(NSString *)hostName {
    _hostName = [hostName copy];
    self.hostNameLabel.text = _hostName;
}


-(void)setHostlogoUrl:(NSString *)hostlogoUrl {
    _hostlogoUrl = [hostlogoUrl copy];
    
    if (hostlogoUrl.length > 0) {
        [self.hostButton sd_setBackgroundImageWithURL:[NSURL URLWithString:hostlogoUrl] forState:UIControlStateNormal];
    }
    
    //2.描边情况
    self.hostButton.layer.borderWidth = hostlogoUrl.length>0 ? 1.0 : 0;
}

-(void)setHostStatus:(KKLiveStudioMicPStatus)hostStatus {
    _hostStatus = hostStatus;
    
    //1.Absent状态,需要更新图片
    if (KKLiveStudioMicPStatusAbsent == hostStatus) {
        //1.1 btn
        _hostlogoUrl = nil;
        [self.hostButton setBackgroundImage:Img(@"live_icon_host_absent") forState:UIControlStateNormal];
        //1.2 nameLabel
        self.hostNameLabel.textColor = _colorYellow;
        self.hostNameLabel.text = @"暂无主持人";
    }else {
        self.hostNameLabel.textColor = _colorBlack;
    }
    
    //2.只要改变status, 就关闭动效
    self.hostSpeaking = NO;
}

-(void)setHostSpeaking:(BOOL)hostSpeaking {
    _hostSpeaking = hostSpeaking;
    
    //1.动效
    if (hostSpeaking) {
        [self.hostGifImageView startAnimating];
        self.hostGifImageView.hidden = NO;
        //有动效,无描边
        self.hostButton.layer.borderWidth = 0;
        
    }else{
        [self.hostGifImageView stopAnimating];
        self.hostGifImageView.hidden = YES;
        //无动效, 有图有描边,无图无描边
        self.hostButton.layer.borderWidth = self.hostlogoUrl.length>0 ? 1.0 : 0;
    }
}

#pragma mark guest
-(void)setGuestName:(NSString *)guestName {
    _guestName = [guestName copy];
    self.guestNameLabel.text = _guestName;
}

-(void)setGuestlogoUrl:(NSString *)guestlogoUrl {
    //1.过滤 关闭guest的情况
    if(self.guestStatus == KKLiveStudioMicPStatusClose) {
        return;
    }
    
    //2.赋值
    _guestlogoUrl = [guestlogoUrl copy];
    
    //3.改变状态
    if (guestlogoUrl.length > 0) {
        [self.guestButton sd_setBackgroundImageWithURL:[NSURL URLWithString:guestlogoUrl] forState:UIControlStateNormal];
    }
    
    //4.描边情况
    self.guestButton.layer.borderWidth = guestlogoUrl.length>0 ? 1.0 : 0;
}

-(void)setGuestStatus:(KKLiveStudioMicPStatus)guestStatus {
    _guestStatus = guestStatus;
    
    //1.某些状态需要改头像
    if (KKLiveStudioMicPStatusAbsent == guestStatus) {
        // btn
        _guestlogoUrl = nil;
        [self.guestButton setBackgroundImage:Img(@"live_icon_guest_absent") forState:UIControlStateNormal];
        // nameLabel
        self.guestNameLabel.textColor = _colorYellow;
        self.guestNameLabel.text = @"虚以待位";
        
    }else if (KKLiveStudioMicPStatusClose == guestStatus) {
        // btn
        _guestlogoUrl = nil;
        [self.guestButton setBackgroundImage:Img(@"live_icon_guest_close") forState:UIControlStateNormal];
        // nameLabel
        self.guestNameLabel.textColor = _colorGray;
        self.guestNameLabel.text = @"闭麦";
        
    }else{
        self.guestNameLabel.textColor = _colorBlack;
    }
    
    //2.只要改变status, 就关闭动效
    self.guestSpeaking = NO;
}

-(void)setGuestSpeaking:(BOOL)guestSpeaking {
    _guestSpeaking = guestSpeaking;
    
    //1.改变状态
    if (guestSpeaking) {
        [self.guestGifImageView startAnimating];
        self.guestGifImageView.hidden = NO;
        //有动效,无描边
        self.guestButton.layer.borderWidth = 0;
        
    }else{
        [self.guestGifImageView stopAnimating];
        self.guestGifImageView.hidden = YES;
        //无动效, 有图有描边,无图无描边
        self.guestButton.layer.borderWidth = self.guestlogoUrl.length>0 ? 1.0 : 0;
    }
    
    
}


@end
