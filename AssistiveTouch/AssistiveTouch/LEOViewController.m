//
//  LEOViewController.m
//  AssistiveTouch
//
//  Created by chinabkorse on 15/10/20.
//  Copyright © 2015年 Leo. All rights reserved.
//

#import "LEOViewController.h"
#import "LEOAssistiveTouch.h"
#import "LEONextViewController.h"

@interface LEOViewController ()

@end

@implementation LEOViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //设置背景
    self.view.backgroundColor = [UIColor brownColor];
    
    //测试控件
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeContactAdd];
    btn.frame = CGRectMake(200, 200, 50, 50);
    [self.view addSubview:btn];
    [btn addTarget:self action:@selector(push) forControlEvents:UIControlEventTouchUpInside];
}

- (void)push {
    
    LEONextViewController *next = [[LEONextViewController alloc]init];
    [self presentViewController:next animated:YES completion:nil];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
