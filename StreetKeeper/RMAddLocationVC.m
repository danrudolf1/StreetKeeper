//
//  RMAddLocationVCViewController.m
//  StreetKeeper
//
//  Created by Dan Rudolf on 2/21/15.
//  Copyright (c) 2015 com.rudolfmedia. All rights reserved.
//

#import "RMAddLocationVC.h"
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
#import "RMNewIssue.h"
#import <Parse/Parse.h>
#import "RMSubmitVC.h"

@interface RMAddLocationVC () <CLLocationManagerDelegate, MKMapViewDelegate>

@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (weak, nonatomic) IBOutlet UIButton *setLocationButton;

@property CLLocationManager *locationManager;
@property RMNewIssue *issue;

@end

@implementation RMAddLocationVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];

    self.locationManager = [[CLLocationManager alloc] init];
    self.mapView.delegate = self;
    self.locationManager.delegate = self;
    
    [self.locationManager requestWhenInUseAuthorization];
    [self.locationManager startUpdatingLocation];

    
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{

    if ([segue.identifier isEqualToString:@"Details"]) {

        RMSubmitVC *destination = segue.destinationViewController;
        destination.issue = self.issue;
    }
}

#pragma mark - LocationManager Delegate

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations{

    for (CLLocation *current in locations) {
        if (current.horizontalAccuracy < 150 && current.verticalAccuracy < 150) {
            [self.locationManager stopUpdatingLocation];
            [self setMapViewRegion];
            break;
        }
    }
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error{

    NSLog(@"%@",error);
}

#pragma mark - MapView Delegate

- (void)setMapViewRegion{

    CLLocationCoordinate2D zoomCenter;
    zoomCenter = self.locationManager.location.coordinate;

    MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(zoomCenter, 500, 500);
    [self.mapView setRegion:viewRegion animated:YES];
}


- (IBAction)onSetLocationPressed:(id)sender {

    self.issue = [[RMNewIssue alloc] init];
    self.issue.location = [PFGeoPoint geoPointWithLatitude:self.mapView.centerCoordinate.latitude
                                            longitude:self.mapView.centerCoordinate.longitude];

}
@end
