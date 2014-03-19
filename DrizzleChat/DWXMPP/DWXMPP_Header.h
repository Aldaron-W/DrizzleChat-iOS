//
//  DWXMPP_Header.h
//  DrizzleChat
//
//  Created by mitbbs on 14-3-14.
//  Copyright (c) 2014年 DrizzleWang. All rights reserved.
//

#ifndef DrizzleChat_DWXMPP_Header_h
#define DrizzleChat_DWXMPP_Header_h

#import "DWXMPP_Core.h"
#import "DWXMPP_Friends.h"

#pragma mark - ServerData
#define DrizzleChat_XMPP_IP @"115.28.228.212"
#define DrizzleChat_XMPP_port 5222

#pragma mark - NotificationData
#pragma mark ConnectServer(连接服务器)
/** DWXMPP将要连接服务器的Notification */
#define DWXMPP_NOTIFICATION_WILL_CONNECT @"DWXMPP_Will_Connect_Server"
/** DWXMPP已经连接到服务器的Notification */
#define DWXMPP_NOTIFICATION_CONNECT_SUCCEED @"DWXMPP_Connect_Server_Succeed"
/** DWXMPP连接服务器失败的Notification */
#define DWXMPP_NOTIFICATION_CONNECT_FAULT @"DWXMPP_Connect_Server_Fault"

#pragma mark - Authenticate(密码验证)
/** DWXMPP将要验证密码的Notification */
#define DWXMPP_NOTIFICATION_WILL_AUTNENTICATE @"DWXMPP_Will_Authenticate"
/** DWXMPP验证密码成功的Notification */
#define DWXMPP_NOTIFICATION_AUTNENTICATE_SUCCEED @"DWXMPP_Authenticate_Succeed"
/** DWXMPP验证密码失败的Notification */
#define DWXMPP_NOTIFICATION_AUTNENTICATE_FAULT @"DWXMPP_Authenticate_Fault"
#endif
