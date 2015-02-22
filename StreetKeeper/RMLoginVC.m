//
//  ViewController.m
//  StreetKeeper
//
//  Created by Dan Rudolf on 2/21/15.
//  Copyright (c) 2015 com.rudolfmedia. All rights reserved.
//

#import "RMLoginVC.h"
#import <Parse/Parse.h>

@interface RMLoginVC ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *usernameTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UITextField *confirmPasswordTextField;
@property (weak, nonatomic) IBOutlet UIButton *loginButton;
@property (weak, nonatomic) IBOutlet UIButton *signUpButton;
@property UIAlertView *alert;
@property NSString *errorString;
@property NSString *alertTitle;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@property NSUInteger signUpState;


@end

@implementation RMLoginVC

- (void)viewDidLoad {

    if ([PFUser currentUser] != nil) {

        [self performSegueWithIdentifier:@"LoggedIN" sender:self];

    }

    [super viewDidLoad];
    self.signUpState = 0;
    self.alertTitle = @"Oops! \xF0\x9F\x99\x88";
    [self.activityIndicator setHidden:YES];


    [self.confirmPasswordTextField setHidden:YES];

    UITapGestureRecognizer *screenTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard)];

    [self.view addGestureRecognizer:screenTap];

    
}

#pragma mark - TextField Delegates
- (IBAction)onLoginPressed:(id)sender {

    if (self.signUpState == 1) {
        [self.confirmPasswordTextField setHidden:YES];
        [self.signUpButton setTitle:@"Sign Up" forState:UIControlStateNormal];
        self.signUpState = 0;


    }

    else{
        [PFUser logInWithUsernameInBackground:self.usernameTextField.text password:self.passwordTextField.text block:^(PFUser *user, NSError *error) {


            if (!error) {

                [self performSegueWithIdentifier:@"LoggedIN" sender:self];
                [self.activityIndicator setHidden:YES];

            }

            else{

                [self.activityIndicator setHidden:YES];

                self.errorString = [error userInfo][@"error"];
                self.alert = [[UIAlertView alloc] initWithTitle:self.alertTitle
                                                        message:self.errorString
                                                       delegate:self
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];

                [self.alert show];

            }
        }];
    }


}

- (IBAction)onSignUpPressed:(id)sender {

    if (self.signUpState == 0) {

        [self.confirmPasswordTextField setHidden:NO];
        self.signUpState = 1;
        [self.signUpButton setTitle:@"Create User" forState:UIControlStateNormal];
    }

    else if (self.signUpState == 1){

        [self createNewUser];

    }

}

- (void)createNewUser{
    if (self.usernameTextField.text.length < 3) {

        self.errorString = @"Usernames must be atleast 3 characters";
        self.alert = [[UIAlertView alloc] initWithTitle:self.alertTitle
                                                message:self.errorString
                                               delegate:self
                                      cancelButtonTitle:@"OK"
                                      otherButtonTitles:nil];

        [self.alert show];
    }

    else if (self.passwordTextField.text.length < 5){

        self.errorString = @"Passwords must be atleast 3 characters";
        self.alert = [[UIAlertView alloc] initWithTitle:self.alertTitle
                                                message:self.errorString
                                               delegate:self
                                      cancelButtonTitle:@"OK"
                                      otherButtonTitles:nil];

        [self.alert show];

    }

    else if (![self.passwordTextField.text isEqualToString:self.confirmPasswordTextField.text]){


        self.errorString = @"Please check your Passwords";
        self.alert = [[UIAlertView alloc] initWithTitle:self.alertTitle
                                                message:self.errorString
                                               delegate:self
                                      cancelButtonTitle:@"OK"
                                      otherButtonTitles:nil];

        [self.alert show];


    }

    else{

        [self.activityIndicator setHidden:NO];

        PFUser *user = [PFUser user];
        user.username = self.usernameTextField.text;
        user.password = self.passwordTextField.text;

        [user signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {

            if (!error) {

                [self.activityIndicator setHidden:YES];
                [self performSegueWithIdentifier:@"LoggedIn" sender:self];


            }

            else{

                [self.activityIndicator setHidden:YES];

                self.errorString = [error userInfo][@"error"];
                self.alert = [[UIAlertView alloc] initWithTitle:self.alertTitle
                                                        message:self.errorString
                                                       delegate:self
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
                
                [self.alert show];
                
            }
            
        }];
        
    }
}

-(void)hideKeyboard{

    [self.usernameTextField resignFirstResponder];
    [self.passwordTextField resignFirstResponder];
    [self.confirmPasswordTextField resignFirstResponder];


}


@end
