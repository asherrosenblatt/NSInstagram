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
@property NSMutableArray *photosArray;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation ActivityFeedViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.followingArray = [NSMutableArray arrayWithArray:[PFUser currentUser][@"following"]];
//    for (PFUser *user in [PFUser currentUser][@"following"]) {
//        [self.followingArray addObject:user];
//    }
    NSLog(@"%@",self.followingArray);
    self.photosArray = [NSMutableArray new];
    [self fetchTheUsersImages];

}

- (IBAction)onResfreshPressed:(id)sender
{
    self.followingArray = [NSMutableArray arrayWithArray:[PFUser currentUser][@"following"]];
    [self fetchTheUsersImages];
}

-(void)fetchTheUsersImages
{
   for (PFUser *user in self.followingArray) {
       PFQuery *query = [PFQuery queryWithClassName:@"Photo"];
       [query whereKey:@"user" equalTo:user];
       [query orderByAscending:@"createdAt"];
       [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
           if (error) {
               NSLog(@"%@", error.userInfo);
           } else {
          [self.photosArray addObjectsFromArray:objects];
          [self.tableView reloadData];
           }
        }];
   }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"activityFeedCell"];
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
