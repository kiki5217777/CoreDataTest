//
//  SigninViewController.m
//  CoreDataTest
//
//  Created by kiki Huang on 13/11/28.
//  Copyright (c) 2013年 kiki Huang. All rights reserved.
//

#import "DirectionViewController.h"

@interface DirectionViewController ()

@end

@implementation DirectionViewController{
    UIScrollView *scrollView1;
    CGFloat dimension;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
//    srandom(time(0));
    self.pageControl.numberOfPages = 0;
    [self.pageControl addTarget:self action:@selector(pageTurn:) forControlEvents:UIControlEventValueChanged];
    scrollView1 = [[UIScrollView alloc]init];
//    scrollView1.pagingEnabled = YES;
    scrollView1.delegate = self;
    scrollView1.showsHorizontalScrollIndicator = NO;
    [self.view addSubview:scrollView1];
    
   
    for (int i=0; i<3; i++) {
        [self addPage];
    }
    
    self.pageControl.currentPage =0;
    
    self.slider.value = 0.0;
    self.slider.minimumValue = 0;
//    NSLog(@"%f",scrollView1.contentSize.width);
    self.slider.maximumValue = scrollView1.contentSize.width;
}
-(void)viewDidAppear:(BOOL)animated{
    dimension = MIN(self.view.bounds.size.width, self.view.bounds.size.height)*0.8f;
    NSLog(@"dimension %f",dimension);
    [self layoutPages];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//-(BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender{
//    
//    return YES;
//}
-(void)pageTurn :(UIPageControl *)aPageControl{
    NSInteger whichPage = aPageControl.currentPage;
    [UIView animateWithDuration:0.3f animations:^{
        scrollView1.contentOffset = CGPointMake(dimension * whichPage, 0.0f);
        NSLog(@"scroll contentOffset %f",scrollView1.contentOffset.x);
    }];
}
-(void)scrollViewDidEndDecelerating:(UIScrollView *)aScrollview{
    self.pageControl.currentPage = floor((scrollView1.contentOffset.x/dimension)+0.25);
}
-(UIColor *)randomColor{
    float red = (64+random() %191)/255.0f;
    float green = (64+random() %191)/255.0f;
    float blur = (64+random() %191)/255.0f;
    return [UIColor colorWithRed:red green:green blue:blur alpha:1.0f];
}
-(void)layoutPages{
    NSInteger wihichPage = self.pageControl.currentPage;
//    NSLog(@"pageControl currentPage%li",(long)wihichPage);
    scrollView1.frame = CGRectMake(0, 0, dimension, dimension);
//    NSLog(@"scrollview frame %f : %f",scrollView.frame.size.width , scrollView.frame.size.height);
    scrollView1.contentSize = CGSizeMake(self.pageControl.numberOfPages * dimension, dimension);
    scrollView1.center = CGPointMake(CGRectGetMidX(self.view.bounds), CGRectGetMidY(self.view.bounds));
    
    float offset=0.0f;
    for (UIView *eachView in scrollView1.subviews) {
        if (eachView.tag == 999) {
            eachView.frame = CGRectMake(offset, 0.0f, dimension, dimension);
            offset+=dimension;
        }
    }
    
    scrollView1.contentOffset = CGPointMake(dimension*wihichPage, 0.0f);
    NSLog(@"scrollview contentSize%f",scrollView1.contentSize.width);
    self.slider.maximumValue = scrollView1.contentSize.width-dimension;
}
-(void)addPage{
    self.pageControl.numberOfPages = self.pageControl.numberOfPages+1;
//    NSLog(@"addPage numberOfPage%li",(long)self.pageControl.numberOfPages);
    self.pageControl.currentPage = self.pageControl.numberOfPages-1;
//    NSLog(@"addPage currentPage%li",(long)self.pageControl.currentPage);
    
    UIView *aView = [[UIView alloc]init];
    aView.backgroundColor = [self randomColor];
    aView.tag = 999;
    [aView.layer setCornerRadius:5];
    [scrollView1 addSubview:aView];
//    [self layoutPages];
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView;
{
    //    NSLog(@" scrollViewDidScroll");
    /*
    CGFloat width = scrollView.frame.size.width;
    NSLog(@"Contentframe  offset x is  %f\n--------------------------------",scrollView.contentOffset.x);
    NSInteger currentPage = ((scrollView.contentOffset.x - width / 2) / width) + 1;
    NSLog(@"minus %f\n*********************************",scrollView.contentOffset.x/width);
    NSLog(@"currentPage%ld",(long)currentPage);*/
    self.slider.value = scrollView1.contentOffset.x;
}

- (IBAction)pageChange:(id)sender {
    UISlider *slider = (UISlider *)sender;
    scrollView1.contentOffset = CGPointMake([slider value], 0);
    
}
@end
