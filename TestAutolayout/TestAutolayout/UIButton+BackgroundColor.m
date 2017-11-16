//
//  UIButton+BackgroundColor.m
//  DYZB
//
//  Created by Owen on 2017/7/13.
//  Copyright © 2017年 mydouyu. All rights reserved.
//

#import "UIButton+BackgroundColor.h"

@implementation UIButton (BackgroundColor)
- (void)setBackgroundColor:(UIColor *)color state:(UIControlState)state
{
    [self setBackgroundImage:[self imageWithColor:color] forState:state];
}

- (UIImage *)imageWithColor:(UIColor *)color {
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}
@end
