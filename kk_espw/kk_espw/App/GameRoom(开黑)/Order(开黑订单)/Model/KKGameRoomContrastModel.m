//
//  KKGameRoomContrastModel.m
//  kk_espw
//
//  Created by hsd on 2019/8/5.
//  Copyright © 2019 david. All rights reserved.
//

#import "KKGameRoomContrastModel.h"

@implementation KKGameRoomPositionModel

+ (instancetype)createWith:(NSInteger)position title:(NSString *)title {
    KKGameRoomPositionModel *model = [[KKGameRoomPositionModel alloc] init];
    model.position = position;
    model.title = title;
    return model;
}

@end





@implementation KKGameRoomContrastModel

#pragma mark - get
- (NSDictionary<NSString *,KKGameRoomPositionModel *> *)positionMapDic {
    if (!_positionMapDic) {
        _positionMapDic = @{@"TOP": [KKGameRoomPositionModel createWith:0 title:@"上"],
                            @"MID": [KKGameRoomPositionModel createWith:1 title:@"中"],
                            @"ADC": [KKGameRoomPositionModel createWith:2 title:@"下"],
                            @"JUG": [KKGameRoomPositionModel createWith:3 title:@"野"],
                            @"SUP": [KKGameRoomPositionModel createWith:4 title:@"辅"],
                            };
    }
    return _positionMapDic;
}

- (NSDictionary<NSString *,NSString *> *)medalMapDic {
    if (!_medalMapDic) {
        _medalMapDic = @{@"GOD_V1": @"game_great_god_level1",
                         @"GOD_V2": @"game_great_god_level2",
                         @"GOD_V3": @"game_great_god_level3",
                         @"GOD_V4": @"game_great_god_level4",
                         @"GOD_V5": @"game_great_god_level5",
                         @"GODDESS_V1": @"game_goddess_level1",
                         @"GODDESS_V2": @"game_goddess_level2",
                         @"GODDESS_V3": @"game_goddess_level3",
                         @"GODDESS_V4": @"game_goddess_level4",
                         @"GODDESS_V5": @"game_goddess_level5",
                         };
    }
    return _medalMapDic;
}

- (NSDictionary<NSString *,NSString *> *)evaluateMapDic {
    if (!_evaluateMapDic) {
        _evaluateMapDic = @{@"KAN_YA_WANG": @"抗压王",
                            @"QUAN_NENG_FU_ZHU": @"全能辅助",
                            @"FA_WANG": @"法王",
                            @"YE_WANG": @"野王",
                            @"KENG_HUO": @"坑货",
                            };
    }
    return _evaluateMapDic;
}

- (NSDictionary<NSString *,NSNumber *> *)patternMapDic {
    if (!_patternMapDic) {
        _patternMapDic = @{@"MULTI_PLAYER_TEAM_ONE": @(1),
                           @"MULTI_PLAYER_TEAM_TWO": @(2),
                           @"FIVE_PLAYER_TEAM": @(4)
                           };
    }
    return _patternMapDic;
}

- (NSDictionary<NSString *,UIImage *> *)rankImageMapDic {
    if (!_rankImageMapDic) {
        _rankImageMapDic = @{@"BRONZE": Img(@"game_room_main_bronze"),
                             @"SILVER": Img(@"game_room_main_silver"),
                             @"GOLD": Img(@"game_room_main_gold"),
                             @"PLATINUM": Img(@"game_room_main_platinum"),
                             @"DIAMOND": Img(@"game_room_main_diamond"),
                             @"STARSHINE": Img(@"game_room_main_starshine"),
                             @"KING": Img(@"game_room_main_king"),
                             @"GLORY": Img(@"game_room_main_glory"),
                             };
    }
    return _rankImageMapDic;
}

- (NSDictionary<NSString *,UIImage *> *)sexMapDic {
    if (!_sexMapDic) {
        _sexMapDic = @{@"M": Img(@"game_sex_man"),
                       @"F": Img(@"game_sex_woman"),
                       };
    }
    return _sexMapDic;
}

- (NSDictionary<NSString *,UIImage *> *)cardSexMapDic {
    if (!_cardSexMapDic) {
        _cardSexMapDic = @{@"M": Img(@"game_player_card_sex_man"),
                           @"F": Img(@"game_player_card_sex_woman"),
                           };
    }
    return _cardSexMapDic;
}

#pragma mark - 单例
static KKGameRoomContrastModel *_staticContrastModel = nil;

+ (instancetype)shareInstance {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _staticContrastModel = [[KKGameRoomContrastModel alloc] init];
    });
    return _staticContrastModel;
}

@end
