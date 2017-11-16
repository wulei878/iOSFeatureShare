//
//  TestViewController.m
//  TestAutolayout
//
//  Created by Owen on 2017/8/15.
//  Copyright © 2017年 Owen. All rights reserved.
//

#import "TestViewController.h"
#import <Masonry/Masonry.h>
#import <IQKeyboardManager/IQKeyboardManager.h>
#import "PreviewViewController.h"

#define ALBUM_PATH NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0]
@interface TestObject:NSObject
@property (nonatomic,strong) NSString *cid;
@end
@implementation TestObject
@end

@interface TestViewController ()<UITableViewDelegate,UITableViewDataSource,UIViewControllerPreviewingDelegate>
@property (weak, nonatomic) IBOutlet UIView *container;
@property (weak, nonatomic) IBOutlet UIView *leftView;
@property (weak, nonatomic) IBOutlet UIView *rightView;
@property (nonatomic, strong) UILabel *rightLabel;
@property (weak, nonatomic) IBOutlet UIButton *button;
@property (nonatomic, strong) UILabel *testLabel;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *dataArray;
@end

@implementation TestViewController

+ (TestViewController *)getInstance {
    return [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"TestViewController"];
}

#pragma mark - lifecycle
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Test";
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}



#pragma mark - public methods

#pragma mark - delegates
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([UITableViewCell class])];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NSStringFromClass([UITableViewCell class])];
        NSDictionary *dic = self.dataArray[indexPath.row];
        cell.textLabel.text = dic[@"name"];
        if (self.traitCollection.forceTouchCapability == UIForceTouchCapabilityAvailable) {
            [self registerForPreviewingWithDelegate:self sourceView:cell];
        }
    }
    return cell;
}

- (UIViewController *)previewingContext:(id<UIViewControllerPreviewing>)previewingContext viewControllerForLocation:(CGPoint)location {
    //获取按压的cell所在行，[previewingContext sourceView]就是按压的那个视图
    NSIndexPath *indexPath = [self.tableView indexPathForCell:(UITableViewCell *)[previewingContext sourceView]];
    NSDictionary *dic = self.dataArray[indexPath.row];
    PreviewViewController *preVC = [[PreviewViewController alloc] initWithText:dic[@"detail"]];
    preVC.preferredContentSize = CGSizeMake(0, 500);
    //调整不被虚化的范围，按压的那个cell不被虚化（轻轻按压时周边会被虚化，再少用力展示预览，再加力跳页至设定界面）
    CGRect rect = CGRectMake(0, 0, self.view.frame.size.width,40);
    previewingContext.sourceRect = rect;
    
    //返回预览界面
    return preVC;
}

- (void)previewingContext:(id<UIViewControllerPreviewing>)previewingContext commitViewController:(UIViewController *)viewControllerToCommit {
    NSIndexPath *indexPath = [self.tableView indexPathForCell:(UITableViewCell *)[previewingContext sourceView]];
    NSDictionary *dic = self.dataArray[indexPath.row];
    PreviewViewController *preVC = [[PreviewViewController alloc] initWithText:dic[@"detail"]];
    [self.navigationController pushViewController:preVC animated:YES];
}

#pragma mark - event responses

#pragma mark - private methods

#pragma mark - getters and setters

- (UILabel *)testLabel {
    if (!_testLabel) {
        _testLabel = [[UILabel alloc] init];
    }
    return _testLabel;
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    }
    return _tableView;
}

- (NSArray *)dataArray {
    if (!_dataArray) {
        _dataArray = @[@{@"name":@"成龙",
                         @"detail":@"成龙，1954年4月7日出生于香港中西区，祖籍安徽省芜湖，中国香港男演员、导演、动作指导、制作人、编剧、歌手。\
                         1971年以武师身份进入电影圈[1]  。1976年在动作片《新精武门》中担任男主角。1978年主演的动作片《蛇形刁手》、《醉拳》标志着功夫喜剧片的开端[2]  。1980年自编自导的动作片《师弟出马》获得香港年度票房冠军[3]  。1985年主演的喜剧动作片《夏日福星》打破香港地区票房纪录[4]  。1986年自导自演的动作片《警察故事》获得第5届香港电影金像奖最佳影片奖[5]  。1991年担任剧情片《阮玲玉》的制作人。1992年发行个人首张国语专辑《第一次》。1993年凭借警匪片《重案组》获得第30届台湾电影金马奖最佳男主角奖[6]  。\
                         1995年通过动作片《红番区》打入美国好莱坞[7]  。1998年凭借动作片《尖峰时刻》奠定其在好莱坞的地位[8]  。2001年主演的喜剧动作片《尖峰时刻2》创下华人演员主演好莱坞电影的票房纪录[9-10]  。2010年获得第54届亚太影展杰出电影成就奖[11]  。2012年被美国《纽约时报》评选为“史上20位最伟大的动作影星第一位”[12]  。2013年凭借动作片《十二生肖》获得第32届香港电影金像奖最佳动作设计奖[13]  。2016年获得奥斯卡金像奖终身成就奖[14]  。成龙与周润发、周星驰并称为双周一成。他擅长谐趣风格的动作喜剧片；截至2017年，其主演电影在全球的总票房超过200亿元。\
                             演艺事业外，成龙热心公益事业。2004年担任联合国儿童基金会亲善大使[15]  。2006年入选《福布斯》杂志评出的“十大慈善之星”[16]  。"
                         
                         },
                       @{@"name":@"MIUI 9",
                         @"detail":@"MIUI9是2017年7月26日小米在北京国家会议中心召开发布会发布的全新小米手机官方操作系统。[1]\
                                                                                                           MIUI9在小米MIUI内部代号“闪电”，主要特点是“快”。官方slogan是“快如闪电”。[2]\
                                                                                                           MIUI9在系统稳定性、流畅度、续航上面有很大提升。2017年新发布的传送门、信息助手、照片查找、分屏等功能着重于提高使用手机使用效率。[3]\
                                                                                                           MIUI9提升了应用启动速度，在艾瑞TOP50热门应用进行启动速度对比中领先。采用动态资源分配机制，优先把资源分配给当前正在使用的应用。在测试过程中，MIUI9模拟用户日常综合使用行为，连续使用不卡顿。[4]  2017年11月15日，MIUI9稳定版现已支持18款小米手机升级。[5] "
                         }
                       ];
    }
    return _dataArray;
}
@end
