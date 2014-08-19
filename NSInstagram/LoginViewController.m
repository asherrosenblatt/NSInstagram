//
//  LoginViewController.m
//  NSInstagram
//
//  Created by Asher Rosenblatt on 8/18/14.
//  Copyright (c) 2014 MM. All rights reserved.
//

#import "LoginViewController.h"

@interface LoginViewController ()
@property (strong, nonatomic) IBOutlet UITextField *usernameField;
@property (strong, nonatomic) IBOutlet UITextField *passwordField;

@end

@implementation LoginViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (IBAction)onSignInPressed:(id)sender
{
    [PFUser logInWithUsernameInBackground:self.usernameField.text password:self.passwordField.text block:^(PFUser *user, NSError *error) {
        if (error) {
            NSLog(@"login error %@", [error userInfo]);
        }else{
        self.currentUser = user;
            NSLog(@"Successfully logged in %@", self.currentUser);
        [self.navigationController popToRootViewControllerAnimated:YES];
        }
    }];
}


@end
