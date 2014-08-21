//
//  SearchedThenChosenThenClickedUserViewController.m
//  NSInstagram
//
//  Created by Meredith Packham on 8/21/14.
//  Copyright (c) 2014 MM. All rights reserved.
//

#import "SearchedThenChosenThenClickedUserViewController.h"

@interface SearchedThenChosenThenClickedUserViewController () <UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property PFUser *user;
@property NSArray *clickedUsersPhotos;
@property NSMutableArray *following;
@property (weak, nonatomic) IBOutlet UILabel *bioLabel;


@end

@implementation SearchedThenChosenThenClickedUserViewController



- (void)viewDidLoad
{
    [super viewDidLoad];

    self.user = [PFUser currentUser];
    PFFile *file = [self.clickedUser objectForKey:@"profilePicture"];

    [file getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
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

        [[PFUser currentUser]addObject:self.clickedUser forKey:@"following"];
       [[PFUser currentUser]save];


}


@end
