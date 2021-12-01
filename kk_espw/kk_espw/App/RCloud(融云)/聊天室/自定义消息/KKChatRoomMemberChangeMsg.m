//
//  KKChatRoomMemberChangeMsg.m
//  kk_espw
//
//  Created by 阿杜 on 2019/8/12.
//  Copyright © 2019 david. All rights reserved.
//

#import "KKChatRoomMemberChangeMsg.h"

@implementation KKChatRoomMemberChangeMsg

#pragma mark - RCMessageCoding
/// NSCoding
- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super init];
    if (self) {
        self.changeType = [aDecoder decodeObjectForKey:@"changeType"];
        self.changeUserId = [aDecoder decodeObjectForKey:@"changeUserId"];
    }
    return self;
}

/// NSCoding
- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:self.changeType forKey:@"changeType"];
    [aCoder encodeObject:self.changeUserId forKey:@"changeUserId"];
}

///将消息内容编码成json
- (NSData *)encode {
    NSMutableDictionary *dataDict = [NSMutableDictionary dictionary];
    if (self.changeType) {
        [dataDict setObject:self.changeType forKey:@"changeType"];
    }
    
    if (self.changeUserId) {
        [dataDict setObject:self.changeUserId forKey:@"changeUserId"];
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
            self.changeType = dictionary[@"changeType"];
            self.changeUserId = dictionary[@"changeUserId"];
            
            NSDictionary *userinfoDic = dictionary[@"user"];
            [self decodeUserInfo:userinfoDic];
        }
    }
}

///消息的类型名
+ (NSString *)getObjectName
{
    return KKChatRoomMemberChangeMsgId;
}

// 这里返回的关键内容列表将用于消息搜索，自定义消息必须要实现此接口才能进行搜索。

- (NSArray<NSString *> *)getSearchableWords
{
    NSMutableArray *arr = [[NSMutableArray alloc] init];
    if (self.changeType) {
        [arr addObject:self.changeType];
    }
    if (self.changeUserId) {
        [arr addObject:self.changeUserId];
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


