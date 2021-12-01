//
//  KKChatRoomMicPositionMsg.m
//  kk_espw
//
//  Created by 阿杜 on 2019/8/12.
//  Copyright © 2019 david. All rights reserved.
//

#import "KKChatRoomMicPositionMsg.h"

@implementation KKChatRoomMicPositionMsg

#pragma mark - RCMessageCoding
/// NSCoding
- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super init];
    if (self) {
        self.micChangeType = [aDecoder decodeObjectForKey:@"micChangeType"];
        self.fromChangeUserId = [aDecoder decodeObjectForKey:@"fromChangeUserId"];
        self.toChangeUserId = [aDecoder decodeObjectForKey:@"toChangeUserId"];
        self.extra = [aDecoder decodeObjectForKey:@"extra"];
    }
    return self;
}

/// NSCoding
- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:self.micChangeType forKey:@"micChangeType"];
    [aCoder encodeObject:self.fromChangeUserId forKey:@"fromChangeUserId"];
    [aCoder encodeObject:self.toChangeUserId forKey:@"toChangeUserId"];
    [aCoder encodeObject:self.extra forKey:@"extra"];
}

///将消息内容编码成json
- (NSData *)encode {
    NSMutableDictionary *dataDict = [NSMutableDictionary dictionary];
    if (self.micChangeType) {
        [dataDict setObject:self.micChangeType forKey:@"micChangeType"];
    }
    
    if (self.fromChangeUserId) {
        [dataDict setObject:self.fromChangeUserId forKey:@"fromChangeUserId"];
    }
    
    if (self.toChangeUserId) {
        [dataDict setObject:self.toChangeUserId forKey:@"toChangeUserId"];
    }
    
    if (self.extra) {
        [dataDict setObject:self.extra forKey:@"extra"];
    }
    
    if (self.senderUserInfo) {
        [dataDict setObject:[self encodeUserInfo:self.senderUserInfo] forKey:@"user"];
    }
    
    NSData *data = [NSJSONSerialization dataWithJSONObject:dataDict options:kNilOptions error:nil];
    return data;
}

///将json解码生成消息内容
- (void)decodeWithData:(NSData *)data {
    if (data) {
        __autoreleasing NSError *error = nil;
        
        NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
        
        if (dictionary) {
            self.micChangeType = dictionary[@"micChangeType"];
            self.fromChangeUserId = dictionary[@"fromChangeUserId"];
            self.toChangeUserId = dictionary[@"toChangeUserId"];
            self.extra = dictionary[@"extra"];
            
            NSDictionary *userinfoDic = dictionary[@"user"];
            [self decodeUserInfo:userinfoDic];
        }
    }
}

///消息的类型名
+ (NSString *)getObjectName
{
    return KKChatRoomMicPositionMsgId;
}

// 这里返回的关键内容列表将用于消息搜索，自定义消息必须要实现此接口才能进行搜索。

- (NSArray<NSString *> *)getSearchableWords
{
    NSMutableArray *arr = [[NSMutableArray alloc] init];
    if (self.micChangeType) {
        [arr addObject:self.micChangeType];
    }
    if (self.fromChangeUserId) {
        [arr addObject:self.fromChangeUserId];
    }
    if (self.toChangeUserId) {
        [arr addObject:self.toChangeUserId];
    }
    if (self.extra) {
        [arr addObject:self.extra];
    }
    return arr.mutableCopy;
}

#pragma mark -RCMessagePersistentCompatible
///消息是否存储，是否计入未读数
+ (RCMessagePersistent)persistentFlag {
    return MessagePersistent_ISCOUNTED;
}

#pragma mark - RCMessageContentView
/// 会话列表中显示的摘要
- (NSString *)conversationDigest {
    return @"";
}


@end

