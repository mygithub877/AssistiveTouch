//
//  LEOAssistiveViewController.m
//  AssistiveTouch
//
//  Created by chinabkorse on 15/10/20.
//  Copyright © 2015年 Leo. All rights reserved.
//

/**
 *  弹出其它Item的数量
 */
#define LEOPushOtherItemCount 4

#import "LEOAssistiveViewController.h"
#import "UIView+LEOExtension.h"
#import "LEONextViewController.h"
#import "LEOAssistiveTouch.h"

@interface LEOAssistiveViewController ()

/** 显示弹出其他item的View */
@property (nonatomic, weak) UIView *showItemView;

/** item */
@property (nonatomic, weak) UIButton *assistiveButton;


@end

@implementation LEOAssistiveViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    
//    self.view.translatesAutoresizingMaskIntoConstraints = NO;
    
//    self.view.backgroundColor = [UIColor yellowColor];
    
//    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
//        button.backgroundColor = [UIColor redColor];
//    button.frame = CGRectMake(0, 0, 50, 40);
//    [button setImage:[UIImage imageNamed:@"cc"] forState:UIControlStateNormal];
//    [button addTarget:self action:@selector(clickButton:) forControlEvents:UIControlEventTouchUpInside];
//    _assistiveButton = button;
//    button.selected = NO;
//    [self.view addSubview:button];
//    
//    button.translatesAutoresizingMaskIntoConstraints = NO;
//    
//    NSLayoutConstraint *heightConstraint = [NSLayoutConstraint constraintWithItem:button attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:0.0 constant:40];
//    [button addConstraint:heightConstraint];
////
//    NSLayoutConstraint *widthConstraint = [NSLayoutConstraint constraintWithItem:button attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:0.0 constant:40];
//    [button addConstraint:widthConstraint];
//    
//    NSLayoutConstraint *leftConstraint = [NSLayoutConstraint constraintWithItem:button attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeft multiplier:1.0 constant:0];
//    [self.view addConstraint:leftConstraint];
//    
//    NSLayoutConstraint *topConstraint = [NSLayoutConstraint constraintWithItem:button attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1.0 constant:0];
//    [self.view addConstraint:topConstraint];
//
}

#pragma mark - 状态栏控制
- (BOOL)prefersStatusBarHidden
{
    return NO;
}

@end
