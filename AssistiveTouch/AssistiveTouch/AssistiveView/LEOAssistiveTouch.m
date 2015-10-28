//
//  LEOAssistiveTouch.m
//  AssistiveTouch
//
//  Created by chinabkorse on 15/10/20.
//  Copyright © 2015年 Leo. All rights reserved.
//

/**
 *  浮窗默认位置和尺寸
 *
 *  @return return value description
 */

#import "LEOAssistiveTouch.h"
#import "LEOAssistiveViewController.h"
#import "LEOAssistiveWindow.h"
#import "LEOAssistiveWindowItem.h"
#import "LEOAssistiveWindowMainItem.h"


#pragma mark - LEOAssistiveTouch
@interface LEOAssistiveTouch ()<LEOAssistiveWindowDelegate>
{
    LEOAssistiveWindow *_window;
    CGRect _currentWindowFrame;
    CGRect _currentScreenBounds;
    BOOL _select;
    UIGestureRecognizer *_panGesture;
}
@end

@implementation LEOAssistiveTouch


+(instancetype)sharedInstance{
    static dispatch_once_t onceToken;
    static LEOAssistiveTouch *instance=nil;
    dispatch_once(&onceToken, ^{
        instance = [[LEOAssistiveTouch alloc] init];
    });
    return instance;

}

