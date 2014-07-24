//
//  DWChatRoomViewController.h
//  DrizzleChat
//
//  Created by Private on 14/7/24.
//  Copyright (c) 2014年 DrizzleWang. All rights reserved.
//

//#import "JSQMessagesCollectionView.h"

#import "JSQMessages.h"
#import "DWXMPP_Header.h"
#import "XMPP.h"

@class DWChatRoomViewController;


@protocol JSQDemoViewControllerDelegate <NSObject>

- (void)didDismissJSQDemoViewController:(DWChatRoomViewController *)vc;

@end

@interface DWChatRoomViewController : JSQMessagesViewController<NSFetchedResultsControllerDelegate>

@property (weak, nonatomic) id<JSQDemoViewControllerDelegate> delegateModal;

@property (strong, nonatomic) NSMutableArray *messages;
@property (copy, nonatomic) NSDictionary *avatars;

@property (strong, nonatomic) UIImageView *outgoingBubbleImageView;
@property (strong, nonatomic) UIImageView *incomingBubbleImageView;

@property (strong, nonatomic) XMPPUserCoreDataStorageObject *senderInfo;
@property (strong, nonatomic) XMPPUserCoreDataStorageObject *friendInfo;

@property (strong, nonatomic) XMPPJID *friendJID;


- (void)receiveMessagePressed:(UIBarButtonItem *)sender;

- (void)closePressed:(UIBarButtonItem *)sender;

- (void)setupTestModel;

@end
