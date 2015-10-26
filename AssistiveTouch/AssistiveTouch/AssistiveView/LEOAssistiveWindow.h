//
//  LEOAssistiveWindow.h
//  AssistiveTouch
//
//  Created by liuwenjie on 15/10/24.
//  Copyright © 2015年 Leo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LEOAssistiveWindowMainItem.h"
static  CGFloat const kDragWindowHeight  =70.f;
static  CGFloat const kDragMainItemWidth =60;
static  CGFloat const kDragSubItemWidth  =60;//40.f;
static  CGFloat const kDragItemMarginWidth  =0.f;
static  CGFloat const kDragWindowMinScreenMargin  =25.f;


typedef NS_OPTIONS(NSInteger, DragWindowDirection) {
    DragWindowDirectionNone,
    DragWindowDirectionLeft,
    DragWindowDirectionRight,
};
typedef NS_OPTIONS(NSInteger, AssistiveWindowEdge) {
    AssistiveWindowEdgeNone,
    AssistiveWindowEdgeBottom,
    AssistiveWindowEdgeTop,
    AssistiveWindowEdgeLeft,
    AssistiveWindowEdgeRight
};
@class  LEOAssistiveWindow;
@protocol LEOAssistiveWindowDelegate <NSObject>

@optional
-(void)assistiveWindowWillAppear:(LEOAssistiveWindow *)window;

-(void)assistiveWindowDidAppear:(LEOAssistiveWindow *)window;

-(void)assistiveWindowWillDisAppear:(LEOAssistiveWindow *)window;

-(void)assistiveWindowDidDisAppear:(LEOAssistiveWindow *)window;


-(void)assistiveWindow:(LEOAssistiveWindow *)window itemEventAtIndex:(NSInteger)index;

-(void)assistiveWindowMainButtonEvent:(LEOAssistiveWindow *)window ;
-(void)assistiveWindowNotTouchInTimer:(LEOAssistiveWindow *)window;

@end

@interface LEOAssistiveWindow : UIWindow

@property (nonatomic, weak) id <LEOAssistiveWindowDelegate>assistiveDelegate;

@property (nonatomic, assign)DragWindowDirection direction;

@property (nonatomic, assign) BOOL select;

@property (nonatomic, assign) AssistiveWindowEdge windowEdge;

@property (nonatomic, strong, readonly) NSArray *items;


/**
 设置小虫子图片 设置button的select和normal状态的图片即可,
 close->normal
 open->select
 如果设置open下方向图片 在代理里面设置
 */
@property (nonatomic, strong) LEOAssistiveWindowMainItem *mainButton;


-(void)open;

-(void)close;

-(void)addButtonItem:(UIButton *)btn;



@end
