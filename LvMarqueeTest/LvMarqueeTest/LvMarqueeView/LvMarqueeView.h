//
//  LvMarqueeView.h
//  LvMarqueeTest
//
//  Created by lv on 2016/11/4.
//  Copyright © 2016年 lv. All rights reserved.

#import <UIKit/UIKit.h>
#import "LvPageControl.h"

@class LvMarqueeView;

@protocol LvMarqueeViewDelegate <NSObject>

@optional

//滑动结束事件   图片切换结束执行  isCancel是否滑动取消 网络图
-(void)LvMarqueeView:(LvMarqueeView *)LvMarqueeView sliderEndIndex:(NSInteger)index url:(NSString *)strURL sliderCancel:(BOOL)isCancel;

//滑动结束事件   图片切换结束执行  isCancel是否滑动取消 本地图
-(void)LvMarqueeView:(LvMarqueeView *)LvMarqueeView sliderEndIndex:(NSInteger)index image:(NSString *)imagePath sliderCancel:(BOOL)isCancel;

//点击当前显示图片事件 网络图
-(void)LvMarqueeView:(LvMarqueeView *)LvMarqueeView selectedIndex:(NSInteger)index url:(NSString *)strURL;

//点击当前显示图片事件 本地图
-(void)LvMarqueeView:(LvMarqueeView *)LvMarqueeView selectedIndex:(NSInteger)index image:(NSString *)imagePath;

@end


@interface LvMarqueeView : UIView

@property (nonatomic, strong) id <LvMarqueeViewDelegate> delagate;

@property (nonatomic, strong) UIImage  *placeholderImage;
@property (nonatomic, strong) UIImageView  *imgLeft ;
@property (nonatomic, strong) UIImageView  *imgCenter ;
@property (nonatomic, strong) UIImageView  *imgRight ;
@property (nonatomic, strong) UIView  *viewContent;//滚动图片所在层
@property (nonatomic, strong) LvPageControl  *pageControl;//PageControl
@property (nonatomic, strong) NSTimer  *timer;//定时器

@property (nonatomic, assign) NSInteger currentIndex;  //当前显示的是第几张
@property (nonatomic, assign) NSInteger selectIndex;  //初始默认显示第几张，默认0

@property (nonatomic, assign) CGFloat slideDistance;// 滑动距离，即拖动图片超过这个距离才算翻页成功，否则滑动取消，默认当前视图宽度的1/4
@property (nonatomic, assign) NSTimeInterval timeInterval;// 定时器间隔，默认5
@property (nonatomic, assign) NSTimeInterval timeAnimation;// 图片切换动画时间，默认0.6
@property (nonatomic, strong) NSMutableArray *arrURL;//图片链接数组
@property (nonatomic, strong) NSMutableArray *arrImages;//图片Image数组
@property (nonatomic, assign) BOOL  isShowNetImage;//是否显示的是网络图片
//显示网络图片初始化方法
- (instancetype)initWithFrame:(CGRect)frame imgURL:(NSMutableArray *)arrImgURL;

//显示本地图片初始化方法
- (instancetype)initWithFrame:(CGRect)frame images:(NSMutableArray *)arrImages;
@end
