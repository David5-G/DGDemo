//
//  KKLiveStudioMicRankCurrentRankInfoView.m
//  kk_espw
//
//  Created by david on 2019/7/24.
//  Copyright © 2019 david. All rights reserved.
//

#import "KKChatRoomMicRankCurrentRankInfoView.h"

@interface KKChatRoomMicRankCurrentRankInfoView ()
{
    CGFloat _portraitHeight;
    CGFloat _nameLabelHeight;
    CGFloat _nameLabelTopSpace;
}
@property (nonatomic, strong) UIImageView *tagImageView;
@end


@implementation KKChatRoomMicRankCurrentRankInfoView

-(instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setDimension];
        [self setupUI];
    }
    return self;
}


#pragma mark - UI
-(void)setDimension {
    _portraitHeight = [ccui getRH:50];
    _nameLabelHeight = [ccui getRH:14];
    _nameLabelTopSpace = [ccui getRH:5];
}

-(void)setupUI {
  
    CGFloat leftSpace = [ccui getRH:31];
    CGFloat portraitH = _portraitHeight;
    CGFloat nameLabelTopSpace = _nameLabelTopSpace;
    CGFloat nameLabelH = _nameLabelHeight;
 
    
    //1.rank
    DGLabel *rankL = [DGLabel labelWithText:@"1" fontSize:[ccui getRH:15] color:KKES_COLOR_YELLOW];
    self.rankLabel = rankL;
    rankL.hidden = YES;
    [self addSubview:rankL];
    [rankL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(leftSpace);
        make.centerY.mas_equalTo(0);
    }];
    
    //2.头像
    UIImageView *portraitImgV = [[UIImageView alloc]init];
    self.portraitImageView = portraitImgV;
    portraitImgV.hidden = YES;
    portraitImgV.backgroundColor = UIColor.lightGrayColor;
    portraitImgV.layer.cornerRadius = portraitH/2.0;
    portraitImgV.layer.masksToBounds = YES;
    [self addSubview:portraitImgV];
    [portraitImgV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo([ccui getRH:16]+leftSpace);
        make.centerY.mas_equalTo(0);
        make.width.height.mas_equalTo(portraitH);
    }];
    
    //3.name
    DGLabel *nameL = [DGLabel labelWithText:@"XXX" fontSize:[ccui getRH:16] color:KKES_COLOR_YELLOW];
    self.nameLabel = nameL;
    nameL.hidden = YES;
    [self addSubview:nameL];
    [nameL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(portraitImgV.mas_right).mas_offset([ccui getRH:10]);
        make.top.mas_equalTo(portraitImgV.mas_top).mas_equalTo(nameLabelTopSpace);
        make.height.mas_equalTo(nameLabelH);
        make.right.mas_equalTo(-10);
    }];
    
    //4.tag
    UIImageView *tagImgV = [[UIImageView alloc] init];
    self.tagImageView = tagImgV;
    [self addSubview:tagImgV];
    [tagImgV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(nameL.mas_left);
        make.bottom.mas_equalTo(portraitImgV.mas_bottom).mas_offset(-[ccui getRH:9]);
        make.width.mas_equalTo([ccui getRH:42]);
        make.height.mas_equalTo([ccui getRH:14]);
    }];
    
    //5.rankInfoL
    DGLabel *rankInfoL = [DGLabel labelWithText:@"目前x个人正在排麦，赶快加入队伍上麦吧" fontSize:[ccui getRH:15] color:KKES_COLOR_YELLOW];
    self.rankInfoLabel = rankInfoL;
    [self addSubview:rankInfoL];
    [rankInfoL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo([ccui getRH:29]);
        make.right.mas_equalTo(-[ccui getRH:29]);
        make.top.bottom.mas_equalTo(0);
    }];
}

#pragma mark - setter
-(void)setRanking:(BOOL)ranking {
    _ranking =  ranking;
    
    self.rankInfoLabel.hidden = ranking;
    self.rankLabel.hidden = !ranking;
    self.portraitImageView.hidden = !ranking;
    self.nameLabel.hidden = !ranking;
    self.tagImageView.hidden = !ranking;
}

-(void)setLocalImageName:(NSString *)localImageName {
    _localImageName = [localImageName copy];
    
    //1.imageView
    self.tagImageView.hidden = localImageName.length<1;
    self.tagImageView.image = Img(localImageName);
    
    //2.nameLabel
    WS(weakSelf);
    CGFloat nameTopSpace = localImageName.length<1 ? (_portraitHeight - _nameLabelHeight)/2.0 : _nameLabelTopSpace;
    [self.nameLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(weakSelf.portraitImageView.mas_top).mas_offset(nameTopSpace);
    }];
}

@end
