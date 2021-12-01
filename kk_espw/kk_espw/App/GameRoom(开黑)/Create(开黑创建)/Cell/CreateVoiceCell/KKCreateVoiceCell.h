//
//  KKCreateVoiceCell.h
//  kk_espw
//
//  Created by jingtian9 on 2019/10/14.
//  Copyright © 2019 david. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
typedef void(^tapRandomNumButttonBlock)(void);
typedef void(^tfInputBlock)(NSString *text);
@interface KKCreateVoiceCell : UITableViewCell
@property (nonatomic, copy) NSString *declarationStr;
@property (nonatomic, copy) tapRandomNumButttonBlock tapRandomNumButttonBlock;
@property (nonatomic, copy) tfInputBlock tfInputBlock;
@end

NS_ASSUME_NONNULL_END
