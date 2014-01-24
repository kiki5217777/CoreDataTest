//
//  CoreDataViewController.m
//  CoreDataTest
//
//  Created by kiki Huang on 13/11/27.
//  Copyright (c) 2013年 kiki Huang. All rights reserved.
//

#import "CoreDataViewController.h"
const CGFloat kOptimumPickerHeight = 100;
const CGFloat kOptimumPickerWidth = 240;
@interface CoreDataViewController (){
    UIDatePicker *birthdayPickerView;
    NSManagedObjectContext *localContext;
    BOOL isMale;
    int currentBirthDayYear,currentBirthDayMonth,currentBirthDay;
}

@end

@implementation CoreDataViewController{
    UITextField *currentActiveTextField;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.extendedLayoutIncludesOpaqueBars = YES;
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.userID.enabled = YES;
    isMale = NO;
    self.myScrollView.contentSize = self.myEnterView.frame.size;
    localContext = [NSManagedObjectContext MR_contextForCurrentThread];
    
}
-(void)viewWillAppear:(BOOL)animated{
    NSLog(@"IDstring :%@",self.IDstring);
    if (self.IDstring !=nil && ![self.IDstring isEqualToString:@" "]) {
        [self getDatafromCoreData:self.IDstring];
        self.userID.enabled =NO;
    }
    self.userID.enabled = YES;
    
    [self subscribeForKeyboardEvents];
}
-(void)viewWillDisappear:(BOOL)animated{
    [self unsubscribeForKeyboardEvents];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - save and get data from CoreData
- (IBAction)saveToCoreData:(id)sender {
    
     NSPredicate *predicate = [NSPredicate predicateWithFormat:@"id == %@",self.userID.text];
     NSArray *array=[User findAllWithPredicate:predicate];
     NSString *sex = isMale ==YES ? @"男" :@"女";
     
     if ([array count]!=0) {
         User *userexist = [array objectAtIndex:0];
         userexist.name = self.userName.text;
         userexist.sex = sex;
         
         
         NSPredicate *predicate2 = [NSPredicate predicateWithFormat:@"user_detail == %@",userexist];
         NSArray *array2 = [UserDetail findAllWithPredicate:predicate2];
         
         for (int i=0; i<array2.count; i++) {
             UserDetail *u = [array2 objectAtIndex:i];
             
             u.phone_number = ((UITextField *)[self.myEnterView viewWithTag:100+i]).text;
             u.address = ((UITextField *)[self.myEnterView viewWithTag:200+i]).text;
             
             if (u.phone_number.length ==0) {
                 u.phone_number = @"";
             }
             if (u.address.length==0) {
                 u.address = @"";
             }
         }
         
         
         NSPredicate *predicate3 = [NSPredicate predicateWithFormat:@"phone_number ==%@ AND address == %@",@"",@""];
         [UserDetail MR_deleteAllMatchingPredicate:predicate3];
         
        
//         UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"alert" message:[NSString  stringWithFormat:@"%@ is existed",self.userID] delegate:self cancelButtonTitle:@"ok" otherButtonTitles:nil];
//         [alert show];
//         alert = nil;
     }else{
         
         User *user = [User createInContext:localContext];
         user.name = self.userName.text;
         user.id = self.userID.text;
         user.birthday =self.birthdayBtn.titleLabel.text;
         user.sex = sex;
//         int count1 =0;
        
         if (self.userPhone1.text.length || self.userAddress1.text.length) {
             UserDetail *userdetail = [UserDetail createInContext:localContext];
            NSLog(@"userphone1: %@,useraddress: %@\n----------------------",((UITextField *)[self.myEnterView viewWithTag:100]).text ,((UITextField *)[self.myEnterView viewWithTag:200]).text);
             userdetail.phone_number = ((UITextField *)[self.myEnterView viewWithTag:100]).text;
             userdetail.address = ((UITextField *)[self.myEnterView viewWithTag:200]).text;
             
             if (self.userPhone2.text.length || self.userAddress2.text.length) {
//                 for (int i=0; i<2; i++) {
//                     NSLog(@"phone_number text%d:%@",i,((UITextField *)[self.myEnterView viewWithTag:100+i]).text);
//                     NSLog(@"address text%d:%@",i,((UITextField *)[self.myEnterView viewWithTag:200+i]).text);
                 UserDetail *userdetail1 = [UserDetail createInContext:localContext];
                 userdetail1.phone_number = ((UITextField *)[self.myEnterView viewWithTag:101]).text;
                 userdetail1.address = ((UITextField *)[self.myEnterView viewWithTag:201]).text;
                 userdetail1.user_detail = user;
                 
//                 }

             }
             userdetail.user_detail = user;
         }
     }
    
     [localContext saveToPersistentStoreWithCompletion:^(BOOL success, NSError *error) {
     if (success) {
     NSLog(@"save success ");
     }else{
         UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"alert" message:@"save to coredata error!" delegate:self cancelButtonTitle:@"ok" otherButtonTitles:nil];
         [alert show];
         alert = nil;
     }
         
     }];
    
}

