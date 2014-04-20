//
//  DWXMPP_Logging.h
//  DrizzleChat
//
//  Created by 王 雨 on 4/20/14.
//  Copyright (c) 2014 DrizzleWang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DWXMPP_Logging : NSObject

+ (id)sharedDWXMPP_Logging;

#pragma mark - ShowAlert
- (void)showAlertWithTitle:(NSString *)strTitle andMessage:(NSString *)strMessage;

@end
