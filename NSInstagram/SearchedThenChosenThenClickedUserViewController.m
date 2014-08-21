//
//  SearchedThenChosenThenClickedUserViewController.m
//  NSInstagram
//
//  Created by Meredith Packham on 8/21/14.
//  Copyright (c) 2014 MM. All rights reserved.
//

#import "SearchedThenChosenThenClickedUserViewController.h"

@interface SearchedThenChosenThenClickedUserViewController () <UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableViewCell *tableViewCell;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property PFUser *user;


@end

@implementation SearchedThenChosenThenClickedUserViewController



- (void)viewDidLoad
{
    [super viewDidLoad];
    self.user = [PFUser currentUser];

}

#pragma mark TableView Delegate Methods

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 10;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"poopCell"];
    return cell;

}

- (IBAction)onFollowButtonPressed:(UIButton *)sender {
}



@end
