//
//  DWFriendListViewController.h
//  DrizzleChat
//
//  Created by mitbbs on 14-3-19.
//  Copyright (c) 2014年 DrizzleWang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DWXMPP_Header.h"

@interface DWFriendListViewController : UITableViewController<NSFetchedResultsControllerDelegate>{
    NSFetchedResultsController *fetchedResultsController;
}

@end
