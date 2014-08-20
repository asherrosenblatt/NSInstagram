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

@end

@implementation EditUserProfileViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    NSData *imageData = [PFUser currentUser][@"profilePicture"];
    self.editProfileImageView.image = [UIImage imageWithData:imageData];
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
