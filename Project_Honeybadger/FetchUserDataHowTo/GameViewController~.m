//
//  GameViewController.m
//  FetchUserDataHowTo
//
//  Created by Andrew Peterson on 11/21/13.
//  Copyright (c) 2013 Facebook Inc. All rights reserved.
//


// Believe it or not all of these properties were used and necessary to our line of thinking

#import "GameViewController.h"
#import <CoreLocation/CoreLocation.h>
#import <Parse/Parse.h>
@interface GameViewController ()<UITextFieldDelegate>
@property CLLocationManager *locationManager;
@property PFObject *user;
@property NSMutableArray *targetList;
@property (weak, nonatomic) IBOutlet UILabel *targetLable;
@property (weak, nonatomic) IBOutlet UILabel *idToGiveToAssassinator;
@property (weak, nonatomic) IBOutlet UITextField *targetCode;
@property NSString *myId;
@property NSString *userName;
@property NSString *targetName;
@property NSString *targetId;
@property int targetIndex;


@end

@implementation GameViewController
@synthesize targetCode;
@synthesize textField;

// we ran out of time. this was supposed to upload an updated array if the user entered the correct data into the code box. we have all the necessary information, we just failed to work out our problems in time

- (IBAction)getTextFromUser:(id)sender
{
    if ([self.targetId isEqualToString:[textField text]])
    {
        //Call parse method to change user status
        [self.targetList removeObjectAtIndex:self.targetIndex];
        
    }
}


- (IBAction)getTarget:(id)sender {
    PFQuery * query = [PFQuery queryWithClassName: @"Player"];
    [query whereKey:@"facebookId" equalTo: self.myId];
    [query findObjectsInBackgroundWithTarget:self
                                   selector: @selector(loadTargetListCallback:error:)];
     

}


// This is very similar logic to another method we used when doing logic with trying to figure out what to do with targets and assassins.
/*
We had a lot of trouble with this method. Our original idea was to give each person a unique tagetId on parse and then query for said id when in range of the iBeacon.
The problem we could not over come was that the same id was uploaded for every parse object. We believe this to be because our method would finish running before parase would finish quering and saving
In the state that it is in now I do not think that this method does much, but everytime I get rid of it the "Get Target" button doesnt work, so I decided to leave it be.
 
also it strings together a number of parse queries, not the most economical choice, but at the time it seemed like a good idea
 */

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
            self.targetIndex = i+1;
        }else if((i == self.targetList.count -1) && ([self.userName isEqualToString:self.targetList[i]]))
        {
            self.targetLable.text = self.targetList[0];
            self.targetName = self.targetList[0];
            self.targetIndex = 0;
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

}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}



// I don't think this code does anything at all, but I'm not sure, and at this point i dont want to cause any new problems

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation {
    CLLocationCoordinate2D currentCoordinates = newLocation.coordinate;

}





// This is a weird method. We made it when iBeacon was still a priority, and I think that it used to be the button that said "Arm", but that we changed it to "Ping" and that is button it refferences.


- (IBAction)armButtonPressed:(id)sender;
{
}


// this big blob of code is what updates the users location and than saves it to parse


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
