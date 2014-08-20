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
@property (weak, nonatomic) IBOutlet UITextField *usernameTextField;
@property (weak, nonatomic) IBOutlet UITextField *emailTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;

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
    }
    [[PFUser currentUser] saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        NSLog(@"changes saved");
        [self dismissViewControllerAnimated:YES completion:nil];
    }];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    //load the picture into the edit thumbnail
    PFFile *imageFile = [[PFUser currentUser] objectForKey:@"profilePicture"];
    [imageFile getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
        UIImage *profileImage = [[UIImage alloc]init];
        profileImage = [UIImage imageWithData:data];
        if (profileImage) {
            self.editProfileImageView.image = profileImage;
        }
    }];
    self.usernameTextField.text = [PFUser currentUser].username;
    self.emailTextField.text = [PFUser currentUser].email;
    self.passwordTextField.text = @"password";
}

- (IBAction)onChooseImageButtonPressed:(id)sender
{
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
    self.editProfileImageView.image = [UIImage imageWithData:imageData];
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

    [picker dismissModalViewControllerAnimated:YES];
    //UIImage *newImage = image;
}

@end