-(void)getDatafromCoreData:(NSString*)string{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"id == %@",string];
    NSArray *array=[User findAllWithPredicate:predicate];
    User *user;
    UserDetail *userdetail;
    NSDateFormatter *timeFormatter = [[NSDateFormatter alloc]init];
    [timeFormatter setDateFormat:@"MM/dd/yyyy HH:mm:ss"];
//    [timeFormatter setTimeZone:[NSTimeZone timeZoneWithName:@"GMT"]];
    
    if ([array count]!=0) {
        user = [array objectAtIndex:0];
        self.userName.text = user.name;
        self.userID.text = user.id;
        if ([user.sex isEqualToString:@"男"]) {
            self.maleBtn.selected=YES;
            self.femaleBtn.selected = NO;
        }else{
            self.maleBtn.selected=NO;
            self.femaleBtn.selected = YES;
        }

        self.userBirthday.text =user.birthday;
        
        NSPredicate *predicate1 = [NSPredicate predicateWithFormat:@"user_detail == %@",user];
        NSArray *array1=[UserDetail findAllWithPredicate:predicate1];
        if ([array1 count]!=0){
            for (int i=0; i<array1.count; i++) {
                userdetail = [array1 objectAtIndex:i];
                ((UITextField *)[self.myEnterView viewWithTag:100+i]).text = userdetail.phone_number;
                ((UITextField *)[self.myEnterView viewWithTag:200+i]).text = userdetail.address;
            }
            
        }
       
       
    }
//    else{
//        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"fault" message:@"data don't get from coredata" delegate:self cancelButtonTitle:@"ok" otherButtonTitles:nil];
//        [alert show];
//        alert = nil;
//        
//    }

}

#pragma mark - UITextField Delegate
-(void)textFieldDidBeginEditing:(UITextField *)textField{
//    NSLog(@"currentTextField in delegate");
    currentActiveTextField = textField;
}
-(void)textFieldDidEndEditing:(UITextField *)textField{
    currentActiveTextField = nil;
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
//    NSLog(@"should return");
    [self.view endEditing:YES];
//    [currentActiveTextField resignFirstResponder];
    return YES;
}
-(void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    NSLog(@"touch begin");
    [self.userName resignFirstResponder];
    [self.userID resignFirstResponder];
//    [self.userSex resignFirstResponder];
    [self.userBirthday resignFirstResponder];
    [self.userPhone1 resignFirstResponder];
    [self.userPhone2 resignFirstResponder];
    [self.userAddress1 resignFirstResponder];
    [self.userAddress2 resignFirstResponder];
    
}

