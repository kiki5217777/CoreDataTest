//
//  User.h
//  CoreDataTest
//
//  Created by kiki Huang on 13/11/27.
//  Copyright (c) 2013年 kiki Huang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class UserDetail;

@interface User : NSManagedObject

@property (nonatomic, retain) NSString * id;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * sex;
@property (nonatomic, retain) NSString * birthday;
@property (nonatomic, retain) NSSet *detail_id;
@end

@interface User (CoreDataGeneratedAccessors)

- (void)addDetail_idObject:(UserDetail *)value;
- (void)removeDetail_idObject:(UserDetail *)value;
- (void)addDetail_id:(NSSet *)values;
- (void)removeDetail_id:(NSSet *)values;

@end
