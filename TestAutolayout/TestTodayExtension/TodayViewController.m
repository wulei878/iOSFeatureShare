//
//  TodayViewController.m
//  TestTodayExtension
//
//  Created by Owen on 2017/11/16.
//  Copyright © 2017年 Owen. All rights reserved.
//

#import "TodayViewController.h"
#import <NotificationCenter/NotificationCenter.h>
#import <AFNetworking/AFNetworking.h>
#import <JSONModel/JSONModel.h>
#import <Masonry/Masonry.h>
#import <SDWebImage/UIImageView+WebCache.h>
#import "UIColor+Utils.h"

@interface TADataModel:JSONModel
@property (nonatomic, strong) NSURL *room_src;
@property (nonatomic, copy) NSString *room_name;
@end

@implementation TADataModel
@end

@protocol TADataModel;
@interface TADataListModel:JSONModel
@property (nonatomic, strong) NSArray <TADataModel,Optional> *data;
@property (nonatomic, assign) NSInteger error;
@end

@implementation TADataListModel
@end

@interface TodayViewController () <NCWidgetProviding,UITableViewDataSource,UITableViewDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UILabel *openAppLabel;
@property (nonatomic, strong) NSArray *dataList;
@property (nonatomic, strong) UILabel *tableViewHeader;
@end

@implementation TodayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
    self.extensionContext.widgetLargestAvailableDisplayMode = NCWidgetDisplayModeExpanded;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    // NSUserDefaults共享数据
//    NSUserDefaults *shared = [[NSUserDefaults alloc] initWithSuiteName:@"group.tv.douyu.live"];
//    NSString *time = [shared objectForKey:@"TestAutolayoutTime"];
    
    // NSFileManager共享数据
    NSURL *containerURL = [[NSFileManager defaultManager] containerURLForSecurityApplicationGroupIdentifier:@"group.tv.douyu.live"];
    containerURL = [containerURL URLByAppendingPathComponent:@"Library/Caches/widget"];
    NSString *time = [NSString stringWithContentsOfURL:containerURL encoding:NSUTF8StringEncoding error:nil];
    
    if (time) {
        self.tableViewHeader.text = time;
        self.tableView.tableHeaderView = self.tableViewHeader;
    }
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    
    NSURL *URL = [NSURL URLWithString:@"https://capi.douyucdn.cn/api/v1/getbigDataRoom?client_sys=ios"];
    NSURLRequest *request = [NSURLRequest requestWithURL:URL];
    
    NSURLSessionDataTask *dataTask = [manager dataTaskWithRequest:request completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
        if (error) {
            NSLog(@"Error: %@", error);
        } else {
            TADataListModel *listModel = [[TADataListModel alloc] initWithDictionary:responseObject error:nil];
            self.dataList = listModel.data;
            [self.tableView reloadData];
        }
    }];
    [dataTask resume];
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
        self.preferredContentSize = CGSizeMake([UIScreen mainScreen].bounds.size.width, 120);
    } else {
        self.preferredContentSize = CGSizeMake([UIScreen mainScreen].bounds.size.width, 270);
    }
}

- (void)widgetPerformUpdateWithCompletionHandler:(void (^)(NCUpdateResult))completionHandler {
    // Perform any setup necessary in order to update the view.
    
    // If an error is encountered, use NCUpdateResultFailed
    // If there's no update required, use NCUpdateResultNoData
    // If there's an update, use NCUpdateResultNewData

    completionHandler(NCUpdateResultNewData);
}

#pragma mark - lifecycle

#pragma mark - public methods

#pragma mark - delegates
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return MIN(self.dataList.count, 3);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([UITableViewCell class])];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NSStringFromClass([UITableViewCell class])];
        [cell.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(10);
            make.size.mas_equalTo(CGSizeMake(100, 56));
            make.top.mas_equalTo(10);
            make.bottom.mas_equalTo(-10);
        }];
        [cell.textLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(cell.imageView.mas_right).offset(5);
            make.centerY.mas_equalTo(cell.contentView);
            make.right.mas_lessThanOrEqualTo(-10);
        }];
        cell.textLabel.textColor = [UIColor whiteColor];
        cell.textLabel.font = [UIFont boldSystemFontOfSize:16];
        cell.textLabel.numberOfLines = 0;
        cell.textLabel.textAlignment = NSTextAlignmentLeft;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    TADataModel *model = (TADataModel *)self.dataList[arc4random() % self.dataList.count];
    [cell.imageView sd_setImageWithURL:model.room_src placeholderImage:[UIImage imageNamed:@"video_list_cell_placeholder"]];
    cell.textLabel.text = model.room_name;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self openURLContainingAPP];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.001;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.001;
}
#pragma mark - event responses

#pragma mark - private methods

#pragma mark - getters and setters

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

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.tableFooterView = [[UIView alloc] init];
    }
    return _tableView;
}

- (UILabel *)tableViewHeader {
    if (!_tableViewHeader) {
        _tableViewHeader = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 30)];
        _tableViewHeader.font = [UIFont systemFontOfSize:12];
        _tableViewHeader.textColor = [UIColor whiteColor];
        _tableViewHeader.textAlignment = NSTextAlignmentCenter;
    }
    return _tableViewHeader;
}
@end
