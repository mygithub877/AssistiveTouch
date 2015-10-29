//
//  LEOAssistiveWindow.m
//  AssistiveTouch
//
//  Created by liuwenjie on 15/10/24.
//  Copyright © 2015年 Leo. All rights reserved.
//

#import "LEOAssistiveWindow.h"
#import <objc/runtime.h>
@interface LEOAssistiveWindow ()
{
    NSMutableArray *_buttonItems;
    UIView *_contentView;
    
    CGFloat _toolBarWidth;
    
    NSTimeInterval _lastEventTimeStamp;
    
    NSTimer *_timer;
    CGPoint _startPoint;
    
    BOOL _isMove;
}

@end

@implementation LEOAssistiveWindow
- (void)dealloc
{
    _timer=nil;
}
- (instancetype)init
{
    self = [super init];
    if (self) {
        [self configuration];
    }
    return self;
}
- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [self configuration];
    }
    return self;
}
-(void)configuration{
    _buttonItems=[NSMutableArray array];
    self.clipsToBounds=YES;
    _contentView=[[UIView alloc] init];
    
//    dispatch_async(dispatch_get_global_queue(0, 0), ^{
//        @autoreleasepool {
//            _timer = [NSTimer timerWithTimeInterval:1.0f target:self selector:@selector(checkWindowEvent:) userInfo:nil repeats:YES];
//
//            [[NSRunLoop currentRunLoop]addTimer:_timer forMode:NSRunLoopCommonModes];
//            [[NSRunLoop currentRunLoop]run];
//            [_timer fire];
//
//        }
//        _lastEventTimeStamp=[[NSDate date] timeIntervalSince1970];
//    });
    
    NSTimeInterval period = 1.0; //设置时间间隔
    
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    
    dispatch_source_t _gcdtimer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    
    dispatch_source_set_timer(_gcdtimer, dispatch_walltime(NULL, 0), period * NSEC_PER_SEC, 0); //每秒执行
    _lastEventTimeStamp=[[NSDate date] timeIntervalSince1970];

    dispatch_source_set_event_handler(_gcdtimer, ^{
        //在这里执行事件
        [self checkWindowEvent:nil];
        if (0) {
            dispatch_source_cancel(_gcdtimer);
        }
    });

    dispatch_resume(_gcdtimer);
    


}
/**
 添加字按钮
 */
-(void)addButtonItem:(UIButton *)btn{
    if (btn) {
        btn.userInteractionEnabled=NO;
        [_buttonItems addObject:btn];
        [self addSubview:btn];
    }
    _items=[_buttonItems copy];
    _toolBarWidth=_items.count*(kDragSubItemWidth+kDragItemMarginWidth);
}
/**
 设置主按钮
 */
-(void)setMainButton:(LEOAssistiveWindowMainItem *)mainButton{
    mainButton.userInteractionEnabled=NO;
    [_mainButton removeFromSuperview];
    _mainButton=mainButton;
    [self addSubview:mainButton];
}
/**
 按钮重新布局
 */
-(void)layoutSubviews{
    [super layoutSubviews];
    if (_direction==DragWindowDirectionLeft) {
        
        [_mainButton setFrame:CGRectMake(self.frame.size.width-kDragMainItemWidth, self.frame.size.height/2-kDragMainItemWidth/2, kDragMainItemWidth, kDragMainItemWidth)];
        for (int i=0; i<_items.count; i++) {
            UIButton *btn=_items[i];
            if (self.select) {
                btn.hidden=NO;
                [btn setFrame:CGRectMake(i*(kDragSubItemWidth+kDragItemMarginWidth), self.frame.size.height/2-kDragSubItemWidth/2, kDragSubItemWidth, self.frame.size.height)];
            }else{
                btn.hidden=YES;
                [btn setFrame:CGRectMake(0, self.frame.size.height/2, 0, 0)];
            }
            ;
        }
        
    }else if (_direction==DragWindowDirectionRight){
        [_mainButton setFrame:CGRectMake(0, self.frame.size.height/2-kDragMainItemWidth/2, kDragMainItemWidth, kDragMainItemWidth)];
        for (int i=0; i<_buttonItems.count; i++) {
            UIButton *btn=_buttonItems[i];
            if (self.select) {
                btn.hidden=NO;
                [btn setFrame:CGRectMake(_mainButton.frame.size.width+i*(kDragSubItemWidth+kDragItemMarginWidth), self.frame.size.height/2-kDragSubItemWidth/2, kDragSubItemWidth, self.frame.size.height)];
            }else{
                btn.hidden=YES;
                [btn setFrame:CGRectMake(_mainButton.frame.size.width, self.frame.size.height/2, 0, 0)];
            }
            
        }
        
    }else{
        [_mainButton setFrame:CGRectMake(0, self.frame.size.height/2-kDragMainItemWidth/2, kDragMainItemWidth, kDragMainItemWidth)];
    }
}

