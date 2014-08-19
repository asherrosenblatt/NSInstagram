//
//  SignUpViewController.m
//  NSInstagram
//
//  Created by Asher Rosenblatt on 8/18/14.
//  Copyright (c) 2014 MM. All rights reserved.
//

#import "SignUpViewController.h"
#import "AddPhotoViewController.h"
#import "FirstViewController.h"

@interface SignUpViewController ()<UIAlertViewDelegate>
@property (strong, nonatomic) IBOutlet UITextField *usernameField;
@property (strong, nonatomic) IBOutlet UITextField *emailField;
@property (strong, nonatomic) IBOutlet UITextField *passwordField;

@end

@implementation SignUpViewController


- (void)viewDidLoad
{
   [super viewDidLoad];

}

- (IBAction)onSignUpPressed:(id)sender
{
    
    if (self.usernameField.text == nil || self.emailField.text == nil || self.passwordField.text == nil) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Information not complete" message:@"You forgot a username, email, or password!" delegate:nil cancelButtonTitle:@"Okay" otherButtonTitles:nil, nil];
        [alertView show];
    }else{
        PFUser *user = [PFUser user];
        user.username = [self.usernameField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        user.password = [self.passwordField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        user.email = [self.emailField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        [user signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            if (error) {
                NSString *errorString = [NSString stringWithFormat:@"%@", [error userInfo]];
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Sorry there was a problem!" message:errorString delegate:nil cancelButtonTitle:@"I'll try again" otherButtonTitles:nil, nil];
                [alertView show];
            } else {
                [PFUser logInWithUsernameInBackground:self.usernameField.text password:self.passwordField.text block:^(PFUser *user, NSError *error) {
                    if (error) {
                        NSLog(@"login error %@", [error userInfo]);
                    }else{
                        self.currentUser = user;
                    }
                }];
                [self.navigationController popToRootViewControllerAnimated:YES];
//                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Congrats!" message:@"Your signup was successful! Welcome to NSInstagram." delegate:nil cancelButtonTitle:@"Okay" otherButtonTitles:nil, nil];
//                alertView.tag = 1234;
//                alertView.delegate = self;
//                [alertView show];
            }
        }];
    }
}




@end
