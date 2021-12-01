//
//  KKPlayerCardCollectionCell.m
//  kk_espw
//
//  Created by hsd on 2019/7/19.
//  Copyright © 2019 david. All rights reserved.
//

#import "KKPlayerCardCollectionCell.h"
#import "KKPlayerLabelView.h"
#import "KKGameRoomContrastModel.h"
#import "UIView+WaterSpread.h"
@interface KKPlayerCardCollectionCell ()

@property (weak, nonatomic) IBOutlet UIView *gradientView;        ///< 颜色渐变视图
@property (weak, nonatomic) IBOutlet UIImageView *headerImageView;          ///< 头部图片
@property (weak, nonatomic) IBOutlet UIView *playerPhotoSuperView;

@property (weak, nonatomic) IBOutlet UILabel *playRoadLabel;                ///< 主打路线
@property (weak, nonatomic) IBOutlet UIImageView *homeOwnerImageView;       ///< 房主标志图片
@property (weak, nonatomic) IBOutlet UIImageView *playerPhotoImageView;     ///< 玩家头像
@property (weak, nonatomic) IBOutlet UIImageView *playerSexImageView;

@property (weak, nonatomic) IBOutlet UILabel *playerNickLabel;              ///< 昵称
@property (weak, nonatomic) IBOutlet UILabel *playerLevelLabel;             ///< 等级
@property (weak, nonatomic) IBOutlet CC_Button *joinButton;                  ///< 上车/切换
@property (weak, nonatomic) IBOutlet UIImageView *hasPreparedImageView;     ///< 准备状态

@property (nonatomic, strong, nonnull) NSMutableArray<KKPlayerLabelView *> *playerLabels; ///< 玩家标签

@property (nonatomic, strong, nullable) CAGradientLayer *gradientLayer;

@property (nonatomic, assign) KKPlayerCardUserActionStatus userActionStaus;
@property (weak, nonatomic) IBOutlet UIImageView *gifImageView;

@end

@implementation KKPlayerCardCollectionCell

#pragma mark - set
- (void)setIsSpeaking:(BOOL)isSpeaking {
    if (isSpeaking) {
        [self.gifImageView startAnimating];
    }else {
        [self.gifImageView stopAnimating];
    }
    
    
}

- (void)setDataModel:(KKGameBoardDetailSimpleModel *)dataModel {

    _dataModel = dataModel;
 
    // 房主标志
    self.homeOwnerImageView.hidden = !dataModel.isRoomOwner;
    
    /*
     PREPARE - 已准备
     OCCUPY - 占座
     CANCEL - 已撤销
     FINISH - 已结束
     */
    
    // 准备且支付成功才算已准备
    BOOL isPrepare = [dataModel.userProceedStatus.name isEqualToString:@"PREPARE"];
    BOOL isOccupy = [dataModel.userProceedStatus.name isEqualToString:@"OCCUPY"];
    BOOL isPay = [dataModel.purchaseOrderPayStatusEnum.name isEqualToString:@"FREEZE_FINISH"];
    
    // 是否准备
    self.hasPreparedImageView.hidden = !(isPrepare && isPay);
    
    // 加入按钮文本
    if (!dataModel.isRoomOwner && self.loginUserIsInGame) {
        self.userActionStaus = KKPlayerCardUserActionStatusSwitch;
        [self.joinButton setTitle:nil forState:UIControlStateNormal];
        [self.joinButton setImage:Img(@"game_switch_position") forState:UIControlStateNormal];
    } else {
        self.userActionStaus = KKPlayerCardUserActionStatusOccupy;
        [self.joinButton setTitle:@"上车" forState:UIControlStateNormal];
        [self.joinButton setImage:nil forState:UIControlStateNormal];
    }
    
    // 加入按钮显示隐藏
    if (self.loginUserIsRoomOwner) {
        self.joinButton.hidden = YES;
        
    } else if (self.forceHiddenJoinBtn) {
        self.joinButton.hidden = YES;
        
    } else if (!dataModel.joinId) {
        self.joinButton.hidden = YES;
        
    } else {
        
        // 当前用户在玩家列表
        if (self.loginUserIsInGame) {
            // 当前卡片就是当前登录用户
            if ([dataModel.userId isEqualToString:[KKUserInfoMgr shareInstance].userId]) {
                self.joinButton.hidden = YES;
            } else {
                // 已准备玩家,隐藏上车按钮
                if (self.loginUserIsPrepare) {
                    self.joinButton.hidden = YES;
                } else {
                    self.joinButton.hidden = (isPrepare || isOccupy);
                }
            }
            
            // 当前用户是观众
        } else {
            if (self.reachMaxPlayers) {
                self.joinButton.hidden = YES;
            } else {
                self.joinButton.hidden = (isPrepare || isOccupy);
            }
        }
    }
    
    // 文本
    self.playRoadLabel.text = dataModel.playRoadString;
    self.playerNickLabel.text = dataModel.userName;
    self.playerLevelLabel.text = dataModel.gameRank.message;
    
    // 性别
    self.playerSexImageView.image = [KKGameRoomContrastModel shareInstance].sexMapDic[dataModel.sex.name ?: @""];
    
    // 显示/隐藏
    if (dataModel.userId == nil) {
        self.playerSexImageView.hidden = YES;
        self.playerNickLabel.hidden = YES;
        self.playerLevelLabel.hidden = YES;
    } else {
        self.playerSexImageView.hidden = NO;
        self.playerNickLabel.hidden = NO;
        self.playerLevelLabel.hidden = NO;
    }
    
    // 头像
    if (dataModel.userId) {
        NSString *photoStr = dataModel.userHeaderImgUrl;
        if (![dataModel.userHeaderImgUrl containsString:dataModel.userId]) {
            photoStr = [dataModel.userHeaderImgUrl stringByAppendingString:dataModel.userId];
        }
        
        WS(weakSelf)
        [self.playerPhotoImageView sd_setImageWithURL:[NSURL URLWithString:photoStr] placeholderImage:Img(@"game_absent") completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
            if (weakSelf.dataModel.userId &&
                [imageURL.absoluteString containsString:weakSelf.dataModel.userId]) {
                weakSelf.playerPhotoImageView.image = image;
            } else {
                [weakSelf setDefaultPlayerHeaderImage];
            }
        }];
        
    } else {
        [self setDefaultPlayerHeaderImage];
    }
    
    // 标签
    [self reloadPlayerLabelsView:dataModel hidden:!self.joinButton.hidden];
}

