//
//  SearchedUserThenPhotosViewController.m
//  NSInstagram
//
//  Created by Asher Rosenblatt on 9/23/14.
//  Copyright (c) 2014 MM. All rights reserved.
//

#import "SearchedUserThenPhotosViewController.h"

@interface SearchedUserThenPhotosViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (strong, nonatomic) IBOutlet UITableView *photosTableView;
@property NSArray *clickedUsersPhotos;

@end

@implementation SearchedUserThenPhotosViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self queryClickedUserImages];
}

-(void)queryClickedUserImages
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat: @"user = %@", self.clickedUser];
    PFQuery *query = [PFQuery queryWithClassName:@"Photo" predicate:predicate];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        self.clickedUsersPhotos = [NSArray new];
        self.clickedUsersPhotos = objects;
        [self.photosTableView reloadData];
    }];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [self.photosTableView dequeueReusableCellWithIdentifier:@"cellID"];
    PFObject *imageObject = [PFObject objectWithClassName:@"Photo"];
    imageObject = [self.clickedUsersPhotos objectAtIndex:indexPath.row];
    PFFile *imageFile = [imageObject objectForKey:@"image"];

    [imageFile getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
        UIImage *image = [[UIImage alloc]init];
        image = [UIImage imageWithData:data];
        if (image) {
            cell.imageView.image = image;
        }
        [self.photosTableView reloadData];
    }];
    return cell;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.clickedUsersPhotos.count;
}


-(void)viewWillAppear:(BOOL)animated
{
    [self queryClickedUserImages];
}


@end
