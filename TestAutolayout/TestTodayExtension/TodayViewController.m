//
//  TodayViewController.m
//  TestTodayExtension
//
//  Created by Owen on 2017/11/16.
//  Copyright © 2017年 Owen. All rights reserved.
//

#import "TodayViewController.h"
#import <NotificationCenter/NotificationCenter.h>

@interface TodayViewController () <NCWidgetProviding>
@property (nonatomic, strong) UILabel *openAppLabel;
@end

@implementation TodayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.extensionContext.widgetLargestAvailableDisplayMode = NCWidgetDisplayModeExpanded;
    [self.view addSubview:self.openAppLabel];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)openURLContainingAPP {
    //scheme为app的scheme
    [self.extensionContext openURL:[NSURL URLWithString:@"TestTodayExtension://Test"]
                 completionHandler:^(BOOL success) {
                     NSLog(@"open url result:%d",success);
                 }];
}

- (void)widgetActiveDisplayModeDidChange:(NCWidgetDisplayMode)activeDisplayMode withMaximumSize:(CGSize)maxSize {
    if (activeDisplayMode == NCWidgetDisplayModeCompact) {
        self.preferredContentSize = CGSizeMake([UIScreen mainScreen].bounds.size.width, 100);
    } else {
        self.preferredContentSize = CGSizeMake([UIScreen mainScreen].bounds.size.width, 300);
    }
}

- (void)widgetPerformUpdateWithCompletionHandler:(void (^)(NCUpdateResult))completionHandler {
    // Perform any setup necessary in order to update the view.
    
    // If an error is encountered, use NCUpdateResultFailed
    // If there's no update required, use NCUpdateResultNoData
    // If there's an update, use NCUpdateResultNewData

    completionHandler(NCUpdateResultNewData);
}

- (UILabel *)openAppLabel {
    if (!_openAppLabel) {
        _openAppLabel = [[UILabel alloc] init];
        _openAppLabel.textColor = [UIColor colorWithRed:(97.0/255.0) green:(97.0/255.0) blue:(97.0/255.0) alpha:1];
        _openAppLabel.backgroundColor = [UIColor clearColor];
        _openAppLabel.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 100);
        _openAppLabel.textAlignment = NSTextAlignmentCenter;
        _openAppLabel.text = @"点击打开app";
        _openAppLabel.font = [UIFont systemFontOfSize:15];
        _openAppLabel.userInteractionEnabled = YES;
        UITapGestureRecognizer *openURLContainingAPP = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(openURLContainingAPP)];
        [_openAppLabel addGestureRecognizer:openURLContainingAPP];
    }
    return _openAppLabel;
}
@end