#pragma mark - UITextField Notification Methods
-(void)subscribeForKeyboardEvents{
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWasShown:) name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWillBeHidden:) name:UIKeyboardWillHideNotification object:nil];
}
-(void)unsubscribeForKeyboardEvents{
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardDidShowNotification
                                                  object:nil];
	[[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillHideNotification
                                                  object:nil];
}
-(void)keyboardWasShown:(NSNotification *)note{
    NSDictionary *info = [note userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey]CGRectValue].size;
    UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, kbSize.height, 0.0);
    self.myScrollView.contentInset = contentInsets;
    self.myScrollView.scrollIndicatorInsets = contentInsets;
    
    if (currentActiveTextField) {
        NSLog(@"currentTextField");
        CGRect aRect = self.view.frame;
        NSLog(@"self view size width:%f height:%f",aRect.size.width,aRect.size.height);
        aRect.size.height-= kbSize.height;
//        NSLog(@"self view kbsize width:%f height:%f",aRect.size.width,aRect.size.height);
        if (!CGRectContainsPoint(aRect, currentActiveTextField.frame.origin)) {
            [self.myScrollView scrollRectToVisible:currentActiveTextField.frame animated:YES ];
        }
    }
}
-(void)keyboardWillBeHidden:(NSNotification *)note{
//    NSLog(@"keyboardwillbehidden");
//     NSDictionary *info = [note userInfo];
//    CGSize kbSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey]CGRectValue].size;
    UIEdgeInsets contentInsets = UIEdgeInsetsZero;
    self.myScrollView.contentInset = contentInsets;
    self.myScrollView.scrollIndicatorInsets = contentInsets;
}
#pragma mark - Button Events
- (IBAction)buttonPressed:(id)sender {
    UIButton *button = (UIButton*)sender;
    if (button == self.maleBtn) {
        self.maleBtn.selected = YES;
        self.femaleBtn.selected = NO;
        isMale = YES;
    }else if (button == self.femaleBtn){
        self.femaleBtn.selected = YES;
        self.maleBtn.selected = NO;
        isMale = NO;
    }else if (button == self.birthdayBtn){
        [self createActionSheet];
    }
}

-(void)createActionSheet{
    

    birthdayPickerView = [[UIDatePicker alloc]init];
    birthdayPickerView.frame = CGRectMake(20, 80, 240, 150);
//    birthdayPickerView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
    
    birthdayPickerView.datePickerMode = UIDatePickerModeDate;
//    [birthdayPickerView sizeToFit];
//    CGSize pickerSize = birthdayPickerView.frame.size;
//    birthdayPickerView.frame = [self pickerFrameWithSize:pickerSize];
    
//    [self.view addSubview:birthdayPickerView];
    birthdayPickerView.maximumDate = [NSDate date];
    
    NSDateComponents *comps = [[NSDateComponents alloc]init];
    [comps setDay:1];
    [comps setMonth:1];
    [comps setYear:1900];
    NSCalendar *calender = [NSCalendar currentCalendar];
    NSDate *date = [calender dateFromComponents:comps];
    birthdayPickerView.minimumDate = date;
    
    currentBirthDayYear = 1970;
    currentBirthDayMonth = 1;
    currentBirthDay = 1;
    [comps setDay:currentBirthDay];
    [comps setMonth:currentBirthDayMonth];
    [comps setYear:currentBirthDayYear];
    date = [calender dateFromComponents:comps];
    birthdayPickerView.date = date;
    UIAlertView *dateAlert = [[UIAlertView alloc]initWithTitle:@"Birthday" message:@"請選擇出生日期\n\n\n\n\n\n\n\n\n" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"確定",nil];
    dateAlert.delegate = self;
    [dateAlert addSubview:birthdayPickerView];
    [dateAlert show];
    dateAlert = nil;
    

}
- (CGRect)pickerFrameWithSize:(CGSize)size
{
    CGRect resultFrame;
    
    CGFloat height = size.height;
    CGFloat width = size.width;
    
    if (size.height < kOptimumPickerHeight)
        // if in landscape, the picker height can be sized too small, so use a optimum height
        height = kOptimumPickerHeight;
    
    if (size.width > kOptimumPickerWidth)
        // keep the width an optimum size as well
        width = kOptimumPickerWidth;
    
    resultFrame = CGRectMake(0.0,-1.0, width, height);
    
    return resultFrame;
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    switch (buttonIndex) {
        case 1:{
            NSDate *date = [birthdayPickerView date];
            NSDateFormatter *df = [[NSDateFormatter alloc]init];
            [df setDateFormat:[NSString stringWithFormat:@"yyyy年MM月dd日"]];
            self.birthdayBtn.titleLabel.text = [df stringFromDate:date];
            break;
        }
        default:
            break;
    }
}

@end
