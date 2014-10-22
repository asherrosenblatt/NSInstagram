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
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *loadingIndicator;
@property (strong, nonatomic) IBOutlet UIImageView *dailyPhotoImageView;


@end

@implementation AddPhotoViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
}

-(void)viewDidAppear:(BOOL)animated
{
    [self.loadingIndicator setHidden:YES];
}

-(void)viewWillAppear:(BOOL)animated
{
    NSDateFormatter *dateformat =[[NSDateFormatter alloc]init];
    [dateformat setDateFormat:@"MM/dd/YYYY"];
    NSString *date_String=[dateformat stringFromDate:[NSDate date]];
    PFQuery *query = [PFQuery queryWithClassName:@"Photo"];
    [query whereKey:@"user" equalTo:[PFUser currentUser]];
    [query whereKey:@"dateString" containsString:date_String];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        PFObject *photo = [PFObject objectWithClassName:@"Photo"];
        if (objects.count > 0) {
            photo = [objects objectAtIndex:0];
            PFFile *imageFile = photo[@"image"];
            [imageFile getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
                UIImage *dailyImage = [UIImage imageWithData:data];
                self.dailyPhotoImageView.image = dailyImage;
            }];
        }
        }];
}

-(BOOL)checkUploadCount
{
    NSDateFormatter *dateformat =[[NSDateFormatter alloc]init];
    [dateformat setDateFormat:@"MM/dd/YYYY"];
    NSString *date_String=[dateformat stringFromDate:[NSDate date]];
    //if ([[NSString stringWithFormat:@"%@",[PFUser currentUser][@"PCDateString"]] isEqualToString:date_String])
    if ([[PFUser currentUser][@"PCDateString"] isEqualToString:date_String])
    {
        //NSNumber *PCNumber = [PFUser currentUser][@"PCNumber"];
        if ([[PFUser currentUser][@"PCNumber"] intValue] < 1)
        {
            return YES;
        }
        else
        {
            return NO;
        }
    }
    else if (![[PFUser currentUser][@"PCDateString"] isEqualToString:date_String])
    {
        NSNumber *num = [NSNumber numberWithInt:0];
        [PFUser currentUser][@"PCDateString"] = date_String;
        [PFUser currentUser][@"PCNumber"] = num;
        [[PFUser currentUser] saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            if (error) {
                NSLog(@"ERROR SAVING UPLOAD COUNT %@", error.userInfo);
            }
            else
            {

            }
        }];
        return YES;
    }
    else
    {
        NSLog(@"ERROR CHECKIN UPLOAD COUNTS");
        return YES;
    }
}

- (IBAction)onCameraButtonPressed:(UIButton *)sender
{
    [[PFUser currentUser] fetchInBackgroundWithBlock:^(PFObject *object, NSError *error) {
        if ([self checkUploadCount]) {
            UIImagePickerController *picker = [[UIImagePickerController alloc] init];
            picker.sourceType = UIImagePickerControllerSourceTypeCamera;
            picker.delegate = self;
            [self presentViewController:picker animated:YES completion:nil];
        }
        else
        {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"You've reached your limits!" message:@"Sorry, but you've reached your upload quota for the day so this picture will replace your earlier photo" delegate:nil cancelButtonTitle:@"Okay" otherButtonTitles:nil];
            [alertView show];
            UIImagePickerController *picker = [[UIImagePickerController alloc] init];
            picker.sourceType = UIImagePickerControllerSourceTypeCamera;
            picker.delegate = self;
            [self presentViewController:picker animated:YES completion:nil];
        }
    }];
}


- (IBAction)onLibraryButtonPressed:(UIButton *)sender
{
    [[PFUser currentUser] fetchInBackgroundWithBlock:^(PFObject *object, NSError *error) {
        if ([self checkUploadCount])
        {
            UIImagePickerController *imagePickerController = [[UIImagePickerController alloc]init];
            imagePickerController = [[UIImagePickerController alloc] init];
            imagePickerController.delegate = self;
            imagePickerController.sourceType =  UIImagePickerControllerSourceTypePhotoLibrary;

            [self presentViewController:imagePickerController animated:YES completion:nil];
        }
        else if (![self checkUploadCount])
        {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"You've reached your limits!" message:@"Sorry, but you've reached your upload quota for the day so this picture will replace your earlier photo" delegate:nil cancelButtonTitle:@"Okay" otherButtonTitles:nil];
            [alertView show];

            UIImagePickerController *imagePickerController = [[UIImagePickerController alloc]init];
            imagePickerController = [[UIImagePickerController alloc] init];
            imagePickerController.delegate = self;
            imagePickerController.sourceType =  UIImagePickerControllerSourceTypePhotoLibrary;

            [self presentViewController:imagePickerController animated:YES completion:nil];
        }
    }];
}


- (IBAction)onUploadPressed:(id)sender
{
    
}

- (void)imagePickerController:(UIImagePickerController *)picker
        didFinishPickingImage:(UIImage *)image
                  editingInfo:(NSDictionary *)editingInfo
{


    [[PFUser currentUser] fetchInBackgroundWithBlock:^(PFObject *object, NSError *error) {
        if ([self checkUploadCount])
        {
            NSDateFormatter *dateformat =[[NSDateFormatter alloc]init];
            [dateformat setDateFormat:@"MM/dd/YYYY"];
            NSString *date_String=[dateformat stringFromDate:[NSDate date]];
            NSNumber *photoCount = [PFUser currentUser][@"PCNumber"];

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
            photo[@"dateString"] = date_String;
            
            int PCInt = [photoCount intValue];
            PCInt ++;
            photoCount = [NSNumber numberWithInt:PCInt];
            [PFUser currentUser][@"PCNumber"] = photoCount;

            [photo saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                [self.loadingIndicator setHidden:YES];
                self.dailyPhotoImageView.image = [UIImage imageWithData:imageData];
            }];
            [picker dismissModalViewControllerAnimated:YES];
            if (image) {
                [self.loadingIndicator setHidden:NO];
                [self.loadingIndicator startAnimating];
            }

        }
        else if (![self checkUploadCount])
        {
            NSDateFormatter *dateformat =[[NSDateFormatter alloc]init];
            [dateformat setDateFormat:@"MM/dd/YYYY"];
            NSString *date_String=[dateformat stringFromDate:[NSDate date]];
            PFQuery *query = [PFQuery queryWithClassName:@"Photo"];
            [query whereKey:@"user" equalTo:[PFUser currentUser]];
            [query whereKey:@"dateString" containsString:date_String];
            [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
                PFObject *photo = [PFObject objectWithClassName:@"Photo"];
                photo = [objects objectAtIndex:0];
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
                [photo saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                    [self.loadingIndicator setHidden:YES];
                    self.dailyPhotoImageView.image = [UIImage imageWithData:imageData];
                }];
                [picker dismissModalViewControllerAnimated:YES];
                if (image) {
                    [self.loadingIndicator setHidden:NO];
                    [self.loadingIndicator startAnimating];
                }
            }];
        }
    }];

    
}



@end
