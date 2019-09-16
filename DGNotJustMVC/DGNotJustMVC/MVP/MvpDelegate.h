//
//  MvpDelegate.h
//  DGNotJustMVC
//
//  Created by David.G on 2019/7/10.
//  Copyright © 2019 David.G. All rights reserved.
//

#ifndef MvpDelegate_h
#define MvpDelegate_h


@protocol MvpDelegate <NSObject>

@optional
// UI(num) ---> model,  ui改变调整model
- (void)didClickAddBtnWithNum:(NSString *)num indexPath:(NSIndexPath *)indexPath;

// 当某条件下model会改变 ---> 刷新UI,  model改变调整UI
- (void)refreshUI;

@end



#endif /* MvpDelegate_h */
