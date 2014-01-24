//
//  Annotation.m
//  CoreDataTest
//
//  Created by kiki Huang on 13/12/3.
//  Copyright (c) 2013年 kiki Huang. All rights reserved.
//

#import "Annotation.h"

@implementation Annotation
-(CLLocationCoordinate2D)coordinate{
    CLLocationCoordinate2D coord = {self.latitude,self.longitude};
    return coord;
}
@end
