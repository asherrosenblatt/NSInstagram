//
//  SearchedThenChosenThenClickedUserViewController.m
//  NSInstagram
//
//  Created by Meredith Packham on 8/21/14.
//  Copyright (c) 2014 MM. All rights reserved.
//

#import "SearchedThenChosenThenClickedUserViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "SearchedUserThenPhotosViewController.h"

@interface SearchedThenChosenThenClickedUserViewController () <UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property PFUser *user;
@property NSArray *clickedUsersPhotos;
@property NSArray *following;
@property (weak, nonatomic) IBOutlet UILabel *bioLabel;
@property (strong, nonatomic) IBOutlet UIImageView *profileHeaderImageView;
@property (strong, nonatomic) IBOutlet UIButton *followButton;
@property (strong, nonatomic) IBOutlet UIButton *blockButton;


@end

@implementation SearchedThenChosenThenClickedUserViewController



- (void)viewDidLoad
{
    [super viewDidLoad];
    [self checkFollowAndBlockStatus];


}

-(void)loadUserInfo
{
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
            self.profileHeaderImageView.image = profileImage;
        }
    }];

    [self queryClickedUserImages];

    self.navigationItem.title = self.clickedUser.username;
    self.bioLabel.text = [self.clickedUser objectForKey:@"profileBio"];
}

- (IBAction)onBlockPressed:(UIButton *)sender
{
    if ([sender.titleLabel.text isEqualToString:@"Block"]) {
        [self.clickedUser addObject:[PFUser currentUser] forKey:@"blockedBy"];
        [self.clickedUser saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            [sender setTitle:@"Unblock" forState:UIControlStateNormal];
                }];
    } else {
        [self.clickedUser removeObject:[PFUser currentUser] forKey:@"blockedBy"];
        [self.clickedUser saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            [sender setTitle:@"Block" forState:UIControlStateNormal];
        }];
    }
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
        if ([self.followButton.backgroundColor isEqual:[UIColor grayColor]]) {
            [[PFUser currentUser] removeObject:self.clickedUser forKey:@"following"];
            [[PFUser currentUser] saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                [self.followButton setTitle:@"Follow" forState:UIControlStateNormal];
                self.followButton.backgroundColor = [UIColor blueColor];
            }];
        } else {
            [[PFUser currentUser] addObject:self.clickedUser forKey:@"following"];
            [[PFUser currentUser] saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                [self.followButton setTitle:@"Following" forState:UIControlStateNormal];
                self.followButton.backgroundColor = [UIColor grayColor];
            }];
        }
}

-(void)viewWillAppear:(BOOL)animated
{
    [self checkFollowAndBlockStatus];
    [self loadUserInfo];
}

-(void)checkFollowAndBlockStatus
{
    NSMutableArray *followingUsernames = [NSMutableArray new];
    [self.clickedUser fetchIfNeededInBackgroundWithBlock:^(PFObject *object, NSError *error) {
        for (PFUser *user in [PFUser currentUser][@"following"]) {
            [user fetchIfNeededInBackgroundWithBlock:^(PFObject *object, NSError *error) {
                [followingUsernames addObject:user.username];
            }];
        }
        for (NSString *username in followingUsernames) {
            if ([username isEqualToString:self.clickedUser.username]) {
                [self.followButton setTitle:@"Following" forState:UIControlStateNormal];
                self.followButton.backgroundColor = [UIColor grayColor];
            }
        }
    }];

    NSMutableArray *blockedByUsernames = [NSMutableArray new];
    [self.clickedUser fetchIfNeededInBackgroundWithBlock:^(PFObject *object, NSError *error) {
        for (PFUser *user in self.clickedUser[@"blockedBy"]) {
            [user fetchIfNeededInBackgroundWithBlock:^(PFObject *object, NSError *error) {
                [blockedByUsernames addObject:user.username];
            }];
        }
        for (NSString *username in blockedByUsernames) {
            if ([username isEqualToString:[PFUser currentUser].username]) {
                [self.blockButton setTitle:@"Unblock" forState:UIControlStateNormal];
            }
        }
    }];
}



-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    SearchedUserThenPhotosViewController *vc = segue.destinationViewController;
    vc.clickedUser = self.clickedUser;
}


@end
