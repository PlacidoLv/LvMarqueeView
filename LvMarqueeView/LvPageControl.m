//
//  LvPageControl.m
//  LvMarqueeTest
//
//  Created by lv on 2016/11/4.
//  Copyright © 2016年 lv. All rights reserved.
#import "LvPageControl.h"

@interface LvPageControl ()
{
}

@end

@implementation LvPageControl

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.pageImageSize=CGSizeMake(8, 8);
    }
    return self;
}

-(id)initWithFrame:(CGRect)frame
{
    
    self = [super initWithFrame:frame];
    self.pageImageSize=CGSizeMake(8, 8);
    
    return self;
    
}

-(void)updateDots
{
    for (int i=0; i<[self.subviews count]; i++)
    {
        UIView* dot = [self.subviews objectAtIndex:i];
        [dot.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [obj removeFromSuperview];
        }];

        dot.backgroundColor=[UIColor clearColor];
        
        [dot setFrame:CGRectMake(dot.frame.origin.x, dot.frame.origin.y, self.pageImageSize.width, self.pageImageSize.width)];
        UIImageView *img=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.pageImageSize.width, self.pageImageSize.width)];
       
        
        if (i==self.currentPage)
        {
             img.image=self.selectPageImage;
        }
        else
        {
            img.image=self.unSelectPageImage;
        }
        
        [dot addSubview:img];
    }
}

-(void)setCurrentPage:(NSInteger)page
{
    [super setCurrentPage:page];
    
    if (self.selectPageImage&&self.unSelectPageImage)
    {
        [self updateDots];
    }
}



@end
