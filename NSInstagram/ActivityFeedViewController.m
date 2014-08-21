//
//  SecondViewController.m
//  NSInstagram
//
//  Created by Asher Rosenblatt on 8/18/14.
//  Copyright (c) 2014 MM. All rights reserved.
//

#import "ActivityFeedViewController.h"

@interface ActivityFeedViewController ()<UITableViewDataSource, UITableViewDelegate>
@property (strong, nonatomic) IBOutlet UITableView *activityFeedTableView;
@property NSMutableArray *followingArray;
@property NSArray *photosArray;

@end

@implementation ActivityFeedViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.followingArray = [PFUser currentUser][@"following"];
    for (PFUser *user in [PFUser currentUser][@"following"]) {
        [self.followingArray addObject:user];
    }
}

-(void)fetchTheUsersImages
{
   // for (PFUser *user in self.followingArray) {
   //     PFUser *searchString = user;
        PFQuery *query = [PFQuery queryWithClassName:@"Photo"];
        [query whereKey:@"user" containedIn:self.followingArray];
        [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
            self.photosArray = [[NSArray alloc] initWithArray:objects];
        }];
  //  }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@""];
    PFFile *imageFile = [[self.photosArray objectAtIndex:indexPath.row] objectForKey:@"image"];
    [imageFile getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
        UIImage *image = [[UIImage alloc]init];
        image = [UIImage imageWithData:data];
        cell.imageView.image = image;
        NSLog(@"loaded an image");
    }];
    return cell;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.photosArray.count;
}

@end
