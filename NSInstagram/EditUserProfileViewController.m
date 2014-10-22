//
//  EditUserProfileViewController.m
//  NSInstagram
//
//  Created by Asher Rosenblatt on 8/19/14.
//  Copyright (c) 2014 MM. All rights reserved.
//

#import "EditUserProfileViewController.h"

@interface EditUserProfileViewController () <UIImagePickerControllerDelegate, UINavigationControllerDelegate>
@property (strong, nonatomic) IBOutlet UIImageView *editProfileImageView;
@property (strong, nonatomic) IBOutlet UIImageView *headerImageView;
@property (weak, nonatomic) IBOutlet UITextField *usernameTextField;
@property (weak, nonatomic) IBOutlet UITextField *emailTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (strong, nonatomic) IBOutlet UITextField *bioTextField;
@property NSData *profileImageData;
@property NSData *headerImageData;
@property BOOL isProfileImage;

@end

@implementation EditUserProfileViewController
- (IBAction)onDoneButtonPressed:(UIButton *)sender
{
    if (![[PFUser currentUser].username isEqualToString:self.usernameTextField.text]) {
        [[PFUser currentUser] setUsername:self.usernameTextField.text];
    } if (![[PFUser currentUser].email isEqualToString:self.emailTextField.text]) {
        [[PFUser currentUser] setEmail:self.emailTextField.text];
    } if (![self.passwordTextField.text isEqualToString:@"password"]) {
        [[PFUser currentUser] setPassword:self.passwordTextField.text];
        NSLog(@"password changed");
    } if (![[PFUser currentUser][@"profileBio"] isEqualToString:self.bioTextField.text]) {
        [[PFUser currentUser] setObject:self.bioTextField.text forKey:@"profileBio"];
        NSLog(@"password changed");
    }
    PFFile *profileImageFile = [PFFile fileWithData:self.profileImageData];
    [[PFUser currentUser] setObject:profileImageFile forKey:@"profilePicture"];
    PFFile *headerImageFile = [PFFile fileWithData:self.headerImageData];
    [[PFUser currentUser] setObject:headerImageFile forKey:@"headerPicture"];
    [[PFUser currentUser] saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (error) {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Could not update profile!" message:[NSString stringWithFormat:@"%@", error.userInfo] delegate:nil cancelButtonTitle:@"Okay" otherButtonTitles: nil];
            [alertView show];
        } else {
            [self dismissViewControllerAnimated:YES completion:nil];
        }
    }];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    //load the picture into the edit thumbnail
//    PFFile *imageFile = [[PFUser currentUser] objectForKey:@"profilePicture"];
//    [imageFile getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
//        UIImage *profileImage = [[UIImage alloc]init];
//        profileImage = [UIImage imageWithData:data];
//        if (profileImage) {
//            self.editProfileImageView.image = profileImage;
//        }
//    }];
//    self.bioTextField.text = [PFUser currentUser][@"profileBio"];
//    self.usernameTextField.text = [PFUser currentUser].username;
//    self.emailTextField.text = [PFUser currentUser].email;
//    self.passwordTextField.text = @"password";
}

- (void)viewDidAppear:(BOOL)animated
{
    PFFile *imageFile = [[PFUser currentUser] objectForKey:@"profilePicture"];
    [imageFile getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
        UIImage *profileImage = [[UIImage alloc]init];
        profileImage = [UIImage imageWithData:data];
        if (profileImage) {
            self.profileImageData = data;
            self.editProfileImageView.image = profileImage;
        }
    }];
    PFFile *headerImageFile = [[PFUser currentUser] objectForKey:@"headerPicture"];
    [headerImageFile getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
        UIImage *headerImage = [[UIImage alloc]init];
        headerImage = [UIImage imageWithData:data];
        if (headerImage) {
            self.headerImageData = data;
            self.headerImageView.image = headerImage;
        }
    }];
    self.bioTextField.text = [PFUser currentUser][@"profileBio"];
    self.usernameTextField.text = [PFUser currentUser].username;
    self.emailTextField.text = [PFUser currentUser].email;
    self.passwordTextField.text = @"password";
}

- (IBAction)onChooseImageButtonPressed:(id)sender
{
    self.isProfileImage = YES;
    UIImagePickerController *imagePickerController = [[UIImagePickerController alloc]init];
    imagePickerController = [[UIImagePickerController alloc] init];
    imagePickerController.delegate = self;
    imagePickerController.sourceType =  UIImagePickerControllerSourceTypePhotoLibrary;

    [self presentViewController:imagePickerController animated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker
        didFinishPickingImage:(UIImage *)image
                  editingInfo:(NSDictionary *)editingInfo
{

    // Dismiss the image selection, hide the picker and
    NSData *imageData = [NSData dataWithData:UIImagePNGRepresentation(image)];
    if (self.isProfileImage) {
        self.editProfileImageView.image = [UIImage imageWithData:self.profileImageData];
        self.profileImageData = imageData;
    }
    if (!self.isProfileImage) {
        self.headerImageView.image = [UIImage imageWithData:self.headerImageData];
        self.headerImageData = imageData;

    }
    [picker dismissModalViewControllerAnimated:YES];
    //UIImage *newImage = image;
}

- (IBAction)cancelEditProfilePressed:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)onEditProfileHeaderPressed:(id)sender
{
    self.isProfileImage = NO;
#warning make sure the image picker only changes the current image: profile or header. Not both.
    UIImagePickerController *imagePickerController = [[UIImagePickerController alloc]init];
    imagePickerController = [[UIImagePickerController alloc] init];
    imagePickerController.delegate = self;
    imagePickerController.sourceType =  UIImagePickerControllerSourceTypePhotoLibrary;

    [self presentViewController:imagePickerController animated:YES completion:nil];
}


@end
