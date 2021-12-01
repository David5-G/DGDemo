//
//  KKHomeTeachView.m
//  kk_espw
//
//  Created by 阿杜 on 2019/8/12.
//  Copyright © 2019 david. All rights reserved.
//

#import "KKHomeTeachView.h"

@implementation KKHomeTeachView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        UIView *backgroundView = [[UIView alloc] initWithFrame:self.bounds];
        backgroundView.backgroundColor = [UIColor clearColor];
        [self addSubview:backgroundView];
        
        UIImageView *teachImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        teachImageView.image = Img(@"teachView3");
        teachImageView.userInteractionEnabled = YES;
        teachImageView.bottom = SCREEN_HEIGHT-HOME_INDICATOR_HEIGHT;
        [backgroundView addSubview:teachImageView];
        
        UIImageView *teachImageView2 = [[UIImageView alloc] initWithFrame:CGRectMake(0, RH(320 + 38), SCREEN_WIDTH, RH(210))];
        teachImageView2.image = Img(@"teachView2");
        WS(weakSelf)
        [teachImageView2 addTapWithTimeInterval:0.2 tapBlock:^(UIView * _Nonnull view) {
            [weakSelf removeFromSuperview];
        }];
        teachImageView2.userInteractionEnabled = YES;
        [backgroundView addSubview:teachImageView2];
        
        UIImageView *teachImageView1 = [[UIImageView alloc] initWithFrame:CGRectMake(RH(20), teachImageView2.top - RH(80), SCREEN_WIDTH - RH(40), RH(65))];
        teachImageView1.image = Img(@"teachView1");
        [backgroundView addSubview:teachImageView1];
        
    }
    return self;
}
@end
