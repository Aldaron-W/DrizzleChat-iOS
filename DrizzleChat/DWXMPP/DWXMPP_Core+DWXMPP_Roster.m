//
//  DWXMPP_Core+DWXMPP_Roster.m
//  DrizzleChat
//
//  Created by 王 雨 on 4/20/14.
//  Copyright (c) 2014 DrizzleWang. All rights reserved.
//

#import "DWXMPP_Core+DWXMPP_Roster.h"

@implementation DWXMPP_Core (DWXMPP_Roster)

#pragma mark - RosterDelegate
- (void)xmppRoster:(XMPPRoster *)sender didReceivePresenceSubscriptionRequest:(XMPPPresence *)presence{
    [[DWXMPP_Logging sharedDWXMPP_Logging] showAlertWithTitle:@"收到加为好友的请求" andMessage:[NSString stringWithFormat:@"%@发来加好友的请求", [[presence from] full]]];
    
    [self.subscriptionRequests setObject:[presence from] forKey:[[presence from] bare]];
}

#pragma AcceptSubscriptionRequest
- (void)acceptSubscriptionRequestFrom:(XMPPJID *)JID{
    [self acceptSubscriptionRequestFrom:JID andAddToRoster:YES];
}

- (void)acceptSubscriptionRequestFrom:(XMPPJID *)JID andAddToRoster:(BOOL)isAddToRoster{
    [self.xmppRoster acceptPresenceSubscriptionRequestFrom:JID andAddToRoster:isAddToRoster];
    [self.subscriptionRequests removeObjectForKey:[JID bare]];
}

#pragma RejectSubscriptionRequest
- (void)rejectPresenceSubscriptionRequestFrom:(XMPPJID *)JID{
    [self.xmppRoster rejectPresenceSubscriptionRequestFrom:JID];
    [self.subscriptionRequests removeObjectForKey:[JID bare]];
}

#pragma mark - Getter
- (NSMutableDictionary *)getSubscriptionRequests{
    return self.subscriptionRequests;
}
@end
