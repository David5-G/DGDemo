//
//  KKCreateGameRoomController+DataSource.m
//  kk_espw
//
//  Created by hsd on 2019/7/29.
//  Copyright © 2019 david. All rights reserved.
//

#import "KKCreateGameRoomController+DataSource.h"
#import "KKCreateGameRoomExternKey.h"
#import <objc/runtime.h>

@implementation KKCreateGameRoomController (DataSource)

#pragma makr - Action
- (NSArray<NSDictionary *> * _Nonnull)defaultSectionDataSource {
    
    NSArray<NSDictionary *> *sectionArr = @[@{kkCreateGameRoom_title: @"选择名片"},
                                            @{kkCreateGameRoom_title: @"模式选择"},
                                            @{kkCreateGameRoom_title: @"想打位置(单选)",
                                              kkCreateGameRoom_attribute_title: @"(单选)"},
                                            ];
    NSMutableArray<NSDictionary *> *mutArr = [NSMutableArray arrayWithArray:sectionArr];
    
    if (self.depositPrice) {
        NSDictionary *dic3 = @{kkCreateGameRoom_title: @"是否收费"};
        [mutArr addObject:dic3];
    }
    
    return [mutArr copy];
}

- (NSArray * _Nonnull)dataSourceForSection:(NSInteger)section {
    
    NSArray *sectionDatas = nil;
    
    switch (section) {
        case 0:
            sectionDatas = (self.cardList ?: @[]);
            break;
        case 1:
        {
            sectionDatas = @[@{kkCreateGameRoom_normal_image: @"game_double_player_unselect",
                               kkCreateGameRoom_select_image: @"game_double_player_select",
                               kkCreateGameRoom_title: @"双人",
                               kkCreateGameRoom_param_data: @"MULTI_PLAYER_TEAM_ONE",
                               },
                             @{kkCreateGameRoom_normal_image: @"game_three_player_unselect",
                               kkCreateGameRoom_select_image: @"game_three_player_select",
                               kkCreateGameRoom_title: @"三人",
                               kkCreateGameRoom_param_data: @"MULTI_PLAYER_TEAM_TWO",
                               },
                             @{kkCreateGameRoom_normal_image: @"game_five_player_unselect",
                               kkCreateGameRoom_select_image: @"game_five_player_select",
                               kkCreateGameRoom_title: @"五人",
                               kkCreateGameRoom_param_data: @"FIVE_PLAYER_TEAM",
                               }];
        }
            break;
        case 2:
        {
            sectionDatas = @[@{kkCreateGameRoom_normal_image: @"game_up_road_unselect",
                               kkCreateGameRoom_select_image: @"game_up_road_select",
                               kkCreateGameRoom_title: @"上路",
                               kkCreateGameRoom_param_data: @"TOP",
                               },
                             @{kkCreateGameRoom_normal_image: @"game_middle_road_unselect",
                               kkCreateGameRoom_select_image: @"game_middle_road_select",
                               kkCreateGameRoom_title: @"中路",
                               kkCreateGameRoom_param_data: @"MID",
                               },
                             @{kkCreateGameRoom_normal_image: @"game_down_road_unselect",
                               kkCreateGameRoom_select_image: @"game_down_road_select",
                               kkCreateGameRoom_title: @"下路",
                               kkCreateGameRoom_param_data: @"ADC",
                               },
                             @{kkCreateGameRoom_normal_image: @"game_assist_unselect",
                               kkCreateGameRoom_select_image: @"game_assist_select",
                               kkCreateGameRoom_title: @"辅助",
                               kkCreateGameRoom_param_data: @"SUP",
                               },
                             @{kkCreateGameRoom_normal_image: @"game_wild_unselect",
                               kkCreateGameRoom_select_image: @"game_wild_select",
                               kkCreateGameRoom_title: @"打野",
                               kkCreateGameRoom_param_data: @"JUG",
                               }];
        }
            break;
        case 3:
        {
            if (self.depositPrice) {
                sectionDatas = @[@{kkCreateGameRoom_title: [NSString stringWithFormat:@"%@K币/人", self.depositPrice],
                                   kkCreateGameRoom_param_data: @"CHARGE_FOR_BOARD",
                                   },
                                 @{kkCreateGameRoom_title: @"免费",
                                   kkCreateGameRoom_param_data: @"FREE_FOR_BOARD",
                                   }];
            } else {
                sectionDatas = @[@{kkCreateGameRoom_title: @"免费",
                                   kkCreateGameRoom_param_data: @"FREE_FOR_BOARD",
                                   }];
            }
        }
            break;
            
        default:
            sectionDatas = @[];
            break;
    }
    
    return sectionDatas;
}

@end
