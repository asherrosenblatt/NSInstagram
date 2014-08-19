//
//  FirstViewController.m
//  NSInstagram
//
//  Created by Asher Rosenblatt on 8/18/14.
//  Copyright (c) 2014 MM. All rights reserved.
//

#import "FirstViewController.h"

@interface FirstViewController ()<UINavigationControllerDelegate, UIImagePickerControllerDelegate>
@property (strong, nonatomic) IBOutlet UIImageView *profileImageView;
@end

@implementation FirstViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
//    if (self.currentUser == nil)
//    {
        [self performSegueWithIdentifier:@"loginSegue" sender:self];
//    }
}


- (IBAction)onProfileImageTapped:(id)sender
{
    UIImagePickerController *imagePickerController = [[UIImagePickerController alloc]init];
    imagePickerController = [[UIImagePickerController alloc] init];
    imagePickerController.delegate = self;
    imagePickerController.sourceType =  UIImagePickerControllerSourceTypePhotoLibrary;

    [self presentViewController:imagePickerController animated:YES completion:^{

    }];
}

- (void)imagePickerController:(UIImagePickerController *)picker
        didFinishPickingImage:(UIImage *)image
                  editingInfo:(NSDictionary *)editingInfo
{
    // Dismiss the image selection, hide the picker and
    NSData *imageData = [NSData dataWithData:UIImagePNGRepresentation(image)];
    self.profileImageView.image = [UIImage imageWithData:imageData];
    self.currentUser[@"profilePicture"] = imageData;
    [self.currentUser saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
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
