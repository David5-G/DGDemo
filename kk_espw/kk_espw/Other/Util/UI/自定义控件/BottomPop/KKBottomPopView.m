//
//  KKBottomPopView.m
//  kk_espw
//
//  Created by david on 2019/7/24.
//  Copyright © 2019 david. All rights reserved.
//

#import "KKBottomPopView.h"

@interface KKBottomPopView ()<UIGestureRecognizerDelegate>
{
    CGFloat _leftSpace;
    CGFloat _cornerRadii;
}

@property (nonatomic, strong) UIView *displayView;

@end

@implementation KKBottomPopView

-(instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    if (self) {
        
        [self setDimension];
        [self setupSelf];
        [self setupDisplayView:frame];
    }
    return self;
}

#pragma mark - UI
-(void)setDimension {
    _leftSpace = [ccui getRH:10];
    _cornerRadii = [ccui getRH:10];
}

-(void)setupSelf {
    self.backgroundColor = RGBA(51, 51, 51, 0.5);
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hidePopView)] ;
    tap.delegate = self;
    [self addGestureRecognizer:tap];
}

-(void)setupDisplayView:(CGRect)frame {
    
    //1.frame调整
    CGFloat height =  frame.size.height > SCREEN_HEIGHT*0.9 ? SCREEN_HEIGHT*0.9 :  frame.size.height;
    CGRect displayFrame = CGRectMake(_leftSpace, self.frame.size.height, self.frame.size.width-2*_leftSpace, height);
    
    //2.创建
    self.displayView = [[UIView alloc]initWithFrame:displayFrame];
    self.displayView.backgroundColor = UIColor.whiteColor;
    [self addSubview:self.displayView];
    
    //3.圆角处理
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:self.displayView.bounds byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight cornerRadii:CGSizeMake(_cornerRadii, _cornerRadii)];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc]init];
    maskLayer.frame = self.displayView.bounds;
    maskLayer.path = maskPath.CGPath;
    self.displayView.layer.mask = maskLayer;
}

/** 子类重写此方法, 布局subView */
-(void)setupSubViewsForDisplayView:(UIView *)displayView {
    
    DGLabel *label = [DGLabel labelWithText:@"子类要重写\nsetupSubViewsForDisplayView:方法" fontSize:19 color:UIColor.purpleColor];
    label.numberOfLines = 0;
    label.textAlignment = NSTextAlignmentCenter;
    label.frame = CGRectMake(10, 10, displayView.frame.size.width-20, 50);
    [displayView addSubview:label];
}


#pragma mark - interaction

-(void)showPopView {
    
    UIWindow* window = [UIApplication sharedApplication].keyWindow;
    [window addSubview:self];
    [self setupSubViewsForDisplayView:self.displayView];
    
    WS(weakSelf);
    CGRect frame = weakSelf.displayView.frame;
    frame.origin.y = weakSelf.height-frame.size.height;
    [UIView animateWithDuration:0.3 animations:^{
        weakSelf.displayView.frame = frame;
    }];
    
}

-(void)hidePopView {
    
    WS(weakSelf);
    CGRect frame = weakSelf.displayView.frame;
    frame.origin.y = weakSelf.height;
    [UIView animateWithDuration:0.3 animations:^{
        weakSelf.displayView.frame = frame;
    } completion:^(BOOL finished) {
        [weakSelf removeFromSuperview];
    }];
}


#pragma mark - delegate
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    
    if(self.forbidTapHidden){
        return NO;
    }
    if ([touch.view isDescendantOfView:self.displayView]) {
        return NO ;
    }
    return YES ;
}

@end
