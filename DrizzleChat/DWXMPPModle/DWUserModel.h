//
//  DWUserMode.h
//  DrizzleChat
//
//  Created by Private on 14/7/24.
//  Copyright (c) 2014年 DrizzleWang. All rights reserved.
//

#import "XMPPUserCoreDataStorageObject.h"

@interface DWUserModel : XMPPUserCoreDataStorageObject

- (instancetype)initWithJID:(XMPPJID *)jid;

@end
