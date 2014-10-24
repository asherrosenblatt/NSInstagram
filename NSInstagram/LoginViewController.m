//
//  LoginViewController.m
//  NSInstagram
//
//  Created by Asher Rosenblatt on 8/22/14.
//  Copyright (c) 2014 MM. All rights reserved.
//

#import "LoginViewController.h"
#import <FacebookSDK/FacebookSDK.h>
#import "UserDetailsViewController.h"


@interface LoginViewController ()<FBLoginViewDelegate>
@property (strong, nonatomic) IBOutlet UITextField *usernameField;
@property (strong, nonatomic) IBOutlet UITextField *passwordField;
@property (strong, nonatomic) IBOutlet UIButton *bottomButton;
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) IBOutlet FBLoginView *loginView;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;

@end

@implementation LoginViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.loginView = [FBLoginView new];
}

+ (void)initializeFacebook
{

}

- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation {
    // attempt to extract a token from the url
    return [FBAppCall handleOpenURL:url sourceApplication:sourceApplication];
}

// This method will be called when the user information has been fetched
- (void)loginViewFetchedUserInfo:(FBLoginView *)loginView
                            user:(id<FBGraphUser>)user {
//    PFUser *parseUser = [PFUser new];
//    [parseUser setUsername:user.username];
//    parseUser[@"firstName"] = user.name;

    [PFFacebookUtils logInWithFacebookId:user.objectID accessToken:user.objectID expirationDate:nil block:^(PFUser *user, NSError *error) {
        if (error) {
            NSLog(@"Error logging in with facebook to parse");
        }
        else {
            NSLog(@"No error logging in with facebook to parse");
        }
    }];

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

//- (IBAction)loginButtonTouchHandler:(id)sender  {
//    // Set permissions required from the facebook user account
//    NSArray *permissionsArray = @[ @"user_about_me", @"user_relationships", @"user_birthday", @"user_location"];
//
//    // Login PFUser using Facebook
//    [PFFacebookUtils logInWithPermissions:permissionsArray block:^(PFUser *user, NSError *error) {
//        [_activityIndicator stopAnimating]; // Hide loading indicator
//
//        if (!user) {
//            NSString *errorMessage = nil;
//            if (!error) {
//                NSLog(@"Uh oh. The user cancelled the Facebook login.");
//                errorMessage = @"Uh oh. The user cancelled the Facebook login.";
//            } else {
//                NSLog(@"Uh oh. An error occurred: %@", error);
//                errorMessage = [error localizedDescription];
//            }
//            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Log In Error"
//                                                            message:errorMessage
//                                                           delegate:nil
//                                                  cancelButtonTitle:nil
//                                                  otherButtonTitles:@"Dismiss", nil];
//            [alert show];
//        } else {
//            if (user.isNew) {
//                NSLog(@"User with facebook signed up and logged in!");
//            } else {
//                NSLog(@"User with facebook logged in!");
//            }
//            [self _presentUserDetailsViewControllerAnimated:YES];
//        }
//    }];
//
//    [_activityIndicator startAnimating]; // Show loading indicator until login is finished
//}

- (void)_presentUserDetailsViewControllerAnimated:(BOOL)animated {
    UserDetailsViewController *detailsViewController = [[UserDetailsViewController alloc] initWithStyle:UITableViewStyleGrouped];
    [self.navigationController pushViewController:detailsViewController animated:animated];
}



//Allow the keyboard to move when the keyboard appears

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
