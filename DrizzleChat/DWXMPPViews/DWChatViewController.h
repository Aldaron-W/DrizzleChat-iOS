//
//  DWChatViewController.h
//  DrizzleChat
//
//  Created by 王 雨 on 4/13/14.
//  Copyright (c) 2014 DrizzleWang. All rights reserved.
//

//#import "JSMessagesViewController.h"
//#import "JSMessage.h"
#import "DWXMPP_Core.h"

@interface DWChatViewController : JSMessagesViewController <JSMessagesViewDataSource, JSMessagesViewDelegate>

@property (strong, nonatomic) XMPPJID *receiverJID;

@property (strong, nonatomic) NSMutableArray *messages;
@property (strong, nonatomic) NSDictionary *avatars;

@end
