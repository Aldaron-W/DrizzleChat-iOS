//
//  DWXMPP_Core.m
//  DrizzleChat
//
//  Created by mitbbs on 14-3-14.
//  Copyright (c) 2014年 DrizzleWang. All rights reserved.
//

#import "DWXMPP_Core.h"

@interface DWXMPP_Core (){
    BOOL isRegister;
}

#pragma mark - XMPPFramework
#pragma mark XMPP_Core
/** XMPP交流所用到的主要对象 */
@property (nonatomic, strong) XMPPStream *xmppStream;

#pragma mark XMPP_Reconnect
/** XMPP重新连接对象 */
@property (nonatomic, strong) XMPPReconnect *xmppReconnect;

#pragma mark XMPP_Roster
/** XMPP花名册管理对象 */
@property (nonatomic, strong) XMPPRoster *xmppRoster;
/** XMPP花名册存储对象（CoreData） */
@property (nonatomic, strong) XMPPRosterCoreDataStorage *xmppRosterStorage_CoreData;

#pragma mark XMPP_vCard(XEP-054)
/** XMPP名片管理对象的工厂函数 */
@property (nonatomic, strong) XMPPvCardTempModule *xmppvCardTempModule;
/** XMPP名片管理对象 */
@property (nonatomic, strong) XMPPvCardAvatarModule *xmppvCard;
/** XMPP名片存储对象（CoreData） */
@property (nonatomic, strong) XMPPvCardCoreDataStorage *xmppvCardStorage_CoreData;

#pragma mark XMPP_Capabilities(XEP-115)
/** XMPP客户端信息管理对象 */
@property (nonatomic, strong) XMPPCapabilities *xmppCapabilities;
/** XMPP客户端信息存储对象（CoreData） */
@property (nonatomic, strong) XMPPCapabilitiesCoreDataStorage *xmppCapabilitiesStorage;

#pragma mark XMPP_MessageController(XEP-136)
/** XMPPMessage存储的管理对象 */
@property (nonatomic, strong) XMPPMessageArchiving *xmppMessageArchiving;
/** XMPPMessage的CoreData存储的管理对象 */
@property (nonatomic, strong) XMPPMessageArchivingCoreDataStorage *xmppMessageArchivngStorage_CoreData;

#pragma mark - DW_UserData
@property (nonatomic, strong) NSString *userName;
@property (nonatomic, strong) NSString *passWord;
@property (nonatomic, strong) NSString *resource;

#pragma mark - DW_ServerData
@property (nonatomic, strong) NSString *XMPPServiceIP;
@property (nonatomic, assign) int XMPPServicePort;

@end

@implementation DWXMPP_Core
#pragma mark - Singleton
+ (DWXMPP_Core *)sharedManager
{
    static DWXMPP_Core *sharedDWXMPPCoreInstance = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        if (!sharedDWXMPPCoreInstance) {
            sharedDWXMPPCoreInstance = [[self alloc] init];
        }
    });
    return sharedDWXMPPCoreInstance;
}

#pragma mark - Initialization
- (instancetype) initWithUserName:(NSString *)userName andPassWord:(NSString *)passWord{
    self = [super init];
    if (self) {
        self.userName = userName;
        self.passWord = passWord;
        self.resource = nil;
    }
    return self;
}

- (BOOL)initUserDataWithUserName:(NSString *)userName andPassWord:(NSString *)passWord{
    if (userName && passWord) {
        self.userName = userName;
        self.passWord = passWord;
    }
    else{
        return NO;
    }
    
    return YES;
}

- (BOOL)initXMPPFramework{
    //XMPP_Core
    if (!self.xmppStream) {
        return NO;
    }
    //XMPP_Reconnect
    if (!self.xmppReconnect) {
        return NO;
    }
    //XMPP_Roster
    if (!self.xmppRoster) {
        return NO;
    }
    //XMPP_vCard
    if (!self.xmppvCard) {
        return NO;
    }
    //XMPP_Capabilities
    if (!self.xmppCapabilities) {
        return NO;
    }
    //XMPP_MessageArchiving
    if (!self.xmppMessageArchiving) {
        return NO;
    }
    return YES;
}

#pragma mark - Login
- (void)loginWithUserName:(NSString *)userName andPassWord:(NSString *)passWord{
    if (userName && passWord) {
        self.userName = userName;
        self.passWord = passWord;
        
        [self login];
    }
}