/// 设置用户默认头像
- (void)setDefaultPlayerHeaderImage {
    if (self.reachMaxPlayers) {
        if (self.loginUserIsPrepare) {
            self.playerPhotoImageView.image = Img(@"game_nobody");
        } else {
            self.playerPhotoImageView.image = self.loginUserIsInGame ? Img(@"game_absent") : Img(@"game_nobody");
        }
    } else {
        self.playerPhotoImageView.image = Img(@"game_absent");
    }
}

#pragma mark - get
- (NSMutableArray<KKPlayerLabelView *> *)playerLabels {
    if (!_playerLabels) {
        _playerLabels = [NSMutableArray array];
    }
    return _playerLabels;
}

#pragma mark - system
- (void)awakeFromNib {
    [super awakeFromNib];
    [self resetUI];
    [self addGredientLayer];
    
    //gif
    NSMutableArray *imgArr = [NSMutableArray arrayWithCapacity:4];
    for (NSInteger i = 1; i < 5; i ++) {
        NSString *imgStr = [NSString stringWithFormat:@"voice_gif_voice_%02ld",(long)i];
        [imgArr addObject:Img(imgStr)];
    }
    self.gifImageView.animationImages = imgArr;
    self.gifImageView.animationDuration = 0.1*imgArr.count;
    self.gifImageView.animationRepeatCount = 0;
}

- (void)layoutSubviews {
    [super layoutSubviews];
}

- (void)resetUI {
    
    self.playerPhotoImageView.layer.cornerRadius = 20;
    self.playerPhotoImageView.layer.masksToBounds = YES;
    self.playerPhotoImageView.image = Img(@"game_absent");
    
    self.joinButton.layer.cornerRadius = 2;
    self.joinButton.layer.masksToBounds = YES;
    
    WS(weakSelf)
    [self.joinButton addTappedOnceDelay:0.5 withBlock:^(UIButton *button) {
        if (weakSelf.tapPrepareBlock) {
            weakSelf.tapPrepareBlock(weakSelf.dataModel, weakSelf.userActionStaus);
        }
    }];
    
    
}

- (void)addGredientLayer {
    CAGradientLayer *gLayer = [CAGradientLayer layer];
    gLayer.frame = CGRectZero;
    gLayer.startPoint = CGPointMake(0.5, 0);
    gLayer.endPoint = CGPointMake(0.5, 1.0);
    gLayer.colors = @[(__bridge id)RGB(42, 43, 60).CGColor, (__bridge id)KKES_COLOR_HEX(0x100D15).CGColor];
    //gLayer.colors = @[(__bridge id)RGB(42, 43, 60).CGColor, (__bridge id)RGB(24, 22, 33).CGColor];
    gLayer.locations = @[@(0.0), @(1.0)];
    self.gradientLayer = gLayer;
    
    [self.gradientView.layer addSublayer:gLayer];
    [self.contentView sendSubviewToBack:self.gradientView];
}

