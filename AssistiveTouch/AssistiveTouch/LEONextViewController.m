//
//  LEONextViewController.m
//  AssistiveTouch
//
//  Created by chinabkorse on 15/10/20.
//  Copyright © 2015年 Leo. All rights reserved.
//

#import "LEONextViewController.h"
#import "LEOAssistiveTouch.h"

@interface LEONextViewController ()

@end

@implementation LEONextViewController



- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor grayColor];
    
    //测试控件
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeContactAdd];
    btn.frame = CGRectMake(200, 200, 50, 50);
    [self.view addSubview:btn];
    [btn addTarget:self action:@selector(dismis) forControlEvents:UIControlEventTouchUpInside];
    
}

- (void)dismis
{
    [self  dismissViewControllerAnimated:YES completion:^{
        [LEOAssistiveTouch show];
    }];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
