//
//  UIView+HitTest.m
//  DGDemo
//
//  Created by david on 2018/10/17.
//  Copyright © 2018 david. All rights reserved.
//

#import "UIView+HitTest.h"
#import <objc/runtime.h>

@implementation UIView (HitTest)

+(void)load {
    //[self exchangeHitTestMethod];
}


+ (void)exchangeHitTestMethod {
    Method originPoint = class_getInstanceMethod([self class], @selector(pointInside:withEvent:));
    Method customPoint = class_getInstanceMethod([self class], @selector(dg_pointInside:withEvent:));
    method_exchangeImplementations(originPoint, customPoint);
    
    Method originHit = class_getInstanceMethod([self class], @selector(hitTest:withEvent:));
    Method customHit = class_getInstanceMethod([self class], @selector(dg_hitTest:withEvent:));
    method_exchangeImplementations(originHit, customHit);
}

- (BOOL)dg_pointInside:(CGPoint)point withEvent:(UIEvent *)event{
    
    BOOL canAnswer = [self dg_pointInside:point withEvent:event];
    NSLog(@"%@ can answer: %d",self.class,canAnswer);
    return canAnswer;
}

- (UIView *)dg_hitTest:(CGPoint)point withEvent:(UIEvent *)event{
    
    UIView *answerView = [self dg_hitTest:point withEvent:event];
    NSLog(@"hit view :%@",self.class);
    return answerView;
}

@end
