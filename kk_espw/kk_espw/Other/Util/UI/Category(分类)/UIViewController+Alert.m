//
//  UIViewController+Alert.m
//
//  Created by david on 2018/11/29.
//  Copyright © 2018 david. All rights reserved.
//

#import "UIViewController+Alert.h"
#import <objc/runtime.h>

static const char *associatedAlertKey = "associatedAlertKey";

@implementation UIViewController (DGAlert)

#pragma mark - 关联对象
-(void)setAssociatedAlert:(UIAlertController *)alert{
    objc_setAssociatedObject(self, associatedAlertKey, alert, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

-(id)associatedAlert {
    UIAlertController *alert = objc_getAssociatedObject(self, associatedAlertKey);
    return alert;
}


#pragma mark - 警告框 提醒
-(void)alertWithTitle:(NSString *)title message:(NSString *)message{
    [self alertWithTitle:title message:message duration:1.0f];
}

/** 显示警告框 */
-(void)alertWithTitle:(NSString *)title message:(NSString *)message duration:(float)duration{
    //1.创建AlertController
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    //设置关联对象
    [self setAssociatedAlert:alert];
    
    
    if(title.length){
        NSMutableAttributedString *attributedTitleStr = [[NSMutableAttributedString alloc] initWithString:title];
        [attributedTitleStr addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:16] range:NSMakeRange(0, title.length)];
        [alert setValue:attributedTitleStr forKey:@"attributedTitle"];
    }
    
    if (message.length) {
        NSMutableAttributedString *attributedMsgStr = [[NSMutableAttributedString alloc] initWithString:message];
        [attributedMsgStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:15] range:NSMakeRange(0, message.length)];
        [alert setValue:attributedMsgStr forKey:@"attributedMessage"];
    }
    
    //2.显示AlertController
    [self presentViewController:alert animated:YES completion:nil];
    
    //3.定时收起警告框
    [NSTimer scheduledTimerWithTimeInterval:duration target:self selector:@selector(performDismiss) userInfo:nil repeats:NO];
}

/** 收起警告框 */
-(void) performDismiss{
    UIAlertController *alert = [self associatedAlert];
    [alert dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - 警告框 操作
/** 设定title msg */
-(void)alert:(UIAlertControllerStyle)style title:(NSString *)title msg:(NSString *)msg actions:(NSArray<UIAlertAction *> *)actions {
    
    [self alert:style title:title titleFont:[UIFont boldSystemFontOfSize:17.0] msg:msg msgFont:[UIFont systemFontOfSize:15.0] actions:actions];
}

/** 设定title msg 及其font */
-(void)alert:(UIAlertControllerStyle)style title:(NSString *)title titleFont:(UIFont *)titleFont msg:(NSString *)msg msgFont:(UIFont *)msgFont actions:(NSArray<UIAlertAction *> *)actions {
    
    UIColor *textBlackColor = [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1.0];
    [self alert:style title:title titleFont:titleFont titleColor:textBlackColor msg:msg msgFont:msgFont msgColor:textBlackColor actions:actions];
}

/** 设定title msg 及其font,color */
-(void)alert:(UIAlertControllerStyle)style title:(NSString *)title titleFont:(UIFont *)titleFont titleColor:(UIColor *)titleColor msg:(NSString *)msg msgFont:(UIFont *)msgFont msgColor:(UIColor *)msgColor actions:(NSArray<UIAlertAction *> *)actions {
    
    //1.创建AlertController
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:msg preferredStyle:style];
    
    //title
    if(title.length){
        NSRange titleRange = NSMakeRange(0, title.length);
        NSMutableAttributedString *attributedTitleStr = [[NSMutableAttributedString alloc] initWithString:title];
        [attributedTitleStr addAttribute:NSFontAttributeName value:titleFont range:titleRange];
        [attributedTitleStr addAttribute:NSForegroundColorAttributeName value:titleColor range:titleRange];
        [alert setValue:attributedTitleStr forKey:@"attributedTitle"];
    }
    //message
    if (msg.length) {
        NSRange msgRange = NSMakeRange(0, msg.length);
        NSMutableAttributedString *attributedMsgStr = [[NSMutableAttributedString alloc] initWithString:msg];
        [attributedMsgStr addAttribute:NSFontAttributeName value:msgFont range:msgRange];
        [attributedMsgStr addAttribute:NSForegroundColorAttributeName value:msgColor range:msgRange];
        [alert setValue:attributedMsgStr forKey:@"attributedMessage"];
    }
    
    //2.添加action
    for (NSInteger i=0; i<actions.count; i++) {
        [alert addAction:actions[i]];
    }
    
    //3.显示AlertController
    [self presentViewController:alert animated:YES completion:nil];
}


- (NSMutableAttributedString *)getAttrStr:(NSString *)originalStr
                                frontFont:(float)frontFont
                                    aFont:(float)aFont
                                   aIndex:(float)aIndex{
    NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:originalStr];
    [attrStr addAttribute:NSFontAttributeName value:RF(frontFont) range:NSMakeRange(0, originalStr.length - aIndex)];
    [attrStr addAttribute:NSFontAttributeName value:RF(aFont) range:NSMakeRange(originalStr.length - aIndex, aIndex)];
    return attrStr;
}
@end
