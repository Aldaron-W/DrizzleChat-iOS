//
//  DWXMPP_Core+DWXMPP_Message.h
//  DrizzleChat
//
//  Created by Private on 14/7/24.
//  Copyright (c) 2014年 DrizzleWang. All rights reserved.
//


#import "DWXMPP_Core.h"

@interface DWXMPP_Core (DWXMPP_Message)

- (void)sendMessage:(NSString *)message andReciver:(XMPPJID *)reciverJID;

- (void)xmppStream:(XMPPStream *)sender didSendMessage:(XMPPMessage *)message;

- (void)xmppStream:(XMPPStream *)sender didReceiveMessage:(XMPPMessage *)message;

@end