//
//  TANotificationManager.h
//  TestAutolayout
//
//  Created by Owen on 2017/11/21.
//  Copyright © 2017年 Owen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TANotificationManager : NSObject
+ (TANotificationManager *)sharedManager;
- (void)requestAuthorization;
- (void)createNotification;
@end
