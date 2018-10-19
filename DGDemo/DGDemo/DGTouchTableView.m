//
//  DGTouchTableView.m
//  DGDemo
//
//  Created by david on 2018/10/17.
//  Copyright © 2018 david. All rights reserved.
//

#import "DGTouchTableView.h"

@implementation DGTouchTableView

//在touchesBegan的时候，让tableView.scrollEnabled = NO;然后在touchesEnd的时候，让tableView.scrollEnabled = YES;这么做的原因是为了避免在想要实现滑动效果的时候，会被uitableview的滚动个阻断掉，达不到预期效果

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    self.scrollEnabled = NO;
    [super touchesBegan:touches withEvent:event];
    
    if ([_touchDelegate conformsToProtocol:@protocol(DGTouchTableViewDelegate)] && [_touchDelegate respondsToSelector:@selector(tableView:touchesBegan:withEvent:)]) {
        [_touchDelegate tableView:self touchesBegan:touches withEvent:event];
    }
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [super touchesMoved:touches withEvent:event];
    
    if ([_touchDelegate conformsToProtocol:@protocol(DGTouchTableViewDelegate)] && [_touchDelegate respondsToSelector:@selector(tableView:touchesMoved:withEvent:)]) {
        [_touchDelegate tableView:self touchesMoved:touches withEvent:event];
    }
}

-(void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    self.scrollEnabled = YES;
    [super touchesCancelled:touches withEvent:event];
    
    if ([_touchDelegate conformsToProtocol:@protocol(DGTouchTableViewDelegate)] && [_touchDelegate respondsToSelector:@selector(tableView:touchesCancelled:withEvent:)]) {
        [_touchDelegate tableView:self touchesCancelled:touches withEvent:event];
    }
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    self.scrollEnabled = YES;
    [super touchesEnded:touches withEvent:event];
    
    if ([_touchDelegate conformsToProtocol:@protocol(DGTouchTableViewDelegate)] && [_touchDelegate respondsToSelector:@selector(tableView:touchesEnded:withEvent:)]) {
        [_touchDelegate tableView:self touchesEnded:touches withEvent:event];
    }
}

@end
