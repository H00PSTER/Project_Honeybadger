//
//  GameViewController.m
//  FetchUserDataHowTo
//
//  Created by Andrew Peterson on 11/21/13.
//  Copyright (c) 2013 Facebook Inc. All rights reserved.
//

#import "GameViewController.h"
#import <CoreLocation/CoreLocation.h>
@interface GameViewController ()
@property CLLocationManager *locationManager;
@end

@implementation GameViewController
- (IBAction)startTracking:(id)sender {
    [self.locationManager startUpdatingLocation];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation {
    CLLocationCoordinate2D currentCoordinates = newLocation.coordinate;
    NSLog(@"Entered new Location with the coordinates Latitude: %f Longitude: %f", currentCoordinates.latitude, currentCoordinates.longitude);
}
- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    NSLog(@"Unable to start location manager. Error:%@", [error description]);
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.locationManager = [[CLLocationManager alloc] init];
    [self.locationManager setDelegate:self];
    //Only applies when in foreground otherwise it is very significant changes
    [self.locationManager setDesiredAccuracy:kCLLocationAccuracyBest];
    self.locationManager.distanceFilter = 15;
	// Do any additional setup after loading the view.
    [self.locationManager startUpdatingLocation];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
