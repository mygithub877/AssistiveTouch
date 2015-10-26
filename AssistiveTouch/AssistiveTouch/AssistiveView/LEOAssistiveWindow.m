//
//  LEOAssistiveWindow.m
//  AssistiveTouch
//
//  Created by liuwenjie on 15/10/24.
//  Copyright © 2015年 Leo. All rights reserved.
//

#import "LEOAssistiveWindow.h"

@interface LEOAssistiveWindow ()
{
    NSMutableArray *_buttonItems;
    UIView *_contentView;
    
    CGFloat _toolBarWidth;
    
    NSTimeInterval _lastEventTimeStamp;
    
    NSTimer *_timer;
    
}
@end

@implementation LEOAssistiveWindow
- (void)dealloc
{
    [_timer invalidate];
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
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
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
    _timer = [NSTimer timerWithTimeInterval:1.0f target:self selector:@selector(checkWindowEvent:) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop]addTimer:_timer forMode:NSDefaultRunLoopMode];
    [_timer fire];
    _lastEventTimeStamp=[[NSDate date] timeIntervalSince1970];

}
-(void)addButtonItem:(UIButton *)btn{
    if (btn) {
        btn.userInteractionEnabled=NO;
        [_buttonItems addObject:btn];
        [self addSubview:btn];
    }
    _items=[_buttonItems copy];
    _toolBarWidth=_items.count*(kDragSubItemWidth+kDragItemMarginWidth);
}
-(void)setMainButton:(LEOAssistiveWindowMainItem *)mainButton{
    mainButton.userInteractionEnabled=NO;
    [_mainButton removeFromSuperview];
    _mainButton=mainButton;
    [self addSubview:mainButton];
}
-(void)setFrame:(CGRect)frame{
    [super setFrame:frame];
}
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
            [self animation:btn];
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
            [self animation:btn];
            
        }
        
    }else{
        [_mainButton setFrame:CGRectMake(0, self.frame.size.height/2-kDragMainItemWidth/2, kDragMainItemWidth, kDragMainItemWidth)];
    }
}
- (void)animation:(UIButton *)btn
{
    CAKeyframeAnimation *k = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
    k.values = @[@(0.1),@(1.0),@(1.5),@(1.0)];
    k.keyTimes = @[@(0.0),@(0.5),@(0.8),@(1.0),@(0.5)];
    k.calculationMode = kCAAnimationLinear;
    [btn.layer addAnimation:k forKey:@"SHOW"];
}

#pragma mark - NSTimer Event
-(void)checkWindowEvent:(NSTimer *)timer{
    if (self.select) {
        if ((long)([[NSDate date] timeIntervalSince1970]-_lastEventTimeStamp)==5) {
            if ([self.assistiveDelegate respondsToSelector:@selector(assistiveWindowNotTouchInTimer:)]) {
                [self.assistiveDelegate assistiveWindowNotTouchInTimer:self];
            }
        }
    }else{
        if ((long)([[NSDate date] timeIntervalSince1970]-_lastEventTimeStamp)==5) {
            if ([self.assistiveDelegate respondsToSelector:@selector(assistiveWindowNotTouchInTimer:)]) {
                [self.assistiveDelegate assistiveWindowNotTouchInTimer:self];
            }
        }
        if (self.windowEdge!=AssistiveWindowEdgeNone && (long)([[NSDate date] timeIntervalSince1970]-_lastEventTimeStamp)==10) {
            if ([self.assistiveDelegate respondsToSelector:@selector(assistiveWindowNotTouchInTimer:)]) {
                [self.assistiveDelegate assistiveWindowNotTouchInTimer:self];
            }

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
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self];
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
-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self];
    if (CGRectContainsPoint(_mainButton.frame, point)) {
        _mainButton.highlighted=NO;
        if ([self.assistiveDelegate respondsToSelector:@selector(assistiveWindowMainButtonEvent:)]) {
            [self.assistiveDelegate assistiveWindowMainButtonEvent:self];
            
        }
    }else{
        int i=0;
        for (UIButton *btn in _items) {
            if (CGRectContainsPoint(btn.frame, point)) {
                btn.highlighted=NO;
                if ([self.assistiveDelegate respondsToSelector:@selector(assistiveWindow:itemEventAtIndex:)]) {
                    [self.assistiveDelegate assistiveWindow:self itemEventAtIndex:i];
                }
            }
            
            i++;
        }
    }
    
    
}
-(void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event{
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
        
        [UIView animateKeyframesWithDuration:0.2 delay:0 options:UIViewKeyframeAnimationOptionLayoutSubviews animations:^{
            self.frame=frame;
            
        } completion:^(BOOL finished) {
            if ([self.assistiveDelegate respondsToSelector:@selector(assistiveWindowDidAppear:)]) {
                [self.assistiveDelegate assistiveWindowDidAppear:self];
            }

        }];
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
        [UIView animateKeyframesWithDuration:0.2 delay:0 options:UIViewKeyframeAnimationOptionLayoutSubviews animations:^{
            self.frame=frame;
            
        } completion:^(BOOL finished) {
            if ([self.assistiveDelegate respondsToSelector:@selector(assistiveWindowDidAppear:)]) {
                [self.assistiveDelegate assistiveWindowDidAppear:self];
            }
            

        }];
        
    }
}
-(void)close{
    _lastEventTimeStamp=[[NSDate date] timeIntervalSince1970];
    CGRect frame=self.frame;
    //   CGRect screenBounds=[UIScreen mainScreen].bounds;
    if (self.direction==DragWindowDirectionRight) {
        //右
        frame.size.width-=_toolBarWidth;
        
        if ([self.assistiveDelegate respondsToSelector:@selector(assistiveWindowWillDisAppear:)]) {
            [self.assistiveDelegate assistiveWindowWillDisAppear:self];
        }
        self.frame=frame;
        if ([self.assistiveDelegate respondsToSelector:@selector(assistiveWindowDidDisAppear:)]) {
            [self.assistiveDelegate assistiveWindowDidDisAppear:self];
        }

    }else{
        //左
        frame.size.width-=_toolBarWidth;
        frame.origin.x+=_toolBarWidth;
        if ([self.assistiveDelegate respondsToSelector:@selector(assistiveWindowWillDisAppear:)]) {
            [self.assistiveDelegate assistiveWindowWillDisAppear:self];
        }
        self.frame=frame;
        if ([self.assistiveDelegate respondsToSelector:@selector(assistiveWindowDidDisAppear:)]) {
            [self.assistiveDelegate assistiveWindowDidDisAppear:self];
        }
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
