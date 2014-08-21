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


@end

@implementation SearchedThenChosenThenClickedUserViewController



- (void)viewDidLoad
{
    [super viewDidLoad];
    [[PFUser currentUser]addObject:self.clickedUser forKey:@"following"];
    [[PFUser currentUser]save];
    self.user = [PFUser currentUser];
    NSLog(@"%@",self.clickedUser.username);
    PFFile *file = [self.clickedUser objectForKey:@"profilePicture"];

    [file getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
        UIImage *profileImage = [[UIImage alloc]init];
        profileImage = [UIImage imageWithData:data];
        if (profileImage) {
            self.imageView.image = profileImage;
        }
    }];

    [self queryClickedUserImages];


}

-(void)queryClickedUserImages
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat: @"user = %@", self.clickedUser];
    PFQuery *query = [PFQuery queryWithClassName:@"Photo" predicate:predicate];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        NSLog(@"%@", objects);
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

    //[PFUser currentUser][@"following"]
    PFQuery *query = [PFUser query];
    NSString *usernameString = [PFUser currentUser][@"username"];
    [query whereKey:@"username" containsString:usernameString];
    [query whereKey:@"status" equalTo:[NSNumber numberWithInt:1]];

        self.following = [[NSMutableArray alloc] init];
        self.following = [[query findObjects]mutableCopy];
        NSLog(@"MY FOLLOWING IS %@", self.following);

}


@end
