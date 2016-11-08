//
//  LvPageControl.h
//  LvMarqueeTest
//
//  Created by lv on 2016/11/4.
//  Copyright © 2016年 lv. All rights reserved.

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
@interface LvPageControl : UIPageControl

//选中图片
@property(nonatomic,retain)UIImage* selectPageImage;

//非选中图片
@property(nonatomic,retain)UIImage* unSelectPageImage;

@property(nonatomic,assign)CGSize pageImageSize;
@end
