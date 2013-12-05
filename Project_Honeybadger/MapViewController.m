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
    //NSString *test = @"12.348573";
    //double myDouble = [test doubleValue];
    
    /*
    [super viewDidLoad];
    optionsSingle = [GlobalVariables singleObject];
    NSString *myId =  optionsSingle.userInfo[@"id"];
    PFQuery * query = [PFQuery queryWithClassName: @"Player"];
    [query whereKey:@"facebookId" equalTo:myId];
    [query findObjectsInBackgroundWithTarget:self
                                    selector: @selector(loadPersonCallback:error:)];
     */
    

}

-(void) loadPersonCallback: (NSArray*) person error: (NSError*) error {
    
    PFObject *user = person[0];
    PFQuery * query = [PFQuery queryWithClassName: @"Player"];
    [query whereKey:@"facebookId" equalTo:user[@"targetId"]];
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


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
