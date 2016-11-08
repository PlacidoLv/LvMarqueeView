//
//  LvMarqueeView.m
//  LvMarqueeTest
//
//  Created by lv on 2016/11/4.
//  Copyright © 2016年 lv. All rights reserved.

#import "LvMarqueeView.h"
#import "UIImageView+WebCache.h"


#define ScrollWidth self.frame.size.width

#define ScrollHeight self.frame.size.height


@interface LvMarqueeView ()
{
    CGPoint _pointCenterLeft;
    CGPoint _pointCenterCenter;
    CGPoint _pointCenterRight;
}


@end

@implementation LvMarqueeView


- (void)dealloc
{
    self.arrURL = nil;
    self.placeholderImage = nil;
    [self removeTimer];
}


- (instancetype)init
{
    self = [super init];
    if (self) {
       
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame imgURL:(NSMutableArray *)arrImgURL
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self setInit];
        
        _arrURL=arrImgURL;
        self.isShowNetImage=YES;
        [self createPageControl];
    }
    return self;
}



- (instancetype)initWithFrame:(CGRect)frame images:(NSMutableArray *)arrImages
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setInit];
        
        self.arrImages=arrImages;
        self.isShowNetImage=NO;
        [self createPageControl];
    }
    return self;
}

- (void)setInit
{
    self.timeInterval=5;
    self.timeAnimation=0.6;
    self.slideDistance=ScrollWidth/4;
    self.userInteractionEnabled=YES;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationWillEnterForeground) name:UIApplicationWillEnterForegroundNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationDidEnterBackground) name:UIApplicationDidEnterBackgroundNotification object:nil];
}

-(void)applicationWillEnterForeground
{
    [self createTimer];
}

-(void)applicationDidEnterBackground
{
    [self removeTimer];
}

-(void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    
    [self createImageView];
}

#pragma mark 创建轮滑图片
- (void)createImageView
{
    _viewContent=[[UIView alloc]initWithFrame:self.bounds];
    _viewContent.clipsToBounds=YES;
    _viewContent.userInteractionEnabled=YES;
    [self addSubview:_viewContent];
    
    UIImageView *imgCenter = [[UIImageView alloc] initWithFrame:self.bounds];
    imgCenter.userInteractionEnabled=NO;
    [_viewContent addSubview:imgCenter];
    _pointCenterCenter=CGPointMake(ScrollWidth/2.0, ScrollHeight/2.0);
    
     _imgCenter = imgCenter;
    
    if (self.arrURL.count>1||_arrImages.count>1)
    {
        UIImageView *imgLeft = [[UIImageView alloc] initWithFrame:CGRectMake(-ScrollWidth, 0, ScrollWidth, ScrollHeight)];
        imgLeft.userInteractionEnabled=YES;
        [_viewContent addSubview:imgLeft];
        _pointCenterLeft=CGPointMake(-ScrollWidth/2, ScrollHeight/2);
        
        UIImageView *imgRight = [[UIImageView alloc] initWithFrame:CGRectMake(ScrollWidth, 0,  ScrollWidth, ScrollHeight)];
        imgRight.userInteractionEnabled=YES;
        [_viewContent addSubview:imgRight];
        _pointCenterRight=CGPointMake(3*ScrollWidth/2, ScrollHeight/2);;

        _imgLeft = imgLeft;
        _imgRight = imgRight;
    }

    
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(pan:)];
    [self addGestureRecognizer:pan];

    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
    [self addGestureRecognizer:tap];
    

    [self changeImageCurrentt:_currentIndex];
    
    [self createTimer];
    
    if(self.selectIndex>0)
    {
        self.currentIndex=self.selectIndex-1;
        [self slideToLeft:NO];
    }
    
    [self bringSubviewToFront:_pageControl];
}

#pragma mark 创建PageControl
-(void)createPageControl
{
    self.pageControl = [[LvPageControl alloc] initWithFrame:CGRectMake(0, ScrollHeight-30, ScrollWidth, 30)];
    self.pageControl.numberOfPages =self.isShowNetImage? _arrURL.count:_arrImages.count;
    self.pageControl.currentPage = 0;
    [self addSubview:self.pageControl];
}


#pragma mark 点击手势
-(void)tap:(UITapGestureRecognizer *)tap
{
    if (tap.state==UIGestureRecognizerStateEnded)
    {
        
        if (_currentIndex<0) {
            return;
        }
        
        if (self.isShowNetImage)
        {
            if ([self.delagate respondsToSelector:@selector(LvMarqueeView:selectedIndex:url:)])
            {
                [self.delagate LvMarqueeView:self selectedIndex:_currentIndex url:_arrURL[_currentIndex]];
            }
        }
        else
        {
            if ([self.delagate respondsToSelector:@selector(LvMarqueeView:selectedIndex:image:)])
            {
                [self.delagate LvMarqueeView:self selectedIndex:_currentIndex image:_arrImages[_currentIndex]];
            }
        }

    }
}

