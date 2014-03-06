//
//  DWLoginViewController.m
//  DrizzleChat
//
//  Created by mitbbs on 14-3-5.
//  Copyright (c) 2014年 DrizzleWang. All rights reserved.
//

#import "DWLoginViewController.h"

@interface DWLoginViewController (){
    BOOL allowSelfSignedCertificates;
}

@property (nonatomic, strong) XMPPStream *xmppStream;

@end

@implementation DWLoginViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)userLogin:(id)sender {
    
    NSString *userName = [self.textUserName text];
    NSString *passWord = [self.textPassWord text];
    
    int r = arc4random() % 99999;
    NSString * resource = [NSString stringWithFormat:@"%@%d",@"DrizzleChat",r];
//    [self.xmppStream setMyJID:[XMPPJID jidWithString:userName resource:resource]];
    [self.xmppStream setMyJID:[XMPPJID jidWithString:userName]];
//	password = myPassword;
    
    NSError *error = nil;
	if (![self.xmppStream connectWithTimeout:XMPPStreamTimeoutNone error:&error])
	{
		UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error connecting"
		                                                    message:@"See console for error details."
		                                                   delegate:nil
		                                          cancelButtonTitle:@"Ok"
		                                          otherButtonTitles:nil];
		[alertView show];
        
        
//		return NO;
	}
}

- (IBAction)userRegister:(id)sender {
    NSString *userName = [self.textUserName text];
    NSString *passWord = [self.textPassWord text];
    
    int r = arc4random() % 99999;
    NSString * resource = [NSString stringWithFormat:@"%@%d",@"DrizzleChat",r];
    //    [self.xmppStream setMyJID:[XMPPJID jidWithString:userName resource:resource]];
    [self.xmppStream setMyJID:[XMPPJID jidWithString:userName]];
    //	password = myPassword;
    
    NSError *error = nil;
	if (![self.xmppStream connectWithTimeout:XMPPStreamTimeoutNone error:&error])
	{
		UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error connecting"
		                                                    message:@"See console for error details."
		                                                   delegate:nil
		                                          cancelButtonTitle:@"Ok"
		                                          otherButtonTitles:nil];
		[alertView show];
        
        
        //		return NO;
	}
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark XMPPStream Delegate
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

- (void)xmppStream:(XMPPStream *)sender socketDidConnect:(GCDAsyncSocket *)socket
{
//	DDLogVerbose(@"%@: %@", THIS_FILE, THIS_METHOD);
}

- (void)xmppStream:(XMPPStream *)sender willSecureWithSettings:(NSMutableDictionary *)settings
{
//	DDLogVerbose(@"%@: %@", THIS_FILE, THIS_METHOD);
	
}

- (void)xmppStreamDidSecure:(XMPPStream *)sender
{
//	DDLogVerbose(@"%@: %@", THIS_FILE, THIS_METHOD);
}

- (void)xmppStreamDidConnect:(XMPPStream *)sender
{
//	DDLogVerbose(@"%@: %@", THIS_FILE, THIS_METHOD);
	NSError *error = nil;
//	if (![[self xmppStream] authenticateWithPassword:self.textPassWord.text error:&error])
//	{
//        
//    }
    
    if (![[self xmppStream] registerWithPassword:self.textPassWord.text error:&error]){
        
    }
}

- (void)xmppStreamDidAuthenticate:(XMPPStream *)sender
{
	[self goOnline];
}

- (void)xmppStream:(XMPPStream *)sender didNotAuthenticate:(NSXMLElement *)error
{
    
}

- (BOOL)xmppStream:(XMPPStream *)sender didReceiveIQ:(XMPPIQ *)iq
{
	
	return NO;
}

- (void)xmppStream:(XMPPStream *)sender didReceiveMessage:(XMPPMessage *)message
{
    
	// A simple example of inbound message handling.
    
}

- (void)xmppStream:(XMPPStream *)sender didReceivePresence:(XMPPPresence *)presence
{
//	DDLogVerbose(@"%@: %@ - %@", THIS_FILE, THIS_METHOD, [presence fromStr]);
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Connected Succeed"
                                                        message:[presence show]
                                                       delegate:nil
                                              cancelButtonTitle:@"Ok"
                                              otherButtonTitles:nil];
    [alertView show];
}

- (void)xmppStream:(XMPPStream *)sender didReceiveError:(id)error
{
//	DDLogVerbose(@"%@: %@", THIS_FILE, THIS_METHOD);
}

- (void)xmppStreamDidDisconnect:(XMPPStream *)sender withError:(NSError *)error
{
//	DDLogVerbose(@"%@: %@", THIS_FILE, THIS_METHOD);
	
}

/**
 * This method is called after registration of a new user has successfully finished.
 * If registration fails for some reason, the xmppStream:didNotRegister: method will be called instead.
 **/
- (void)xmppStreamDidRegister:(XMPPStream *)sender{
    
}

/**
 * This method is called if registration fails.
 **/
- (void)xmppStream:(XMPPStream *)sender didNotRegister:(NSXMLElement *)error{
    
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

- (void)goOnline
{
	XMPPPresence *presence = [XMPPPresence presence]; // type="available" is implicit
    
    NSString *domain = [self.xmppStream.myJID domain];
    
    //Google set their presence priority to 24, so we do the same to be compatible.
    
    if([domain isEqualToString:@"gmail.com"]
       || [domain isEqualToString:@"gtalk.com"]
       || [domain isEqualToString:@"talk.google.com"])
    {
        NSXMLElement *priority = [NSXMLElement elementWithName:@"priority" stringValue:@"24"];
        [presence addChild:priority];
    }
	
	[[self xmppStream] sendElement:presence];
}

#pragma mark - Getter
#pragma mark XMPP
- (XMPPStream *)xmppStream{
    if (!_xmppStream) {
        _xmppStream = [[XMPPStream alloc] init];
        
        [_xmppStream addDelegate:self delegateQueue:dispatch_get_main_queue()];
        [_xmppStream setHostName:@"115.28.228.212"];
        [_xmppStream setHostPort:5222];
    }
    
    return _xmppStream;
}
@end
