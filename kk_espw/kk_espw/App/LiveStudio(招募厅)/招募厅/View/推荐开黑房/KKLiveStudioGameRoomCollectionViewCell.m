//
//  KKLiveStudioGameRoomCollectionViewCell.m
//  kk_espw
//
//  Created by david on 2019/7/18.
//  Copyright © 2019 david. All rights reserved.
//

#import "KKLiveStudioGameRoomCollectionViewCell.h"

@implementation KKLiveStudioGameRoomCollectionViewCell
-(instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
    }
    return self;
}

#pragma mark - UI
-(void)setupUI {
    
    CGFloat leftSpace = [ccui getRH:15];
    
    //1.bg
    UIImageView *bgImgV = [[UIImageView alloc]initWithImage:Img(@"live_gameRoom_bg")];
    [self addSubview:bgImgV];
    [bgImgV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.bottom.mas_equalTo(0);
    }];
    
    //2.id
    UIImageView *idBgImgV = [[UIImageView alloc] initWithImage:Img(@"live_gameRoom_bg_idTag")];
    [self addSubview:idBgImgV];
    [idBgImgV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.mas_equalTo(0);
        make.height.mas_equalTo([ccui getRH:18]);
        make.width.mas_equalTo([ccui getRH:41]);
    }];
    
    //2.1 idLabel
    DGLabel *idL = [DGLabel labelWithText:@"*****" fontSize:[ccui getRH:10] color:KKES_COLOR_BLACK_TEXT bold:YES];
    self.idLabel = idL;
    idL.textAlignment = NSTextAlignmentCenter;
    [idBgImgV addSubview:idL];
    [idL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.mas_equalTo(0);
        make.right.mas_equalTo(-[ccui getRH:2]);
    }];
    
    //3.title
    DGLabel *titleL = [DGLabel labelWithText:@"微信-**局" fontSize:[ccui getRH:13] color:UIColor.whiteColor];
    self.titleLabel = titleL;
    [self addSubview:titleL];
    [titleL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo([ccui getRH:8]);
        make.left.mas_equalTo(idL.mas_right).mas_equalTo([ccui getRH:5]);
        make.right.mas_equalTo(-[ccui getRH:5]);
    }];
    
    //4.grayLine
    UIView *grayLine = [[UIView alloc]init];
    [self addSubview:grayLine];
    grayLine.backgroundColor = rgba(255, 255, 255, 0.5);;
    [grayLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo([ccui getRH:32]);
        make.left.mas_equalTo(leftSpace);
        make.right.mas_equalTo(-leftSpace);
        make.height.mas_equalTo([ccui getRH:1]);
    }];
    
    //5.msgL
    DGLabel *msgL = [DGLabel labelWithText:@"come,快上车" fontSize:[ccui getRH:12] color:UIColor.whiteColor bold:YES];
    self.msgLabel = msgL;
    [self addSubview:msgL];
    [msgL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(grayLine.mas_bottom).mas_equalTo([ccui getRH:8]);
        make.left.mas_equalTo(leftSpace);
        make.right.mas_equalTo(-leftSpace);
    }];
    
    //6.memberV
    [self setupMemberView];
}
    
-(void)setupMemberView {
    
    CGFloat iconH = [ccui getRH:10];
    CGFloat memberViewH = [ccui getRH:19];
    CGFloat fontSize = [ccui getRH:10];
    
    //1.view
    UIView *memberV = [[UIView alloc] init];
    memberV.backgroundColor = rgba(255, 255, 255, 0.5);
    memberV.layer.cornerRadius = memberViewH/2.0;
    memberV.layer.masksToBounds = YES;
    [self addSubview:memberV];
    [memberV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(-[ccui getRH:6]);
        make.left.mas_equalTo([ccui getRH:15]);
        make.height.mas_equalTo(memberViewH);
        make.width.mas_equalTo([ccui getRH:90]);
    }];
    
    //2.male
    UIImageView *maleImgV = [[UIImageView alloc]initWithImage:Img(@"live_gameRoom_icon_male")];
    [memberV addSubview:maleImgV];
    [maleImgV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo([ccui getRH:8]);
        make.centerY.mas_equalTo(0);
        make.width.height.mas_equalTo(iconH);
    }];
    
    //label
    DGLabel *maleL = [DGLabel labelWithText:@"7" fontSize:fontSize color:UIColor.whiteColor bold:YES];
    self.maleCountLabel = maleL;
    maleL.textAlignment = NSTextAlignmentCenter;
    [memberV addSubview:maleL];
    [maleL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(maleImgV.mas_right).mas_equalTo([ccui getRH:1]);
        make.centerY.mas_equalTo(0);
        make.width.mas_equalTo(iconH);
        make.height.mas_equalTo(iconH);
    }];
    
    //3.female
    UIImageView *femaleImgV = [[UIImageView alloc]initWithImage:Img(@"live_gameRoom_icon_female")];
    [memberV addSubview:femaleImgV];
    [femaleImgV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo([ccui getRH:37]);
        make.centerY.mas_equalTo(0);
        make.width.height.mas_equalTo(iconH);
    }];
    
    //label
    DGLabel *femaleL = [DGLabel labelWithText:@"2" fontSize:fontSize color:UIColor.whiteColor bold:YES];
    self.femaleCountLabel = femaleL;
    femaleL.textAlignment = NSTextAlignmentCenter;
    [memberV addSubview:femaleL];
    [femaleL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(femaleImgV.mas_right).mas_equalTo([ccui getRH:1]);
        make.centerY.mas_equalTo(0);
        make.width.mas_equalTo(iconH);
        make.height.mas_equalTo(iconH);
    }];
    
    //4.statistic
    UILabel *statisticL = [DGLabel labelWithText:@"9/5" fontSize:fontSize color:UIColor.whiteColor bold:YES];
    self.statisticLabel = statisticL;
    statisticL.textAlignment = NSTextAlignmentRight;
    [memberV addSubview:statisticL];
    [statisticL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-[ccui getRH:8]);
        make.centerY.mas_equalTo(0);
        make.height.mas_equalTo(iconH);
        make.width.mas_equalTo(2*iconH);
    }];
}



@end
