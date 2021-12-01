//
//  KKLiveStatuView.m
//  kk_espw
//
//  Created by 景天 on 2019/7/26.
//  Copyright © 2019年 david. All rights reserved.
//

#import "KKLiveStatusView.h"

@interface KKLiveStatusView ()
@property (nonatomic, strong) UIImageView *redImgV;
@end

@implementation KKLiveStatusView
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        NSMutableArray *imgArr = [NSMutableArray arrayWithCapacity:4];
        for (NSInteger i = 1; i < 5; i ++) {
            NSString *imgStr = [NSString stringWithFormat:@"live_gif_redSexangle_%02ld",(long)i];
            [imgArr addObject:Img(imgStr)];
        }
        
        self.redImgV = [[UIImageView alloc]initWithImage:imgArr.firstObject];
        self.redImgV.animationImages = imgArr;
        self.redImgV.animationDuration = 0.1*imgArr.count;
        self.redImgV.animationRepeatCount = 0;
        self.redImgV.frame = CGRectMake(0, 0, frame.size.width, frame.size.height);
        [self addSubview:self.redImgV];
    }
    return self;
}

- (void)startAnimate {
    [self.redImgV startAnimating];
}

- (void)stopAnimate {
    [self.redImgV stopAnimating];
}
@end
