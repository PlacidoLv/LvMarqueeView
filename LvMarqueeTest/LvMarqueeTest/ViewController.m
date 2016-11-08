//
//  ViewController.m
//  LvMarqueeTest
//
//  Created by lv on 2016/11/4.
//  Copyright © 2016年 lv. All rights reserved.
//

#import "ViewController.h"
#import "LvMarqueeView.h"
#import "UIImageView+WebCache.h"
@interface ViewController ()<LvMarqueeViewDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.automaticallyAdjustsScrollViewInsets=NO;
//    NSArray *arrURL=@[@"http://img04.tooopen.com/images/20130712/tooopen_17270713.jpg"];
//    NSArray *arrURL=@[@"http://img04.tooopen.com/images/20130712/tooopen_17270713.jpg",
//                      @"http://img04.tooopen.com/images/20130617/tooopen_21382885.jpg"];
    
    NSArray *arrURL=@[@"http://img04.tooopen.com/images/20130712/tooopen_17270713.jpg",
                      @"http://img04.tooopen.com/images/20130617/tooopen_21382885.jpg",
                      @"http://img04.tooopen.com/images/20130617/tooopen_21403492.jpg",
                      @"http://img03.tooopen.com/images/20130509/tooopen_09413727.jpg"];
    
    
    UILabel *labNet = [[UILabel alloc]initWithFrame:CGRectMake(50, 30, 50, 30)];
    labNet.textColor=[UIColor blackColor];
    labNet.font=[UIFont systemFontOfSize:14];
    labNet.text=@"网络图";
    labNet.numberOfLines=0;
    [self.view addSubview:labNet];
    
    LvMarqueeView *scrollView=[[LvMarqueeView alloc]initWithFrame:CGRectMake(50, 60, self.view.frame.size.width-100, 180) imgURL:arrURL];
    scrollView.timeAnimation=0.3;
    scrollView.timeInterval=2;
    scrollView.delagate=self;
    [self.view addSubview:scrollView];

    UILabel *labLocal = [[UILabel alloc]initWithFrame:CGRectMake(50, 270, 50, 30)];
    labLocal.textColor=[UIColor blackColor];
    labLocal.font=[UIFont systemFontOfSize:14];
    labLocal.text=@"本地图";
    labLocal.numberOfLines=0;
    [self.view addSubview:labLocal];
    

 
    NSArray *arrImage=@[@"1.jpg",@"2.jpg"];
//    NSArray *arrImage=@[@"1.jpg",@"2.jpg",@"3.jpg",@"4.jpg"];
    LvMarqueeView *scrollImage=[[LvMarqueeView alloc]initWithFrame:CGRectMake(50, 300, self.view.frame.size.width-100, 180) images:arrImage];
    scrollImage.timeAnimation=0.3;
    scrollImage.timeInterval=2;
    scrollImage.delagate=self;
    [self.view addSubview:scrollImage];
}

-(void)LvMarqueeView:(LvMarqueeView *)LvMarqueeView selectedIndex:(NSInteger)index url:(NSString *)strURL
{
    NSLog(@"index=%zd strURL=%@",index,strURL);
}

-(void)LvMarqueeView:(LvMarqueeView *)LvMarqueeView sliderEndIndex:(NSInteger)index url:(NSString *)strURL sliderCancel:(BOOL)isCancel
{
    NSLog(@"index=%zd strURL=%@ isCancel=%zd",index,strURL,isCancel);
}

-(void)LvMarqueeView:(LvMarqueeView *)LvMarqueeView selectedIndex:(NSInteger)index image:(UIImage *)imagePath
{
    NSLog(@"index=%zd image=%@",index,imagePath);
}

-(void)LvMarqueeView:(LvMarqueeView *)LvMarqueeView sliderEndIndex:(NSInteger)index image:(UIImage *)imagePath sliderCancel:(BOOL)isCancel
{
    NSLog(@"index=%zd image=%@ isCancel=%zd",index,imagePath,isCancel);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
