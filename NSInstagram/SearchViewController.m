//
//  SearchViewController.m
//  NSInstagram
//
//  Created by Meredith Packham on 8/20/14.
//  Copyright (c) 2014 MM. All rights reserved.
//

#import "SearchViewController.h"
#import "SearchTableViewCell.h"


@interface SearchViewController () <UISearchBarDelegate, UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UISearchBar *seachBar;
@property (weak, nonatomic) IBOutlet UITableView *searchTableView;


@end

@implementation SearchViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SearchTableViewCell *cell = [self.searchTableView dequeueReusableCellWithIdentifier:@"searchCell"];
    return cell;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 10;
}

 -(void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{

}



@end
