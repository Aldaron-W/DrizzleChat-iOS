//
//  DWXMPP_Core.m
//  DrizzleChat
//
//  Created by mitbbs on 14-3-14.
//  Copyright (c) 2014年 DrizzleWang. All rights reserved.
//

#import "DWXMPP_Core.h"

@interface DWXMPP_Core ()

/**
 *  XMPP交流所用到的主要对象
 */
@property (nonatomic, strong) XMPPStream *xmppStream;
@property (nonatomic, strong) DWXMPP_Friends *DWFriends;

@property (nonatomic, strong) NSString *userName;
@property (nonatomic, strong) NSString *passWord;
@property (nonatomic, strong) NSString *resource;

@property (nonatomic, strong) NSString *XMPPServiceIP;
@property (nonatomic, assign) int XMPPServicePort;

@end

@implementation DWXMPP_Core

#pragma mark - Initialization
- (instancetype) initWithUserName:(NSString *)userName andPassWord:(NSString *)passWord{
    self = [super init];
    if (self) {
        self.userName = userName;
        self.passWord = passWord;
        self.resource = nil;
//        self.DWFriends = [[DWXMPP_Friends alloc] initWithXMPPStream:self.xmppStream];
    }
    return self;
}

#pragma mark - Login
- (void)login{
    [self.xmppStream setMyJID:[XMPPJID jidWithString:self.userName resource:self.resource]];
    
    NSError *error = nil;
	if (![self.xmppStream connectWithTimeout:XMPPStreamTimeoutNone error:&error]){
		[self showAlertWithTitle:@"Error connecting" andMessage:@"See console for error details."];
	}
}

#pragma mark - Register

#pragma mark - OnLine
- (void)goOnline{
    XMPPPresence *presence = [XMPPPresence presence]; // type="available" is implicit
    [[self xmppStream] sendElement:presence];
}

#pragma mark - Logout
- (void)logout{
    [self goOffLine];
    [self.xmppStream disconnect];
    
    [self teardownStream];
}
- (void)goOffLine{
    XMPPPresence *presence = [XMPPPresence presenceWithType:@"unavailable"];
	[[self xmppStream] sendElement:presence];
}

- (void)teardownStream
{
	[self.xmppStream removeDelegate:self];
    [self.DWFriends teardownFriends];
	
	[self.xmppStream disconnect];
	
	self.xmppStream = nil;
}

#pragma mark - XMPPStreamDelegate
#pragma mark Connect（连接服务器）
- (void)xmppStreamWillConnect:(XMPPStream *)sender{
    NSLog(@"\n\tStream将要连接服务器 \n\t服务器：%@ \n\t端口号：%d", sender.hostName, sender.hostPort);
}

- (void)xmppStream:(XMPPStream *)sender socketDidConnect:(GCDAsyncSocket *)socket{
    NSLog(@"\n\tStream连接服务器成功 \n\t服务器：%@ \n\t端口号：%d", sender.hostName, sender.hostPort);
}

- (void)xmppStreamDidConnect:(XMPPStream *)sender{
    NSLog(@"\n\tStream连接服务器成功 \n\t服务器：%@ \n\t端口号：%d", sender.hostName, sender.hostPort);
    NSError *error = nil;
	if (![[self xmppStream] authenticateWithPassword:self.passWord error:&error])
	{
        [self showAlertWithTitle:@"Error authenticating" andMessage:@"验证密码失败"];
	}
}

#pragma mark Authenticate（密码鉴定）
- (void)xmppStreamDidAuthenticate:(XMPPStream *)sender{
    NSLog(@"\n\tStream验证密码成功");
    [self goOnline];
}

- (void)xmppStream:(XMPPStream *)sender didNotAuthenticate:(NSXMLElement *)error{
    NSLog(@"\n\tStream验证密码错误 错误：%@", error);
}

#pragma mark GetPresence
- (void)xmppStream:(XMPPStream *)sender didReceivePresence:(XMPPPresence *)presence
{
    NSLog(@"信息类型 :%@ From :%@ To ：%@", [presence type], [presence from], [presence to]);
    
    switch ([self GetPresenceType:[presence type]]) {
        case XMPPMessageType_Subscribe:{
            break;
        }
        case XMPPMessageType_Available:{
            break;
        }
        case XMPPMessageType_UnAvailable:{
            break;
        }
        case XMPPMessageType_Unknown:
        default:{
            break;
        }
    }
}

- (XMPPMessageType)GetPresenceType:(NSString *)messageType{
    if ([messageType isEqualToString:@"subscribe"]) {
        return XMPPMessageType_Subscribe;
    }
    else if ([messageType isEqualToString:@"available"]){
        return XMPPMessageType_Available;
    }
    else if ([messageType isEqualToString:@"unavailable"]){
        return XMPPMessageType_UnAvailable;
    }
    return XMPPMessageType_Unknown;
}

#pragma mark - GetIQ
/**
 * Delegate method to receive incoming IQ stanzas.
 **/
- (BOOL)xmppStream:(XMPPStream *)sender didReceiveIQ:(XMPPIQ *)iq
{
    return YES;
}

#pragma mark - Getter
#pragma mark XMPP
- (XMPPStream *)xmppStream{
    if (!_xmppStream) {
        _xmppStream = [[XMPPStream alloc] init];
        
        [_xmppStream addDelegate:self delegateQueue:dispatch_get_main_queue()];
        [_xmppStream setHostName:DrizzleChat_XMPP_IP];
        [_xmppStream setHostPort:DrizzleChat_XMPP_port];
    }
    
    return _xmppStream;
}

#pragma makr UserData
- (NSString *)resource{
    if (!_resource) {
        int r = arc4random() % 99999;
        _resource = [NSString stringWithFormat:@"%@%d",@"DrizzleChat",r];
    }
    return _resource;
}

#pragma mark - Setter
#pragma mark UserData


#pragma mark - OtherMethods
- (void)showAlertWithTitle:(NSString *)strTitle andMessage:(NSString *)strMessage{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:strTitle
                                                        message:strMessage
                                                       delegate:nil
                                              cancelButtonTitle:@"Ok"
                                              otherButtonTitles:nil];
    [alertView show];
}
@end