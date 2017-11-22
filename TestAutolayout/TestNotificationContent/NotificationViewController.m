//
//  NotificationViewController.m
//  TestNotificationContent
//
//  Created by Owen on 2017/11/21.
//  Copyright © 2017年 Owen. All rights reserved.
//

#import "NotificationViewController.h"
#import <UserNotifications/UserNotifications.h>
#import <UserNotificationsUI/UserNotificationsUI.h>
#import <SDWebImage/UIImageView+WebCache.h>
#import <AVKit/AVKit.h>

@interface NotificationItem:NSObject
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *content;
@property (nonatomic, strong) NSURL *url;
@end

@implementation NotificationItem
@end

@interface NotificationViewController () <UNNotificationContentExtension>

@property IBOutlet UILabel *label;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (nonatomic, strong) NSMutableArray <NotificationItem *> *items;
@property (weak, nonatomic) IBOutlet UIView *playerContainer;
@property (nonatomic, assign) NSInteger currentIndex;
@property (nonatomic, strong) AVPlayer *player;
@end

@implementation NotificationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any required interface initialization here.
}

- (void)didReceiveNotification:(UNNotification *)notification {
//    self.label.text = notification.request.content.title;
//    self.textView.text = notification.request.content.body;
    NSArray *items = notification.request.content.userInfo[@"items"];
    NSArray *attachments = notification.request.content.attachments;
    self.items = [NSMutableArray array];
    for (int i = 0;i < items.count;i++) {
        NSDictionary *dic = items[i];
        NotificationItem *item = [[NotificationItem alloc] init];
        item.name = dic[@"title"];
        item.content = dic[@"content"];
        if (i < attachments.count) {
            item.url = ((UNNotificationAttachment *)(attachments[i])).URL;
        }
        [self.items addObject:item];
    }
    [self updateUI:0];
}

- (void)updateUI:(NSInteger)index {
    NotificationItem *item = self.items[index];
    self.label.text = item.name;
    self.textView.text = item.content;
    NSURL *url = item.url;
    if ([url startAccessingSecurityScopedResource]) {
        if (index == 0) {
            self.imageView.image = [UIImage imageWithContentsOfFile:url.path];
            [self.player pause];
        } else {
            AVPlayer *player = [AVPlayer playerWithURL:url];
            AVPlayerLayer *playerLayer = [AVPlayerLayer playerLayerWithPlayer:player];
            [self.playerContainer.layer addSublayer:playerLayer];
            playerLayer.frame = self.playerContainer.bounds;
            [player play];
            self.player = player;
        }
//        [url stopAccessingSecurityScopedResource];
    }
    self.playerContainer.hidden = index == 0;
    self.imageView.hidden = index == 1;
    self.textView.hidden = self.imageView.hidden;
    self.currentIndex = index;
}

- (void)didReceiveNotificationResponse:(UNNotificationResponse *)response completionHandler:(void (^)(UNNotificationContentExtensionResponseOption))completion {
    if ([response.actionIdentifier isEqualToString:@"action.switch"]) {
        if (self.currentIndex == 0) {
            [self updateUI:1];
        } else {
            [self updateUI:0];
        }
        completion(UNNotificationContentExtensionResponseOptionDoNotDismiss);
    } else if ([response.actionIdentifier isEqualToString:@"action.input"]) {
        completion(UNNotificationContentExtensionResponseOptionDismissAndForwardAction);
    } else if ([response.actionIdentifier isEqualToString:@"action.share"]) {
        completion(UNNotificationContentExtensionResponseOptionDismiss);
    }
}
@end
