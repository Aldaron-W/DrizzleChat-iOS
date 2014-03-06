//
//  DWLoginViewController.h
//  DrizzleChat
//
//  Created by mitbbs on 14-3-5.
//  Copyright (c) 2014年 DrizzleWang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XMPPFramework.h"

@interface DWLoginViewController : UIViewController{
    
}
@property (strong, nonatomic) IBOutlet UILabel *labUserName;
@property (strong, nonatomic) IBOutlet UILabel *labPassWord;
@property (strong, nonatomic) IBOutlet UIButton *buttLogin;
@property (strong, nonatomic) IBOutlet UIButton *buttRegister;
@property (strong, nonatomic) IBOutlet UITextField *textUserName;
@property (strong, nonatomic) IBOutlet UITextField *textPassWord;
- (IBAction)userLogin:(id)sender;
- (IBAction)userRegister:(id)sender;

@end