- (void)login{
    [self initXMPPFramework];
    [self.xmppStream setMyJID:[XMPPJID jidWithString:self.userName resource:self.resource]];
    isRegister = NO;
    
    NSError *error = nil;
	if (![self.xmppStream connectWithTimeout:30 error:&error]){
        /** DWXMPP连接服务器失败的Notification */
        [[NSNotificationCenter defaultCenter] postNotificationName:DWXMPP_NOTIFICATION_CONNECT_FAULT object:error];
	}
}

#pragma mark - Register
- (void)registerWithUserName:(NSString *)userName andPassWord:(NSString *)passWord{
    if (userName && passWord) {
        self.userName = userName;
        self.passWord = passWord;
        
        [self registerXMPPUser];
    }
}

- (void)registerXMPPUser{
    if ([self initXMPPFramework]) {
        [self.xmppStream setMyJID:[XMPPJID jidWithString:self.userName resource:self.resource]];
        isRegister = YES;
        
        NSError *error = nil;
        if (![self.xmppStream connectWithTimeout:30 error:&error]){
            /** DWXMPP连接服务器失败的Notification */
            [[NSNotificationCenter defaultCenter] postNotificationName:DWXMPP_NOTIFICATION_CONNECT_FAULT object:error];
        }
    }
}

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
	[self.xmppStream disconnect];
    
    //XMPP_Core
    [self.xmppStream removeDelegate:self];
    //XMPP_Reconnect
    [self.xmppReconnect         deactivate];
    //XMPP_Roster
    [self.xmppRoster removeDelegate:self];
    [self.xmppRoster            deactivate];
    //XMPP_vCard
    [self.xmppvCardTempModule   deactivate];
	[self.xmppvCard deactivate];
    //XMPP_Capabilities
    [self.xmppCapabilities      deactivate];
    //XMPP_MessageArchiving
    [self.xmppMessageArchiving deactivate];
    
    self.xmppStream = nil;
    self.xmppReconnect = nil;
    self.xmppRoster = nil;
	self.xmppRosterStorage_CoreData = nil;
	self.xmppvCardStorage_CoreData = nil;
    self.xmppvCardTempModule = nil;
	self.xmppvCard = nil;
    self.xmppCapabilities = nil;
	self.xmppCapabilitiesStorage = nil;
    self.xmppMessageArchiving = nil;
    self.xmppMessageArchivngStorage_CoreData = nil;
}

#pragma mark -  Core Data
- (NSManagedObjectContext *)managedObjectContext_roster{
	return [self.xmppRosterStorage_CoreData mainThreadManagedObjectContext];
}

- (NSManagedObjectContext *)managedObjectContext_vCard{
	return [self.xmppvCardStorage_CoreData mainThreadManagedObjectContext];
}

- (NSManagedObjectContext *)managedObjectContext_Message{
    return [self.xmppMessageArchivngStorage_CoreData mainThreadManagedObjectContext];
}


#pragma mark - XMPPStreamDelegate
#pragma mark Connect（连接服务器）
- (void)xmppStreamWillConnect:(XMPPStream *)sender{
    NSLog(@"\n\tStream将要连接服务器 \n\t服务器：%@ \n\t端口号：%d", sender.hostName, sender.hostPort);
    /** DWXMPP将要连接服务器的Notification */
    [[NSNotificationCenter defaultCenter] postNotificationName:DWXMPP_NOTIFICATION_WILL_CONNECT object:self.xmppStream];
}

- (void)xmppStream:(XMPPStream *)sender socketDidConnect:(GCDAsyncSocket *)socket{
    NSLog(@"\n\tStream连接服务器成功 \n\t服务器：%@ \n\t端口号：%d", sender.hostName, sender.hostPort);
}

- (void)xmppStreamDidConnect:(XMPPStream *)sender{
    NSLog(@"\n\tStream连接服务器成功 \n\t服务器：%@ \n\t端口号：%d", sender.hostName, sender.hostPort);
    NSError *error = nil;
    /** DWXMPP已经连接到服务器的Notification */
    [[NSNotificationCenter defaultCenter] postNotificationName:DWXMPP_NOTIFICATION_CONNECT_SUCCEED object:self.xmppStream];

    if (!isRegister) {
        //登陆
        if (![[self xmppStream] authenticateWithPassword:self.passWord error:&error])
        {
            [[DWXMPP_Logging sharedDWXMPP_Logging] showAlertWithTitle:@"Error authenticating" andMessage:@"验证密码失败"];
            /** DWXMPP验证密码失败的Notification */
            [[NSNotificationCenter defaultCenter] postNotificationName:DWXMPP_NOTIFICATION_AUTNENTICATE_FAULT object:error];
        }
        else{
            /** DWXMPP将要验证密码的Notification */
            [[NSNotificationCenter defaultCenter] postNotificationName:DWXMPP_NOTIFICATION_WILL_AUTNENTICATE object:self.xmppStream];
        }
    }
    else{
        //注册
        if (![[self xmppStream] registerWithPassword:self.passWord error:&error]) {
            [[NSNotificationCenter defaultCenter] postNotificationName:DWXMPP_NOTIFICATION_REGISTER_FAULT object:error];
        }
        else{
            [[NSNotificationCenter defaultCenter] postNotificationName:DWXMPP_NOTIFICATION_WILL_REGISTER object:error];
        }
    }
}

