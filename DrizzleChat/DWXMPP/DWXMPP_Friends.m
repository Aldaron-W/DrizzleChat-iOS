//
//  DWXMPP_Friends.m
//  DrizzleChat
//
//  Created by mitbbs on 14-3-18.
//  Copyright (c) 2014年 DrizzleWang. All rights reserved.
//

#import "DWXMPP_Friends.h"

@interface DWXMPP_Friends ()

@property (nonatomic, strong) XMPPStream *xmppStream;
@property (nonatomic, strong) XMPPRoster *xmppRoster;
@property (nonatomic, strong) XMPPRosterCoreDataStorage *xmppRosterCoreDataStorage;

@end

@implementation DWXMPP_Friends
#pragma mark - Initialization
- (instancetype)initWithXMPPStream:(XMPPStream *)xmppStream{
    self = [super init];
    if (self) {
        self.xmppStream = xmppStream;
        
        self.xmppRoster = [[XMPPRoster alloc] initWithRosterStorage:self.xmppRosterCoreDataStorage];
        self.xmppRoster.autoFetchRoster = YES;
        self.xmppRoster.autoAcceptKnownPresenceSubscriptionRequests = YES;
        
        [self.xmppRoster activate:self.xmppStream];
        [self.xmppRoster addDelegate:self delegateQueue:dispatch_get_main_queue()];
    }
    return self;
}

- (void)teardownFriends{
    [self.xmppRoster removeDelegate:self];
    self.xmppRosterCoreDataStorage = nil;
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark Core Data
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

- (NSManagedObjectContext *)managedObjectContext_roster
{
	return [self.xmppRosterCoreDataStorage mainThreadManagedObjectContext];
}

#pragma mark - XMPPRosterDelegate
- (void)xmppRoster:(XMPPRoster *)sender didReceiveBuddyRequest:(XMPPPresence *)presence
{
	XMPPUserCoreDataStorageObject *user = [self.xmppRosterCoreDataStorage userForJID:[presence from]
                                                                          xmppStream:self.xmppStream
                                                                managedObjectContext:[self managedObjectContext_roster]];
	
	NSString *displayName = [user displayName];
	NSString *jidStrBare = [presence fromStr];
	NSString *body = nil;
	
	if (![displayName isEqualToString:jidStrBare])
	{
		body = [NSString stringWithFormat:@"Buddy request from %@ <%@>", displayName, jidStrBare];
	}
	else
	{
		body = [NSString stringWithFormat:@"Buddy request from %@", displayName];
	}
	
	
	if ([[UIApplication sharedApplication] applicationState] == UIApplicationStateActive)
	{
		UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:displayName
		                                                    message:body
		                                                   delegate:nil
		                                          cancelButtonTitle:@"Not implemented"
		                                          otherButtonTitles:nil];
		[alertView show];
	}
	else
	{
		// We are not active, so use a local notification instead
		UILocalNotification *localNotification = [[UILocalNotification alloc] init];
		localNotification.alertAction = @"Not implemented";
		localNotification.alertBody = body;
		
		[[UIApplication sharedApplication] presentLocalNotificationNow:localNotification];
	}
	
}

#pragma mark - Getter
- (XMPPRosterCoreDataStorage *)xmppRosterCoreDataStorage{
    if (!_xmppRosterCoreDataStorage) {
        _xmppRosterCoreDataStorage = [[XMPPRosterCoreDataStorage alloc] init];
    }
    return _xmppRosterCoreDataStorage;
}

@end
