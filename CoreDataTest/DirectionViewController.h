//
//  SigninViewController.h
//  CoreDataTest
//
//  Created by kiki Huang on 13/11/28.
//  Copyright (c) 2013年 kiki Huang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import<MapKit/MapKit.h>

@interface DirectionViewController : UIViewController<UIScrollViewDelegate>
@property (strong, nonatomic) IBOutlet UIPageControl *pageControl;
- (IBAction)pageChange:(id)sender;
@property (strong, nonatomic) IBOutlet UISlider *slider;

@end
