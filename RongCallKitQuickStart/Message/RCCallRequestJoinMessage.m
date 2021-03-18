//
//  RCCallRequestJoinMessage.m
//  RongCallLib
//
//  Created by LiuLinhong on 2021/03/15.
//  Copyright © 2021 Rong Cloud. All rights reserved.
//

#import "RCCallRequestJoinMessage.h"

@implementation RCCallRequestJoinMessage

//初始化
- (instancetype)initWithUserId:(NSString *)userId {
    self = [super init];
    if (self) {
        self.userId = userId;
    }
    return self;
}

//消息是否存储，是否计入未读数
+ (RCMessagePersistent)persistentFlag {
    return MessagePersistent_NONE;
}

//将消息内容编码成json
- (NSData *)encode {
    NSMutableDictionary *dataDict = [NSMutableDictionary dictionary];
    [dataDict setObject:self.userId forKey:@"userId"];
    
    if (self.senderUserInfo) {
        NSMutableDictionary *userInfoDic = [[NSMutableDictionary alloc] init];
        if (self.senderUserInfo.name) {
            [userInfoDic setObject:self.senderUserInfo.name forKeyedSubscript:@"name"];
        }
        if (self.senderUserInfo.portraitUri) {
            [userInfoDic setObject:self.senderUserInfo.portraitUri forKeyedSubscript:@"portrait"];
        }
        if (self.senderUserInfo.userId) {
            [userInfoDic setObject:self.senderUserInfo.userId forKeyedSubscript:@"id"];
        }
        [dataDict setObject:userInfoDic forKey:@"user"];
    }

    return [NSJSONSerialization dataWithJSONObject:dataDict options:kNilOptions error:nil];
}

//将json解码生成消息内容
- (void)decodeWithData:(NSData *)data {
    if (data) {
        __autoreleasing NSError *error = nil;

        NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];

        if (dictionary) {
            self.userId = dictionary[@"userId"];

            NSDictionary *userinfoDic = dictionary[@"user"];
            [self decodeUserInfo:userinfoDic];
        }
    }
}

//消息的类型名
+ (NSString *)getObjectName {
    return RCCallRequestJoinMessageTypeIdentifier;
}

@end
