//
//  DWFriendListViewController.m
//  DrizzleChat
//
//  Created by mitbbs on 14-3-19.
//  Copyright (c) 2014年 DrizzleWang. All rights reserved.
//

#import "DWFriendListViewController.h"

@interface DWFriendListViewController ()
@end

@implementation DWFriendListViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated{
    [self.navigationItem setHidesBackButton:YES];
    
    //好友申请列表
    UIButton *subscribeList = [UIButton buttonWithType:UIButtonTypeCustom];
    [subscribeList setFrame:CGRectMake(0, 0, 80, 30)];
    [subscribeList addTarget:self action:@selector(jumpToSubscribView) forControlEvents:UIControlEventTouchUpInside];
    [subscribeList setTitle:@"添加好友列表" forState:UIControlStateNormal];
    [subscribeList setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    UIBarButtonItem *liftButton = [[UIBarButtonItem alloc] initWithCustomView:subscribeList];
    
    self.navigationItem.rightBarButtonItem = liftButton;
    
    //添加好友按钮
    UIButton *subscribe = [UIButton buttonWithType:UIButtonTypeCustom];
    [subscribe setFrame:CGRectMake(0, 0, 80, 30)];
    [subscribe addTarget:self action:@selector(jumpToSubscribView) forControlEvents:UIControlEventTouchUpInside];
    [subscribe setTitle:@"添加好友" forState:UIControlStateNormal];
    [subscribe setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    UIBarButtonItem *subscribeButton = [[UIBarButtonItem alloc] initWithCustomView:subscribe];
    
    self.navigationItem.rightBarButtonItem = subscribeButton;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [[[self fetchedResultsController] sections] count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSArray *sections = [[self fetchedResultsController] sections];
	
	if (section < [sections count])
	{
		id <NSFetchedResultsSectionInfo> sectionInfo = [sections objectAtIndex:section];
		return sectionInfo.numberOfObjects;
	}
	
	return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
	
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	if (cell == nil)
	{
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                      reuseIdentifier:CellIdentifier];
	}
	
	XMPPUserCoreDataStorageObject *user = [[self fetchedResultsController] objectAtIndexPath:indexPath];
	
	cell.textLabel.text = user.displayName;
	[self configurePhotoForCell:cell user:user];
	
	return cell;
}

- (NSString *)tableView:(UITableView *)sender titleForHeaderInSection:(NSInteger)sectionIndex
{
	NSArray *sections = [[self fetchedResultsController] sections];
	
	if (sectionIndex < [sections count])
	{
		id <NSFetchedResultsSectionInfo> sectionInfo = [sections objectAtIndex:sectionIndex];
        
		int section = [sectionInfo.name intValue];
		switch (section)
		{
			case 0  : return @"Available";
			case 1  : return @"Away";
			default : return @"Offline";
		}
	}
	
	return @"";
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    XMPPUserCoreDataStorageObject *user = [[self fetchedResultsController] objectAtIndexPath:indexPath];
    
//    [[DWXMPP_Core sharedManager] sendMessage:@"再见" andReciver:user.jid];
//    [[[DWXMPP_Core sharedManager] xmppRoster] unsubscribePresenceFromUser:user.jid];
//    [[[DWXMPP_Core sharedManager] xmppRoster] removeUser:user.jid];
//    XMPPvCardTemp *myvCardTemp =  [[[[DWXMPP_Core sharedManager] xmppvCard] xmppvCardTempModule] myvCardTemp];
//    NSString *str = [myvCardTemp nickname];
    
//    DWUserInfoViewController *userInfoView = [[DWUserInfoViewController alloc] initWithUserJID:user.jid];
//    [self.navigationController pushViewController:userInfoView animated:YES];
    
    DWChatRoomViewController *chatRoomView = [DWChatRoomViewController messagesViewController];
    [chatRoomView setFriendJID:user.jid];
    
    [self.navigationController pushViewController:chatRoomView animated:YES];
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark NSFetchedResultsController
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

- (NSFetchedResultsController *)fetchedResultsController
{
	if (fetchedResultsController == nil)
	{
		NSManagedObjectContext *moc = [[DWXMPP_Core sharedManager] managedObjectContext_roster];
		
		NSEntityDescription *entity = [NSEntityDescription entityForName:@"XMPPUserCoreDataStorageObject" inManagedObjectContext:moc];
		
		NSSortDescriptor *sd1 = [[NSSortDescriptor alloc] initWithKey:@"sectionNum" ascending:YES];
		NSSortDescriptor *sd2 = [[NSSortDescriptor alloc] initWithKey:@"displayName" ascending:YES];
		
		NSArray *sortDescriptors = [NSArray arrayWithObjects:sd1, sd2, nil];
		
		NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
		[fetchRequest setEntity:entity];
		[fetchRequest setSortDescriptors:sortDescriptors];
		[fetchRequest setFetchBatchSize:10];
		
		fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest
		                                                               managedObjectContext:moc
		                                                                 sectionNameKeyPath:@"sectionNum"
		                                                                          cacheName:nil];
		[fetchedResultsController setDelegate:self];
		
		NSError *error = nil;
		if (![fetchedResultsController performFetch:&error])
		{
            
		}
        
	}
	
	return fetchedResultsController;
}

- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(NSIndexPath *)newIndexPath{
    
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
	[[self tableView] reloadData];
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark UITableViewCell helpers
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

- (void)configurePhotoForCell:(UITableViewCell *)cell user:(XMPPUserCoreDataStorageObject *)user
{
	// Our xmppRosterStorage will cache photos as they arrive from the xmppvCardAvatarModule.
	// We only need to ask the avatar module for a photo, if the roster doesn't have it.
	
	if (user.photo != nil)
	{
		cell.imageView.image = user.photo;
	}
	else
	{
		NSData *photoData = [[[DWXMPP_Core sharedManager] xmppvCard] photoDataForJID:user.jid];
        
		if (photoData != nil)
			cell.imageView.image = [UIImage imageWithData:photoData];
		else
			cell.imageView.image = [UIImage imageNamed:@"defaultPerson"];
	}
}
#pragma mark - ChangeView
- (void)jumpToSubscribView{
    DWSubscribeViewController *subscribe = [[DWSubscribeViewController alloc] initWithNibName:@"DWSubscribeViewController" bundle:nil];
    [self.navigationController pushViewController:subscribe animated:YES];
}


@end
