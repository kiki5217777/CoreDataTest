//
//  ViewController.m
//  CoreDataTest
//
//  Created by kiki Huang on 13/11/27.
//  Copyright (c) 2013年 kiki Huang. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    UILabel *laebl = [[UILabel alloc]initWithFrame:CGRectMake(110, 30, 200, 50)];
    laebl.backgroundColor = [UIColor clearColor];
    laebl.text =NSLocalizedString(@"TitleLabel", @"This field is Title");
    [self.view addSubview:laebl];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender{
    if ([identifier isEqualToString:@"showDetail"])
    {
        NSLog(@"showDetail");
        NSPredicate *predicate =[NSPredicate predicateWithFormat:@"id == %@",self.signinUserID.text];
        NSArray *array = [User findAllWithPredicate:predicate];
        if ([array count]!=0) {
            NSLog(@"find id");
            //            [segue identifier];
            return YES;
        }
        else{
            
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:NSLocalizedString(@"AlertTitle", @"Show Alert Title") message:NSLocalizedString(@"AlertMsg", @"Show Alert Message") delegate:self cancelButtonTitle:NSLocalizedString(@"AlertCancelBtnTitle", @"Show Alert Cancel Button Title") otherButtonTitles:nil];
            [alert show];
            alert= nil;
            return NO;
        }
    }
    else
        return YES;
}
- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    id page2 = segue.destinationViewController;
    if ([[segue identifier]isEqualToString:@"showDetail"]) {
        [page2 setValue:self.signinUserID.text forKey:@"IDstring"];
    }else if([[segue identifier]isEqualToString:@"signin"]){
        [page2 setValue:@"" forKey:@"IDstring"];
    }
    
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    //    NSLog(@"should return");
    [self.view endEditing:YES];
    //    [currentActiveTextField resignFirstResponder];
    return YES;
}
@end
