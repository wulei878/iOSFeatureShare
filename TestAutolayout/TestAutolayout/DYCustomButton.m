//
//  DYCustomButton.m
//  TestAutolayout
//
//  Created by Owen on 2017/9/4.
//  Copyright © 2017年 Owen. All rights reserved.
//

#import "DYCustomButton.h"
#import "UIButton+BackgroundColor.h"

@interface DYCustomButton()

@end

@implementation DYCustomButton
- (instancetype)init {
    if (self = [super init]) {
        [self setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [self setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
        [self setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        [self setBackgroundColor:[UIColor whiteColor] state:UIControlStateNormal];
        [self setBackgroundColor:[UIColor yellowColor] state:UIControlStateHighlighted];
        [self setBackgroundColor:[UIColor yellowColor] state:UIControlStateSelected];
        self.layer.cornerRadius = 15;
        self.layer.borderColor = [UIColor grayColor].CGColor;
        self.layer.borderWidth = 0.5;
        self.clipsToBounds = YES;
        self.titleLabel.font = [UIFont systemFontOfSize:14];
        [self setTitle:@"我是按钮" forState:UIControlStateNormal];
//        [self addTarget:self action:@selector(selectTopic) forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}

- (void)setHighlighted:(BOOL)highlighted {
    [super setHighlighted:highlighted];
    if (!highlighted && !self.selected) {
        self.layer.borderWidth = 0.5;
    } else {
       self.layer.borderWidth = 0;
    }
}

- (void)setSelected:(BOOL)selected {
    [super setSelected:selected];
    if (!selected && !self.isHighlighted) {
        self.layer.borderWidth = 0.5;
    } else {
       self.layer.borderWidth = 0;
    }
}
@end
