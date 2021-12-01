//
//  KKLiveStudioOnlineUserView.m
//  kk_espw
//
//  Created by david on 2019/7/18.
//  Copyright © 2019 david. All rights reserved.
//

#import "KKLiveStudioOnlineUserView.h"


@interface KKLiveStudioOnlineUserView ()
{
    CGFloat _iconHeight;
    CGFloat _onlineCountViewWidth;
    CGFloat _spaceX;
}
@property (nonatomic, strong) NSMutableArray *usersArr;
@property (nonatomic, weak) UIView *onlineUserView;
@property (nonatomic, strong) NSMutableArray *buttonArray;
@property (nonatomic, strong) NSMutableDictionary *logoUrlDictionary;

@property (nonatomic, strong) UIView *onlineCountView;
@property (nonatomic, weak) DGLabel *onlineCountLabel;

@end

@implementation KKLiveStudioOnlineUserView
#pragma mark - lazy load
-(NSMutableArray *)buttonArray {
    if (!_buttonArray) {
        _buttonArray = [NSMutableArray arrayWithCapacity:3];
    }
    return _buttonArray;
}

-(NSMutableDictionary *)logoUrlDictionary {
    if (!_logoUrlDictionary) {
        _logoUrlDictionary = [NSMutableDictionary dictionary];
    }
    return _logoUrlDictionary;
}

#pragma mark - life circle

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
    _iconHeight = [ccui getRH:26];
    _onlineCountViewWidth = [ccui getRH:42];
    _spaceX = [ccui getRH:4];
    
}

-(void)setupUI {
    
    CGFloat spaceX = _spaceX;
    CGFloat iconH = _iconHeight;
    
    //1.在线数
   UIView *onlineCountV = [self setupOnlineCountView];
    
    //2.在线人
    UIView *onlineUserV = [[UIView alloc]init];
    self.onlineUserView = onlineUserV;
    [self addSubview:onlineUserV];
    [onlineUserV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(onlineCountV.mas_left).mas_offset(-spaceX);
        make.centerY.mas_equalTo(0);
        make.height.mas_equalTo(iconH);
        make.width.mas_equalTo(2*spaceX+3*iconH);
    }];
    
    //2.1 subviews
    DGButton *rightBtn = nil;
    for (NSInteger i=0; i<3; i++) {
        DGButton *userBtn = [[DGButton alloc]init];
        userBtn.userInteractionEnabled = NO;
        userBtn.layer.cornerRadius = iconH/2.0;
        userBtn.layer.masksToBounds = YES;
        [onlineUserV addSubview:userBtn];
        [self.buttonArray addObject:userBtn];
        
        [userBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(0);
            make.width.height.mas_equalTo(iconH);
            if (rightBtn) {
                make.right.mas_equalTo(rightBtn.mas_left).mas_offset(-spaceX);
            }else{
                make.right.mas_equalTo(0);
            }
        }];
        //right
        rightBtn = userBtn;
    }
}



-(UIView *)setupOnlineCountView {
    
    CGFloat h = _iconHeight;
    CGFloat onlineCountViewW = _onlineCountViewWidth;
    
    //1.onlineCountV
    UIView *onlineCountV = [[UIView alloc]init];
    self.onlineCountView = onlineCountV;
    onlineCountV.backgroundColor = rgba(0, 0, 0, 0.7);
    onlineCountV.layer.cornerRadius = _iconHeight/2.0;
    onlineCountV.layer.masksToBounds = YES;
    [self addSubview:onlineCountV];
    [onlineCountV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(0);
        make.centerY.mas_equalTo(0);
        make.width.mas_equalTo(onlineCountViewW);
        make.height.mas_equalTo(h);
    }];
    
    //2.arrow
    UIImageView *arrowImgV = [[UIImageView alloc] initWithImage:Img(@"live_arrow_right_white")];
    [onlineCountV addSubview:arrowImgV];
    [arrowImgV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-[ccui getRH:5]);
        make.centerY.mas_equalTo(0);
        make.width.height.mas_equalTo([ccui getRH:7]);
    }];
    
    //3.在线
    DGLabel *onlineTitleL = [DGLabel labelWithText:@"在线" fontSize:[ccui getRH:9] color:UIColor.whiteColor];
    onlineTitleL.textAlignment = NSTextAlignmentCenter;
    [onlineCountV addSubview:onlineTitleL];
    [onlineTitleL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(2);
        make.left.mas_equalTo([ccui getRH:5]);
        make.right.mas_equalTo(arrowImgV.mas_left).mas_offset(0);
    }];
    
    //4.人数
    DGLabel *onlineCountL = [DGLabel labelWithText:@"999" fontSize:[ccui getRH:9] color:UIColor.whiteColor];
    self.onlineCountLabel = onlineCountL;
    onlineCountL.textAlignment = NSTextAlignmentCenter;
    [onlineCountV addSubview:onlineCountL];
    [onlineCountL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(onlineTitleL.mas_bottom).mas_offset(0);
        make.left.mas_equalTo([ccui getRH:5]);
        make.right.mas_equalTo(arrowImgV.mas_left).mas_offset(0);
    }];
    
    //5.
    return onlineCountV;
}


#pragma mark - tool
-(void)setUserLogoUrl:(NSString *)userLogoUrl atIndex:(NSInteger)index {
    //过滤越界
    if (self.buttonArray.count <= index) {
        return;
    }
    
    //过滤相同userLogoUrl
    NSString *indexStr = [NSString stringWithFormat:@"index%ld",index];
    NSString *oldUserLogoUrl = self.logoUrlDictionary[indexStr];
    if ([userLogoUrl isEqualToString:oldUserLogoUrl]) {
        return;
    }
    
    UIButton *btn = self.buttonArray[index];
    if(userLogoUrl.length < 1){
        self.logoUrlDictionary[indexStr] = @"";
        [btn setBackgroundImage:nil forState:UIControlStateNormal];
    }else{
        self.logoUrlDictionary[indexStr] = userLogoUrl;
        [btn sd_setBackgroundImageWithURL:Url(userLogoUrl) forState:UIControlStateNormal];
    }
    
}

#pragma mark - public
-(void)setUserLogoUrlArray:(NSArray *)logoUrlArray {
    
    NSInteger btnCount = self.buttonArray.count;
    NSInteger logoCount = logoUrlArray.count>btnCount ? btnCount : logoUrlArray.count;
    
    //1. 数量少于btnCount(3个) => 赋空
    for (NSInteger i = btnCount - 1; i >= logoCount; i --) {
        [self setUserLogoUrl:nil atIndex:i];
    }
    
    //2.赋值
    for (NSInteger btnIndex=logoCount-1,logoIndex=0; btnIndex>=0 && logoIndex<logoCount; btnIndex--,logoIndex++) {
        [self setUserLogoUrl:logoUrlArray[logoIndex] atIndex:btnIndex];
    }
}


-(void)setUserCount:(NSInteger)count {
    self.onlineCountLabel.text = [NSString stringWithFormat:@"%ld",count];
}

-(void)setOnlineUserCountViewBackgroundColor:(UIColor *)bgColor {
    self.onlineCountView.backgroundColor = bgColor;
}

@end
