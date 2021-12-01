//
//  UIView+WaterSpread.m
//  XTest_LayerAnimate
//
//  Created by hsd on 2019/10/21.
//  Copyright © 2019 hsd. All rights reserved.
//

#import "UIView+WaterSpread.h"

@implementation UIView (WaterSpread)

#pragma mark - Public
- (void)startWaterSpreadAnimation {
    CAReplicatorLayer *replcatorLayer = [self waterSpreadAnimationLayer];
//    [self.layer addSublayer:replcatorLayer];
    [self.layer insertSublayer:replcatorLayer atIndex:0];
}

- (void)stopWaterSpreadAnimation {
    NSArray<CALayer *> *layerArray = [self.layer.sublayers copy];
    for (CALayer *subLayer in layerArray) {
        if ([subLayer isKindOfClass:[CAReplicatorLayer class]]) {
            [subLayer removeAllAnimations];
            [subLayer removeFromSuperlayer];
        }
    }
}

#pragma mark - Private
- (CABasicAnimation *)alphaAnimation{
    CABasicAnimation *alpha = [CABasicAnimation animationWithKeyPath:@"opacity"];
    alpha.fromValue = @(0.4);
    alpha.toValue = @(0.0);
    return alpha;
}

- (CABasicAnimation *)scaleAnimation {
    CABasicAnimation *scale = [CABasicAnimation animationWithKeyPath:@"transform"];
    CATransform3D identiity = CATransform3DIdentity;
    scale.fromValue = [NSValue valueWithCATransform3D:CATransform3DScale(identiity, 1.0, 1.0, 0.0)];
    scale.toValue = [NSValue valueWithCATransform3D:CATransform3DScale(identiity, 1.5, 1.5, 1.0)];
    return scale;
}

- (CAReplicatorLayer *)waterSpreadAnimationLayer {
    
    CGFloat width = self.bounds.size.width;
    
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    shapeLayer.frame = CGRectMake(0, 0, width, width);
    shapeLayer.path = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(0, 0, width, width)].CGPath;
    shapeLayer.fillColor = KKES_COLOR_MAIN_YELLOW.CGColor;
    shapeLayer.opacity = 0.0;
    
    CAAnimationGroup *animationGroup = [CAAnimationGroup animation];
    animationGroup.animations = @[[self alphaAnimation],[self scaleAnimation]];
    animationGroup.duration = 2.0;
    animationGroup.autoreverses = NO;
    animationGroup.repeatCount = HUGE;
    
    [shapeLayer addAnimation:animationGroup forKey:@"animationGroup"];
    
    CAReplicatorLayer *replicatorLayer = [CAReplicatorLayer layer];
    replicatorLayer.frame = CGRectMake(0, 0, width, width);
    replicatorLayer.instanceDelay = 0.5;
    replicatorLayer.instanceCount = 4;
    [replicatorLayer addSublayer:shapeLayer];
    
    return replicatorLayer;
}

@end
