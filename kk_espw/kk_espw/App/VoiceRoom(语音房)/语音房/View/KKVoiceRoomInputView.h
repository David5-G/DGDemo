//
//  KKVoiceRoomInputView.h
//  kk_espw
//
//  Created by david on 2019/7/18.
//  Copyright © 2019 david. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, KKInputViewThemeStyle) {
    KKInputViewThemeStyleDefault,//默认,button都是灰色的
    KKInputViewThemeStyleDark,//深色模式,button都是白色的
};

#define KKInputViewToolButtonSpeaker @"KKInputViewToolButtonSpeaker"
#define KKInputViewToolButtonMic     @"KKInputViewToolButtonMic"
#define KKInputViewToolButtonShare   @"KKInputViewToolButtonShare"
#define KKInputViewToolButtonBroom   @"KKInputViewToolButtonBroom"

#pragma mark -
@class KKVoiceRoomInputView;
@protocol KKVoiceRoomInputViewDelegate <NSObject>
@optional
-(void)inputView:(KKVoiceRoomInputView *)inputView tryToSendText:(NSString *)text;
-(void)inputView:(KKVoiceRoomInputView *)inputView didClickBroom:(UIButton *)button;
-(void)inputView:(KKVoiceRoomInputView *)inputView didClickShare:(UIButton *)button;
-(void)inputView:(KKVoiceRoomInputView *)inputView openMic:(BOOL)isOpen;
-(void)inputView:(KKVoiceRoomInputView *)inputView openSpeaker:(BOOL)isOpen;
@end


#pragma mark -
@interface KKVoiceRoomInputView : UIView
///右侧工具条 按钮数组
@property (nonatomic, strong) NSArray<NSString *> *rightToolButtons;
@property (nonatomic, strong, readonly) DGButton *micButton;
@property (nonatomic, strong, readonly) DGButton *speakerButton;
///UI风格
@property (nonatomic, assign) KKInputViewThemeStyle themeStyle;
///代理
@property (nonatomic, weak) id<KKVoiceRoomInputViewDelegate> delegate;
/** 清空输入 */
-(void)clearInputText;
/** 结束输入 */
-(void)stopInput;
/** 设置leftToolView的subview (width是subview的宽)*/
-(void)setLeftToolSubview:(nullable UIView *)subview width:(CGFloat)width;
@end

NS_ASSUME_NONNULL_END
