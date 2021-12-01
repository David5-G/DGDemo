//
//  KKLiveStudioMicPositionView.h
//  kk_espw
//
//  Created by david on 2019/7/18.
//  Copyright © 2019 david. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class KKLiveStudioMicPositionView;

@protocol KKLiveStudioMicPositionViewDelegate <NSObject>

-(void)didClickHostButton:(KKLiveStudioMicPositionView *)micPositionView;
-(void)didClickGuestButton:(KKLiveStudioMicPositionView *)micPositionView;

@end

typedef NS_ENUM(NSUInteger, KKLiveStudioMicPStatus) {
    KKLiveStudioMicPStatusAbsent = 1,//虚以待位
    KKLiveStudioMicPStatusPresent,//在位
    KKLiveStudioMicPStatusClose,//关闭
};


@interface KKLiveStudioMicPositionView : UIView

@property (nonatomic, weak) id<KKLiveStudioMicPositionViewDelegate> delegate;
//host
@property (nonatomic, copy) NSString *hostName;
@property (nonatomic, copy) NSString *hostlogoUrl;
@property (nonatomic, assign) KKLiveStudioMicPStatus hostStatus;
@property (nonatomic, assign) BOOL hostSpeaking;

//guest
@property (nonatomic, copy) NSString *guestName;
@property (nonatomic, copy) NSString *guestlogoUrl;
@property (nonatomic, assign) KKLiveStudioMicPStatus guestStatus;
@property (nonatomic, assign) BOOL guestSpeaking;
 
@end

NS_ASSUME_NONNULL_END
