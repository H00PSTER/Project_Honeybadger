//
//  GameViewController.m
//  FetchUserDataHowTo
//
//  Created by Andrew Peterson on 11/21/13.
//  Copyright (c) 2013 Facebook Inc. All rights reserved.
//

#import "GameViewController.h"
#import <CoreLocation/CoreLocation.h>
#import <Parse/Parse.h>
@interface GameViewController ()
@property CLLocationManager *locationManager;
@property PFObject *user;
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


// What happens when arm button is pressed

- (IBAction)armButtonPressed:(id)sender;
{
    // insert tracking iBeacon code
        
    
    
}



- (void)viewDidLoad
{
    [super viewDidLoad];
    
    optionsSingle = [GlobalVariables singleObject];
    self.locationManager = [[CLLocationManager alloc] init];
    [self.locationManager setDelegate:self];
    //Only applies when in foreground otherwise it is very significant changes
    [self.locationManager setDesiredAccuracy:kCLLocationAccuracyBest];
    self.locationManager.distanceFilter = 150;
    
	// Do any additional setup after loading the view.
    NSString *myId =  optionsSingle.userInfo[@"id"];
    PFQuery * query = [PFQuery queryWithClassName: @"Player"];
    query.limit = 1000;
    [query whereKey: @"facebookId" equalTo: myId];
    [query findObjectsInBackgroundWithTarget:self
                                    selector: @selector(loadPersonCallback:error:)];
    [self.locationManager startUpdatingLocation];
    [NSTimer scheduledTimerWithTimeInterval:30 target:self
                                   selector:@selector(update) userInfo:nil repeats:YES];

}
-(void) loadPersonCallback: (NSArray*) person error: (NSError*) error{
    self.user = person[0];
}

-(void) update {
    NSNumber *myLatitude = [NSNumber numberWithDouble:self.locationManager.location.coordinate.latitude];
    [self.user setObject: [myLatitude stringValue]  forKey:@"latitude"];
    NSNumber *myLongitude = [NSNumber numberWithDouble:self.locationManager.location.coordinate.longitude];
    [self.user setObject: [myLongitude stringValue] forKey:@"longitude"];
    [self.user saveInBackground];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.

}

@end
