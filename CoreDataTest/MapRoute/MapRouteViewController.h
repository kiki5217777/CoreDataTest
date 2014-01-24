//
//  MapRouteViewController.h
//  CoreDataTest
//
//  Created by kiki Huang on 13/12/3.
//  Copyright (c) 2013年 kiki Huang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import<MapKit/MapKit.h>
#import<CoreLocation/CoreLocation.h>
#import "Annotation.h"
#import "AppDelegate.h"
#import "DirectionViewController.h"
#import "PinAnnotationView.h"
//#import <MapBox/MapBox.h>

@interface MapRouteViewController : UIViewController<MKMapViewDelegate,CLLocationManagerDelegate,UITextFieldDelegate>{
//    DirectionViewController *directView;
    PinAnnotationView *pinView;
}

@property (strong, nonatomic) IBOutlet MKMapView *myMapRouteView;
@property (strong, nonatomic) IBOutlet UITextField *localSearchLabel;
@property (strong, nonatomic) AppDelegate *delegate;
- (IBAction)searchDirection:(id)sender;

//@property (strong, nonatomic) IBOutlet RMMapView *myMapUIView;
//@property (strong) NSArray *activeFilterTypes;

@end