- (void)xmppStreamConnectDidTimeout:(XMPPStream *)sender{
    [[NSNotificationCenter defaultCenter] postNotificationName:DWXMPP_NOTIFICATION_CONNECT_FAULT object:sender];
}

- (void)xmppStreamDidDisconnect:(XMPPStream *)sender withError:(NSError *)error{
    [[NSNotificationCenter defaultCenter] postNotificationName:DWXMPP_NOTIFICATION_CONNECT_FAULT object:error];
}

#pragma mark Authenticate（密码鉴定）
- (void)xmppStreamDidAuthenticate:(XMPPStream *)sender{
    NSLog(@"\n\tStream验证密码成功");
    /** DWXMPP验证密码成功的Notification */
    [[NSNotificationCenter defaultCenter] postNotificationName:DWXMPP_NOTIFICATION_AUTNENTICATE_SUCCEED object:self.xmppStream];
    [self goOnline];
}

- (void)xmppStream:(XMPPStream *)sender didNotAuthenticate:(NSXMLElement *)error{
    NSLog(@"\n\tStream验证密码错误 错误：%@", error);
    /** DWXMPP验证密码失败的Notification */
    [[NSNotificationCenter defaultCenter] postNotificationName:DWXMPP_NOTIFICATION_AUTNENTICATE_FAULT object:error];
}

#pragma mark SendPresence
- (void)xmppStream:(XMPPStream *)sender didSendPresence:(XMPPPresence *)presence{
    
}

#pragma mark GetPresence
- (void)xmppStream:(XMPPStream *)sender didReceivePresence:(XMPPPresence *)presence
{
    
}

#pragma mark Register（用户注册 XEP-0077）
- (void)xmppStreamDidRegister:(XMPPStream *)sender{
    [self teardownStream];
    [[NSNotificationCenter defaultCenter] postNotificationName:DWXMPP_NOTIFICATION_REGISTER_SUCCEED object:sender];
}

