//
//  LEOAssistiveWindow.h
//  AssistiveTouch
//
//  Created by liuwenjie on 15/10/24.
//  Copyright © 2015年 Leo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LEOAssistiveWindowMainItem.h"
/**
 window 高
 */
static  CGFloat const kDragWindowHeight  =70.f;
/**
 window 主按钮宽高
 */
static  CGFloat const kDragMainItemWidth =60;
/**
 子按钮宽
 */
static  CGFloat const kDragSubItemWidth  =60;//40.f;
/**
 字按钮间距
 */
static  CGFloat const kDragItemMarginWidth  =0.f;
/**
 贴边隐藏显示出来的宽
 */
static  CGFloat const kDragWindowMinScreenMargin  =35.f;

/**
 window打开时的方向
 */
typedef NS_OPTIONS(NSInteger, DragWindowDirection) {
    DragWindowDirectionNone,    //关闭没打开
    DragWindowDirectionLeft,    //左
    DragWindowDirectionRight,   //右
};
/**
 贴边时屏幕边框方向
 */
typedef NS_OPTIONS(NSInteger, AssistiveWindowEdge) {
    AssistiveWindowEdgeNone =0, //没有贴边
    AssistiveWindowEdgeBottom,  //底部
    AssistiveWindowEdgeTop,     //顶部
    AssistiveWindowEdgeLeft,    //左
    AssistiveWindowEdgeRight    //右
};
@class  LEOAssistiveWindow;

@protocol LEOAssistiveWindowDelegate <NSObject>

@optional
/**
 将要出现
 */
-(void)assistiveWindowWillAppear:(LEOAssistiveWindow *)window;
/**
 完成出现
 */
-(void)assistiveWindowDidAppear:(LEOAssistiveWindow *)window;
/**
 将要关闭
 */
-(void)assistiveWindowWillDisAppear:(LEOAssistiveWindow *)window;
/**
 完成关闭
 */
-(void)assistiveWindowDidDisAppear:(LEOAssistiveWindow *)window;
/**
 字按钮点击
 */
-(void)assistiveWindow:(LEOAssistiveWindow *)window itemEventAtIndex:(NSInteger)index;
/**
 主按钮点击
 */
-(void)assistiveWindowMainButtonEvent:(LEOAssistiveWindow *)window ;
/**
 5s时间
 */
-(void)assistiveWindowNotTouchInTimer:(LEOAssistiveWindow *)window;

@end

@interface LEOAssistiveWindow : UIWindow

@property (nonatomic, weak) id <LEOAssistiveWindowDelegate>assistiveDelegate;

@property (nonatomic, assign)DragWindowDirection direction;

@property (nonatomic, assign) BOOL select;

@property (nonatomic, assign) AssistiveWindowEdge windowEdge;

@property (nonatomic, strong, readonly) NSArray *items;


@property (nonatomic, strong) LEOAssistiveWindowMainItem *mainButton;
/**
 在弹出控制器时一定要设置为yes 重要的事情说三遍
 在关闭控制器是一定要设置为no
 */
@property (nonatomic, assign) BOOL isCloseWindowAllEvent;

-(void)open;


-(void)close;

-(void)addButtonItem:(UIButton *)btn;

/**
 在弹出控制器之前一定要掉 重要的事情说三遍
 */
-(void)fullScreen;
/**
 在控制器关闭之前一定要掉 重要的事情说三遍
 */
-(void)revert;

@end
