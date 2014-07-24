//
//  DWXMPP_Core.h
//  DrizzleChat
//
//  Created by mitbbs on 14-3-14.
//  Copyright (c) 2014年 DrizzleWang. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "DWXMPP_MetaData.h"
#import "DWXMPP_Logging.h"
#import "XMPPFramework.h"


#pragma mark - DWXMPP_Core
typedef NS_ENUM(NSInteger, XMPPMessageType) {
    XMPPMessageType_Subscribe,  //订阅类型信息
    XMPPMessageType_Available,  //上线类型信息
    XMPPMessageType_UnAvailable,//下线类型信息
    XMPPMessageType_Unknown     //未知类型信息
};

@interface DWXMPP_Core : NSObject<XMPPStreamDelegate, XMPPRosterDelegate>

#pragma mark - XMPPFramework
#pragma mark XMPP_Core
/** XMPP交流所用到的主要对象 */
@property (nonatomic, strong, readonly) XMPPStream *xmppStream;

#pragma mark XMPP_Reconnect
/** XMPP重新连接对象 */
@property (nonatomic, strong, readonly) XMPPReconnect *xmppReconnect;

#pragma mark XMPP_Roster
/** XMPP花名册管理对象 */
@property (nonatomic, strong, readonly) XMPPRoster *xmppRoster;
/** XMPP花名册存储对象（CoreData） */
@property (nonatomic, strong, readonly) XMPPRosterCoreDataStorage *xmppRosterStorage_CoreData;
@property (nonatomic, strong) NSMutableDictionary *subscriptionRequests;

#pragma mark XMPP_vCard(XEP-054)
/** XMPP名片管理对象的工厂函数 */
@property (nonatomic, strong, readonly) XMPPvCardTempModule *xmppvCardTempModule;
/** XMPP名片管理对象 */
@property (nonatomic, strong, readonly) XMPPvCardAvatarModule *xmppvCard;
/** XMPP名片存储对象（CoreData） */
@property (nonatomic, strong, readonly) XMPPvCardCoreDataStorage *xmppvCardStorage_CoreData;

#pragma mark XMPP_Capabilities(XEP-115)
/** XMPP客户端信息管理对象 */
@property (nonatomic, strong, readonly) XMPPCapabilities *xmppCapabilities;
/** XMPP客户端信息存储对象（CoreData） */
@property (nonatomic, strong, readonly) XMPPCapabilitiesCoreDataStorage *xmppCapabilitiesStorage;

#pragma mark - Singleton
+ (DWXMPP_Core *)sharedManager;

#pragma mark - Initialization
- (BOOL)initUserDataWithUserName:(NSString *)userName andPassWord:(NSString *)passWord;

#pragma mark - Login
- (void)loginWithUserName:(NSString *)userName andPassWord:(NSString *)passWord;
- (void)login;

#pragma mark - Logout
- (void)logout;

#pragma mark - Register
- (void)registerWithUserName:(NSString *)userName andPassWord:(NSString *)passWord;

//#pragma mark - MessageController
//- (void)sendMessage:(NSString *)message andReciver:(XMPPJID *)reciverJID;

#pragma mark -  Core Data
- (NSManagedObjectContext *)managedObjectContext_roster;
- (NSManagedObjectContext *)managedObjectContext_Message;

@end
