//
//  UIView+LEOExtension.m
//  百思不得姐
//
//  Created by chinabkorse on 15/7/22.
//  Copyright (c) 2015年 Leo. All rights reserved.
//

#import "UIView+LEOExtension.h"

@implementation UIView (LEOExtension)

- (void)setLeo_x:(CGFloat)leo_x
{
    CGRect frame = self.frame;
    frame.origin.x = leo_x;
    self.frame = frame;
}
- (CGFloat)leo_x
{
    return self.frame.origin.x;
}

- (void)setLeo_y:(CGFloat)leo_y
{
    CGRect frame = self.frame;
    frame.origin.y = leo_y;
    self.frame = frame;
}
- (CGFloat)leo_y
{
    return self.frame.origin.y;
}

- (void)setLeo_centerX:(CGFloat)leo_centerX
{
    CGPoint center = self.center;
    center.x = leo_centerX;
    self.center = center;
}

- (CGFloat)leo_centerX
{
    return self.center.x;
}
- (void)setLeo_centerY:(CGFloat)leo_centerY
{
    CGPoint center = self.center;
    center.y = leo_centerY;
    self.center = center;
}

- (CGFloat)leo_centerY
{
    return self.center.y;
}

- (void)setLeo_width:(CGFloat)leo_width
{
    CGRect frame = self.frame;
    frame.size.width = leo_width;
    self.frame = frame;
}

- (CGFloat)leo_width
{
    return self.frame.size.width;
}

- (void)setLeo_height:(CGFloat)leo_height
{
    CGRect frame = self.frame;
    frame.size.height = leo_height;
    self.frame = frame;
}
- (CGFloat)leo_height
{
    return self.frame.size.height;
}

- (void)setLeo_size:(CGSize)leo_size
{
    CGRect frame = self.frame;
    frame.size = leo_size;
    self.frame = frame;
}

- (CGSize)leo_size
{
    return self.frame.size;
}




@end
