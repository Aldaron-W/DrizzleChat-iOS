//
//  DWSubscribeViewController.h
//  DrizzleChat
//
//  Created by mitbbs on 14-4-10.
//  Copyright (c) 2014年 DrizzleWang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DWXMPP_Core.h"

@interface DWSubscribeViewController : UIViewController
@property (strong, nonatomic) IBOutlet UITextField *userName_Text;
@property (strong, nonatomic) IBOutlet UIButton *subscribe_Button;
- (IBAction)subscribeUser:(id)sender;

@end
