//
//  AddPhotoViewController.m
//  NSInstagram
//
//  Created by Asher Rosenblatt on 8/18/14.
//  Copyright (c) 2014 MM. All rights reserved.
//

#import "AddPhotoViewController.h"

@interface AddPhotoViewController () <UIImagePickerControllerDelegate, UINavigationControllerDelegate>
@property (weak, nonatomic) IBOutlet UIButton *cameraButton;
@property (weak, nonatomic) IBOutlet UIButton *libraryButton;


@end

@implementation AddPhotoViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (IBAction)onCameraButtonPressed:(UIButton *)sender
{


}


- (IBAction)onLibraryButtonPressed:(UIButton *)sender
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
    PFObject *photo = [PFObject objectWithClassName:@"Photo"];
    NSData *imageData = [NSData dataWithData:UIImagePNGRepresentation(image)];
    PFFile *file = [PFFile fileWithData:imageData];
    photo[@"image"] = file;
    photo[@"user"] = [PFUser currentUser];
    [photo saveInBackground];
    [picker dismissModalViewControllerAnimated:YES];
    //UIImage *newImage = image;

    
}



@end
