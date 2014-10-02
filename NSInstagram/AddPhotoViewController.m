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

    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.sourceType = UIImagePickerControllerSourceTypeCamera;
    picker.delegate = self;
    [self presentViewController:picker animated:YES completion:nil];

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

    UIImage *imageTaked = image;

    UIImage* imageCropped;

    CGFloat side = MIN(imageTaked.size.width, imageTaked.size.height);
    CGFloat x = imageTaked.size.width / 2 - side / 2;
    CGFloat y = imageTaked.size.height / 2 - side / 2;

    CGRect cropRect = CGRectMake(x,y,side,side);
    CGImageRef imageRef = CGImageCreateWithImageInRect([imageTaked CGImage], cropRect);
    imageCropped = [UIImage imageWithCGImage:imageRef];
    CGImageRelease(imageRef);
    NSData *imageData = [NSData dataWithData:UIImagePNGRepresentation(imageCropped)];
    PFFile *file = [PFFile fileWithData:imageData];
    photo[@"image"] = file;
    photo[@"user"] = [PFUser currentUser];
    //PFUser *user = [PFUser currentUser];
    //[photo setObject:file forKey:@"image"];
    // [photo setObject:user forKey:@"user"];
    [photo saveInBackground];
    [picker dismissModalViewControllerAnimated:YES];
    //UIImage *newImage = image;

    
}



@end
