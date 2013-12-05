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
@interface GameViewController ()<UITextFieldDelegate>
@property CLLocationManager *locationManager;
@property PFObject *user;
@property NSArray *targetList;
@property (weak, nonatomic) IBOutlet UILabel *targetLable;
@property (weak, nonatomic) IBOutlet UILabel *idToGiveToAssassinator;
@property (weak, nonatomic) IBOutlet UITextField *targetCode;
@property NSString *myId;
@property NSString *userName;
@property NSString *targetName;
@property NSString *targetId;


@end

@implementation GameViewController
@synthesize targetCode;
@synthesize textField;
- (IBAction)getTextFromUser:(id)sender
{
    if ([_targetId isEqualToString:[textField text]])
    {
        //Call parse method to change user status
        NSLog(@"Win");
    }
}

- (IBAction)startTracking:(id)sender {
    [self.locationManager startUpdatingLocation];
}

- (IBAction)getTarget:(id)sender {
    self.targetCode.text;
    PFQuery * query = [PFQuery queryWithClassName: @"Player"];
    [query whereKey:@"facebookId" equalTo: self.myId];
    [query findObjectsInBackgroundWithTarget:self
                                    selector: @selector(loadTargetListCallback:error:)];
     

}


-(void) loadTargetListCallback: (NSArray*) targetList error: (NSError*) error
{
    PFObject *user = targetList[0];
    self.targetList = user[@"targetArray"];
    for(int i = 0; i < self.targetList.count; i ++)
    {
        if((i < self.targetList.count -1) && ([self.userName isEqualToString:self.targetList[i]]))
        {
            self.targetLable.text = self.targetList[i+1];
            self.targetName = self.targetList[i+1];
        }else if((i == self.targetList.count -1) && ([self.userName isEqualToString:self.targetList[i]]))
        {
            self.targetLable.text = self.targetList[0];
            self.targetName = self.targetList[0];
        }
    }
    PFQuery * query = [PFQuery queryWithClassName: @"Player"];
    [query whereKey:@"name" equalTo: self.targetName];
    [query findObjectsInBackgroundWithTarget:self
                                    selector: @selector(loadTargetPersonCallback:error:)];
    
    
    
}
-(void) loadTargetPersonCallback: (NSArray*) target error: (NSError*) error
{
    PFObject *user = target[0];
    self.targetId = user[@"targetId"];
    NSLog(@"%@", self.targetId);
    NSLog(@"here");
    
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

}
- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {

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
    self.myId =  optionsSingle.userInfo[@"id"];
    PFQuery * query = [PFQuery queryWithClassName: @"Player"];
    query.limit = 1000;
    [query whereKey: @"facebookId" equalTo: self.myId];
    [query findObjectsInBackgroundWithTarget:self
                                    selector: @selector(loadPersonCallback:error:)];
    [self.locationManager startUpdatingLocation];
    [NSTimer scheduledTimerWithTimeInterval:10 target:self
                                   selector:@selector(update) userInfo:nil repeats:YES];
    NSString *test = [textField text];
    NSLog(@"%@", test);

      NSLog(@"%@", self.targetId);
}
-(void) loadPersonCallback: (NSArray*) person error: (NSError*) error{
    self.user = person[0];
    self.userName = self.user[@"name"];
    self.idToGiveToAssassinator.text = self.user[@"targetId"];
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
