//
//  TestViewController.h
//  TestAutolayout
//
//  Created by Owen on 2017/8/15.
//  Copyright © 2017年 Owen. All rights reserved.
//

#import <UIKit/UIKit.h>
@class TestViewController;
typedef void (^actionClour)(TestViewController *viewController);
@interface TestViewController : UIViewController
@property (nonatomic, strong) actionClour actionBlock;
+ (TestViewController *)getInstance;
@end
