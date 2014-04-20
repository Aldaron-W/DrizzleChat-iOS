//
//  DWSubscribeViewController.m
//  DrizzleChat
//
//  Created by mitbbs on 14-4-10.
//  Copyright (c) 2014年 DrizzleWang. All rights reserved.
//

#import "DWSubscribeViewController.h"

@interface DWSubscribeViewController ()

@end

@implementation DWSubscribeViewController

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

- (IBAction)subscribeUser:(id)sender {
    [[[DWXMPP_Core sharedManager] xmppRoster] subscribePresenceToUser:[XMPPJID jidWithString:self.userName_Text.text]];
}

- (IBAction)hidKeyBoard:(id)sender {
    [self.userName_Text resignFirstResponder];
    [self.nickName_Text resignFirstResponder];
}
@end
