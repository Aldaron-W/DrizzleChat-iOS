//
//  DWUserInfoViewController.m
//  DrizzleChat
//
//  Created by mitbbs on 14-4-9.
//  Copyright (c) 2014年 DrizzleWang. All rights reserved.
//

#import "DWUserInfoViewController.h"

@interface DWUserInfoViewController ()

@end

@implementation DWUserInfoViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (instancetype)initWithUserJID:(XMPPJID *)userJID{
    self = [super init];
    if (self) {
        self.userJID = userJID;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.uservCardTemp = [[[DWXMPP_Core sharedManager] xmppvCardTempModule] vCardTempForJID:self.userJID shouldFetch:YES];
    
    self.userInfo = [[[DWXMPP_Core sharedManager] xmppRosterStorage_CoreData]
                     userForJID:self.userJID xmppStream:[[DWXMPP_Core sharedManager] xmppStream]
                     managedObjectContext:[[DWXMPP_Core sharedManager] managedObjectContext_roster]];
    
    self.userName_Label.text = [self.userInfo jidStr];
    self.nickName_Label.text = [self.userInfo nickname];
    if ([[self.userInfo subscription] isEqualToString:@"both"]) {
        [self.isSub_Switch setOn:YES];
        [self.isSendSub_Switch setOn:YES];
    }
    else{
        [self.isSub_Switch setOn:NO];
        if ([[self.userInfo ask] isEqualToString:@"subscribe"]) {
            [self.isSendSub_Switch setOn:YES];
        }
        else{
            [self.isSendSub_Switch setOn:NO];
        }
    }
    self.unreadMessageCount_Label.text = [NSString stringWithFormat:@"%@", [self.userInfo unreadMessages]];
    self.userPhoto_ImageView.image = [[UIImage alloc] initWithData:[self.uservCardTemp photo]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