- (instancetype)init
{
    self = [super init];
    if (self) {
        _window = [[LEOAssistiveWindow alloc]init];
        _window.frame = CGRectMake(0, [UIScreen mainScreen].bounds.size.height/2, kDragMainItemWidth, kDragWindowHeight);
        _currentWindowFrame=_window.frame;
        _window.windowLevel = UIWindowLevelAlert;
        _window.backgroundColor = [UIColor clearColor];
        _window.hidden=YES;
        _window.assistiveDelegate=self;
        if ([[UIDevice currentDevice].systemVersion floatValue]>=9.0) {
            _window.rootViewController = [[LEOAssistiveViewController alloc] init];
        }
        LEOAssistiveWindowMainItem *mainbtn=[[LEOAssistiveWindowMainItem alloc] init];
        [mainbtn setImage:[UIImage imageNamed:@"entrance_logo"] forState:UIControlStateNormal];
        [mainbtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        _window.mainButton=mainbtn;

        NSArray *title=@[@"账号",@"论坛",@"攻略",@"帮助"];
        NSArray *image=@[@"entrance_btn_accounts_nor",@"entrance_btn_bbs_nor",@"entrance_btn_raiders_nor",@"entrance_btn_infor_nor"];
        for (int i=0; i<title.count; i++) {
            LEOAssistiveWindowItem *btn=[[LEOAssistiveWindowItem alloc] init];
            //btn.backgroundColor=[UIColor blueColor];
            [btn setTitle:title[i] forState:UIControlStateNormal];
            [btn setImage:[UIImage imageNamed:image[i]] forState:UIControlStateNormal];
            btn.titleLabel.font=[UIFont systemFontOfSize:11];
            [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [_window addButtonItem:btn];
        }
        
        _currentScreenBounds=[UIScreen mainScreen].bounds;
        
//        _panGesture = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(panGesture:)];
//        [_window addGestureRecognizer:_panGesture];
        
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(deviceOrientationChange:) name:UIDeviceOrientationDidChangeNotification object:nil];

    }
    return self;
}
#pragma mark - window delegate
-(void)assistiveWindowNotTouchInTimer:(LEOAssistiveWindow *)window{
    if (window.select) {
        window.select=NO;
        [self closeWindow];
    }else{
        if (window.windowEdge!=AssistiveWindowEdgeNone){
            CGRect frame=window.frame;
            CGRect screenBounds=[UIScreen mainScreen].bounds;
            
            if (window.windowEdge==AssistiveWindowEdgeLeft) {
                frame.origin.x=-frame.size.width+kDragWindowMinScreenMargin;
            }else if (window.windowEdge==AssistiveWindowEdgeRight){
                frame.origin.x=screenBounds.size.width-kDragWindowMinScreenMargin;
            }else if (window.windowEdge==AssistiveWindowEdgeTop){
                frame.origin.y=-frame.size.height+kDragWindowMinScreenMargin;
            }else if (window.windowEdge==AssistiveWindowEdgeBottom){
                frame.origin.y=screenBounds.size.height-kDragWindowMinScreenMargin;
            }
            [UIView animateWithDuration:0.25 animations:^{
                window.frame=frame;
            } completion:^(BOOL finished) {
                _currentWindowFrame=window.frame;

            }];
        }
        [window setAlpha:0.5];

    }
}
-(void)assistiveWindow:(LEOAssistiveWindow *)window itemEventAtIndex:(NSInteger)index{
        NSLog(@"index------%d",(int)index);
//    UIViewController *root=[UIApplication sharedApplication].keyWindow.rootViewController;
//    UIViewController *vc=[[UIViewController alloc] init];
//    vc.view.backgroundColor=[UIColor yellowColor];
//    [root presentViewController:vc animated:YES completion:nil];
//    
}
-(void)assistiveWindowMainButtonEvent:(LEOAssistiveWindow *)window{
    if (window.windowEdge!=AssistiveWindowEdgeNone) {
        CGRect frame=window.frame;
        CGRect screenBounds=[UIScreen mainScreen].bounds;

        if (window.windowEdge==AssistiveWindowEdgeLeft) {
            frame.origin.x=0;
        }else if (window.windowEdge==AssistiveWindowEdgeRight){
            frame.origin.x=screenBounds.size.width-window.frame.size.width;
        }else if (window.windowEdge==AssistiveWindowEdgeTop){
            frame.origin.y=0;
        }else if (window.windowEdge==AssistiveWindowEdgeBottom){
            frame.origin.y=screenBounds.size.height-window.frame.size.height;
        }
        [UIView animateWithDuration:0.25 animations:^{
            window.frame=frame;
        } completion:^(BOOL finished) {
            window.windowEdge=AssistiveWindowEdgeNone;
            window.select=YES;
            [window open];
//            _currentWindowFrame=window.frame;
//            if (window.direction==DragWindowDirectionRight) {
//                window.mainButton.borderImageView.image=[UIImage imageNamed:@"entrance_logo_triangle"];
//            }else if (window.direction==DragWindowDirectionLeft){
//                window.mainButton.borderImageView.image=[UIImage imageNamed:@"entrance_logo_left"];
//            }
        }];
        return;
    }
    _window.select=!_window.select;
    if (_window.select) {
        [window open];
    }else{
        [self closeWindow];

    }

}
-(void)assistiveWindowWillAppear:(LEOAssistiveWindow *)window{

}
-(void)assistiveWindowDidAppear:(LEOAssistiveWindow *)window{
    _currentWindowFrame=window.frame;
    if (window.direction==DragWindowDirectionRight) {
        window.mainButton.borderImageView.image=[UIImage imageNamed:@"entrance_logo_triangle"];
    }else if (window.direction==DragWindowDirectionLeft){
        window.mainButton.borderImageView.image=[UIImage imageNamed:@"entrance_logo_left"];
    }

}

-(void)assistiveWindowWillDisAppear:(LEOAssistiveWindow *)window{
}
-(void)assistiveWindowDidDisAppear:(LEOAssistiveWindow *)window{
    _currentWindowFrame=window.frame;

}
-(void)closeWindow{
    [_window close];
    _currentWindowFrame=_window.frame;
}
#pragma mark - pan
- (void)panGesture:(UIPanGestureRecognizer *)pan
{
    // 当前触摸点
    CGPoint currentP = [pan locationInView:_window];
    if (!CGRectContainsPoint(_window.mainButton.frame, currentP)) {
        return;
    }
    if (_window.select) {
        _window.select=NO;
        [self closeWindow];
    }

    NSLog(@"触摸点 = %@",NSStringFromCGPoint(currentP));
    // 移动视图
    // 获取手势的移动，也是相对于最开始的位置
    CGPoint transP = [pan translationInView:_window];
    _window.transform = CGAffineTransformTranslate(_window.transform, transP.x, transP.y);
    // 复位
    [pan setTranslation:CGPointZero inView:_window];
    CGRect frame=_window.frame;
    CGRect screenBounds=[UIScreen mainScreen].bounds;
    _window.windowEdge=AssistiveWindowEdgeNone;
    if (_window.frame.origin.x<0) {
        if (_window.frame.origin.x<=-frame.size.width+kDragWindowMinScreenMargin) {
            frame.origin.x=-frame.size.width+kDragWindowMinScreenMargin;
            _window.frame=frame;
        }
        _window.windowEdge=AssistiveWindowEdgeLeft;
    }
    if (_window.frame.origin.y<0) {
        if (_window.frame.origin.y<=-frame.size.height+kDragWindowMinScreenMargin) {
            frame.origin.y=-frame.size.height+kDragWindowMinScreenMargin;
            _window.frame=frame;

        }
        _window.windowEdge=AssistiveWindowEdgeTop;

    }
    if (_window.frame.origin.x>screenBounds.size.width-_window.frame.size.width) {
        if (_window.frame.origin.x>=screenBounds.size.width-kDragWindowMinScreenMargin) {
            frame.origin.x=screenBounds.size.width-kDragWindowMinScreenMargin;
            _window.frame=frame;

        }
        _window.windowEdge=AssistiveWindowEdgeRight;

    }
    if (_window.frame.origin.y>screenBounds.size.height-_window.frame.size.height) {
        if (_window.frame.origin.y>=screenBounds.size.height-kDragWindowMinScreenMargin) {
            frame.origin.y=screenBounds.size.height-kDragWindowMinScreenMargin;
            _window.frame=frame;
        }
        _window.windowEdge=AssistiveWindowEdgeBottom;

    }
    _currentWindowFrame=_window.frame;
}
-(CGRect)layoutFrame{
    CGRect screenBounds=[UIScreen mainScreen].bounds;
    CGFloat x=_currentWindowFrame.origin.x/_currentScreenBounds.size.width*screenBounds.size.width;
    CGFloat y=_currentWindowFrame.origin.y/_currentScreenBounds.size.height*screenBounds.size.height;
    _currentScreenBounds=screenBounds;
    CGRect rect=CGRectMake(x, y, _currentWindowFrame.size.width, _currentWindowFrame.size.height);
    return rect;
}
-(void)deviceOrientationChange:(NSNotification *)notification{
    UIDeviceOrientation  orient = [UIDevice currentDevice].orientation ;
    _window.frame=[self layoutFrame];

    switch (orient)
    
    {
            
        case UIDeviceOrientationPortrait:
            
            NSLog(@"home 下");
            
            break;
            
        case UIDeviceOrientationLandscapeLeft:
            
            
            NSLog(@"home 右");
            
            
            break;
            
        case UIDeviceOrientationPortraitUpsideDown:
            
            
            NSLog(@"home 上");
            
            
            break;
            
        case UIDeviceOrientationLandscapeRight:
            
            
            
            NSLog(@"home 左");
            
            break;
            
            
            
        default:
            
            break;
            
    }
    

}


#pragma mark ----
+ (void)show
{
    [[LEOAssistiveTouch sharedInstance] show];
}
-(void)show{
    _window.hidden=NO;
}
+ (void)hide
{
    [[LEOAssistiveTouch sharedInstance] hide];
}
-(void)hide{
    _window.hidden=YES;
}
@end


