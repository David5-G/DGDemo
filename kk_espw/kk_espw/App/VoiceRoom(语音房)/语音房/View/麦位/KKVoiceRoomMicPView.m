//
//  KKVoiceRoomMicPView.m
//  kk_espw
//
//  Created by david on 2019/10/16.
//  Copyright © 2019 david. All rights reserved.
//

#import "KKVoiceRoomMicPView.h"

@interface KKVoiceRoomMicPView ()
@property (nonatomic, strong) NSArray <KKVoiceRoomMicPItemView *>*micPs;
@end

@implementation KKVoiceRoomMicPView

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
    
    NSInteger rowItemCount = 3;
    CGFloat itemW = [ccui getRH:80];
    CGFloat itemH = [ccui getRH:96];
    CGFloat leftSpace = [ccui getRH:32];
    CGFloat spaceX = (SCREEN_WIDTH - itemW*rowItemCount - 2*leftSpace)/2.0;
    CGFloat spaceY = [ccui getRH:8];
    NSMutableArray *mArr = [NSMutableArray arrayWithCapacity:6];
    for (NSInteger i=0; i<6; i++) {
        CGRect frame = CGRectMake(leftSpace+(i%rowItemCount)*(itemW+spaceX), 0+(i/rowItemCount)*(itemH+spaceY), itemW, itemH);
        KKVoiceRoomMicPItemView *itemV = [[KKVoiceRoomMicPItemView alloc]initWithFrame:frame];
        itemV.isHost = NO;
        itemV.isSpeaking = NO;
        [self addSubview:itemV];
        
        //tapBlock
        WS(weakSelf)
        itemV.tapPortraitBlock = ^(KKVoiceRoomMicPItemView * _Nonnull itemView) {
            if (weakSelf.tapMicPItemBlock) {
                weakSelf.tapMicPItemBlock(i, itemView);
            }
        };
        //添加到数组
        [mArr addObject:itemV];
    }
    
    //保存items
    self.micPs = mArr;
}


#pragma mark - public

-(KKVoiceRoomMicPItemView *)getItemViewAtIndex:(NSInteger)index {
    if (index >= self.micPs.count) {
        return nil;
    }
    return self.micPs[index];
}


-(KKVoiceRoomMicPItemView *)getItemViewWithTag:(NSInteger)tag {
    KKVoiceRoomMicPItemView *view = [self viewWithTag:tag];
    if ([view isMemberOfClass:[KKVoiceRoomMicPItemView class]]) {
        return view;
    }
    return nil;
}

-(KKVoiceRoomMicPItemView *)changeMicPItemStatus:(KKVoiceRoomMicPStatus)status tag:(NSInteger)tag {
    //1.获取
    KKVoiceRoomMicPItemView *itemV = [self getItemViewWithTag:tag];
    //2.过滤空
    if (!itemV) {
        return nil;
    }
    //3.改变renturn
    itemV.status = status;
    return itemV;
}

@end
