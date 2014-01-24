//
//  ViewController.h
//  CoreDataTest
//
//  Created by kiki Huang on 13/11/27.
//  Copyright (c) 2013年 kiki Huang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "User.h"
#import "UserDetail.h"

@interface ViewController : UIViewController<UITextFieldDelegate>
    
@property (strong, nonatomic) IBOutlet UITextField *signinUserID;

@end
