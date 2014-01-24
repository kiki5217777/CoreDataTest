//
//  AppDelegate.h
//  CoreDataTest
//
//  Created by kiki Huang on 13/11/27.
//  Copyright (c) 2013年 kiki Huang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate,CLLocationManagerDelegate>

@property (strong, nonatomic) UIWindow *window;
//LocationManager
@property CLLocationCoordinate2D myLocation;
@property (strong, nonatomic) CLLocationManager *myCLLManager;
@end
