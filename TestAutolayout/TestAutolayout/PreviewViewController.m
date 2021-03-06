//
//  PreviewViewController.m
//  TestAutolayout
//
//  Created by Owen on 2017/11/16.
//  Copyright © 2017年 Owen. All rights reserved.
//

#import "PreviewViewController.h"
#import <Masonry/Masonry.h>

@interface PreviewViewController ()
@property (nonatomic, strong) NSString *text;
@property (nonatomic, strong) UILabel *detailLabel;
@end

@implementation PreviewViewController
- (instancetype)initWithText:(NSString *)text {
    self = [super init];
    if (self) {
        self.text = text;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Detail";
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.detailLabel];
    [self.detailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.mas_equalTo(20);
        make.right.bottom.mas_equalTo(-20);
    }];
    self.detailLabel.text = self.text;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSArray<id<UIPreviewActionItem>> *)previewActionItems {
    UIPreviewAction *action1 = [UIPreviewAction actionWithTitle:@"关注" style:UIPreviewActionStyleSelected handler:^(UIPreviewAction * _Nonnull action, UIViewController * _Nonnull previewViewController) {
    }];
    UIPreviewAction *action2 = [UIPreviewAction actionWithTitle:@"分享" style:UIPreviewActionStyleDefault handler:^(UIPreviewAction * _Nonnull action, UIViewController * _Nonnull previewViewController) {
        [self shareActionWithViewController:previewViewController];
    }];
    return @[action1,action2];
}

- (void)shareActionWithViewController:(UIViewController *)viewController {
    NSString *text = @"斗鱼直播-每个人的直播平台";
    NSURL *shareURL = [NSURL URLWithString:@"https://www.douyu.com"];
    NSArray *activityItems = @[text,shareURL];
    UIActivityViewController *activityVC = [[UIActivityViewController alloc] initWithActivityItems:activityItems applicationActivities:nil];
    activityVC.completionWithItemsHandler = ^(UIActivityType  _Nullable activityType, BOOL completed, NSArray * _Nullable returnedItems, NSError * _Nullable activityError) {
        if (completed) {
            NSLog(@"分享成功");
        } else {
            NSLog(@"分享失败");
        }
    };
    [self presentViewController:activityVC animated:YES completion:nil];
}

- (UILabel *)detailLabel {
    if (!_detailLabel) {
        _detailLabel = [[UILabel alloc] init];
        _detailLabel.textColor = [UIColor blackColor];
        _detailLabel.font = [UIFont systemFontOfSize:12];
        _detailLabel.numberOfLines = 0;
    }
    return _detailLabel;
}

@end
