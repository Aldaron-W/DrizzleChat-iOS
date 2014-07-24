//
//  DWXMPP_Core+DWXMPP_Message.m
//  DrizzleChat
//
//  Created by Private on 14/7/24.
//  Copyright (c) 2014年 DrizzleWang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DWXMPP_Core+DWXMPP_Message.h"

@implementation DWXMPP_Core (DWXMPP_Message)


#pragma mark - MessageController
- (void)sendMessage:(NSString *)message andReciver:(XMPPJID *)reciverJID{
    XMPPMessage *sendMessage = [[XMPPMessage alloc] initWithType:@"chat" to:reciverJID];
    [sendMessage addBody:message];
    
    [self.xmppStream sendElement:sendMessage];
}

- (void)xmppStream:(XMPPStream *)sender didReceiveMessage:(XMPPMessage *)message{
    
}

@end