/// 根据模型创建标签
- (KKPlayerLabelView *)createLabelViewWith:(KKPlayerLabelViewModel *)labelModel {
    
    KKPlayerLabelView *labelView = [[KKPlayerLabelView alloc] init];
    labelView.model = labelModel;
    [self.contentView addSubview:labelView];
    
    // 寻找最后添加标签, 如果没有, 则取段位label, 用于添加约束
    UIView *lastLabelView = [self.playerLabels lastObject];
    CGFloat topSpace = 6;
    if (!lastLabelView) {
        lastLabelView = self.playerLevelLabel;
        topSpace = 11;
    }
    
    [labelView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.contentView).mas_offset(11);
        make.right.mas_equalTo(self.contentView);
        make.top.mas_equalTo(lastLabelView.mas_bottom).mas_offset(topSpace);
        make.height.mas_equalTo(14);
    }];
    
    return labelView;
}

/// 刷新标签
- (void)reloadPlayerLabelsView:(KKGameBoardDetailSimpleModel *)dataModel hidden:(BOOL)hidden {
    
    // 移除
    if (self.playerLabels.count > 0) {
        for (KKPlayerLabelView *labelView in self.playerLabels) {
            [labelView removeFromSuperview];
        }
        [self.playerLabels removeAllObjects];
    }
    
    if (!dataModel.userId) {
        return;
    }
    
    // 勋章
    for (KKPlayerMedalDetailModel *medalModel in dataModel.medalDetailList) {
        
        NSString *imgName = [[KKGameRoomContrastModel shareInstance].medalMapDic objectForKey:medalModel.currentMedalLevelConfigCode];
        if (imgName) {
            KKPlayerLabelViewModel *labelModel = [KKPlayerLabelViewModel createWithType:KKPlayerLabelViewModelTypeBigImage bgColors:nil img:Img(imgName) labelStr:nil];
            KKPlayerLabelView *labelView = [self createLabelViewWith:labelModel];
            labelView.hidden = hidden;
            // 保存下来
            [self.playerLabels addObject:labelView];
            
            // 只取第一个勋章
            break;
        }
    }
    
    // 靠谱
    NSInteger reliableScore = [dataModel.reliableScore integerValue];
    if (reliableScore > 0) {
        
        NSString *labelStr = [NSString stringWithFormat:@"靠谱 %ld", reliableScore];
        NSArray *bgColors = @[KKES_COLOR_HEX(0xFF6060)];
        
        KKPlayerLabelViewModel *labelModel = [KKPlayerLabelViewModel createWithType:KKPlayerLabelViewModelTypeIconImage bgColors:bgColors img:nil labelStr:labelStr];
        KKPlayerLabelView *labelView = [self createLabelViewWith:labelModel];
        labelView.hidden = hidden;
        // 保存下来
        [self.playerLabels addObject:labelView];
    }
    
    // 最大只显示两个技能项
    if (self.playerLabels.count == 2) {
        return;
    }
    
    // 标签
    for (KKPlayerEvaluationProfileIdModel *evaluateModel in dataModel.evaluationProfileIds) {
        
        NSString *evaluateStr = [KKGameRoomContrastModel shareInstance].evaluateMapDic[evaluateModel.tagCode ?: @""];
        if (evaluateStr) {
            
            NSString *numStr = [NSString stringWithFormat:@"%@", evaluateModel.evaluationNum];
            if ([evaluateModel.evaluationNum integerValue] > kk_player_max_game_time) {
                numStr = [NSString stringWithFormat:@"%ld+", (long)kk_player_max_game_time];
            }
            
            NSString *labelStr = [NSString stringWithFormat:@"%@ %@", evaluateStr, numStr];
            NSArray *bgColors = @[RGB(253, 186, 46)];
            
            KKPlayerLabelViewModel *labelModel = [KKPlayerLabelViewModel createWithType:KKPlayerLabelViewModelTypeIconImage bgColors:bgColors img:nil labelStr:labelStr];
            KKPlayerLabelView *labelView = [self createLabelViewWith:labelModel];
            labelView.hidden = hidden;
            // 保存下来
            [self.playerLabels addObject:labelView];
            
            // (勋章 + 标签) 最多只有两个
            if (self.playerLabels.count == 2) {
                break;
            }
        }
    }
    
    
}

@end
