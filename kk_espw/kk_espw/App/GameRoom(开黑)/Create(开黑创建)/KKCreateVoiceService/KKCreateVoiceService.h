//
//  KKCreateVoiceService.h
//  kk_espw
//
//  Created by jingtian9 on 2019/10/14.
//  Copyright © 2019 david. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
typedef void(^successBlock)(NSString *roomId, NSString *channelId);
typedef void(^failBlock)(void);
@interface KKCreateVoiceService : NSObject
@property (nonatomic, copy) successBlock successComplete;
@property (nonatomic, copy) failBlock failComplete;

+ (void)requestVoiceChatRoomDeclarationDataWithSuccess:(void (^)(NSMutableArray * _Nonnull))success fail:(nonnull void (^)(void))fail;
+ (void)requestCreateVoiceRoomWithDeclaration:(NSString *)declaration Success:(successBlock)success fail:(failBlock)fail;

@end

NS_ASSUME_NONNULL_END
