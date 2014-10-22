//
//  LoginViewController.m
//  NSInstagram
//
//  Created by Asher Rosenblatt on 8/22/14.
//  Copyright (c) 2014 MM. All rights reserved.
//

#import "LoginViewController.h"
#import <FacebookSDK/FacebookSDK.h>

@interface LoginViewController ()
@property (strong, nonatomic) IBOutlet UITextField *usernameField;
@property (strong, nonatomic) IBOutlet UITextField *passwordField;
@property (strong, nonatomic) IBOutlet UIButton *bottomButton;
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) IBOutlet FBLoginView *loginView;

@end

@implementation LoginViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.loginView = [FBLoginView new];
    self.loginView.readPermissions = @[@"public_profile", @"email", @"user_friends"];
}

// This method will be called when the user information has been fetched
- (void)loginViewFetchedUserInfo:(FBLoginView *)loginView
                            user:(id<FBGraphUser>)user {
    PFUser *parseUser = [PFUser new];
    [parseUser setUsername:user.username];
    parseUser[@"firstName"] = user.name;
}

- (IBAction)onSignInPressed:(UIButton *)sender
{
    [PFUser logInWithUsernameInBackground:self.usernameField.text password:self.passwordField.text block:^(PFUser *user, NSError *error) {
        if (error) {
            NSString *alert = [NSString stringWithFormat:@"%@", [error userInfo][@"error" ]];
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"There was a problem!" message:alert delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            [alertView show];
        } if (user) {
            [self dismissViewControllerAnimated:YES completion:nil];
        }
    }];
}

- (void)registerForKeyboardNotifications {

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWasShown:)
                                                 name:UIKeyboardDidShowNotification
                                               object:nil];

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillBeHidden:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];

}

- (void)deregisterFromKeyboardNotifications {

    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardDidHideNotification
                                                  object:nil];

    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillHideNotification
                                                  object:nil];

}

- (void)viewWillAppear:(BOOL)animated {

    [super viewWillAppear:animated];

    [self registerForKeyboardNotifications];

}

- (void)viewWillDisappear:(BOOL)animated {

    [self deregisterFromKeyboardNotifications];

    [super viewWillDisappear:animated];
    
}

- (void)keyboardWasShown:(NSNotification *)notification
{
    [self.scrollView setContentSize:CGSizeMake(self.scrollView.frame.size.width, 650.0)];
}

- (void)keyboardWillBeHidden:(NSNotification *)notification
{
    [self.scrollView setContentOffset:CGPointZero animated:YES];

    [self.scrollView setContentSize:CGSizeMake(self.scrollView.frame.size.width, self.scrollView.frame.size.height)];
}

@end
