//
//  AppDelegate.m
//  TestAutolayout
//
//  Created by Owen on 2017/8/15.
//  Copyright © 2017年 Owen. All rights reserved.
//

#import "AppDelegate.h"
#import "ViewController.h"
#import "TestViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] init];
    
    UINavigationController *mainView = [ViewController getInstance];
    self.window.rootViewController = mainView;
    [self.window makeKeyAndVisible];

    //动态创建应用图标上的3D touch快捷选项
    [self creatShortcutItem];
    
    UIApplicationShortcutItem *shortcutItem = [launchOptions valueForKey:UIApplicationLaunchOptionsShortcutItemKey];
    if (shortcutItem) {
        [self performActionForShortcutItem:shortcutItem];
        return NO;
    }
    
    return YES;
}

- (void)creatShortcutItem
{
    //创建系统风格的icon
    UIApplicationShortcutIcon *icon = [UIApplicationShortcutIcon iconWithType:UIApplicationShortcutIconTypeLove];
    
    //创建自定义图标的icon,图标格式35x35像素单色
    //UIApplicationShortcutIcon *icon = [UIApplicationShortcutIcon iconWithTemplateImageName:@"Wonderful.png"];
    
    //创建快捷选项
    UIApplicationShortcutItem * item = [[UIApplicationShortcutItem alloc] initWithType:@"douyu.tv.test" localizedTitle:@"测试" localizedSubtitle:nil icon:icon userInfo:nil];
    
    //添加到快捷选项数组
    [UIApplication sharedApplication].shortcutItems = @[item];
}

- (void)performActionForShortcutItem:(UIApplicationShortcutItem *)shortcutItem {
    //判断先前我们设置的快捷选项标签唯一标识，根据不同标识执行不同操作
    if([shortcutItem.type isEqualToString:@"douyu.tv.test"]){
        TestViewController *testVC = [TestViewController getInstance];
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:testVC];
        if ([self.window.rootViewController isKindOfClass:[UINavigationController class]]) {
            [((UINavigationController *)self.window.rootViewController) pushViewController:testVC animated:YES];
        } else if (self.window.rootViewController.navigationController) {
            [self.window.rootViewController.navigationController pushViewController:testVC animated:YES];
        } else {
            [self.window.rootViewController presentViewController:nav animated:YES completion:^{
                
            }];
        }
    }
}

- (void)application:(UIApplication *)application performActionForShortcutItem:(UIApplicationShortcutItem *)shortcutItem completionHandler:(void (^)(BOOL))completionHandler {
    [self performActionForShortcutItem:shortcutItem];
    if (completionHandler) {
        completionHandler(YES);
    }
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
