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
@property NSArray *followingArray;
@property NSArray *photosArray;

@end

@implementation ActivityFeedViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    PFObject *followingObject = [PFUser currentUser][@"following"];
    [followingObject fetchIfNeededInBackgroundWithBlock:^(PFObject *object, NSError *error) {
        self.followingArray = [object allKeys];
        NSLog(@"%@", self.followingArray);
    }];
}

-(void)fetchTheUsersImages
{
   // for (PFUser *user in self.followingArray) {
   //     PFUser *searchString = user;
        PFQuery *query = [PFUser query];
        [query whereKey:@"user" containedIn:self.followingArray];
        [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
            self.photosArray = [[NSArray alloc] initWithArray:objects];
        }];
  //  }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@""];
    return cell;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.photosArray.count;
}

@end
