//
//  DWLoginViewController.m
//  DrizzleChat
//
//  Created by mitbbs on 14-3-5.
//  Copyright (c) 2014年 DrizzleWang. All rights reserved.
//

#import "DWLoginViewController.h"

@interface DWLoginViewController ()

@property (nonatomic, strong) MBProgressHUD *mbpHUD;
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
    
    [self registerNotification];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:DWXMPP_NOTIFICATION_WILL_CONNECT object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:DWXMPP_NOTIFICATION_CONNECT_FAULT object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:DWXMPP_NOTIFICATION_AUTNENTICATE_SUCCEED object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:DWXMPP_NOTIFICATION_AUTNENTICATE_FAULT object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:DWXMPP_NOTIFICATION_REGISTER_SUCCEED object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:DWXMPP_NOTIFICATION_REGISTER_FAULT object:nil];
}

#pragma mark - Login
- (IBAction)userLogin:(id)sender {
    NSString *userName = [self.textUserName text];
    NSString *passWord = [self.textPassWord text];
    
    [[DWXMPP_Core sharedManager] loginWithUserName:userName andPassWord:passWord];
}

- (void)didLogin:(NSNotification *)notification{
    NSString *strNotification = notification.name;
    
    if ([strNotification isEqualToString:DWXMPP_NOTIFICATION_WILL_CONNECT]) {
        MBProgressHUD *HUD = [[MBProgressHUD alloc] initWithView:self.view];
        HUD.labelText = @"正在连接服务器";
        HUD.removeFromSuperViewOnHide = YES;
        [self.view addSubview:HUD];
        [HUD show:YES];
    }
    else if ([strNotification isEqualToString:DWXMPP_NOTIFICATION_AUTNENTICATE_SUCCEED]){
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        
        MBProgressHUD *HUD = [[MBProgressHUD alloc] initWithView:self.view];
        HUD.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"37x-Checkmark.png"]];
        HUD.mode = MBProgressHUDModeCustomView;
        HUD.labelText = @"登陆成功";
        HUD.removeFromSuperViewOnHide = YES;
        [self.view addSubview:HUD];
        [HUD show:YES];
        [HUD hide:YES afterDelay:1.0];
        
        DWFriendListViewController *friendListView = [[DWFriendListViewController alloc] initWithStyle:UITableViewStyleGrouped];
//        [self presentViewController:friendListView animated:NO completion:nil];
        [self.navigationController pushViewController:friendListView animated:YES];
    }
}

- (void)didNotLogin:(NSNotification *)notification{
    NSString *strNotification = notification.name;
    
    if ([strNotification isEqualToString:DWXMPP_NOTIFICATION_CONNECT_FAULT]) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        
        MBProgressHUD *HUD = [[MBProgressHUD alloc] initWithView:self.view];
        HUD.mode = MBProgressHUDModeText;
        HUD.detailsLabelText = @"连接服务器失败\n请稍后再试";
        HUD.removeFromSuperViewOnHide = YES;
        [self.view addSubview:HUD];
        [HUD show:YES];
        [HUD hide:YES afterDelay:2];
    }
    else if([strNotification isEqualToString:DWXMPP_NOTIFICATION_AUTNENTICATE_FAULT]){
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        
        MBProgressHUD *HUD = [[MBProgressHUD alloc] initWithView:self.view];
        HUD.mode = MBProgressHUDModeText;
        HUD.detailsLabelText = @"用户名或密码输入错误\n请重新输入";
        HUD.removeFromSuperViewOnHide = YES;
        [self.view addSubview:HUD];
        [HUD show:YES];
        [HUD hide:YES afterDelay:2];
    }
}

#pragma mark - Register
- (void)didRegister:(NSNotification *)notification{
    NSString *strNotification = notification.name;
    
    if ([strNotification isEqualToString:DWXMPP_NOTIFICATION_REGISTER_SUCCEED]){
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        
        MBProgressHUD *HUD = [[MBProgressHUD alloc] initWithView:self.view];
        HUD.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"37x-Checkmark.png"]];
        HUD.mode = MBProgressHUDModeCustomView;
        HUD.labelText = @"注册成功";
        HUD.removeFromSuperViewOnHide = YES;
        [self.view addSubview:HUD];
        [HUD show:YES];
        [HUD hide:YES afterDelay:1.0];
    }
}

- (void)didNotRegister:(NSNotification *)notification{
    NSString *strNotification = notification.name;
    
    if([strNotification isEqualToString:DWXMPP_NOTIFICATION_REGISTER_FAULT]){
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        
        NSString *errorCode = [[[notification.object elementsForName:@"error"] firstObject] attributeStringValueForName:@"code"];
        
        MBProgressHUD *HUD = [[MBProgressHUD alloc] initWithView:self.view];
        HUD.mode = MBProgressHUDModeText;
        HUD.detailsLabelText = [NSString stringWithFormat:@"注册失败 错误代码：%@", errorCode];
        HUD.removeFromSuperViewOnHide = YES;
        [self.view addSubview:HUD];
        [HUD show:YES];
        [HUD hide:YES afterDelay:2];
    }
}

#pragma mark - Logout
- (IBAction)userLogout:(id)sender {
    [[DWXMPP_Core sharedManager] logout];
}

#pragma mark - Notification
- (void)registerNotification{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didLogin:) name:DWXMPP_NOTIFICATION_WILL_CONNECT object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didNotLogin:) name:DWXMPP_NOTIFICATION_CONNECT_FAULT object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didLogin:) name:DWXMPP_NOTIFICATION_AUTNENTICATE_SUCCEED object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didNotLogin:) name:DWXMPP_NOTIFICATION_AUTNENTICATE_FAULT object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didRegister:) name:DWXMPP_NOTIFICATION_REGISTER_SUCCEED object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didNotRegister:) name:DWXMPP_NOTIFICATION_REGISTER_FAULT object:nil];
}
@end
