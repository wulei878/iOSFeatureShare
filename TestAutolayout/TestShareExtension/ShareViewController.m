//
//  ShareViewController.m
//  TestShareExtension
//
//  Created by Owen on 2017/11/22.
//  Copyright © 2017年 Owen. All rights reserved.
//

#import "ShareViewController.h"

@interface ShareViewController ()

@end

@implementation ShareViewController

- (BOOL)isContentValid {
    // Do validation of contentText and/or NSExtensionContext attachments here
    return YES;
}

- (void)didSelectPost {
    // This is called after the user selects Post. Do the upload of contentText and/or NSExtensionContext attachments.
    
    // Inform the host that we're done, so it un-blocks its UI. Note: Alternatively you could call super's -didSelectPost, which will similarly complete the extension context.
    [self.extensionContext.inputItems enumerateObjectsUsingBlock:^(NSExtensionItem * _Nonnull extItem, NSUInteger idx, BOOL * _Nonnull stop) {
        [extItem.attachments enumerateObjectsUsingBlock:^(NSItemProvider  * _Nonnull itemProvider, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([itemProvider hasItemConformingToTypeIdentifier:@"public.png"]) {
                [itemProvider loadItemForTypeIdentifier:@"public.png" options:nil completionHandler:^(id<NSSecureCoding>  _Nullable item, NSError * _Null_unspecified error) {
                    if ([(NSObject *)item isKindOfClass:[NSURL class]]) {
                        NSUserDefaults *userDefaults = [[NSUserDefaults alloc] initWithSuiteName:@"group.io.fanlv.potatso"];
                        [userDefaults setObject:((NSURL *)item).absoluteString forKey:@"com.owen.iosfeature.shareextension.shareUrl"];
                        [userDefaults synchronize];
//                        [self.extensionContext completeRequestReturningItems:@[itemProvider] completionHandler:nil];
                        [self.extensionContext openURL:[NSURL URLWithString:@"shareExtension://shareImage"] completionHandler:nil];
                    }
                }];
            } else if ([itemProvider hasItemConformingToTypeIdentifier:@"public.mpeg-4"]) {
                [itemProvider loadItemForTypeIdentifier:@"public.mpeg-4" options:nil completionHandler:^(id<NSSecureCoding>  _Nullable item, NSError * _Null_unspecified error) {
                    if ([(NSObject *)item isKindOfClass:[NSURL class]]) {
                        NSUserDefaults *userDefaults = [[NSUserDefaults alloc] initWithSuiteName:@"group.io.fanlv.potatso"];
                        [userDefaults setObject:((NSURL *)item).absoluteString forKey:@"com.owen.iosfeature.shareextension.shareVideo"];
                        [userDefaults synchronize];
//                        [self.extensionContext completeRequestReturningItems:@[itemProvider] completionHandler:nil];
                        [self.extensionContext openURL:[NSURL URLWithString:@"shareExtension://shareVideo"] completionHandler:nil];
                    }
                }];
            }
        }];
    }];
//    [self.extensionContext completeRequestReturningItems:@[] completionHandler:nil];
}

- (NSArray *)configurationItems {
    // To add configuration options via table cells at the bottom of the sheet, return an array of SLComposeSheetConfigurationItem here.
    SLComposeSheetConfigurationItem *item1 = [[SLComposeSheetConfigurationItem alloc] init];
    item1.title = @"发布视频";
    SLComposeSheetConfigurationItem *item2 = [[SLComposeSheetConfigurationItem alloc] init];
    item2.title = @"发布到鱼吧";
    return @[item1,item2];
}

@end
