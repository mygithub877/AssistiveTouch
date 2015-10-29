//
//  LEOAssistiveWindowItem.m
//  AssistiveTouch
//
//  Created by liuwenjie on 15/10/24.
//  Copyright © 2015年 Leo. All rights reserved.
//

#import "LEOAssistiveWindowItem.h"

@implementation LEOAssistiveWindowItem
- (instancetype)init
{
    self = [super init];
    if (self) {
        _titleBgImageView=[[UIImageView alloc] init];
        _titleBgImageView.layer.cornerRadius=3.f;
        _titleBgImageView.layer.masksToBounds=YES;
        UIImage *oimage=[UIImage imageNamed:@"entrance_btn_typeface_bg"];
        UIImage *image=[oimage stretchableImageWithLeftCapWidth:oimage.size.width/2 topCapHeight:oimage.size.height/2];
        _titleBgImageView.image=image;
        [self addSubview:_titleBgImageView];
    }
    return self;
}

-(void)layoutSubviews{
    [super layoutSubviews];
    self.titleLabel.layer.cornerRadius=3.f;
    self.titleLabel.textAlignment=NSTextAlignmentCenter;
    _titleBgImageView.frame=self.titleLabel.frame;
    
    
}
-(CGRect)imageRectForContentRect:(CGRect)contentRect{
    CGFloat hw=contentRect.size.height-10;
    return CGRectMake(contentRect.size.width/2-hw/2, 0, hw, hw);
}
-(CGRect)titleRectForContentRect:(CGRect)contentRect{
    //    CGSize size=[self.titleLabel.text sizeWithAttributes:@{NSFontAttributeName:self.titleLabel.font}];
    CGSize size=CGSizeMake(30, 15);
    return CGRectMake(contentRect.size.width/2-size.width/2, contentRect.size.height-size.height-8, size.width, size.height);
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
