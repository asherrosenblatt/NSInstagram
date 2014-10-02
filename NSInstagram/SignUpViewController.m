//
//  SignUpViewController.m
//  NSInstagram
//
//  Created by Asher Rosenblatt on 8/22/14.
//  Copyright (c) 2014 MM. All rights reserved.
//

#import "SignUpViewController.h"
#import "LoginViewController.h"

@interface SignUpViewController ()<UINavigationControllerDelegate, UIImagePickerControllerDelegate>
@property (strong, nonatomic) IBOutlet UITextField *usernameField;
@property (strong, nonatomic) IBOutlet UITextField *emailField;
@property (strong, nonatomic) IBOutlet UITextField *passwordField;
@property (strong, nonatomic) IBOutlet UITextField *checkPasswordField;
@property (strong, nonatomic) IBOutlet UITextField *firstNameField;
@property UIImage *profileImage;
@property (strong, nonatomic) IBOutlet UIImageView *profileImageView;
@property (strong, nonatomic) IBOutlet UIButton *signInButton;
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;

@end

@implementation SignUpViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.

}

- (IBAction)onSignUp:(id)sender
{
    if ([self.passwordField.text isEqualToString:self.checkPasswordField.text] && ![self.passwordField.text isEqualToString:@""])
    {
        PFUser *user = [PFUser user];
        [user setUsername:self.usernameField.text];
        [user setPassword:self.passwordField.text];
        [user setEmail:self.emailField.text];
        user[@"firstName"] = self.firstNameField.text;
        if (self.profileImage) {
            PFFile *file = [PFFile fileWithData:[NSData dataWithData:UIImagePNGRepresentation(self.profileImage)]];
            [user setObject:file forKey:@"profilePicture"];
            [[PFUser currentUser] saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                if (error) {
                    NSLog(@"ERROR");
                } else {
                    NSLog(@"Photo added");
                }
            }];
        }
        [user signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            if (error) {
                NSLog(@"%@", [error userInfo][@"error"]);
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"There was  a problem!" message:[NSString stringWithFormat:@"%@", error.userInfo[@"error"]] delegate:nil cancelButtonTitle:@"Okay" otherButtonTitles: nil];
                [alertView show];
            } else {
                NSLog(@"%@", [PFUser currentUser]);
                [PFUser becomeInBackground:user.sessionToken];
                [self dismissViewControllerAnimated:YES completion:nil];
            }
        }];
    } else if (![self.passwordField.text isEqualToString:self.checkPasswordField.text] || [self.passwordField.text isEqualToString:@""])
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Passwords dont match" message:@"Sorry, your passwords didnt match or you forgot to enter a password. Please fix this and try again!" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alertView show];
        self.checkPasswordField.text = nil;
        self.passwordField.text = nil;
    }
}

- (IBAction)onAddProfPicPressed:(id)sender
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
    self.profileImage = [UIImage imageWithData:imageData];
    self.profileImageView.image = [UIImage imageWithData:imageData];
//    PFFile *file = [PFFile fileWithData:imageData];
//    PFUser *user = [PFUser currentUser];
//    [user setObject:file forKey:@"profilePicture"];
//    [[PFUser currentUser] saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
//        if (error) {
//            NSLog(@"ERROR");
//        } else {
//            NSLog(@"Photo added");
//        }
//    }];

    [picker dismissModalViewControllerAnimated:YES];
    //UIImage *newImage = image;
    
    
}

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

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self registerForKeyboardNotifications];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [self deregisterFromKeyboardNotifications];
    [super viewWillDisappear:animated];
}

- (void)keyboardWasShown:(NSNotification *)notification
{
    [self.scrollView setContentSize:CGSizeMake(self.scrollView.frame.size.width, 750.0)];
}

- (void)keyboardWillBeHidden:(NSNotification *)notification
{
    [self.scrollView setContentOffset:CGPointZero animated:YES];

    [self.scrollView setContentSize:CGSizeMake(self.scrollView.frame.size.width, self.scrollView.frame.size.height)];
}

@end
