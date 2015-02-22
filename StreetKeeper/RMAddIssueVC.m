//
//  RMAddIssueVC.m
//  StreetKeeper
//
//  Created by Dan Rudolf on 2/21/15.
//  Copyright (c) 2015 com.rudolfmedia. All rights reserved.
//

#import "RMAddIssueVC.h"
#import "RMIssueCell.h"
#import <Parse/Parse.h>

@interface RMAddIssueVC ()<UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property NSArray *issues;


@end

@implementation RMAddIssueVC

- (void)viewDidLoad {
    [super viewDidLoad];

    //self.navigationController.navigationBar.topItem.title = @"";

    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];

    PFQuery *query = [PFQuery queryWithClassName:@"issue"];
        [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {

            self.issues = objects;
            [self.tableView reloadData];

    }];
}

#pragma mark - TableView DataSource / Delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{


    return self.issues.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    RMIssueCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    PFObject *issue = [self.issues objectAtIndex:indexPath.row];
    NSNumber *priority = issue[@"priority"];
    NSDate *date = issue.createdAt;
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
    NSString *dateString = [dateFormatter stringFromDate:date];
    cell.priorityImageView.image = nil;

    if ([priority isEqualToNumber:@1]) {

        cell.priorityImageView.image = [UIImage imageNamed:@"low"];

    }

    else if ([priority isEqualToNumber:@2]){

        cell.priorityImageView.image = [UIImage imageNamed:@"medium"];

    }
    else if ([priority isEqualToNumber:@3]){

        cell.priorityImageView.image = [UIImage imageNamed:@"high"];

    }
    NSLog(@"%@", priority);

    cell.cellDescriptionLabel.text = issue[@"description"];
    cell.titleLabel.text = issue[@"title"];
    cell.celDateLabel.text = dateString;

    PFFile *imageFile = issue[@"image"];

    [imageFile getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {

        UIImage *image = [UIImage imageWithData:data];
        cell.cellImageView.layer.masksToBounds = YES;
        cell.cellImageView.image = image;

        
    }];

    return cell;
    
}

- (IBAction)unwindFromSent:(UIStoryboardSegue *)sender{
    
}



@end
