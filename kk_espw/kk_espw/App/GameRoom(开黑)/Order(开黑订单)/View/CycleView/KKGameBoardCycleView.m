//
//  KKGameBoardCycleView.m
//  kk_espw
//
//  Created by jingtian9 on 2019/10/23.
//  Copyright © 2019 david. All rights reserved.
//

#import "KKGameBoardCycleView.h"

@interface KKGameBoardCycleView ()
@property (nonatomic, strong) UIImageView *cycleV;
@end

@implementation KKGameBoardCycleView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        NSMutableArray *imgArr = [NSMutableArray arrayWithCapacity:4];
        for (NSInteger i = 1; i < 5; i ++) {
            NSString *imgStr = [NSString stringWithFormat:@"voice_gif_voice_%02ld",(long)i];
            [imgArr addObject:Img(imgStr)];
        }
        
        self.cycleV = [[UIImageView alloc]initWithImage:imgArr.firstObject];
        self.cycleV.animationImages = imgArr;
        self.cycleV.animationDuration = 0.1*imgArr.count;
        self.cycleV.animationRepeatCount = 0;
        self.cycleV.frame = CGRectMake(0, 0, RH(39.5), RH(39.5));
        [self addSubview:self.cycleV];
    }
    return self;
}

- (void)layoutSubviews {
    
}

- (void)startAnimate {
    self.cycleV.hidden = NO;
    [self.cycleV startAnimating];
}

- (void)stopAnimate {
    self.cycleV.hidden = YES;
    [self.cycleV stopAnimating];
}

@end
