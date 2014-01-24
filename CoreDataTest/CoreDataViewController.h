//
//  CoreDataViewController.h
//  CoreDataTest
//
//  Created by kiki Huang on 13/11/27.
//  Copyright (c) 2013年 kiki Huang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "User.h"
#import "UserDetail.h"

@interface CoreDataViewController : UIViewController<UITextFieldDelegate,UIActionSheetDelegate>
@property (strong, nonatomic) IBOutlet UITextField *userName;
@property (strong, nonatomic) IBOutlet UITextField *userID;
@property (strong, nonatomic) IBOutlet UITextField *userBirthday;
@property (strong, nonatomic) IBOutlet UITextField *userPhone1;
@property (strong, nonatomic) IBOutlet UITextField *userPhone2;
@property (strong, nonatomic) IBOutlet UITextField *userAddress1;
@property (strong, nonatomic) IBOutlet UITextField *userAddress2;

- (IBAction)saveToCoreData:(id)sender;
@property (strong, nonatomic) IBOutlet UIView *myEnterView;
@property (strong, nonatomic) IBOutlet UIScrollView *myScrollView;
@property (strong, nonatomic) IBOutlet UIButton *birthdayBtn;

@property (weak,nonatomic)NSString *IDstring;
@property (strong, nonatomic) IBOutlet UIButton *maleBtn;
@property (strong, nonatomic) IBOutlet UIButton *femaleBtn;
- (IBAction)buttonPressed:(id)sender;
@end
