//
//  SearchViewController.m
//  NSInstagram
//
//  Created by Meredith Packham on 8/20/14.
//  Copyright (c) 2014 MM. All rights reserved.
//

#import "SearchViewController.h"
#import "SearchTableViewCell.h"
#import "SearchedThenChosenThenClickedUserViewController.h"


@interface SearchViewController () <UISearchBarDelegate, UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (weak, nonatomic) IBOutlet UITableView *searchTableView;
@property NSArray *searchResultsArray;


@end

@implementation SearchViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    self.searchResultsArray = [NSArray new];

}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    [self.searchBar resignFirstResponder];
}



-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    SearchedThenChosenThenClickedUserViewController *dvc = segue.destinationViewController;
    dvc.clickedUser = [self.searchResultsArray objectAtIndex:[self.searchTableView indexPathForSelectedRow].row];
}

-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    
    NSString *searchString = self.searchBar.text;
    PFQuery *query = [PFUser query];
    [query whereKey:@"username" containsString:searchString];
    [query findObjectsInBackgroundWithBlock:^(NSArray *users, NSError *error) {
        if (error)
        {
            NSLog(@"%@", [error userInfo]);
        }
        else
        {
            NSLog(@"THESE ARE THE %@" , users);
            self.searchResultsArray = users;
            [self.searchTableView reloadData];
        }
    }];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{


    SearchTableViewCell *cell = [self.searchTableView dequeueReusableCellWithIdentifier:@"searchCell"];
    PFUser *user = [self.searchResultsArray objectAtIndex:indexPath.row];
    cell.textLabel.text = user.username;
    PFFile *imageFile = [user objectForKey:@"profilePicture"];

    [imageFile getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
        UIImage *profileImage = [[UIImage alloc]init];
        profileImage = [UIImage imageWithData:data];
        cell.imageView.clipsToBounds = YES;
        cell.imageView.layer.cornerRadius = 20;
        cell.imageView.image = profileImage;
        [self.searchTableView reloadData];
    }];


    return cell;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    return self.searchResultsArray.count;
}

 -(void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{

}



@end