- (void)xmppStream:(XMPPStream *)sender didNotRegister:(DDXMLElement *)error{
    [self teardownStream];
    [[NSNotificationCenter defaultCenter] postNotificationName:DWXMPP_NOTIFICATION_REGISTER_FAULT object:error];
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
#pragma mark XMPP_Core
- (XMPPStream *)xmppStream{
    if (!_xmppStream) {
        _xmppStream = [[XMPPStream alloc] init];
        
        [_xmppStream addDelegate:self delegateQueue:dispatch_get_main_queue()];
        [_xmppStream setHostName:DrizzleChat_XMPP_IP];
        [_xmppStream setHostPort:DrizzleChat_XMPP_port];
        
#if !TARGET_IPHONE_SIMULATOR
        {
            // Want xmpp to run in the background?
            //
            // P.S. - The simulator doesn't support backgrounding yet.
            //        When you try to set the associated property on the simulator, it simply fails.
            //        And when you background an app on the simulator,
            //        it just queues network traffic til the app is foregrounded again.
            //        We are patiently waiting for a fix from Apple.
            //        If you do enableBackgroundingOnSocket on the simulator,
            //        you will simply see an error message from the xmpp stack when it fails to set the property.
            
            _xmppStream.enableBackgroundingOnSocket = YES;
        }
#endif
    }
    
    return _xmppStream;
}

#pragma mark XMPP_Reconnect
/**
 * Setup reconnect
 *
 * The XMPPReconnect module monitors for "accidental disconnections" and
 * automatically reconnects the stream for you.
 * There's a bunch more information in the XMPPReconnect header file.
 */
- (XMPPReconnect *)xmppReconnect{
    if (!_xmppReconnect) {
        _xmppReconnect = [[XMPPReconnect alloc] init];
        [_xmppReconnect         activate:self.xmppStream];
    }
    return _xmppReconnect;
}

#pragma mark XMPP_Roster
// Setup roster
//
// The XMPPRoster handles the xmpp protocol stuff related to the roster.
// The storage for the roster is abstracted.
// So you can use any storage mechanism you want.
// You can store it all in memory, or use core data and store it on disk, or use core data with an in-memory store,
// or setup your own using raw SQLite, or create your own storage mechanism.
// You can do it however you like! It's your application.
// But you do need to provide the roster with some storage facility.
- (XMPPRoster *)xmppRoster{
    if (!_xmppRoster) {
        self.xmppRosterStorage_CoreData = [[XMPPRosterCoreDataStorage alloc] init];
        _xmppRoster = [[XMPPRoster alloc] initWithRosterStorage:self.xmppRosterStorage_CoreData];
        _xmppRoster.autoFetchRoster = YES;
        _xmppRoster.autoAcceptKnownPresenceSubscriptionRequests = YES;
        [_xmppRoster            activate:self.xmppStream];
        [_xmppRoster addDelegate:self delegateQueue:dispatch_get_main_queue()];
    }
    return _xmppRoster;
}

- (NSMutableDictionary *)subscriptionRequests{
    if (!_subscriptionRequests) {
        _subscriptionRequests = [[NSMutableDictionary alloc] initWithCapacity:3];
    }
    return _subscriptionRequests;
}

#pragma mark XMPP_vCard(XEP-054)
// Setup vCard support
//
// The vCard Avatar module works in conjuction with the standard vCard Temp module to download user avatars.
// The XMPPRoster will automatically integrate with XMPPvCardAvatarModule to cache roster photos in the roster.
- (XMPPvCardAvatarModule *)xmppvCard{
    if (!_xmppvCard) {
        self.xmppvCardStorage_CoreData = [XMPPvCardCoreDataStorage sharedInstance];
        self.xmppvCardTempModule = [[XMPPvCardTempModule alloc] initWithvCardStorage:self.xmppvCardStorage_CoreData];
        
        _xmppvCard = [[XMPPvCardAvatarModule alloc] initWithvCardTempModule:self.xmppvCardTempModule];
        
        [self.xmppvCardTempModule   activate:self.xmppStream];
        [self.xmppvCard activate:self.xmppStream];
    }
    return _xmppvCard;
}
#pragma mark XMPP_Capabilities(XEP-115)
// Setup capabilities
//
// The XMPPCapabilities module handles all the complex hashing of the caps protocol (XEP-0115).
// Basically, when other clients broadcast their presence on the network
// they include information about what capabilities their client supports (audio, video, file transfer, etc).
// But as you can imagine, this list starts to get pretty big.
// This is where the hashing stuff comes into play.
// Most people running the same version of the same client are going to have the same list of capabilities.
// So the protocol defines a standardized way to hash the list of capabilities.
// Clients then broadcast the tiny hash instead of the big list.
// The XMPPCapabilities protocol automatically handles figuring out what these hashes mean,
// and also persistently storing the hashes so lookups aren't needed in the future.
//
// Similarly to the roster, the storage of the module is abstracted.
// You are strongly encouraged to persist caps information across sessions.
//
// The XMPPCapabilitiesCoreDataStorage is an ideal solution.
// It can also be shared amongst multiple streams to further reduce hash lookups.
- (XMPPCapabilities *)xmppCapabilities{
    if (!_xmppCapabilities) {
        self.xmppCapabilitiesStorage = [XMPPCapabilitiesCoreDataStorage sharedInstance];
        _xmppCapabilities = [[XMPPCapabilities alloc] initWithCapabilitiesStorage:self.xmppCapabilitiesStorage];
        
        _xmppCapabilities.autoFetchHashedCapabilities = YES;
        _xmppCapabilities.autoFetchNonHashedCapabilities = NO;
        
        [_xmppCapabilities      activate:self.xmppStream];
        
    }
    return _xmppCapabilities;
}
#pragma mark XMPP_MessageController(XEP-136)
- (XMPPMessageArchiving *)xmppMessageArchiving{
    if (!_xmppMessageArchiving) {
        self.xmppMessageArchivngStorage_CoreData = [XMPPMessageArchivingCoreDataStorage sharedInstance];
        _xmppMessageArchiving = [[XMPPMessageArchiving alloc] initWithMessageArchivingStorage:self.xmppMessageArchivngStorage_CoreData];
        [_xmppMessageArchiving activate:self.xmppStream];
    }
    return _xmppMessageArchiving;
}

#pragma mark UserData
- (NSString *)resource{
    if (!_resource) {
        int r = arc4random() % 99999;
        _resource = [NSString stringWithFormat:@"%@%d",@"DrizzleChat",r];
    }
    return _resource;
}

#pragma mark - Setter
#pragma mark UserData

@end
