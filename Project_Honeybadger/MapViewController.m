//
//  MapViewController.m
//  FetchUserDataHowTo
//
//  Created by Mitchell Zehr on 12/3/13.
//  Copyright (c) 2013 Facebook Inc. All rights reserved.
//

#import "MapViewController.h"

@interface MapViewController ()
@property (weak, nonatomic) IBOutlet MKMapView *map;
@property NSString *targetName;
@property NSArray *targetList;
@property NSString *usersName;
@property CLLocation *myLocation;
@end

@implementation MapViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

// In the viewDidLoad method I grabbed the user's facebook id from a global variable and use it to query for his/her parse object

- (void)viewDidLoad
{

    
    
    [super viewDidLoad];
    optionsSingle = [GlobalVariables singleObject];
    NSString *myId =  optionsSingle.userInfo[@"id"];
    PFQuery * query = [PFQuery queryWithClassName: @"Player"];
    [query whereKey:@"facebookId" equalTo:myId];
    [query findObjectsInBackgroundWithTarget:self
                                    selector: @selector(loadPersonCallback:error:)];
     
    

}

// This method recieves the users parse object uses it to find the users target's name

-(void) loadPersonCallback: (NSArray*) person error: (NSError*) error {
    
    PFObject *user = person[0];
    
    self.usersName = user[@"name"];
    self.targetList = user[@"targetArray"];
    for(int i = 0; i < self.targetList.count; i ++)
    {
        if((i < self.targetList.count -1) && ([self.usersName isEqualToString:self.targetList[i]]))
        {
            self.targetName = self.targetList[i+1];
        }else if((i == self.targetList.count -1) && ([self.usersName isEqualToString:self.targetList[i]]))
        {
            self.targetName = self.targetList[0];
        }
    }
    
    PFQuery * query = [PFQuery queryWithClassName: @"Player"];
    [query whereKey:@"name" equalTo:self.targetName];
    [query findObjectsInBackgroundWithTarget:self
                                   selector: @selector(loadTargetCallback:error:)];
    
}

// this callback method recieves the users target as a parse object and adds it as an annotation to the map

-(void) loadTargetCallback: (NSArray*) person error: (NSError*) error {
    PFObject *user = person[0];
    NSString*latitude = user[@"latitude"];
    NSString *longitude = user[@"longitude"];
    double myLat = [latitude doubleValue];
    double myLong = [longitude doubleValue];
    CLLocationCoordinate2D coord;
    MKPointAnnotation *targetPing = [[MKPointAnnotation alloc] init];
    coord.latitude = myLat;
    coord.longitude = myLong;
    targetPing.coordinate = coord;
    [self.map addAnnotation: targetPing];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
