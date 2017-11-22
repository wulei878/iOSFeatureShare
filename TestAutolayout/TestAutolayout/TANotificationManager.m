//
//  TANotificationManager.m
//  TestAutolayout
//
//  Created by Owen on 2017/11/21.
//  Copyright © 2017年 Owen. All rights reserved.
//

#import "TANotificationManager.h"
#import <UserNotifications/UserNotifications.h>
#import <MobileCoreServices/MobileCoreServices.h>

@interface TANotificationManager()<UNUserNotificationCenterDelegate>
@end

@implementation TANotificationManager
+ (TANotificationManager *)sharedManager {
    static dispatch_once_t once;
    static TANotificationManager *instance;
    dispatch_once(&once, ^{
        instance = [self new];
    });
    return instance;
}

- (void)requestAuthorization {
    [[UNUserNotificationCenter currentNotificationCenter] requestAuthorizationWithOptions:(UNAuthorizationOptionBadge|UNAuthorizationOptionSound|UNAuthorizationOptionAlert) completionHandler:^(BOOL granted, NSError * _Nullable error) {
        if (granted) {
            [UNUserNotificationCenter currentNotificationCenter].delegate = self;
        }
    }];
}

- (void)createNotification {
    // 1. 创建通知内容
    UNMutableNotificationContent *content = [[UNMutableNotificationContent alloc] init];
    content.title = @"主标题";
    content.subtitle = @"副标题";
    content.body = @"我的第一个通知";
    content.badge = @99;
    content.launchImageName = @"welcome";
    content.sound = [UNNotificationSound defaultSound];


    content.userInfo = @{@"items":@[@{@"title":@"owen",
                                      @"content":@"hello",
                                        },
                                    @{@"title":@"Mark",
                                      @"content":@"Nice to meet you",
                                        },
                                 ],
                         };
    
    // 在通知中添加图片
    NSString *attachmentIdentifier1 = @"tv.douyu.live.usernotification.attachmentIdentifier1";
    NSString *attachmentIdentifier2 = @"tv.douyu.live.usernotification.attachmentIdentifier2";
    NSURL *url1 = [[NSBundle mainBundle] URLForResource:@"welcome" withExtension:@"png"];
    NSURL *url2 = [[NSBundle mainBundle] URLForResource:@"video" withExtension:@"mp4"];
    NSError *error = nil;
    NSDictionary *options1 = @{UNNotificationAttachmentOptionsTypeHintKey:(NSString *)kUTTypeImage,
                              UNNotificationAttachmentOptionsThumbnailHiddenKey:@NO,
                              UNNotificationAttachmentOptionsThumbnailClippingRectKey:NSStringFromCGRect(CGRectMake(0, 0, 0.5, 0.5)),
                              };
    NSDictionary *options2 = @{UNNotificationAttachmentOptionsThumbnailHiddenKey:@NO,
                               UNNotificationAttachmentOptionsThumbnailClippingRectKey:NSStringFromCGRect(CGRectMake(0, 0, 0.5, 0.5)),
                               UNNotificationAttachmentOptionsThumbnailTimeKey:@2,
                               };
    UNNotificationAttachment *attachment1 = [UNNotificationAttachment attachmentWithIdentifier:attachmentIdentifier1 URL:url1 options:options1 error:&error];
    UNNotificationAttachment *attachment2 = [UNNotificationAttachment attachmentWithIdentifier:attachmentIdentifier2 URL:url2 options:options2 error:&error];
    content.attachments = @[attachment1,attachment2];
    
    // 在通知中添加快捷操作
    content.categoryIdentifier = @"tv.douyu.live.usernotification.categoryIdentifier";
    UNNotificationAction *action1 = [UNNotificationAction actionWithIdentifier:@"action.share" title:@"分享" options:0];
    UNTextInputNotificationAction *action2 = [UNTextInputNotificationAction actionWithIdentifier:@"action.input" title:@"快速回复" options:UNNotificationActionOptionForeground textInputButtonTitle:@"发送" textInputPlaceholder:@"一句话回复"];
    UNNotificationAction *action3 = [UNNotificationAction actionWithIdentifier:@"action.switch" title:@"换一换" options:0];
    UNNotificationCategory *category = [UNNotificationCategory categoryWithIdentifier:content.categoryIdentifier actions:@[action1,action2,action3] intentIdentifiers:@[@"action1",@"action2",@"action3"] options:UNNotificationCategoryOptionCustomDismissAction];
    [[UNUserNotificationCenter currentNotificationCenter] setNotificationCategories:[NSSet setWithArray:@[category]]];
    
    // 2. 创建发送触发
    UNTimeIntervalNotificationTrigger *trigger = [UNTimeIntervalNotificationTrigger triggerWithTimeInterval:5 repeats:false];

    
    // 3. 发送请求标识符
    static NSString *requestIdentifier = @"tv.douyu.live.usernotification.myFirstNotification";
    
    // 4. 创建一个发送请求
    UNNotificationRequest *request = [UNNotificationRequest requestWithIdentifier:requestIdentifier content:content trigger:trigger];
    
    // 将请求添加到发送中心
    [[UNUserNotificationCenter currentNotificationCenter] addNotificationRequest:request withCompletionHandler:^(NSError * _Nullable error) {
        if (!error) {
            NSLog(@"Time Interval Notification scheduled: %@",requestIdentifier);
        }
    }];
    
//    // 移除已经展示过的通知
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 7), dispatch_get_main_queue(), ^{
//        [[UNUserNotificationCenter currentNotificationCenter] removeDeliveredNotificationsWithIdentifiers:@[requestIdentifier]];
//    });
//
//    // 移除还未展示的通知
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 2), dispatch_get_main_queue(), ^{
//        [[UNUserNotificationCenter currentNotificationCenter] removePendingNotificationRequestsWithIdentifiers:@[requestIdentifier]];
//    });
//
//    // 更新通知
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 7), dispatch_get_main_queue(), ^{
//        [[UNUserNotificationCenter currentNotificationCenter] addNotificationRequest:request withCompletionHandler:^(NSError * _Nullable error) {
//            if (!error) {
//                NSLog(@"Time Interval Notification scheduled: %@",requestIdentifier);
//            }
//        }];
//    });
}

- (void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)(void))completionHandler {
    // 处理带category的通知
    if ([response isKindOfClass:[UNTextInputNotificationResponse class]] && [response.actionIdentifier isEqualToString:@"action.input"]) {
        UNTextInputNotificationResponse *textResponse = (UNTextInputNotificationResponse *)response;
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:textResponse.userText preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:nil];
        [alert addAction:action];
        [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:alert animated:YES completion:nil];
    }
}

// 应用内展示通知
- (void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions))completionHandler {
    completionHandler(UNNotificationPresentationOptionSound|UNNotificationPresentationOptionAlert);
}
@end