#pragma mark 滑动手势
- (void)pan:(UIPanGestureRecognizer*)pan
{
    CGPoint point=[pan translationInView:pan.view];

    if(_arrURL.count>=2||_arrImages.count>=2)
    {
        _imgCenter.center=CGPointMake(point.x+_imgCenter.center.x, _imgCenter.center.y);
        _imgLeft.center=CGPointMake(point.x+_imgLeft.center.x, _imgLeft.center.y);
        _imgRight.center=CGPointMake(point.x+_imgRight.center.x, _imgRight.center.y);
    }
    
    if(_arrURL.count==1||_arrImages.count==1)
    {
        _imgCenter.center=CGPointMake(point.x+_imgCenter.center.x, _imgCenter.center.y);
    }

   
    if (pan.state==UIGestureRecognizerStateEnded)
    {
        if(_arrURL.count==1||_arrImages.count==1)
        {
            [self slideCancel];
            
            return;
        }
        
        
        if ((_imgCenter.center.x-ScrollWidth/2)>self.slideDistance||(_imgCenter.center.x-ScrollWidth/2)<-self.slideDistance)
        {
            if(_arrURL.count>=2||_arrImages.count>=2)
            {
                if ((_imgCenter.center.x-ScrollWidth/2)>self.slideDistance)
                {
                     [self slideToRight];
                }
                
                if ((_imgCenter.center.x-ScrollWidth/2)<-self.slideDistance)
                {
                    [self slideToLeft:YES];
                }
            }
        }
        else
        {
            [self slideCancel];
        }
    }
    else
    {
        [self removeTimer];
    }
    
    [pan setTranslation:CGPointZero inView:pan.view];

};


#pragma mark 向左滑动
-(void)slideToLeft:(BOOL)animation
{
    if (animation)
    {
        [UIView animateWithDuration:self.timeAnimation animations:^{
            _imgCenter.center=_pointCenterLeft;
            
            _imgRight.center=_pointCenterCenter;
            
        } completion:^(BOOL finished) {
            _imgLeft.center=_pointCenterRight;
            
            UIImageView *viewMiddle=_imgLeft;
            _imgLeft=_imgCenter;
            
            _imgCenter=_imgRight;
            
            _imgRight=viewMiddle;
            
            [self changeImageCurrentt:++_currentIndex];
            [self createTimer];
            
            if (self.isShowNetImage)
            {
                if ([self.delagate respondsToSelector:@selector(LvMarqueeView:sliderEndIndex:url:sliderCancel:)])
                {
                    [self.delagate LvMarqueeView:self sliderEndIndex:self.currentIndex url:_arrURL[self.currentIndex] sliderCancel:NO];
                }
            }
            else
            {
                if ([self.delagate respondsToSelector:@selector(LvMarqueeView:sliderEndIndex:image:sliderCancel:)])
                {
                    [self.delagate LvMarqueeView:self sliderEndIndex:self.currentIndex image:_arrImages[self.currentIndex] sliderCancel:NO];
                }
            }
        }];
    }
    else
    {
        _imgCenter.center=_pointCenterLeft;
        _imgRight.center=_pointCenterCenter;
        _imgLeft.center=_pointCenterRight;
        
        UIImageView *viewMiddle=_imgLeft;
        _imgLeft=_imgCenter;
        _imgCenter=_imgRight;
        _imgRight=viewMiddle;
        
        [self changeImageCurrentt:++_currentIndex];
        [self createTimer];
        
        if (self.isShowNetImage)
        {
            if ([self.delagate respondsToSelector:@selector(LvMarqueeView:sliderEndIndex:url:sliderCancel:)])
            {
                [self.delagate LvMarqueeView:self sliderEndIndex:self.currentIndex url:_arrURL[self.currentIndex] sliderCancel:NO];
            }
        }
        else
        {
            if ([self.delagate respondsToSelector:@selector(LvMarqueeView:sliderEndIndex:image:sliderCancel:)])
            {
                [self.delagate LvMarqueeView:self sliderEndIndex:self.currentIndex image:_arrImages[self.currentIndex] sliderCancel:NO];
            }
        }
    
    }

}

#pragma mark 向右滑动
-(void)slideToRight
{
    [UIView animateWithDuration:self.timeAnimation animations:^{
        _imgCenter.center=_pointCenterRight;
        _imgLeft.center=_pointCenterCenter;
        
    } completion:^(BOOL finished) {
        _imgRight.center=_pointCenterLeft;
        
        UIImageView *viewMiddle=_imgRight;
        
        _imgRight=_imgCenter;
        _imgCenter=_imgLeft;
        _imgLeft=viewMiddle;
        
        [self changeImageCurrentt:--_currentIndex];
        [self createTimer];
        
        if (self.isShowNetImage)
        {
            if ([self.delagate respondsToSelector:@selector(LvMarqueeView:sliderEndIndex:url:sliderCancel:)])
            {
                [self.delagate LvMarqueeView:self sliderEndIndex:self.currentIndex url:_arrURL[self.currentIndex] sliderCancel:NO];
            }
        }
        else
        {
            if ([self.delagate respondsToSelector:@selector(LvMarqueeView:sliderEndIndex:image:sliderCancel:)])
            {
                [self.delagate LvMarqueeView:self sliderEndIndex:self.currentIndex image:_arrImages[self.currentIndex] sliderCancel:NO];
            }
        }
    }];
}

