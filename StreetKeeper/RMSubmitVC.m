//
//  RMSubmitVC.m
//  StreetKeeper
//
//  Created by Dan Rudolf on 2/21/15.
//  Copyright (c) 2015 com.rudolfmedia. All rights reserved.
//

#import "RMSubmitVC.h"
#import <MapKit/MapKit.h>

@interface RMSubmitVC ()<UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate, UITextViewDelegate, MKMapViewDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UITextField *titleTextField;
@property (weak, nonatomic) IBOutlet UITextField *addressTextField;
@property (weak, nonatomic) IBOutlet UITextView *descriptionTextView;
@property (weak, nonatomic) IBOutlet UIButton *levelOneButton;
@property (weak, nonatomic) IBOutlet UIButton *levelTwoButton;
@property (weak, nonatomic) IBOutlet UIButton *levelThreeButton;
@property (weak, nonatomic) IBOutlet MKMapView *mapView;

@property UIImagePickerController *imagePicker;
@property UIPopoverController *popOver;
@property UIImage *image;
@property UIAlertView *alert;
@property NSString *errorString;
@property NSString *alertTitle;


@end

@implementation RMSubmitVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.alertTitle = @"Oops! \xF0\x9F\x99\x88";

    self.imageView.image = [UIImage imageNamed:@"camera"];

    self.issue.priority = 0;

    self.imageView.layer.masksToBounds = YES;

    self.mapView.delegate = self;
    [self setMapView];

    UITapGestureRecognizer *screenTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard)];

    [self.view addGestureRecognizer:screenTap];

    UITapGestureRecognizer *imageTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap)];

    [self.imageView.viewForBaselineLayout addGestureRecognizer:imageTap];

    self.descriptionTextView.delegate = self;
    self.titleTextField.delegate = self;
    self.addressTextField.delegate = self;

    self.descriptionTextView.layer.cornerRadius = 6;
    self.descriptionTextView.layer.masksToBounds = YES;

}


-(void)viewWillAppear:(BOOL)animated{

    if (self.image) {

        self.imageView.image = self.image;

    }
}

#pragma mark - MapView Delegate

-(void)setMapView{

    CLLocationCoordinate2D zoomCenter = CLLocationCoordinate2DMake(self.issue.location.latitude, self.issue.location.longitude);

    MKPointAnnotation *annotaion = [[MKPointAnnotation alloc] init];
    annotaion.coordinate = zoomCenter;
    [self.mapView addAnnotation:annotaion];

    MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(zoomCenter, 500, 500);
    [self.mapView setRegion:viewRegion animated:YES];


}

-(MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation{

    MKAnnotationView *annotationView = [[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:nil];
    annotationView.image = [UIImage imageNamed:@"location"];

    return annotationView;
}

#pragma mark - TextView Delegate 

-(BOOL)textViewShouldBeginEditing:(UITextView *)textView{

    self.descriptionTextView.text = @"";

    return YES;
}

#pragma mark - TextField Delegate

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField{

    textField.text = @"";
    return YES;
}

#pragma mark - ImagePickerController Delegate

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{

    if(UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPhone) {
        [picker dismissViewControllerAnimated:YES completion:nil];
    } else {
        [self.popOver dismissPopoverAnimated:YES];
    }
   self.image = [info objectForKey:UIImagePickerControllerOriginalImage];

}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{

    [picker dismissViewControllerAnimated:YES completion:nil];


}

- (void)handleTap{

    self.imagePicker = [[UIImagePickerController alloc] init];
    self.imagePicker.delegate = self;
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {
        self.imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
        [self presentViewController:self.imagePicker animated:YES completion:NULL];
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"No Camera Available." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alert show];
        alert = nil;
    }


}

- (void)hideKeyboard{

    [self.titleTextField resignFirstResponder];
    [self.addressTextField resignFirstResponder];
    [self.descriptionTextView resignFirstResponder];
}

- (IBAction)onLVLOnePressed:(id)sender {

    self.issue.priority = @1;
    [self.levelOneButton setSelected:YES];
    [self.levelTwoButton setSelected:NO];
    [self.levelThreeButton setSelected:NO];
}

- (IBAction)onLVLTwoPressed:(id)sender {

    self.issue.priority = @2;
    [self.levelTwoButton setSelected:YES];
    [self.levelOneButton setSelected:NO];
    [self.levelThreeButton setSelected:NO];
}
- (IBAction)onLVLThreePressed:(id)sender {

    self.issue.priority = @3;
    [self.levelThreeButton setSelected:YES];
    [self.levelOneButton setSelected:NO];
    [self.levelTwoButton setSelected:NO];
}

- (IBAction)onSubmitPressed:(id)sender {


    if (self.titleTextField.text.length < 3) {

        self.errorString = @"Please Enter a Descriptive Title";
        self.alert = [[UIAlertView alloc] initWithTitle:self.alertTitle
                                                message:self.errorString
                                               delegate:self
                                      cancelButtonTitle:@"OK"
                                      otherButtonTitles:nil];

        [self.alert show];

    }

    else if (self.image == nil){

        self.errorString = @"Please Take a Picture For Us";
        self.alert = [[UIAlertView alloc] initWithTitle:self.alertTitle
                                                message:self.errorString
                                               delegate:self
                                      cancelButtonTitle:@"OK"
                                      otherButtonTitles:nil];

        [self.alert show];

    }

    else if (self.addressTextField.text.length < 3){

        self.errorString = @"Please Enter an Address";
        self.alert = [[UIAlertView alloc] initWithTitle:self.alertTitle
                                                message:self.errorString
                                               delegate:self
                                      cancelButtonTitle:@"OK"
                                      otherButtonTitles:nil];

        [self.alert show];

    }

    else if (self.descriptionTextView.text.length < 5){

        self.errorString = @"Please Enter a Description";
        self.alert = [[UIAlertView alloc] initWithTitle:self.alertTitle
                                                message:self.errorString
                                               delegate:self
                                      cancelButtonTitle:@"OK"
                                      otherButtonTitles:nil];

        [self.alert show];

    }

    else if (self.issue.priority == 0){

        self.errorString = @"Please Enter a Priotity Level";
        self.alert = [[UIAlertView alloc] initWithTitle:self.alertTitle
                                                message:self.errorString
                                               delegate:self
                                      cancelButtonTitle:@"OK"
                                      otherButtonTitles:nil];

        [self.alert show];


    }

    else{

        PFObject *newIssue = [PFObject objectWithClassName:@"issue"];
        NSData* data = UIImageJPEGRepresentation(self.imageView.image, 0.3f);
        PFFile *imageFile = [PFFile fileWithName:@"Image.jpg" data:data];
        PFUser *user = [PFUser currentUser];
        PFRelation *realtion = [user relationForKey:@"issues"];

        newIssue[@"title"] = self.titleTextField.text;
        newIssue[@"state"] = @NO;
        newIssue[@"address"] = self.addressTextField.text;
        newIssue[@"location"] = self.issue.location;
        newIssue[@"description"] = self.descriptionTextView.text;
        newIssue[@"priority"] = self.issue.priority;


        [newIssue setObject:imageFile forKey:@"image"];

        [newIssue saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            if (!error) {

                [realtion addObject:newIssue];
                [user saveInBackground];
                [self performSegueWithIdentifier:@"Uploaded" sender:self];

            }
            
            else{


            }
        }];
    }
}
@end
