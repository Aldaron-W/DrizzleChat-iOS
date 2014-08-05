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
    //程序运行在前台，消息正常显示
    if ([[UIApplication sharedApplication] applicationState] == UIApplicationStateActive)
    {
        
    }else{//如果程序在后台运行，收到消息以通知类型来显示
        if (message.body) {
            UILocalNotification *localNotification = [[UILocalNotification alloc] init];
            localNotification.alertAction = @"Ok";
            localNotification.fireDate = [NSDate new];
            localNotification.timeZone=[NSTimeZone defaultTimeZone];
            localNotification.alertBody = [NSString stringWithFormat:@"%@:%@",message.from.bare,message.body];//通知主体
            localNotification.soundName = UILocalNotificationDefaultSoundName;//通知声音
            localNotification.applicationIconBadgeNumber += 1;//标记数
            [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];//发送通知
        }
    }
}

@end