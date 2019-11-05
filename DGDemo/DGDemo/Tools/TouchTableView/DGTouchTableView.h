//
//  DGTouchTableView.h
//  DGDemo
//
//  Created by david on 2018/10/17.
//  Copyright © 2018 david. All rights reserved.
//

@protocol DGTouchTableViewDelegate<NSObject>

@optional
- (void)tableView:(UITableView *)tableView
     touchesBegan:(NSSet *)touches
        withEvent:(UIEvent *)event;

- (void)tableView:(UITableView *)tableView
 touchesCancelled:(NSSet *)touches
        withEvent:(UIEvent *)event;

- (void)tableView:(UITableView *)tableView
     touchesEnded:(NSSet *)touches
        withEvent:(UIEvent *)event;

- (void)tableView:(UITableView *)tableView
     touchesMoved:(NSSet *)touches
        withEvent:(UIEvent *)event;

@end


#import <UIKit/UIKit.h>

@interface DGTouchTableView : UITableView

@property (nonatomic,weak) id<DGTouchTableViewDelegate> touchDelegate;

@end
