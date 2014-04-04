//
//  DWLoginViewController.h
//  DrizzleChat
//
//  Created by mitbbs on 14-3-5.
//  Copyright (c) 2014年 DrizzleWang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XMPPFramework.h"
#import "DWXMPP_Header.h"
#import "MBProgressHUD.h"

@interface DWLoginViewController : UIViewController<MBProgressHUDDelegate>{
    
}
@property (strong, nonatomic) IBOutlet UILabel *labUserName;
@property (strong, nonatomic) IBOutlet UILabel *labPassWord;
@property (strong, nonatomic) IBOutlet UIButton *buttLogin;
@property (strong, nonatomic) IBOutlet UIButton *buttRegister;
@property (strong, nonatomic) IBOutlet UIButton *buttLogout;
@property (strong, nonatomic) IBOutlet UITextField *textUserName;
@property (strong, nonatomic) IBOutlet UITextField *textPassWord;
- (IBAction)userLogin:(id)sender;
- (IBAction)userRegister:(id)sender;
- (IBAction)userLogout:(id)sender;

@end
