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
@property (strong, nonatomic) IBOutlet UILabel *userBioLabel;
@property (strong, nonatomic) IBOutlet UITableView *userImagesTableView;
@property NSArray *currentUserImagesArray;
@end

@implementation UserProfileViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self queryCurrentUserImages];
}

-(void)viewWillAppear:(BOOL)animated
{
    NSLog(@"started view will appear");
    PFFile *imageFile = [[PFUser currentUser] objectForKey:@"profilePicture"];
    [imageFile getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
        UIImage *profileImage = [[UIImage alloc]init];
        profileImage = [UIImage imageWithData:data];
        self.profileImageView.image = profileImage;
        NSLog(@"throught the block");
        self.navigationItem.title = [PFUser currentUser].username;
    }];
    self.userBioLabel.text = [PFUser currentUser][@"profileBio"];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];

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
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (void)logInViewController:(PFLogInViewController *)logInController didLogInUser:(PFUser *)user
{
    NSLog(@"DID LOG IN USER");
    PFFile *imageFile = [self.currentUserForProfile objectForKey:@"profilePicture"];

    [imageFile getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
        UIImage *profileImage = [[UIImage alloc]init];
        profileImage = [UIImage imageWithData:data];
        if (profileImage) {
            self.profileImageView.image = profileImage;
        }
    }];

    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - userProfile methods

- (IBAction)onLogOutPressed:(id)sender
{
    [PFUser logOut];
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

-(void)queryCurrentUserImages
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat: @"user = %@", [PFUser currentUser]];
    PFQuery *query = [PFQuery queryWithClassName:@"Photo" predicate:predicate];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        NSLog(@"%@", objects);
        self.currentUserImagesArray = [NSArray new];
        self.currentUserImagesArray = objects;
        [self.userImagesTableView reloadData];
    }];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"imageCell"];
    PFObject *imageObject = [PFObject objectWithClassName:@"Photo"];
    imageObject = [self.currentUserImagesArray objectAtIndex:indexPath.row];
    PFFile *imageFile = [imageObject objectForKey:@"image"];

    [imageFile getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
        UIImage *image = [[UIImage alloc]init];
        image = [UIImage imageWithData:data];
        if (image) {
            cell.imageView.image = image;
        }
        [self.userImagesTableView reloadData];
    }];
    return cell;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.currentUserImagesArray.count;
}

-(IBAction)unwindFromEditProfile:(UIStoryboardSegue *)segue
{

}

-(IBAction)unwindFromEditViaCancel:(UIStoryboardSegue *)segue
{
    
}


@end
