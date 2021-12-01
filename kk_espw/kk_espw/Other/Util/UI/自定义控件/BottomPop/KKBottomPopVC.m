//
//  KKBottomPopVC.m
//  kk_espw
//
//  Created by david on 2019/10/22.
//  Copyright © 2019 david. All rights reserved.
//

#import "KKBottomPopVC.h"

@interface KKBottomPopVC ()<UIGestureRecognizerDelegate>
{
    CGFloat _leftSpace;
    CGFloat _cornerRadii;
}
@property (nonatomic, strong) UIView *displayView;
@end

@implementation KKBottomPopVC

#pragma mark - life circle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setDimension];
    [self addTapGuesture];
}

#pragma mark - UI
-(void)setDimension {
    _leftSpace = [ccui getRH:10];
    _cornerRadii = [ccui getRH:10];
}

-(void)setDisplayViewHeight:(CGFloat)height {
    
    CGFloat maxH = self.view.frame.size.height;
    CGFloat maxW = self.view.frame.size.width;
    
    //1.frame调整
    CGFloat displayH =  height > maxH*0.9 ? maxH*0.9 :  height;
    CGRect displayFrame = CGRectMake(_leftSpace, maxH, maxW-2*_leftSpace, displayH);
    
    //2.创建
    self.displayView = [[UIView alloc]initWithFrame:displayFrame];
    self.displayView.backgroundColor = UIColor.whiteColor;
    [self.view addSubview:self.displayView];
    
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


-(void)addTapGuesture {
    self.view.backgroundColor = RGBA(51, 51, 51, 0.5);
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(removeSelf)] ;
    tap.delegate = self;
    [self.view addGestureRecognizer:tap];
}

#pragma mark  interaction
-(void)removeSelf {
    
    //0.block
    if(self.willRomoveSelfBlock){
        self.willRomoveSelfBlock();
    }
    
    //1.动画
    WS(weakSelf);
    CGRect frame = weakSelf.displayView.frame;
    frame.origin.y = weakSelf.view.height;
    [UIView animateWithDuration:0.3 animations:^{
        weakSelf.displayView.frame = frame;
        
    } completion:^(BOOL finished) {
        //2.完成后移除
        [weakSelf.view removeFromSuperview];
        [weakSelf removeFromParentViewController];
    }];
}


-(void)showSelf {
    //1.设置displayView
    [self setupSubViewsForDisplayView:self.displayView];
    
    //2.动画
    WS(weakSelf);
    CGRect frame = weakSelf.displayView.frame;
    frame.origin.y = weakSelf.view.height-frame.size.height;
    [UIView animateWithDuration:0.3 animations:^{
        weakSelf.displayView.frame = frame;
    }];
    
}
 

#pragma mark delegate
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
