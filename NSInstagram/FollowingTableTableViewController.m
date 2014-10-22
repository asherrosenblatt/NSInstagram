//
//  FollowingTableTableViewController.m
//  NSInstagram
//
//  Created by Asher Rosenblatt on 10/1/14.
//  Copyright (c) 2014 MM. All rights reserved.
//

#import "FollowingTableTableViewController.h"

@interface FollowingTableTableViewController ()<UITableViewDelegate>
@property NSArray *followingArray;
@property NSArray *usersArray;
@end

@implementation FollowingTableTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.followingArray = [[NSArray alloc] initWithArray:[PFUser currentUser][@"following"]];
     //self.navigationItem.rightBarButtonItem = self.editButtonItem;
}



#pragma mark - Table view data source


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[PFUser currentUser][@"following"] count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"myCellId" forIndexPath:indexPath];
    //PFUser *user = [self.followingArray objectAtIndex:indexPath.row];
    PFUser *user = [[PFUser currentUser][@"following"] objectAtIndex:indexPath.row];
    [user fetchIfNeededInBackgroundWithBlock:^(PFObject *object, NSError *error) {
        cell.textLabel.text = user.username;
        PFFile *imageFile = user[@"profilePicture"];
        [imageFile getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
            cell.imageView.contentMode = UIViewContentModeScaleAspectFit;
            UIImage *profileImage = [[UIImage alloc]init];
            profileImage = [UIImage imageWithData:data];
            cell.imageView.image = profileImage;
            [self.tableView reloadData];
        }];
    }];

    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //if ([self.navigationItem.rightBarButtonItem.title isEqualToString:@"Done"]) {
        [[PFUser currentUser][@"following"] removeObjectAtIndex:indexPath.row];
        [[PFUser currentUser] saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            //[tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            [tableView reloadData];
        }];
    //}
}


//- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    return YES;
//}
//
//
//
//// Override to support editing the table view.
//- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
//    if (editingStyle == UITableViewCellEditingStyleDelete) {
//        [[PFUser currentUser][@"following"] removeObjectAtIndex:indexPath.row];
//        [[PFUser currentUser] saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
//            [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
//        }];
//    }
//}


@end
