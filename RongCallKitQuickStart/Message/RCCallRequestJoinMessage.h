//
//  RCCallRequestJoinMessage.h
//  RongCallLib
//
//  Created by LiuLinhong on 2021/03/15.
//  Copyright © 2021 Rong Cloud. All rights reserved.
//

#import <RongIMLibCore/RongIMLibCore.h>

#define RCCallRequestJoinMessageTypeIdentifier @"RC:VCRequestJoin"

@interface RCCallRequestJoinMessage : RCMessageContent

@property (nonatomic, strong) NSString *userId;

- (instancetype)initWithUserId:(NSString *)userId;

@end
