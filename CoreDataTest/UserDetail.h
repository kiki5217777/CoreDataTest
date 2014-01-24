//
//  UserDetail.h
//  CoreDataTest
//
//  Created by kiki Huang on 13/11/27.
//  Copyright (c) 2013年 kiki Huang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class User;

@interface UserDetail : NSManagedObject

@property (nonatomic, retain) NSString * phone_number;
@property (nonatomic, retain) NSString * address;
@property (nonatomic, retain) User *user_detail;

@end
