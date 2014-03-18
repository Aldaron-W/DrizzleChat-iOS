//
//  DWXMPP_Core.h
//  DrizzleChat
//
//  Created by mitbbs on 14-3-14.
//  Copyright (c) 2014年 DrizzleWang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DWXMPP_Header.h"

#pragma mark - DWXMPP_Core
typedef NS_ENUM(NSInteger, XMPPMessageType) {
    XMPPMessageType_Subscribe,  //订阅类型信息
    XMPPMessageType_Available,  //上线类型信息
    XMPPMessageType_UnAvailable,//下线类型信息
    XMPPMessageType_Unknown     //未知类型信息
};

@interface DWXMPP_Core : NSObject<XMPPStreamDelegate, XMPPRosterDelegate>

#pragma mark - Initialization
- (instancetype) initWithUserName:(NSString *)userName andPassWord:(NSString *)passWord;

#pragma mark - Login
- (void)login;

#pragma mark - Logout
- (void)logout;

@end
