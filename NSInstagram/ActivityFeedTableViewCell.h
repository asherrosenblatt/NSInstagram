//
//  ActivityFeedTableViewCell.h
//  NSInstagram
//
//  Created by Asher Rosenblatt on 10/8/14.
//  Copyright (c) 2014 MM. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ActivityFeedTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UIImageView *bigImageView;
@property (strong, nonatomic) IBOutlet UIImageView *userImageView;
@property (strong, nonatomic) IBOutlet UILabel *likesLabel;
@property (strong, nonatomic) IBOutlet UILabel *captionLabel;

@end