#pragma mark - NSTimer Event
-(void)checkWindowEvent:(NSTimer *)timer{
    NSLog(@"%d",1);
    if (self.select) {
        if ((long)([[NSDate date] timeIntervalSince1970]-_lastEventTimeStamp)==5) {
            /**
             打开5s
             */
            dispatch_async(dispatch_get_main_queue(), ^{
                if ([self.assistiveDelegate respondsToSelector:@selector(assistiveWindowNotTouchInTimer:)]) {
                    [self.assistiveDelegate assistiveWindowNotTouchInTimer:self];
                }

            });
        }
    }else{
        if ((long)([[NSDate date] timeIntervalSince1970]-_lastEventTimeStamp)==5) {
            /**
             关闭5s
             */
            dispatch_async(dispatch_get_main_queue(), ^{
                if ([self.assistiveDelegate respondsToSelector:@selector(assistiveWindowNotTouchInTimer:)]) {
                    [self.assistiveDelegate assistiveWindowNotTouchInTimer:self];
                }

            });

        }
        /**
         贴边5s
         */
        if (self.windowEdge!=AssistiveWindowEdgeNone && (long)([[NSDate date] timeIntervalSince1970]-_lastEventTimeStamp)==10) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if ([self.assistiveDelegate respondsToSelector:@selector(assistiveWindowNotTouchInTimer:)]) {
                    [self.assistiveDelegate assistiveWindowNotTouchInTimer:self];
                }

            });


        }
        
    }
    
}

-(void)sendEvent:(UIEvent *)event{
    [super sendEvent:event];
    if (self.alpha!=1) {
        self.alpha=1;
    }
    _lastEventTimeStamp=[[NSDate date] timeIntervalSince1970];
}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    NSLog(@"touches---began");
    _isMove=NO;
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self];

    _startPoint=point;
    /**
     设置按钮高亮状态
     */
    if (CGRectContainsPoint(_mainButton.frame, point)) {
        _mainButton.highlighted=YES;
    }else{
        for (UIButton *btn in _items) {
            if (CGRectContainsPoint(btn.frame, point)) {
                btn.highlighted=YES;
            }
        }
    }
    
    
}

-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
    NSLog(@"touches---moved");
    CGPoint point = [[touches anyObject] locationInView:self];

    if (self.select) {
        /**
         open时  移动时触摸点在子item上
         */
        if (self.direction==DragWindowDirectionRight) {
            if (!CGRectContainsPoint(_mainButton.frame, point)) {
                return;
            }
        }else if (self.direction==DragWindowDirectionLeft){
            if (!CGRectContainsPoint(_mainButton.frame, point)) {
                return;
            }

        }
        /**
         移动点在main按钮上 调用点击delegate来关闭 并且要设置主按钮的高亮状态
         */
        if ([self.assistiveDelegate respondsToSelector:@selector(assistiveWindowMainButtonEvent:)]) {
            [self.assistiveDelegate assistiveWindowMainButtonEvent:self];
            
        }
        _mainButton.highlighted=YES;
       return;
    }
    /**
     用来标记是否正在移动
     */
    _isMove=YES;

    //计算位移=当前位置-起始位置
        float dx = point.x - _startPoint.x;
        float dy = point.y - _startPoint.y;
        //计算移动后的view中心点
        CGPoint newcenter = CGPointMake(self.center.x + dx, self.center.y + dy);
        /* 限制用户不可将视图托出屏幕 */
        float halfx = CGRectGetMidX(self.bounds);
        //x坐标左边界
        newcenter.x = MAX(halfx, newcenter.x);
    if (newcenter.x==halfx) {//左边界
        NSLog(@"left edge");
        self.windowEdge=AssistiveWindowEdgeLeft;
    }
        //x坐标右边界
        newcenter.x = MIN([UIScreen mainScreen].bounds.size.width - halfx, newcenter.x);
    if (newcenter.x==[UIScreen mainScreen].bounds.size.width - halfx) {//右边界
        NSLog(@"right edge");
        self.windowEdge=AssistiveWindowEdgeRight;
    }

        //y坐标同理
        float halfy = CGRectGetMidY(self.bounds);
        newcenter.y = MAX(halfy, newcenter.y);
    if (newcenter.y==halfy) {//底部边界
        NSLog(@"top edge");
        self.windowEdge=AssistiveWindowEdgeTop;
    }
        newcenter.y = MIN([UIScreen mainScreen].bounds.size.height - halfy, newcenter.y);
    if (newcenter.y==[UIScreen mainScreen].bounds.size.height - halfy) {//顶部边界
        NSLog(@"bottom edge");
        self.windowEdge=AssistiveWindowEdgeBottom;
    }
        //移动view
        self.center = newcenter;

    
}
-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    NSLog(@"touches---ended");
    //如果是移动完则不走delegate
    if (_isMove) {
        _mainButton.highlighted=NO;
        return;
    }
    //否则走
    
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self];
    if (CGRectContainsPoint(_mainButton.frame, point)) {
        //主按钮点击
        _mainButton.highlighted=NO;
        if ([self.assistiveDelegate respondsToSelector:@selector(assistiveWindowMainButtonEvent:)]) {
            [self.assistiveDelegate assistiveWindowMainButtonEvent:self];
            
        }
    }else{
        //字按钮点击
        int i=0;
        for (UIButton *btn in _items) {
            btn.highlighted=NO;
            if (CGRectContainsPoint(btn.frame, point)) {
                if ([self.assistiveDelegate respondsToSelector:@selector(assistiveWindow:itemEventAtIndex:)]) {
                    [self.assistiveDelegate assistiveWindow:self itemEventAtIndex:i];
                }
            }
            
            i++;
        }
    }
    
    
}
-(void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event{
    NSLog(@"touches---cancel");

    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self];
    if (CGRectContainsPoint(_mainButton.frame, point)) {
        _mainButton.highlighted=NO;
    }else{
        for (UIButton *btn in _items) {
            if (CGRectContainsPoint(btn.frame, point)) {
                btn.highlighted=NO;
            }
        }
    }
}
/**
 window打开
 */
