//
//  Annotation.h
//  CoreDataTest
//
//  Created by kiki Huang on 13/12/3.
//  Copyright (c) 2013年 kiki Huang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
@interface Annotation : NSObject<MKAnnotation>
@property (nonatomic) float latitude;
@property (nonatomic) float longitude;
@property (nonatomic,copy) NSString *title;
@property (nonatomic,readonly) CLLocationCoordinate2D coordinate;
@end