#pragma mark 滑动取消
-(void)slideCancel
{
    [UIView animateWithDuration:self.timeAnimation animations:^{
        _imgCenter.center=_pointCenterCenter;
        _imgLeft.center=_pointCenterLeft;
        _imgRight.center=_pointCenterRight;
    } completion:^(BOOL finished) {
        [self createTimer];
        
        if (self.isShowNetImage)
        {
            if ([self.delagate respondsToSelector:@selector(LvMarqueeView:sliderEndIndex:url:sliderCancel:)])
            {
                [self.delagate LvMarqueeView:self sliderEndIndex:self.currentIndex url:_arrURL[self.currentIndex] sliderCancel:YES];
            }
        }
        else
        {
            if ([self.delagate respondsToSelector:@selector(LvMarqueeView:sliderEndIndex:image:sliderCancel:)])
            {
                [self.delagate LvMarqueeView:self sliderEndIndex:self.currentIndex image:_arrImages[self.currentIndex] sliderCancel:YES];
            }
        }
    }];
}


#pragma mark 设置Image

- (void)changeImageCurrentt:(NSInteger)centerIndex
{
    NSInteger intArrCount=(NSInteger)(self.isShowNetImage?_arrURL.count:_arrImages.count);
    if (centerIndex>(intArrCount-1))
    {
        centerIndex=0;
    }
    
    if (centerIndex<0)
    {
        centerIndex=intArrCount-1;
    }
    
    _currentIndex=centerIndex;
    self.pageControl.currentPage=_currentIndex;
    
    NSInteger LeftIndex=centerIndex-1;
    NSInteger rightIndex=centerIndex+1;
    
    LeftIndex=LeftIndex<0?(intArrCount-1):LeftIndex;
    rightIndex=rightIndex>(intArrCount-1)?0:rightIndex;
    
    
    if (_arrURL.count>2||_arrImages.count>2)
    {
        if (self.isShowNetImage)
        {
            [_imgLeft sd_setImageWithURL:[NSURL URLWithString:_arrURL[LeftIndex]] placeholderImage:_placeholderImage];
            [_imgCenter sd_setImageWithURL:[NSURL URLWithString:_arrURL[centerIndex]] placeholderImage:_placeholderImage];
            [_imgRight sd_setImageWithURL:[NSURL URLWithString:_arrURL[rightIndex]] placeholderImage:_placeholderImage];
        }
        else
        {
            _imgLeft.image=[UIImage imageNamed:_arrImages[LeftIndex]];
            _imgCenter.image=[UIImage imageNamed:_arrImages[centerIndex]];
            _imgRight.image=[UIImage imageNamed:_arrImages[rightIndex]];
        }

    }
    else
    {
        if (_arrURL.count==2||_arrImages.count==2)
        {
            if (self.isShowNetImage)
            {
                [_imgLeft sd_setImageWithURL:[NSURL URLWithString:_arrURL[!centerIndex]] placeholderImage:_placeholderImage];
                [_imgCenter sd_setImageWithURL:[NSURL URLWithString:_arrURL[centerIndex]] placeholderImage:_placeholderImage];
                [_imgRight sd_setImageWithURL:[NSURL URLWithString:_arrURL[!centerIndex]] placeholderImage:_placeholderImage];
            }
            else
            {
                _imgLeft.image=[UIImage imageNamed:_arrImages[!centerIndex]];
                _imgCenter.image=[UIImage imageNamed:_arrImages[centerIndex]];
                _imgRight.image=[UIImage imageNamed:_arrImages[!centerIndex]];
            }
            

        }
        
        if (_arrURL.count==1||_arrImages.count==1)
        {
            if (self.isShowNetImage)
            {
                [_imgCenter sd_setImageWithURL:[NSURL URLWithString:_arrURL[0]] placeholderImage:_placeholderImage];
            }
            else
            {
                _imgCenter.image=[UIImage imageNamed:_arrImages[0]];
            }
            
        }
    }
}

#pragma mark   创建定时器

- (void)createTimer
{
    [_timer invalidate];
    _timer=nil;
    _timer = [NSTimer timerWithTimeInterval:self.timeInterval target:self selector:@selector(timerRepeat) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
}

#pragma mark   定时器重复方法
- (void)timerRepeat
{
    [self slideToLeft:YES];
}

#pragma mark   移除定时器
- (void)removeTimer
{
    if (_timer == nil)
        return;
    
    [_timer invalidate];
    _timer = nil;
}




@end
