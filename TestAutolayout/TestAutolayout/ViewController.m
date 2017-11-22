//
//  ViewController.m
//  TestAutolayout
//
//  Created by Owen on 2017/8/15.
//  Copyright © 2017年 Owen. All rights reserved.
//

#import "ViewController.h"
#import "TestViewController.h"
#import "DYCustomButton.h"
#import <Masonry/Masonry.h>
#import "TANotificationManager.h"
#import <AFNetworking/AFNetworking.h>

@interface ViewController ()
@property (nonatomic, strong) UILabel *touchLabel;
@property (nonatomic, strong) UILabel *touchTipValueLabel;
@property (nonatomic, strong) UIDatePicker *datePicker;
@property (nonatomic, strong) UITextField *textField;
@end

@implementation ViewController
+ (UINavigationController *)getInstance {
    return [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateInitialViewController];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Main";
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.touchLabel];
    [self.view addSubview:self.touchTipValueLabel];
    [self.touchLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(-40);
        make.centerX.mas_equalTo(self.view);
    }];
    [self.touchTipValueLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(70);
        make.centerX.mas_equalTo(self.view);
    }];
    UITextField *textField = [[UITextField alloc] init];
    [self.view addSubview:textField];
    [textField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.touchTipValueLabel.mas_bottom).offset(0);
        make.size.mas_equalTo(CGSizeMake(100, 44));
        make.centerX.mas_equalTo(self.view);
    }];
    UIDatePicker *datePicker = [[UIDatePicker alloc] init];
    datePicker.datePickerMode = UIDatePickerModeDate;
    [datePicker addTarget:self action:@selector(dateChanged) forControlEvents:UIControlEventValueChanged];
    self.datePicker = datePicker;
    textField.inputView = datePicker;
    textField.borderStyle = UITextBorderStyleLine;
    self.textField = textField;
    
    UIButton *shareButton = [[UIButton alloc] init];
    [shareButton setTitle:@"分享" forState:UIControlStateNormal];
    [shareButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [shareButton addTarget:self action:@selector(shareAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:shareButton];
    [shareButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(-50);
        make.width.mas_equalTo(100);
        make.height.mas_equalTo(44);
        make.centerX.mas_equalTo(self.view);
    }];
    [[TANotificationManager sharedManager] createNotification];
}

-(void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    NSArray *arrayTouch = [touches allObjects];
    UITouch *touch = (UITouch *)[arrayTouch lastObject];
    //通过tag确定按压的是哪个view，注意：如果按压的是label，将label的userInteractionEnabled属性设置为YES
    if (touch.view.tag == 520) {
        self.touchTipValueLabel.text = [NSString stringWithFormat:@"force:%f\n maximumPossibleForce:%f",touch.force,touch.maximumPossibleForce];
    }
}

- (void)dateChanged {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    self.textField.text = [formatter stringFromDate:self.datePicker.date];
    // NSUserDefaults共享数据
    NSUserDefaults *shared = [[NSUserDefaults alloc] initWithSuiteName:@"group.io.fanlv.potatso"];
    [shared setObject:self.textField.text forKey:@"com.owen.iosfeature.todayextension.testAutolayoutTime"];
    [shared synchronize];
    
    // NSFileManager共享数据
//    NSURL *containerURL = [[NSFileManager defaultManager] containerURLForSecurityApplicationGroupIdentifier:@"group.tv.douyu.live"];
//    containerURL = [containerURL URLByAppendingPathComponent:@"Library/Caches/widget"];
//    BOOL result = [self.textField.text writeToURL:containerURL atomically:YES encoding:NSUTF8StringEncoding error:nil];
}

- (void)shareAction {
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

#pragma mark - getter and setter
- (UILabel*)touchLabel
{
    if (_touchLabel == nil) {
        _touchLabel = [[UILabel alloc] init];
        _touchLabel.font = [UIFont systemFontOfSize:25];
        _touchLabel.text = @"force touch";
        _touchLabel.userInteractionEnabled = YES;
        _touchLabel.textAlignment = NSTextAlignmentCenter;
        _touchLabel.tag = 520;
    }
    
    return _touchLabel;
}

- (UILabel*)touchTipValueLabel
{
    if (_touchTipValueLabel == nil) {
        _touchTipValueLabel = [[UILabel alloc] init];
        _touchTipValueLabel.font = [UIFont systemFontOfSize:25];
        _touchTipValueLabel.textAlignment = NSTextAlignmentCenter;
        _touchTipValueLabel.numberOfLines = 2;
    }
    
    return _touchTipValueLabel;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)pushAction:(id)sender {
    TestViewController *vc = [TestViewController getInstance];
    [self.navigationController pushViewController:vc animated:YES];
    vc.actionBlock = ^(UIViewController *viewController) {
        NSLog(@"no crash");
    };
    
}


@end
