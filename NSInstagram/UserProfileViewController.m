//
//  FirstViewController.m
//  NSInstagram
//
//  Created by Asher Rosenblatt on 8/18/14.
//  Copyright (c) 2014 MM. All rights reserved.
//

#import "UserProfileViewController.h"
#import "EditUserProfileViewController.h"
#import <QuartzCore/QuartzCore.h>


@interface UserProfileViewController ()<UINavigationControllerDelegate, UITableViewDataSource, UITableViewDelegate, PFLogInViewControllerDelegate, PFSignUpViewControllerDelegate>
@property (strong, nonatomic) IBOutlet UIImageView *profileImageView;
@property (strong, nonatomic) IBOutlet UIImageView *headerImageView;
@property (strong, nonatomic) IBOutlet UILabel *userBioLabel;
@property (strong, nonatomic) IBOutlet UITableView *userImagesTableView;
@property NSArray *currentUserImagesArray;
@property (strong, nonatomic) IBOutlet UILabel *userNameLabel;
@end

@implementation UserProfileViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self queryCurrentUserImages];
    [self loadHeaderAndProfileImages];
    self.profileImageView.clipsToBounds = YES;
    self.profileImageView.layer.cornerRadius = 25;

}

-(void)viewWillAppear:(BOOL)animated
{
    [self loadHeaderAndProfileImages];
    [self queryCurrentUserImages];
}

- (void)loadHeaderAndProfileImages
{
    PFFile *imageFile = [[PFUser currentUser] objectForKey:@"profilePicture"];
    [imageFile getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
        UIImage *profileImage = [[UIImage alloc]init];
        profileImage = [UIImage imageWithData:data];
        self.profileImageView.image = profileImage;
    }];
    PFFile *headerImageFile = [[PFUser currentUser] objectForKey:@"headerPicture"];
    [headerImageFile getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
        UIImage *headerImage = [[UIImage alloc]initWithData:data];
        self.headerImageView.image = headerImage;
    }];
    self.userNameLabel.text = [PFUser currentUser][@"firstName"];
    self.userBioLabel.text = [PFUser currentUser][@"profileBio"];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];

    if (![PFUser currentUser]) {
        [self performSegueWithIdentifier:@"loginSegue" sender:self];
    }
}


#pragma mark - userProfile methods

- (IBAction)onLogOutPressed:(id)sender
{
    [PFUser logOut];
    if (![PFUser currentUser]) {
        [self performSegueWithIdentifier:@"loginSegue" sender:self];
    }
}

- (IBAction)onEditProfileButtonPressed:(id)sender
{
    NSLog(@"edit profile pressed!");
}


//- (void)imagePickerController:(UIImagePickerController *)picker
//        didFinishPickingImage:(UIImage *)image
//                  editingInfo:(NSDictionary *)editingInfo
//{
//    // Dismiss the image selection, hide the picker and
//    NSData *imageData = [NSData dataWithData:UIImagePNGRepresentation(image)];
//    self.profileImageView.image = [UIImage imageWithData:imageData];
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
//    [picker dismissViewControllerAnimated:YES completion:nil];
//    //UIImage *newImage = image;
//}

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



@end