-(void)open{
    CGRect frame=self.frame;
    CGRect screenBounds=[UIScreen mainScreen].bounds;
    
    if (frame.origin.x+frame.size.width/2<=screenBounds.size.width/2) {
        //右
        self.direction=DragWindowDirectionRight;
        frame.size.width+=_toolBarWidth;
        if ((screenBounds.size.width-frame.origin.x)<frame.size.width) {
            frame.origin.x=screenBounds.size.width-frame.size.width;
        }
        if ([self.assistiveDelegate respondsToSelector:@selector(assistiveWindowWillAppear:)]) {
            [self.assistiveDelegate assistiveWindowWillAppear:self];
        }
        
            self.frame=frame;
            
            if ([self.assistiveDelegate respondsToSelector:@selector(assistiveWindowDidAppear:)]) {
                [self.assistiveDelegate assistiveWindowDidAppear:self];
            }

    }else{
        //左
        self.direction=DragWindowDirectionLeft;
        frame.size.width+=_toolBarWidth;
        frame.origin.x-=_toolBarWidth;
        if (frame.origin.x<0) {
            frame.origin.x=0;
        }
        if ([self.assistiveDelegate respondsToSelector:@selector(assistiveWindowWillAppear:)]) {
            [self.assistiveDelegate assistiveWindowWillAppear:self];
        }
            self.frame=frame;
            
            if ([self.assistiveDelegate respondsToSelector:@selector(assistiveWindowDidAppear:)]) {
                [self.assistiveDelegate assistiveWindowDidAppear:self];
            }
    }
    //动画
    [self openItemAnimation];
}
-(void)openItemAnimation{
    for (UIButton *item in _items) {
        CAKeyframeAnimation *k = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
        k.values = @[@(0.1),@(0.5),@(1.0),@(1.3),@(1.0),@(1.1),@(1.0)];
      //  k.keyTimes = @[@(0.1),@(0.3),@(0.3),@(0.5),@(0.3),@(0.3),@(0.3)];
        k.calculationMode = kCAAnimationLinear;
        [item.layer addAnimation:k forKey:@"SHOW"];
        item.highlighted=NO;
    }
}
/**
 关闭
 */
-(void)close{
    [self closeItemAnimation];
}
//关闭动画待定
-(void)closeItemAnimation{
//    for (UIButton *item in _items) {
//        CAKeyframeAnimation *k = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
//        k.values = @[@(1.5),@(1.0),@(0.5),@(0.0)];
//        k.keyTimes = @[@(0.1),@(0.5),@(0.5),@(0.1)];
//        k.calculationMode = kCAAnimationLinear;
//        k.delegate=self;
//        [item.layer addAnimation:k forKey:@"anim"];
//    }
    
    [self animationDidStop:nil finished:NO];
}

//static int i=0;
-(void)animationDidStop:( CAAnimation *)anim finished:(BOOL)fla{
    
    //if (i==_items.count-1) {
        if ([self.assistiveDelegate respondsToSelector:@selector(assistiveWindowWillDisAppear:)]) {
            [self.assistiveDelegate assistiveWindowWillDisAppear:self];
        }
        
        _lastEventTimeStamp=[[NSDate date] timeIntervalSince1970];
        CGRect frame=self.frame;
        //   CGRect screenBounds=[UIScreen mainScreen].bounds;
        if (self.direction==DragWindowDirectionRight) {
            NSLog(@"close right");
            //右
            frame.size.width-=_toolBarWidth;
            
            self.frame=frame;
            _mainButton.highlighted=NO;
            if ([self.assistiveDelegate respondsToSelector:@selector(assistiveWindowDidDisAppear:)]) {
                [self.assistiveDelegate assistiveWindowDidDisAppear:self];
            }
            
        }else if(self.direction==DragWindowDirectionLeft){
            NSLog(@"close left");
            //左
            frame.size.width-=_toolBarWidth;
            frame.origin.x+=_toolBarWidth;
            self.frame=frame;
            _mainButton.highlighted=NO;
            if ([self.assistiveDelegate respondsToSelector:@selector(assistiveWindowDidDisAppear:)]) {
                [self.assistiveDelegate assistiveWindowDidDisAppear:self];
            }
        }

   // }
   // i++;
    _startPoint=CGPointMake(self.frame.size.width/2, self.frame.size.height/2);
}



/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
