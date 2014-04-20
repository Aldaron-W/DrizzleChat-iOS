//
//  DWXMPP_Logging.m
//  DrizzleChat
//
//  Created by 王 雨 on 4/20/14.
//  Copyright (c) 2014 DrizzleWang. All rights reserved.
//

#import "DWXMPP_Logging.h"

@implementation DWXMPP_Logging

+ (id)sharedDWXMPP_Logging
{
    static DWXMPP_Logging *dwLogging = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        dwLogging = [[self alloc] init];
    });
    return dwLogging;
}

#pragma mark - ShowAlert
- (void)showAlertWithTitle:(NSString *)strTitle andMessage:(NSString *)strMessage{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:strTitle
                                                        message:strMessage
                                                       delegate:nil
                                              cancelButtonTitle:@"Ok"
                                              otherButtonTitles:nil];
    [alertView show];
}


@end
