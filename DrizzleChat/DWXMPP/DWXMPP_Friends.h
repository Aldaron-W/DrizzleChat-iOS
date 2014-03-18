//
//  DWXMPP_Friends.h
//  DrizzleChat
//
//  Created by mitbbs on 14-3-18.
//  Copyright (c) 2014年 DrizzleWang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DWXMPP_Friends : NSObject

#pragma mark - Initialization
- (instancetype)initWithXMPPStream:(XMPPStream *)xmppStream;

- (void)teardownFriends;

@end
