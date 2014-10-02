//
//  SearchedThenChosenThenClickedUserViewController.m
//  NSInstagram
//
//  Created by Meredith Packham on 8/21/14.
//  Copyright (c) 2014 MM. All rights reserved.
//

#import "SearchedThenChosenThenClickedUserViewController.h"
#import <QuartzCore/QuartzCore.h>

@interface SearchedThenChosenThenClickedUserViewController () <UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property PFUser *user;
@property NSArray *clickedUsersPhotos;
@property NSArray *following;
@property (weak, nonatomic) IBOutlet UILabel *bioLabel;
@property (strong, nonatomic) IBOutlet UIImageView *profileHeaderImageView;
@property (strong, nonatomic) IBOutlet UIButton *followButton;


@end

@implementation SearchedThenChosenThenClickedUserViewController



- (void)viewDidLoad
{
    [super viewDidLoad];
    self.following = [[NSArray alloc] initWithArray:[PFUser currentUser][@"following"]];
    self.imageView.clipsToBounds = YES;
    self.imageView.layer.cornerRadius = 25;
    self.user = [PFUser currentUser];
    PFFile *profileImageFile = [self.clickedUser objectForKey:@"profilePicture"];

    [profileImageFile getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
        UIImage *profileImage = [[UIImage alloc]init];
        profileImage = [UIImage imageWithData:data];
        if (profileImage) {
            self.imageView.image = profileImage;
        }
    }];
    PFFile *profileHeaderFile = [self.clickedUser objectForKey:@"headerPicture"];

    [profileHeaderFile getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
        UIImage *profileImage = [[UIImage alloc]init];
        profileImage = [UIImage imageWithData:data];
        if (profileImage) {
            self.imageView.image = profileImage;
        }
    }];

    [self queryClickedUserImages];

    self.navigationItem.title = self.clickedUser.username;
    self.bioLabel.text = [self.clickedUser objectForKey:@"profileBio"];
}

-(void)queryClickedUserImages
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat: @"user = %@", self.clickedUser];
    PFQuery *query = [PFQuery queryWithClassName:@"Photo" predicate:predicate];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        self.clickedUsersPhotos = [NSArray new];
        self.clickedUsersPhotos = objects;
        [self.tableView reloadData];
    }];
}


#pragma mark TableView Delegate Methods

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.clickedUsersPhotos.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"poopCell"];
    PFObject *imageObject = [PFObject objectWithClassName:@"Photo"];
    imageObject = [self.clickedUsersPhotos objectAtIndex:indexPath.row];
    PFFile *imageFile = [imageObject objectForKey:@"image"];

    [imageFile getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
        UIImage *image = [[UIImage alloc]init];
        image = [UIImage imageWithData:data];
        if (image) {
            cell.imageView.image = image;
        }
        [self.tableView reloadData];
    }];

    return cell;

}

- (IBAction)onFollowButtonPressed:(UIButton *)sender
{
//    NSArray *followingArray = [NSArray arrayWithArray:[[PFUser currentUser] objectForKey:@"following"]];
//    if ([followingArray containsObject:self.clickedUser]) {
//        UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"Follow them again?" message:@"You're already following this person!" delegate:nil cancelButtonTitle:@"Okay" otherButtonTitles: nil];
//        [alertView show];
//    } else {
//        [[PFUser currentUser]addObject:self.clickedUser forKey:@"following"];
//       [[PFUser currentUser]saveInBackground];
//    }
    self.following = [PFUser currentUser][@"following"];
    if ([self.following containsObject:self.clickedUser]) {
        UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"Follow them again?" message:@"You're already following this person!" delegate:nil cancelButtonTitle:@"Okay" otherButtonTitles: nil];
        [alertView show];
    }
    else if (![self.following containsObject:self.clickedUser])
    {
        [[PFUser currentUser] addObject:self.clickedUser forKey:@"following"];
        [[PFUser currentUser] saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            self.following = [NSArray arrayWithArray:[PFUser currentUser][@"following"]];
            self.followButton.titleLabel.text = @"Following!";
            self.followButton.backgroundColor = [UIColor grayColor];
        }];
    }

}


@end
