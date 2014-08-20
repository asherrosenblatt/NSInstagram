//
//  FirstViewController.m
//  NSInstagram
//
//  Created by Asher Rosenblatt on 8/18/14.
//  Copyright (c) 2014 MM. All rights reserved.
//

#import "UserProfileViewController.h"

@interface UserProfileViewController ()<UINavigationControllerDelegate, UITableViewDataSource, UITableViewDelegate, PFLogInViewControllerDelegate, PFSignUpViewControllerDelegate>
@property (strong, nonatomic) IBOutlet UIImageView *profileImageView;
@end

@implementation UserProfileViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.profileImageView.image = [UIImage imageWithData:[PFUser currentUser][@"profilePicture"]];

}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    self.profileImageView.image = [UIImage imageWithData:[PFUser currentUser][@"profilePicture"]];

    if (![PFUser currentUser]) {
        PFLogInViewController *logInViewController = [[PFLogInViewController alloc] init];
        [logInViewController setDelegate:self]; // Set ourselves as the delegate
        [logInViewController setFields: PFLogInFieldsUsernameAndPassword | PFLogInFieldsLogInButton | PFLogInFieldsSignUpButton | PFLogInFieldsPasswordForgotten];
        PFSignUpViewController *signUpViewController = [[PFSignUpViewController alloc] init];
        [signUpViewController setDelegate:self];
        [signUpViewController setFields: PFSignUpFieldsUsernameAndPassword | PFSignUpFieldsSignUpButton];
        [logInViewController setSignUpController:signUpViewController];
        [self presentViewController:logInViewController animated:NO completion:NULL];
    }
}

#pragma mark - loginviewcontroller methods

- (BOOL)logInViewController:(PFLogInViewController *)logInController shouldBeginLogInWithUsername:(NSString *)username password:(NSString *)password {
    // Check if both fields are completed
    if (username && password && username.length != 0 && password.length != 0) {
        return YES; // Begin login process
    }

    [[[UIAlertView alloc] initWithTitle:@"Missing Information"
                                message:@"Make sure you fill out all of the information!"
                               delegate:nil
                      cancelButtonTitle:@"ok"
                      otherButtonTitles:nil] show];
    return NO; // Interrupt login process
}

- (BOOL)signUpViewController:(PFSignUpViewController *)signUpController shouldBeginSignUp:(NSDictionary *)info {
    BOOL informationComplete = YES;

    // loop through all of the submitted data
    for (id key in info) {
        NSString *field = [info objectForKey:key];
        if (!field || field.length == 0) { // check completion
            informationComplete = NO;
            break;
        }
    }

    // Display an alert if a field wasn't completed
    if (!informationComplete) {
        [[[UIAlertView alloc] initWithTitle:@"Missing Information"
                                    message:@"Make sure you fill out all of the information!"
                                   delegate:nil
                          cancelButtonTitle:@"ok"
                          otherButtonTitles:nil] show];
    }

    return informationComplete;
}

- (void)signUpViewController:(PFSignUpViewController *)signUpController didSignUpUser:(PFUser *)user {
//    UIImage *image = [UIImage imageNamed:@"profilePicture"];
//    NSData *imageData = [NSData dataWithData:UIImagePNGRepresentation(image)];
////    self.editProfileImageView.image = [UIImage imageWithData:imageData];
//    PFFile *file = [PFFile fileWithData:imageData];
//    PFUser *currentUser = [PFUser currentUser];
//    [currentUser setObject:file forKey:@"profilePicture"];
//    [[PFUser currentUser] saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
//        if (error) {
//            NSLog(@"ERROR");
//        } else {
//            NSLog(@"Photo added");
//        }
//    }];
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (void)logInViewController:(PFLogInViewController *)logInController didLogInUser:(PFUser *)user {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - userProfile methods


- (IBAction)onEditProfileButtonPressed:(id)sender
{
    NSLog(@"picture pressed!");
}


- (void)imagePickerController:(UIImagePickerController *)picker
        didFinishPickingImage:(UIImage *)image
                  editingInfo:(NSDictionary *)editingInfo
{
    // Dismiss the image selection, hide the picker and
    NSData *imageData = [NSData dataWithData:UIImagePNGRepresentation(image)];
    self.profileImageView.image = [UIImage imageWithData:imageData];
    PFFile *file = [PFFile fileWithData:imageData];
    PFUser *user = [PFUser currentUser];
    [user setObject:file forKey:@"profilePicture"];
    [[PFUser currentUser] saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (error) {
            NSLog(@"ERROR");
        } else {
            NSLog(@"Photo added");
        }
    }];
    [picker dismissViewControllerAnimated:YES completion:nil];
    //UIImage *newImage = image;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return nil;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 0;
}

-(IBAction)unwindFromEditProfile:(UIStoryboardSegue *)segue
{
    
}

-(IBAction)unwindFromEditViaCancel:(UIStoryboardSegue *)segue
{
    
}


@end
