//
//  RMIssueCell.h
//  StreetKeeper
//
//  Created by Dan Rudolf on 2/21/15.
//  Copyright (c) 2015 com.rudolfmedia. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RMIssueCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *cellImageView;
@property (weak, nonatomic) IBOutlet UILabel *celDateLabel;
@property (weak, nonatomic) IBOutlet UILabel *cellDescriptionLabel;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *priorityImageView;

@end
