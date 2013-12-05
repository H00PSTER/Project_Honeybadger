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

-(void) loadPersonCallback: (NSArray*) person error: (NSError*) error {
    
    PFObject *user = person[0];
    
    self.usersName = user[@"name"];
    NSLog(@"%@", self.usersName);
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
    
    NSLog(@"%@", self.targetName);
    PFQuery * query = [PFQuery queryWithClassName: @"Player"];
    [query whereKey:@"name" equalTo:self.targetName];
    [query findObjectsInBackgroundWithTarget:self
                                   selector: @selector(loadTargetCallback:error:)];
    
}
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
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    
    CLLocation* location = [locations lastObject];
    self.myLocation = location;
    MKCoordinateRegion mapRegion;
    mapRegion.center = location.coordinate;
    mapRegion.span.latitudeDelta = .0001;
    mapRegion.span.longitudeDelta = .0001;
    [self.map setRegion:(mapRegion) animated:(YES)];
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
