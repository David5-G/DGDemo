//
//  KKChatRoomCustomMsg.m
//  kk_espw
//
//  Created by 阿杜 on 2019/8/12.
//  Copyright © 2019 david. All rights reserved.
//

#import "KKChatRoomCustomMsg.h"

@implementation KKChatRoomCustomMsg
+(instancetype)messageWithChatRoomId:(NSString *)chatroomId content:(NSString *)content withUserId:(NSString *)userId msgType:(NSString *)msgType
{
    KKChatRoomCustomMsg *msg = [KKChatRoomCustomMsg new];
    if (chatroomId) {
        msg.chatroomId = chatroomId;
    }
    
    if (content) {
        msg.content = content;
    }
    
    if (userId) {
        msg.fromUserId = userId;
    }
    
    if (msgType) {
        msg.msgType = msgType;
    }
    
    return msg;
}

#pragma mark - RCMessageCoding
/// NSCoding
- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super init];
    if (self) {
        self.fromUserId = [aDecoder decodeObjectForKey:@"fromUserId"];
        self.chatroomId = [aDecoder decodeObjectForKey:@"chatroomId"];
        self.content = [aDecoder decodeObjectForKey:@"content"];
        self.msgType = [aDecoder decodeObjectForKey:@"msgType"];
        self.extra = [aDecoder decodeObjectForKey:@"extra"];
    }
    return self;
}

/// NSCoding
- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:self.fromUserId forKey:@"fromUserId"];
    [aCoder encodeObject:self.chatroomId forKey:@"chatroomId"];
    [aCoder encodeObject:self.content forKey:@"content"];
    [aCoder encodeObject:self.msgType forKey:@"msgType"];
    [aCoder encodeObject:self.extra forKey:@"extra"];
}

///将消息内容编码成json
- (NSData *)encode {
    NSMutableDictionary *dataDict = [NSMutableDictionary dictionary];
    if (self.fromUserId) {
        [dataDict setObject:self.fromUserId forKey:@"fromUserId"];
    }
    
    if (self.chatroomId) {
        [dataDict setObject:self.chatroomId forKey:@"chatroomId"];
    }
    
    if (self.content) {
        [dataDict setObject:self.content forKey:@"content"];
    }
    
    if (self.msgType) {
        [dataDict setObject:self.msgType forKey:@"msgType"];
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
            self.fromUserId = dictionary[@"fromUserId"];
            self.chatroomId = dictionary[@"chatroomId"];
            self.content = dictionary[@"content"];
            self.msgType = dictionary[@"msgType"];
            self.extra = dictionary[@"extra"];
            
            NSDictionary *userinfoDic = dictionary[@"user"];
            [self decodeUserInfo:userinfoDic];
        }
    }
}

///消息的类型名
+ (NSString *)getObjectName
{
    return KKChatRoomGameStatusMessageTypeIdentifier;
}

// 这里返回的关键内容列表将用于消息搜索，自定义消息必须要实现此接口才能进行搜索。

- (NSArray<NSString *> *)getSearchableWords
{
    NSMutableArray *arr = [[NSMutableArray alloc] init];
    if (self.fromUserId) {
        [arr addObject:self.fromUserId];
    }
    if (self.chatroomId) {
        [arr addObject:self.chatroomId];
    }
    if (self.content) {
        [arr addObject:self.content];
    }
    if (self.msgType) {
        [arr addObject:self.msgType];
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
    return @"[聊天室状态改变]";
}


@end
