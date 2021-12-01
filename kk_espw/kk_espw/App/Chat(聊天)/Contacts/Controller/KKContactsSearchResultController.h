//
//  KKContactsSearchResultControllerViewController.h
//  kk_espw
//
//  Created by 阿杜 on 2019/7/18.
//  Copyright © 2019 david. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface KKContactsSearchResultController : UITableViewController<UISearchResultsUpdating>
@property (nonatomic,retain) NSArray *contactsSearchResultArr;
@end

NS_ASSUME_NONNULL_END
