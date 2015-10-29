//
//  LEOAssistiveWindowMainItem.m
//  AssistiveTouch
//
//  Created by liuwenjie on 15/10/24.
//  Copyright © 2015年 Leo. All rights reserved.
//

#import "LEOAssistiveWindowMainItem.h"

@implementation LEOAssistiveWindowMainItem
- (instancetype)init
{
    self = [super init];
    if (self) {
        _borderImageView=[[UIImageView alloc] init];
        [self addSubview:_borderImageView];
        
    }
    return self;
}
-(void)setHighlighted:(BOOL)highlighted{
    [super setHighlighted:highlighted];
    if (highlighted) {
        _borderImageView.image=[UIImage imageNamed:@"entrance_logo_press"];
    }else{
        _borderImageView.image=nil;

    }
}
-(void)layoutSubviews{
    [super layoutSubviews];
    _borderImageView.frame=self.bounds;
}
-(CGRect)imageRectForContentRect:(CGRect)contentRect{
    return CGRectMake(contentRect.origin.x+2, contentRect.origin.y+2, contentRect.size.width-4, contentRect.size.height-4);
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
