//
//  AppDelegate.m
//  CoreDataTest
//
//  Created by kiki Huang on 13/11/27.
//  Copyright (c) 2013年 kiki Huang. All rights reserved.
//

#import "AppDelegate.h"

@implementation AppDelegate

+ (void)initialize
{
    /**
     *  Setup sqlite database, default sqlite name would be
     *  the project name with extend name, sqlite
     */
    [MagicalRecord setupCoreDataStackWithStoreNamed:@"CoreDataTest.sqlite"];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    [self initLocationManager];
    return YES;
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    [self releaseLocationManager];
    [MagicalRecord cleanUp];
}
-(void)initLocationManager{
    self.myCLLManager = [[CLLocationManager alloc]init];
    [self.myCLLManager setDelegate:self];
    [self.myCLLManager setDistanceFilter:kCLDistanceFilterNone];
    [self.myCLLManager startUpdatingLocation];
}
-(void)releaseLocationManager{
    [self.myCLLManager stopUpdatingLocation];
    [self.myCLLManager setDelegate:nil];
    [self setMyCLLManager:nil];
}
-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations{
    CLLocation *location = [locations lastObject];
    self.myLocation = location.coordinate;
}
-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error{
    NSLog(@"%@", [error localizedDescription]);
    CLLocationCoordinate2D zero;
    zero.latitude = 0;
    zero.longitude= 0;
    self.myLocation= zero;
}
@end

